import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gastrodiag/helper/helper.dart';
import 'package:csv/csv.dart';

class Result extends StatefulWidget {
  final data;
  Result({this.data});

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {

  importCsv(String filename) async{
    final csv = await rootBundle.loadString('assets/files/'+filename);
    List<dynamic> result = CsvToListConverter().convert(csv); // convert string ke dalam array
    return result;
  }

  var data = [], success = 0, countErr = 0, error = 0, totalRow = 0, errPercent = 0.0, sucPercent = 0.0, isInit = false, kelas, diagnosis = '';
  var solusi = [
    '<br>1. Makan makanan dengan tekstur halus dan mudah dicerna, seperti roti, kentang, atau pisang.<br><br> 2. Jangan makan atau minum yang mengandung susu atau tinggi gula, seperti es krim, soda, dan permen.<br><br> 3. Jangan mengkonsumsi obat diare yang dijual bebas tanpa resep, kecuali atas anjuran dokter. Pemberian obat sakit perut jenis apa pun sebaiknya dikonsultasikan terlebih dahulu dengan dokter.',
    '<br>1. Mengatur Pola Makan, pengidap perlu membuat pola dan jadwal makan yang teratur. Bila tidak nafsu makan atau merasa cepat kenyang, pengidap bisa menyiasatinya dengan makan sedikit-sedikit, tapi sering.<br><br> 2. Hindari Jenis Makanan Tertentu Pengidap juga dianjurkan untuk menghindari makanan berminyak, asam, ataupun pedas yang bisa membuat gejala gastritis bertambah parah.'+
    '<br><br>3. Kurangi Minuman Beralkohol, Alkohol juga merupakan minuman yang tidak baik untuk lambung yang sedang mengalami peradangan. Karena itu, pengidap gastritis dianjurkan untuk mengurangi, bahkan kalau bisa menghentikan kebiasaan minum minuman beralkohol.'+
    '<br><br>4. Hindari Stres, Faktor lainnya yang juga bisa memicu timbulnya gastritis adalah stres. Karena itu, pengidap dianjurkan untuk mengendalikan tingkat stresnya agar bisa cepat sembuh.'
  ];

  // init diagnosa
  initDiagnosis(){
    List<Widget> list = []; // deklarasi array list

    var no = 0;

    // perulangan data nilai dari pertanyaan
    for (var i = 0; i < widget.data.length; i++) {

      var value;

      switch (i) {
        case 0: if(data[i] == 1){ value = 'Mual'; } break;
        case 1: if(data[i] == 1){ value = 'Muntah'; } break;
        case 2: value = data[i] == 2 ? 'BAB >= 3x' : 'BAB < 3x'; break;
        case 3: value = data[i] == 1 ? 'Jenis tinja Anda padat' : data[i] == 2 ? 'Jenis tinja Anda Lembek' : 'Jenis tinja Anda Cair'; break;
        case 4: value = data[i] == 1 ? 'Dehidrasi sedang' : data[i] == 2 ? 'Dehidrasi berat' : null; break;
        case 5: if(data[i] == 2){ value = 'Demam'; } break;
        case 6: if(data[i] == 1){ value = 'Kram perut'; } break;
        case 7: if(data[i] == 1){ value = 'Sakit kepala'; } break;
        default:
      }
      
      if(value != null){
        no += 1;

        list.add( // isi list dengan widget
          ShowUp(
            delay: 300,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(5)
              ),
              child: text(no.toString()+'. '+value),
            ),
          )
        );
      }
    }

