import 'package:flutter/material.dart';
import 'package:gastrodiag/helper/helper.dart';

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, title: 'Informasi', back: true, actions: [
        
      ]),
      body: Stack(
        children: <Widget>[

          SingleChildScrollView(
            padding: EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 75),
            child: Column(
              children: <Widget>[
                html(
                  '<b>Apa itu Penyakit Gastroenteritis?</b> <br><br>'
                  'Gastroenteritis merupakan penyakit yang membahayakan bagi sistem pencernaan dikarenakan terjadi akibat adanya infeksi virus maupun bakteri. Gastroenteritis atau flu perut merupakan suatu penyakit pencernaan dimana terjadi akibat adanya infeksi pada usus halus dan lambung yang disebabkan oleh beberapa virus antara lain norovirus, rotavirus, dan champylobacter. Gejala gastroenteritis ditandai pada lambung (gastro) dan usus halus/kecil (entero) terjadi peradangan yang menyebabkan penderita mengalami mual, muntah, diare, kejang perut serta dehidrasi yang berlebih.'
                  '<br/></br>Dehidrasi terdiri dari 2 jenis yaitu dehidrasi ringang/sedang dan dehidrasi berat. Dalam menentukan apakah anda dehidrasi ringan/sedang dengan dehidrasi berat dapat dilihat dari 3 gejala yang menandakan dehidrasi, untuk yg ringan/sedang gejala dehidrasi tersebut adalah mulut kering dan mata cekung Sedangkan untuk dehidrasi berat gejalanya adalah mulut kering, mata cekung, dan elastisitas kulit menurun.'

                  '<br><br><b>Gejala Penyakit Gastroenteritis</b> <br>'
                  '<ul>'
                    '<li>Demam di Atas 38oC</li>'
                    '<li>Uring-uringan</li>'
                    '<li>Gelisah</li>'
                    '<li>Menangis Tanpa Mengeluarkan Air Mata</li>'
                    '<li>Muntah Selama Lebih dari Beberapa Jam</li>'
                    '<li>Popok Tetap Kering Dalam Jangka Waktu Lama</li>'
                    '<li>Diare Disertai Darah</li>'
                  '</ul>'
                ),

                html(
                  '<br><b>Penanganan Gastroenteritis Pada Orang Dewasa</b> <br>'
                  
                  '<ul>'
                    '<li>Untuk mencegah dehidrasi, minum banyak cairan, minuman ringan, minuman olahraga, kaldu, atau cairan rehidrasi oral. Jika Anda terlalu mual untuk minum beberapa ons cairan sekaligus, cobalah meminum sedikit tegukan air dan minum dengan durasi yang lebih lama.<br></li>'
                    '<li>Setelah mual Anda mulai mereda, secara bertahap lanjutkan makan dengan normal. Mulailah dengan mengonsumsi sup bening berkaldu, kemudian nasi, sereal beras dan makanan berat. Sementara hindari produk susu dan makanan yang mengandung tepung terigu (seperti roti, makaroni, pizza) karena saluran pencernaan Anda mungkin sangat sensitif terhadap mereka selama beberapa hari. Juga hindari sementara makanan tinggi serat, seperti buah-buahan, jagung dan dedak.<br></li>'
                    '<li>Gunakan obat-obatan anti-diare hati-hati.<br></li>'
                    '<li>Beristirahat di tempat tidur.<br></li>'
                    '<li>Jika Anda memiliki gejala gastroenteritis parah, dokter mungkin meresepkan obat untuk meredakan mual, muntah dan diare, cairan infus untuk gejala dehidrasi berat, dan antibiotik jika tes tinja mengonfirmasi bahwa infeksi bakteri serius yang menyebabkan gastroenteritis.<br></li>'
                  '</ul>'
                ),

                html(
                  '<b>Penanganan Gastroenteritis Pada Anak</b> <br>'

                  '<ul>'
                    '<li>Berikan makanan dengan tekstur halus dan mudah dicerna, seperti roti, kentang, atau pisang.<br></li>'
                    '<li>Jangan memberikan anak Anda makanan atau minuman yang mengandung susu atau tinggi gula, seperti es krim, soda, dan permen.<br></li>'
                    '<li>Jangan memberikan anak Anda obat diare yang dijual bebas tanpa resep, kecuali atas anjuran dokter.<br></li>'
                  '</ul>'
                ),
                
              ],
            )
          ),

          Positioned(
            bottom: 22, left: MediaQuery.of(context).size.width - 130,
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12
                  ),
                borderRadius: BorderRadius.circular(50),

                ),
                child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomLeft: Radius.circular(50)
                    ),
                    child: InkWell(
                      highlightColor: black(opacity: .05),
                      splashColor: black(opacity: .08),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        bottomLeft: Radius.circular(50)
                      ),
                      onTap: (){
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled:true,
                          builder: (BuildContext context){
                            return Gastritis(paddingTop: MediaQuery.of(this.context).padding.top);
                          }
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: 15, left: 15, top: 5, bottom: 5),
                        
                        child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 5),
                            child: text('Gastritis', size: 17, bold: true, color: Colors.blue),
                          ),
                          Icon(Icons.arrow_forward, color: Colors.blue,),
                        ],
                    ),
                      )
                    ),
                  ),
                ),
              ),
          ),

          
        ],
      )
      
      
    );
  }
}

