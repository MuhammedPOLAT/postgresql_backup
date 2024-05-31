######################################## www.muhammedpolat.com.tr ########################################
PostgreSQL Zamanlanmış Otomatik Güvenli Yedekleme / PostgreSQL Scheduled Automatic Secure Backup
######################################## www.muhammedpolat.com.tr ########################################

[TR]------------------------Gereksinimler-------------------------
Gereksinimler:
PGAdmin kurulumu yada yedekleme işlemi için gerekli olan pg_dump dosyasının sistem değişkenlerine tanımlı olması.

Windows:
https://www.pgadmin.org/download/
Bu linkten işletim sisteminize uygun PGAdmin'i indirip yükleyin ardından PGAdmin içerisinden
File->Prefences->Binary Paths->PostgreSQL Binary Path->Herhangi bir versiyon->Dosya yolu (C:\Program Files\pgAdmin 4\runtime) ->Kaydet

![image](https://github.com/MuhammedPOLAT/postgresql_backup/assets/49784051/be46145e-c9e4-4dd5-aa63-866a0f93372a)


Linux (Ubuntu):
https://www.pgadmin.org/download/
Bu linkten işletim sisteminize uygun PGAdmin'i indirip yükleyin yada aşağıdaki komutu da kullanabilirsiniz
"sudo apt install postgresql-client -y"

Birde buna ek olarak zamanlanmış görev oluşturabilmemiz için Cron'a ihtiyacımız var onun içinde aşağıdaki komutla yükleme işlemini gerçekleştirebilirsiniz
"sudo apt install cron -y"

[TR]------------------------Requirements-------------------------
Requirements:
The pg_dump file required for pgAdmin installation or backup operation is defined to the system variables.

Windows:
https://www.pgadmin.org/download/
Download and install the appropriate pgAdmin for your operating system from this link, and then from pgAdmin
File->Prefences->Binary Paths->PostgreSQL Binary Path->Any version->File path (C:\Program Files\pgAdmin 4\runtime) ->Save

![image](https://github.com/MuhammedPOLAT/postgresql_backup/assets/49784051/a24ab6db-faab-4157-a8aa-e40f1184eeb1)


Linux (Ubuntu):
https://www.pgadmin.org/download/
Download and install the appropriate pgAdmin for your operating system from this link, or you can also use the following command
"sudo apt install postgresql-client -y"

In addition, we need Cron to create a scheduled task, in which you can perform the installation process with the following command Oct.
"sudo apt install cron -y"

[TR]------------------------Otomatik Yedekleme-------------------------

PostgreSQL veritabanı yedeklemesi için birçok yöntem ve yazılım kullanılabiliyor. Bu repo'da yer alan içerik, işletim sistemi araçları ile yapabileceğiniz bir yedekleme komutlarını içerir.

Windows:

1)Repo'da yer alan komutları indirin yada bir bat dosyası haline getirerek bilgisayarınıza kaydedin.
2)Bu bat dosyasını otomatik çalıştırabilmek için Görev Zamanlayıcısını açın
3)Sağ menüden "Temel Görev Oluştur" kısmından bir görev oluşturalım
4)İsim kısmını yazıp sonraki sayfaya geçelim
5)Tetikleyici kısmında ihtiyacınıza göre seçebiliriniz. Anlatımda günlük 3 kere alınacağı için günlük kısmını seçebilirsiniz.
6)Her 1 günde yazıp sonraki sayfaya geçelim
7)Programı Başlat'ı seçelim
8)Program/komut dosyası kısmına: C:\Windows\system32\cmd.exe
9)Bağımsız değişkenler ekle (isteğe bağlı) kısmına:/c start "" "D:db_backup.bat"
10)Son kısmı ile tamamlayalım.

Dilerseniz daha sonra bu görev üzerinden "Tetikleyiciler" kısmından günlük saatleri belirleyebilirsiniz birden fazla zaman/tetik ekleyebilirsiniz.
Şimdi güvenlik kısmına geçelim:

Bazı değişkenleri işletim sisteminde ortam değişkenleri olarak eklersek güvenlik konusunda basitte olsa bir tedbir almış oluruz. Bunun için sistem özellikleri bölümüne girip değişkenlerimizi ekliyoruz:


Bu aşamadan sonra oluşturduğumuz BAT dosyası kullanıma hazır.

Linux:

1)Windows işletim sisteminde yaptığımız gibi PostgreSQL'e bağlanacağımız kullanıcı adı ve şifreleri değişken olarak tanımlamak için önce bashrc dosyasında değişiklik yapalım bunun için bir düzenleyici kullanabilirsiniz ben nano kullanacağım:
nano ~/.bashrc
2)Bu dosyaya aşağıdaki değişkenleri kendinize göre düzenleyerek ekleyin:
export PGUSER=MuhammedPOLAT
export PGPASSWORD=My_Database_Password

3)Dosyayı kaydedip çıktıktan sonra değişikliklerin etkin olabilmesi için terminali kapatıp açabilir yada aşağıdaki komutla aktif hâle getirebilirsiniz:
source ~/.bashrc

