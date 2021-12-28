{ postgresql, stdenvNoCC, runCommandNoCC, makeSetupHook }: rec {
  my-postgres = postgresql.withPackages (ps: [ps.postgis]);
  empty-db = runCommandNoCC "postgres-empty-db" {} ''
    ${my-postgres}/bin/initdb -U postgres -A trust $out
  '';
  pgop-psql = ''${my-postgres}/bin/psql -h $(pwd)/run -U postgres -w -d postgres '';
  pgop = name: prev: script: stdenvNoCC.mkDerivation {
    name = "pgop-${name}";
    src = prev;
    buildPhase = ''
      chmod -R 0700 .
      echo Starting postgres
      mkdir run
      ${my-postgres}/bin/postgres -D . -k ./run -d2 &
      postgresPid=$!
      sleep 1

      ${script}
    '';
    phases = [ "unpackPhase" "buildPhase" ];
  };
  pgop-thru = name: prev: script: pgop name prev ''
      ${script}
      kill -INT $postgresPid
      wait $postgresPid
      rm -r run
      mkdir $out
      cp -r . $out/
    '';
  noop = pgop-thru "noop" empty-db ''
    ${pgop-psql} -c 'SELECT 1;'
  '';
}
