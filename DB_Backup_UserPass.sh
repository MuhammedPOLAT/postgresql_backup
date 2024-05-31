#!/bin/bash

# Çevresel değişkenleri ayarla
export PGUSER="DB_Username"
export PGPASSWORD="DB_Password"

# Tarih ve saat bilgisini alma
datestamp=$(date +"%Y_%m_%d")
fullstamp=$(date +"%Y_%m_%d.%H_%M_%S")

# Sunucuların listesi
declare -A SERVERS
SERVERS=( ["server1"]="10.0.0.1 5433" ["server2"]="10.0.0.2 5433" ["server3"]="10.0.0.3 5432" )

# Ana dizin
BASE_DIR="/home/MuhammedPOLAT/Desktop/DB_Backups"

# Her sunucu için yedekleme işlemi
for SERVER in "${!SERVERS[@]}"; do
    # Klasörü oluştur
    mkdir -p "$BASE_DIR/$SERVER/$datestamp"

    # Sunucu bağlantı bilgilerini al
    IFS=' ' read -r PGHOST PGPORT <<< "${SERVERS[$SERVER]}"

    # Veritabanı listesini al ve yedekle
    DBS=$(psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -lqt | cut -d \| -f 1 | sed -e 's/^[ \t]*//' | grep -Ev 'template[01]')
    for DB in $DBS; do
        DB_NAME=$(echo "$DB" | sed 's/ /_/g' | sed 's/\./_/g')
        BACKUP_FILE="$BASE_DIR/$SERVER/$datestamp/${DB_NAME}_$fullstamp.backup"
        pg_dump -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -F c -b -v -f "$BACKUP_FILE" "$DB"
    done

    echo "Yedekleme işlemi $SERVER sunucusu için tamamlandı."
done

echo "Tüm sunucuların veritabanları yedekleme işlemi tamamlandı. www.muhammedpolat.com.tr"
