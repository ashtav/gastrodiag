import 'package:flutter/material.dart';
import 'package:gastrodiag/helper/helper.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, title: 'Tentang Aplikasi', back: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[

            html(
              '<b>Gastro Diag</b> adalah sebuah aplikasi yang dibuat untuk mendeteksi penyakit bernama Gastroenteritis dengan menggunakan metode <b><i>CART (Classification And Regression Tree)</i></b> dalam pengambilan keputusan.<br/>'
              '</br>Harapan adanya aplikasi sistem pakar diagnosa penyakit gastroenteritis ini agar masyarakat umum dapat mengetahui informasi seputar penyakit gastroenteritis dan cara penanggulangannya yang cepat dan tepat apabila terserang penyakit tersebut.'
              '<br/><br/><b>Dibuat Oleh: I Dewa Made Krisnayana<br/> Universitas Udayana (UNUD)</b> <br/><br/>'
            )
          ],
        ),
      ),
    );
  }
}