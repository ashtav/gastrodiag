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

  var data = [], success = 0, countErr = 0, error = 0, totalRow = 0, errPercent = 0.0, sucPercent = 0.0, isInit = false, kelas, diagnosis = '';

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
    final csv = await rootBundle.loadString('assets/files/datatest.csv');
    List<dynamic> result = CsvToListConverter().convert(csv); // convert string ke dalam array

    // hitung total data dari file csv
    totalRow = result.length;

    // nilai gejala atau nilai jawaban (g1-g8)
    var g = widget.data, q = [g['g1'], g['g2'], g['g3'], g['g4'], g['g5'], g['g6'], g['g7'], g['g8']];
    
    // cocokkan nilai dari gejala dengan data uji
    // for (var i = 0; i < result.length; i++) {
    //   var res = result[i];
      
    //   if(res[0] == q[0] && res[1] == q[1] && res[2] == q[2] && res[3] == q[3] && res[4] == q[4] && res[5] == q[5] && res[6] == q[6] && res[7] == q[7]){
    //     success += 1; kelas = res[8];
    //   }else{
    //     error += 1;
    //   }
    // }

    // revisi cara hitung untuk mencocokkan jawaban dengan data
    for (var i = 0; i < result.length; i++) {
      var res = result[i];
      
      // jika jawaban g1 - g8 dengan data g1 - g8 cocok
      if(res[0] == q[0] && res[1] == q[1] && res[2] == q[2] && res[3] == q[3] && res[4] == q[4] && res[5] == q[5] && res[6] == q[6] && res[7] == q[7]){
        // maka hitung sebagai sukses
        success += 1; kelas = res[8];
      }else{
        countErr += 1;
      }
    }

    // jika antara jawaban (g1-g8) dengan data(g1-g8) tidak ada yang cocok sama sekali, maka hitung error
    if(countErr == result.length){
      error += 1;
    }

    errPercent = error / totalRow * 100;
    sucPercent = success / totalRow * 100;

    diagnosis = kelas == 2 ? 'Gastreonteritis' : 'Gastritis';

    print('total data : '+totalRow.toString());
    print('error : '+error.toString());
    print('success : '+success.toString());
    var diagnos = kelas == 1 ? 'Gastreonteritis' : kelas == 2 ? 'Gastritis' : 'Tidak ditemukan';
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