4)Bir sonraki aşama script'i otomatik çalıştırmak için eğer sisteminizde yüklü değilse aşağıdaki komutla önce Cron'u yükleyelim:
sudo apt install cron
5)Script'i otomatik çalıştırabilmek için crontab dosyasını düzenlemek için aşağıdaki komutu girebilirsiniz:
crontab -e
6)Crontab içerisine aşağıdaki satırları ekleyerek otomatik çalışmasını sağlayabilirsiniz:

0 6 * * * /path/to/db_backup.sh
30 12 * * * /path/to/db_backup.sh
30 18 * * * /path/to/db_backup.sh

Yukarıda yer alan "0 6" kısmı Sabah 06.00'da, "30 12" kısmı öğlen 12.30'da, "30 18" kısmı akşam 18.30'da dosya yolu yazan db_backup.sh script'ini çalıştırarak yedek işlemini başlatır. Bu satırlara istediğiniz saat aralığını girerek değiştirebilirsiniz.
Burada ki * (Yıldız) işaretinin anlamı ise:
1->* Minute (Dakika) — komutun çalışacağı saatin dakikası 0-59 arası
2->* Hour (Saat) — komutun hangi saatte çalışacağı 0-23 arası
3->* Day of the month (Ay günü) — ayın hangi gününde komutun çalışacağı, 1-31 arası
4->* Month (Ay) — komutun hangi ayda çalışacağı, 1-12 arası
5->* Day of the week (Haftanın günü) — komutun haftanın hangi gününde çalışacağı, 0-7 arası

[EN]------------------------Automatic Backup-------------------------

Many methods and software can be used for PostgreSQL database backup. The content contained in this repo includes backup commands that you can do with operating system tools.

Windows:

1)Download the commands contained in the repo or save them to your computer by converting them into a bat file.
2)Open the Task Scheduler to be able to run this bat file automatically
3)Let's create a task from the "Create Basic Task" section in the right menu
4)Let's write the name part and go to the next page
5) You can choose the trigger part according to your requirement. You can choose the diary part because it will be taken 3 times a day in the narration.
6)Let's write every 1 day and move on to the next page
7)Let's choose Start the Program
8)To the program/script section: C:\Windows\system32\cmd .exe
9)Add arguments (optional) to the section:/c start "" "D:db_backup.Oct.bat"
10)Let's finish with the last part.

If you wish, you can specify the daily hours from the "Triggers" section later through this task, you can add more than one time/trigger.
Now let's move on to the security part:

If we add some variables as environment variables in the operating system, we will have taken a simple measure of security. Oct. To do this, we enter the system properties section and add our variables:


After this stage, the BAT file we created is ready for use.

Linux:

1)Let's make changes to the bashrc file first to define the username and passwords that we will connect to PostgreSQL as variables, as we do in the Windows operating system, you can use an editor for this, I will use nano:
nano ~/.bashrc
2)Add the following variables to this file by editing them according to yourself:
export PGUSER=MuhammedPOLAT
export PGPASSWORD=My_Database_Password

3)After saving the file and exiting, you can turn the terminal off and on or activate it with the following command so that the changes can take effect:
source ~/.bashrc

4)The next step is to run the script automatically, if it is not installed on your system, let's install Cron first with the following command:
sudo apt install cron
5)You can enter the following command to edit the crontab file in order to run the script automatically:
crontab -e
6)You can make it work automatically by adding the following lines to Crontab:

0 6 * * * /path/to/db_backup.sh
30 12 * * * /path/to/db_backup.sh
30 18 * * * /path/to/db_backup.sh

The "0 6" part above is at 06.00 in the morning, the "30 12" part is at 12.30 in the afternoon, the "30 18" part is at 18.30 in the evening, which says the file path db_backup.sh starts the backup process by running the script. You can change these lines by entering the desired time December.
The meaning of the * (Star) sign here is:
1->* Minute (Minute) — the minute of the hour when the command will run is between 0-59 Dec
2->* Hour — the time at which the command will run is between 0-23 Dec
3->* Day of the month — on which day of the month the command will work, Dec. 1-31
4->* Month —Month) - in which month the command will work, Dec. 1-12
5->* Day of the week — on which day of the week the command will work, Dec. 0-7

[TR]###################-Açıklama-###################

Komutlar için alternatif BAT/Script dosyaları paylaşacağım. Bazı dosyalarda sistem değişkenleri kullanmadan yine dosya içerisine kullanıcı adı-şifre bilgilerini girerek çalıştırabilirsiniz. Buna benzer olarak yine standart değişkenleriniz varsa (IP, Port, Kullanıcı Adı, Şifre vs.) bunları da sistem değişkenlerine ekleyerek otomatik kullanabilirsiniz.


[EN]###################-Description-###################

I will share alternative BAT/Script files for commands. In some files, you can run it by entering the user name-password information into the file again without using system variables. Similarly, if you still have standard variables (IP, Port, Username, Password, etc.) you can also use them automatically by adding them to system variables.
