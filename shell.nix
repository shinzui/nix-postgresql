with import <nixpkgs> {};
mkShell {
  name = "local-postgresql";
  buildInputs = [
    (postgresql_12.withPackages (p: [ p.postgis ]))
    ];

   shellHook = ''
        export PGHOST="$PWD/db"
        export PGDATA="$PGHOST/db"
        export PGLOG=$PGHOST/postgres.log

        mkdir -p $PGHOST

        if [ ! -d $PGDATA ]; then
          initdb --auth=trust --no-locale --encoding=UTF8
        fi

        if ! pg_ctl status
        then
          pg_ctl start -l $PGLOG -o "--unix_socket_directories='$PGHOST'"
        fi

       function end {
          echo "Shutting down local-postgresql..."
          pg_ctl stop
        }
        trap end EXIT
    '';
}
