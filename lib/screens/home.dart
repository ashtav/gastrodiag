
// menyiapkan package dan fungsi yang digunakan
import 'package:flutter/material.dart';
import 'package:gastrodiag/helper/helper.dart';
import 'package:gastrodiag/screens/about.dart';
import 'package:gastrodiag/screens/diagnosis/questions.dart';
import 'package:gastrodiag/screens/info.dart';

class Home extends StatefulWidget { // class home
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> { // state manajemen

  DateTime currentBackPressTime; // deklarasi waktu (untuk saat user menekan tombol kembali)

  initMenu(){ // fungsi inisialisasi menu, fungsi ini mengembalikan sebuah widget (array)
    List<Widget> list = []; // deklarasi list array

    var title = ['Diagnosa Penyakit','Informasi','Tentang Aplikasi'], // judul menu
        icons = [Icons.assignment_ind,Icons.info,Icons.help]; // icon menu

    for (var i = 0; i < title.length; i++) { // melakukan perulangan berdasarkan jumlah judul menu
      list.add( // menambahkan widget kedalam list array
        Container( // dari sini hingga tanda sebelum ";" adalah widget
          margin: EdgeInsets.only(bottom: 10),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            child: InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: (){
                // pindah halaman saat menu diklik, jika i == 0 maka pergi ke halaman questions dst...
                Navigator.push(context, MaterialPageRoute( builder: (context) => i == 0 ? Questions() : i == 1 ? Info() : About() ));
              },
              splashColor: Colors.blue[100],
              highlightColor: black(opacity: .05),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(5)
                ),
                padding: EdgeInsets.only(left: 15, top: 13, bottom: 13, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(icons[i], color: Colors.blue,),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: text(title[i], bold: true, color: Colors.blue)
                        )
                      ],
                    ), Icon(Icons.chevron_right, color: Colors.blue[400],)
                  ],
                ) ,
              ),
            ),
          ),
        )
      );
    }

    return list;
  }

  Future<bool> onWillPop() { // mencegah aplikasi close saat user tidak sengaja menekan "back"
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now; toast('Tekan sekali lagi untuk keluar'); return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) { // widget yang telah disiapkan, ditampilkan disini
    return new WillPopScope(
      onWillPop: onWillPop,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.blue[50],
          body: SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Container(
              margin: EdgeInsets.only(top: 25),
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  text('Gastro Diag', size: 45, bold: true, spacing: 1),

                  Container(
                    margin: EdgeInsets.only(top: 25),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/img/logo.png"),
                      ),
                    ),
                    height: 140,  width: 140,
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 35),
                    child: Column(
                      children: initMenu(),
                    ),
                  ),
                  
                  text('© 2019, Gastro Diag', color: Colors.blue)
                ],
              ),
            ),
          )
        ),
      )
    );
  }
}