class Gastritis extends StatefulWidget {
  final paddingTop;
  Gastritis({this.paddingTop});

  @override
  _GastritisState createState() => _GastritisState();
}

class _GastritisState extends State<Gastritis> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - widget.paddingTop,
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: Column(
          children: <Widget>[
            
            Container(
              padding: EdgeInsets.only(left: 15, right: 0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black12)
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - 120,
                    child: text('Apa itu Penyakit Gastritis?', size: 20, bold: true)
                  ),

                  Material(
                    child: InkWell(
                      highlightColor: black(opacity: .05),
                      splashColor: black(opacity: .08),
                      onTap: (){ Navigator.pop(context); },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: Icon(Icons.close, color: Colors.redAccent,))
                    ),
                  )
                   
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    html(
                      'Gastritis adalah peradangan pada dinding lambung. Ini bukanlah penyakit, namun sebuah kondisi yang disebabkan oleh beragam faktor yang berbeda, seperti konsumsi alkohol berlebihan, stres, muntah-muntah yang kronis, atau obat-obatan tertentu.'

                      '<br><br><b>Gejala Penyakit Gastritis</b> <br>'
                      '<ul>'
                        '<li>Nyeri yang Terasa Panas dan Perih di Perut Bagian Uluhati.</li>'
                        '<li>Perut Kembung</li>'
                        '<li>Cegukan</li>'
                        '<li>Mual</li>'
                        '<li>Muntah</li>'
                        '<li>Hilang Nafsu Makan</li>'
                        '<li>Cepat Merasa Kenyang Saat Makan</li>'
                        '<li>Buang Air Besar Dengan Tinja Berwarna Hitam</li>'
                        '<li>Muntah Darah</li>'
                      '</ul>'
                    ),

                    html(
                      '<br><b>Penyebab Gastritis</b> <br><br>'
                      'Gastritis terjadi akibat peradangan pada dinding lambung. Dinding lambung tersusun dari jaringan yang mengandung kelenjar untuk menghasilkan enzim pencernaan dan asam lambung. Selain itu, dinding lambung juga dapat menghasilkan lendir (mukus) yang tebal untuk melindungi lapisan mukosa lambung dari kerusakan akibat enzim pencernaan dan asam lambung. Rusaknya mukus pelindung ini dapat menyebabkan peradangan pada mukosa lambung.'
                    ),

                    html(
                      '<br><b>Cara Penanggulangan</b> <br><br>'
                      'Pengobatan yang diberikan kepada pasien oleh dokter, tergantung kepada penyebab dan kondisi yang memengaruhi terjadinya gastritis. Untuk mengobati gastritis dan meredakan gejala-gejala yang ditimbulkan, dokter dapat memberikan obat-obatan berupa: <br>'

                      '<ul>'
                        '<li>Obat antasida. Antasida mampu meredakan gejala gastritis (terutama rasa nyeri) secara cepat, dengan cara menetralisir asam lambung. Obat ini efektif untuk meredakan gejala-gejala gastritis, terutama gastritis akut. Contoh obat antasida yang dapat dikonsumsi oleh pasien adalah aluminium hidroksida dan magnesium hidroksida.<br></li>'
                        '<li>Obat penghambat histamin 2 (H2 blocker). Obat ini mampu meredakan gejala gastritis dengan cara menurunkan produksi asam di dalam lambung. Contoh obat penghambat histamin 2 adalah ranitidin, cimetidine, dan famotidine.<br></li>'
                        '<li>Obat penghambat pompa proton (PPI). Obat ini memiliki tujuan yang sama seperti penghambat histamin 2, yaitu menurunkan produksi asam lambung, namun dengan mekanisme kerja yang berbeda. Contoh obat penghambat pompa proton adalah omeprazole, lansoprazole, esomeprazole, rabeprazole, dan pantoprazole.<br></li>'
                        '<li>Obat antibiotik. Obat ini diresepkan pada penderita gastritis yang disebabkan oleh infeksi bakteri, yaitu Helicobacter pylori. Contoh obat antibiotik yang dapat diberikan kepada penderita gastritis adalah amoxicillin, clarithromycin, tetracycline, dan metronidazole.<br></li>'
                        '<li>Obat antidiare. Diberikan kepada penderita gastritis dengan keluhan diare. Contoh obat antidiare yang dapat diberikan kepada penderita gastritis adalah bismut subsalisilat.</li>'
                      '</ul>'
                    ),
                  ],
                )
                
              ),
            )

            

          ],
        ),
    );
  }
}