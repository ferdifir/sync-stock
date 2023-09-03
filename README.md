# Stock Mobile Sync

![Screenshot UI](https://github.com/ferdifir/sync-stock/blob/main/screenshot/synctock.png)

Aplikasi Flutter yang dibangun dengan fitur-fitur berikut:

- Login: Memungkinkan pengguna untuk masuk ke aplikasi menggunakan akun mereka.
- List Product: Menampilkan daftar produk beserta informasi terkait seperti harga, stok, dll.
- Laporan Penjualan: Memungkinkan pengguna untuk melihat laporan penjualan yang mencakup informasi terkait transaksi penjualan.
- Laporan Pembelian: Memungkinkan pengguna untuk melihat laporan pembelian yang mencakup informasi terkait transaksi pembelian.
- Sinkronisasi Data: Aplikasi ini memiliki kemampuan untuk sinkronisasi data dengan server, sehingga pengguna dapat mengakses dan menggunakan aplikasi bahkan saat offline. Data akan disinkronkan ketika user membutuhkan data terbaru dari server.
- Dependency yang Digunakan:
    - glassmorphism: Digunakan untuk menciptakan tampilan antarmuka dengan efek glassmorphism yang elegan.
    - dio: Digunakan untuk melakukan permintaan HTTP ke server untuk sinkronisasi data.
    - get: Digunakan sebagai state management dan routing framework.
    - shared_preferences: Digunakan untuk menyimpan data pengguna seperti token autentikasi secara lokal.
    - sqflite: Digunakan sebagai database lokal untuk menyimpan data aplikasi.
    - intl: Digunakan untuk melakukan format dan lokalisisasi data seperti tanggal, waktu, dan bahasa.

## Instalasi

1. Pastikan Anda telah menginstal Flutter di komputer Anda. [Panduan Instalasi Flutter](https://flutter.dev/docs/get-started/install)

2. Clone repositori ini ke komputer Anda:
```
    git clone https://github.com/ferdifir/sync-stock.git
```
3. Masuk ke direktori aplikasi:
```
    cd sync-stock
```
4. Jalankan perintah berikut untuk menginstal dependensi yang diperlukan:
```
    flutter pub get
```
5. Setelah proses instalasi selesai, jalankan aplikasi:
```
    flutter run
```
