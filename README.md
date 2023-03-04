Langkah-Langkah setup:

1. download dan install di flutter https://flutter.dev/, kemudian setup environment variabelnya
2. download dan install di dart https://dart.dev/get-dart, kemudian setup environment variabelnya
3. git clone file ini
4. buka terminal, masuk ke folder file ini dengan perintah `cd path/to/file`
5. jalankan perintah `flutter pub get`
6. setup firebasenya, isi package namenya dengan "com.metatony.chat_app" ada di file 'android/app/build.gradle'
7. download google-service.json dan replace yang sudah ada di `cd android\app` 
8. buat juga authentication dengan email dan password di firebase
9. buat juga firestore database di firebase
10. setup rulesnya dari 'false' jadi 'true'
11. jalankan perintah `flutter run` untuk menjalankan aplikasi

sumber github: https://github.com/metatony/flutter-chat-app
