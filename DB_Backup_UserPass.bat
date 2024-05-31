@echo off
REM Tarih ve saat bilgisini alma
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"
set "datestamp=%YYYY%_%MM%_%DD%"
set "fullstamp=%YYYY%_%MM%_%DD%.%HH%_%Min%_%Sec%"

REM Sunucuların ve klasörlerin listesi
set "SERVERS=server1 server2 server3 server4 server5 server6 server7 server8"
set "BASE_DIR=C:\Users\MuhammedPOLAT\Desktop\DB_Backups"

REM Sunucu bağlantı bilgileri
setlocal EnableDelayedExpansion
set "server1=10.0.0.1 5433 username DB_Password"
set "server2=10.0.0.2 5433 username DB_Password"
set "server3=10.0.0.3 5432 username DB_Password"
set "server4=10.0.0.4 5432 username DB_Password"
set "server5=10.0.0.5 5433 username DB_Password"
set "server6=10.0.0.6 5433 username DB_Password"
set "server7=10.0.0.7 5433 username DB_Password"
set "server8=10.0.0.8 5433 username DB_Password"

REM Her sunucu için yedekleme işlemi
for %%S in (%SERVERS%) do (
    mkdir "%BASE_DIR%%%S\%datestamp%" 2>nul
    REM Sunucu bağlantı bilgilerini al
    for /f "tokens=1-4" %%A in ("!%%S!") do (
        set "PGHOST=%%A"
        set "PGPORT=%%B"
        set "PGUSER=%%C"
        set "PGPASSWORD=%%D"
    )

    FOR /F "delims=" %%D IN ('psql -h !PGHOST! -p !PGPORT! -U !PGUSER! -l -q -t -A -F ","') DO (
        FOR /F "tokens=1,2 delims=," %%A IN ("%%D") DO (
            set "DB_NAME=%%A"
            set "DB_NAME=!DB_NAME: =_!"
            set "DB_NAME=!DB_NAME:.=_!"
            set "BACKUP_FILE=%BASE_DIR%%%S\%datestamp%\!DB_NAME!_%fullstamp%.backup"
            pg_dump -h !PGHOST! -p !PGPORT! -U !PGUSER! -F c -b -v -f "!BACKUP_FILE!" "%%A"
        )
    )
    echo Yedekleme işlemi %%S sunucusu için tamamlandı.
)

echo Tüm sunucuların veritabanları yedekleme işlemi tamamlandı.

exit