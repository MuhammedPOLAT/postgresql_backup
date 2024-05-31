@echo off
setlocal EnableDelayedExpansion

REM Dosyaları Tarih-Saat formatında oluşturmak için tarih ve saat bilgisini alma
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"
set "datestamp=%YYYY%_%MM%_%DD%"
set "fullstamp=%YYYY%_%MM%_%DD%.%HH%_%Min%_%Sec%"

REM Sunucuların listesi burada server1 server 2 gibi isimleri klasör olarak oluşacağı için kendinize göre değiştirebilirisniz
set "server1=10.0.0.1 5432"
set "server2=10.0.0.2 5433"
set "server3=10.0.0.3 5434"

REM Yedeklerin kaydedileği ana dizin/klasör
set "BASE_DIR=C:\Users\MuhammedPOLAT\Desktop\DB_Backups"

REM Her sunucu için yedekleme işlemi
for %%S in (server1 server2 server3) do (
    set "SERVER=!%%S!"
    set "SERVER_NAME=%%S"
    mkdir "%BASE_DIR%\!SERVER_NAME!\%datestamp%" 2>nul

    REM Sunucu bağlantı bilgilerini al
    for /f "tokens=1,2" %%A in ("!SERVER!") do (
        set "PGHOST=%%A"
        set "PGPORT=%%B"
    )

    REM Veritabanı listesi alma ve filtreleme
    FOR /F "usebackq tokens=1" %%D IN (`psql -h !PGHOST! -p !PGPORT! -U %PGUSER% -d postgres -t -c "SELECT datname FROM pg_database WHERE datistemplate = false;"`) DO (
        set "DB_NAME=%%D"
        set "DB_NAME=!DB_NAME: =_!"
        set "DB_NAME=!DB_NAME:.=_!"
        if not "!DB_NAME!"=="template0" if not "!DB_NAME!"=="template1" (
            set "BACKUP_FILE=%BASE_DIR%\!SERVER_NAME!\%datestamp%\!DB_NAME!_%fullstamp%.backup"
            pg_dump -h !PGHOST! -p !PGPORT! -U %PGUSER% -F c -b -v -f "!BACKUP_FILE!" "!DB_NAME!"
        )
    )
    echo Yedekleme işlemi !SERVER_NAME! sunucusu için tamamlandı.
)

echo Tüm sunucuların veritabanları yedekleme işlemi tamamlandı. www.muhammedpolat.com.tr
endlocal
pause