    // kembalikan berupa widget
    return list;
  }

  // baca file csv
  readCsv() async{
    // nilai gejala atau nilai jawaban (g1-g8)
    var g = widget.data, q = [g['g1'], g['g2'], g['g3'], g['g4'], g['g5'], g['g6'], g['g7'], g['g8']];

    // IMPORT CSV UNTUK PERSENTASE
    var csvPersentase = await importCsv('dataujiwadek.csv');

    // looping data uji untuk persentasenya
    for(var p = 0; p < csvPersentase.length; p++){
      var res = csvPersentase[p];

      // role : jika satu gejala cocok dengan data, maka success = +1, jika semua gejala tidak cocok dengan data maka error = +1

      if(res[0] == q[0] || res[1] == q[1] || res[2] == q[2] || res[3] == q[3] || res[4] == q[4] || res[5] == q[5] || res[6] == q[6] || res[7] == q[7]){
        // maka hitung sebagai sukses
        success += 1;
      }else{
        countErr += 1;
      }
    }

    errPercent = error / csvPersentase.length * 100;
    sucPercent = success / csvPersentase.length * 100;

    print('error : '+error.toString());
    print('success : '+success.toString());

    // IMPORT CSV UNTUK DIAGNOSA
    var csvDiagnosa = await importCsv('datawadek.csv');

    // revisi cara hitung untuk mencocokkan jawaban dengan data
    for (var i = 0; i < csvDiagnosa.length; i++) {
      var res = csvDiagnosa[i];
      
      // jika jawaban g1 - g8 dengan data g1 - g8 cocok
      if(res[0] == q[0] && res[1] == q[1] && res[2] == q[2] && res[3] == q[3] && res[4] == q[4] && res[5] == q[5] && res[6] == q[6] && res[7] == q[7]){
        // maka hitung sebagai sukses
        // success += 1; 
        kelas = res[8];
      }else{
        // countErr += 1;
      }
    }

    // jika antara jawaban (g1-g8) dengan data(g1-g8) tidak ada yang cocok sama sekali, maka hitung error
    if(countErr == csvDiagnosa.length){
      error += 1;
    }

    diagnosis = kelas == 2 ? 'Gastreonteritis' : 'Gastritis';
   
    var diagnos = kelas == 1 ? 'Gastreonteritis' : 'Gastritis';
    print('kelas : '+kelas.toString()+' ('+diagnos+')');

    isInit = true;
  }

  @override
  void initState() { 
    super.initState();

    // set data dengan nilai dari jawaban
    var g = widget.data;
    data = [g['g1'], g['g2'], g['g3'], g['g4'], g['g5'], g['g6'], g['g7'], g['g8']];

    // jalankan fungsi pembaca csv saat halaman dibuka
    readCsv(); print(g);
  }

  // tampilan hasil diagnosa
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, title: 'Hasil Diagnosa', back: true),
       body: SingleChildScrollView(
         padding: EdgeInsets.all(15),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             ShowUp(
               delay: 200,
               child: Container(
                 margin: EdgeInsets.only(bottom: 15),
                 child: text('Berdasarkan gejala yang Anda alami :', bold: true),
               ),
             ),

             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: initDiagnosis()
             ),

             ShowUp(
               delay: 500,
               child: Container(
                 margin: EdgeInsets.only(top: 15),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: <Widget>[
                     Container(
                       margin: EdgeInsets.only(bottom: 5),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: <Widget>[
                            text('Diagnosis : ', bold: true),
                            text(diagnosis, bold: true),
                         ],
                       ),
                     ),

                     Container(
                       margin: EdgeInsets.only(bottom: 5),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: <Widget>[
                          text('Persentase Error : ', bold: true),
                          !isInit ? text(0) : AnimatedCount(count: errPercent.toInt(), n: '%', bold: true)
                         ],
                       ),
                     ),

                     Container(
                       margin: EdgeInsets.only(bottom: 5),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: <Widget>[
                          text('Persentase Sukses : ', bold: true),
                          !isInit ? text(0) : AnimatedCount(count: sucPercent.toInt(), n: '%', bold: true)
                         ],
                       ),
                     ),

                     text('Solusi : ', bold: true),
                     html(kelas == 2 ? solusi[0] : solusi[1])
                   ],
                 ),
               ),
             )
           ],
         ),
       ),
      
    );
  }
}
