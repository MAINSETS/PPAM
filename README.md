Langkah-Langkah setup:

1. download dan install di flutter https://flutter.dev/, kemudian setup environment variabelnya
2. download dan install di dart https://dart.dev/get-dart, kemudian setup environment variabelnya
3. git clone file ini
4. buka terminal, masuk ke folder file ini dengan perintah `cd path/to/file`
5. jalankan perintah `flutter pub get`
6. setup firebasenya, buka file 'android/app/build.gradle' dan sesuaikan semuanya dengan firebase 
7. buat authentication dengan email dan password di firebase
8. buat firestore database di firebase 
9. buat firebase storage di firebase
10. setup rulesnya dari 'false' jadi 'true'
11. jalankan perintah `flutter run` untuk menjalankan aplikasi


Langkah-Langkah shared preference:

1. buka file android/app/src/main/AndroidManifest.xml
2. tambahkan: "<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>"
3. kemudian edit file dart di lib yang diinginkan adanya shared preference (dalam kode ini adanya di splash_screen.dart)

Deployment: flutter build apk
