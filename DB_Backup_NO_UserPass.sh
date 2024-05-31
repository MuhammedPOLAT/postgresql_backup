#!/bin/bash

# Tarih ve saat bilgisini alma
datestamp=$(date +'%Y_%m_%d')
timestamp=$(date +'%Y_%m_%d.%H_%M_%S')

# Sunucuların listesi
servers=(
    "10.0.0.1:5433:server1"
    "10.0.0.2:5433:server2"
    "10.0.0.3:5432:server3"
)

# Ana dizin
BASE_DIR="/home/MuhammedPOLAT/Desktop/DB_Backups"

# Her sunucu için yedekleme işlemi
for server in "${servers[@]}"; do
    IFS=':' read -r -a server_info <<< "$server"
    PGHOST=${server_info[0]}
    PGPORT=${server_info[1]}
    SERVER_NAME=${server_info[2]}

    mkdir -p "$BASE_DIR/$SERVER_NAME/$datestamp"

    # Veritabanı listesi alma ve filtreleme
    databases=$(psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d postgres -t -c "SELECT datname FROM pg_database WHERE datistemplate = false;")
    
    for db in $databases; do
        db=$(echo $db | tr -d '[:space:]')
        if [[ "$db" != "template0" && "$db" != "template1" ]]; then
            BACKUP_FILE="$BASE_DIR/$SERVER_NAME/$datestamp/${db}_${timestamp}.backup"
            pg_dump -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -F c -b -v -f "$BACKUP_FILE" "$db"
        fi
    done

    echo "Yedekleme işlemi $SERVER_NAME sunucusu için tamamlandı."
done

echo "Tüm sunucuların veritabanları yedekleme işlemi tamamlandı. www.muhammedpolat.com.tr"
