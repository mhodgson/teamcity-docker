#!/bin/bash
set -e

mkdir -p $TEAMCITY_DATA_PATH/lib/jdbc $TEAMCITY_DATA_PATH/config
if [ ! -f "$TEAMCITY_DATA_PATH/lib/jdbc/postgresql-9.4.1209.jar" ];
then
    echo "Downloading postgress JDBC driver..."
    wget -P $TEAMCITY_DATA_PATH/lib/jdbc https://jdbc.postgresql.org/download/postgresql-9.4.1209.jar
    # Remove possible old one when upgrading...
    rm -f $TEAMCITY_DATA_PATH/lib/jdbc/postgresql-9.3-1103.jdbc41.jar
fi

# Configure Postgres
rm -f $TEAMCITY_DATA_PATH/config/database.properties

cat > $TEAMCITY_DATA_PATH/config/database.properties <<- EOF
connectionUrl=jdbc:postgresql://$DB_HOST:$DB_PORT/$DB_NAME
connectionProperties.user=$DB_USER
connectionProperties.password=$DB_PASSWORD
EOF

echo "Starting teamcity..."
exec /opt/TeamCity/bin/teamcity-server.sh run
