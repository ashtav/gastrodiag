import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gastrodiag/helper/helper.dart';
import 'package:gastrodiag/screens/diagnosis/result.dart';

class Questions extends StatefulWidget {
  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {

  DateTime currentBackPressTime; Timer timer;
  var totalQuestion = 0, answered = [], isAnswered = false,
      rv0 = 0, rv1 = 0, rv2 = 0, rv3 = 0, rv4 = 0, rv5 = 0, rv6 = 0, rv7 = 0,
      g = {'g1': 0, 'g2': 0, 'g3': 0, 'g4': 0, 'g5': 0, 'g6': 0, 'g7': 0, 'g8': 0};

  var questions = [ // daftar pertanyaan
    'Apakah Anda merasa mual dalam sehari ?',
    'Apakah Anda muntah dalam sehari ?',
    'Berapa kali Anda BAB dalam sehari ?',
    'Apa jenis konsistensi tinja Anda ?',
    'Dari nomor gejala dibawah ini (1. Mata cekung 2. Bibir kering 3. Elastisitas kulit menurun) manakah gejala yang Anda alami ?',
    'Apakah Anda mengalami demam (suhu tubuh lebih dari sama dengan 37,5) ?',
    'Apakah Anda mengalami kram perut seharian ?',
    'Apakah Anda mengalami pusing atau sakit kepala ?'
  ], options = [
    'Iya | Tidak',
    'Iya | Tidak',
    'Lebih dari atau sama dengan 3 kali | Kurang dari 3 kali',
    'Padat | Lembek | Cair',
    'No. 1 dan 2 saja | Semua Nomor | Tidak ada sama sekali',
    'Iya | Tidak',
    'Iya | Tidak',
    'Iya | Tidak',
  ], values = [
    '1 | 2',
    '1 | 2',
    '2 | 1',
    '1 | 2 | 3',
    '1 | 2 | 3',
    '2 | 1',
    '1 | 2',
    '1 | 2',
  ];

  _answered(index){
    if( !answered.contains(index) ){
      setState(() {
        answered.add(index);
      });
    }
  }


  // mempersiapkan (meng-inisialisasi) pertanyaan
  initQuestions(){
    List<Widget> listQuestions = []; // array untuk menampung widget pertanyaan

    _options(x){
      var listOptions = [ ];

      for (var i = 0; i < options.length; i++) {
        var ov = options[i].split(' | '),
            qv = values[i].split(' | ');

        listOptions.add(
          Column(
            children: List.generate(ov.length, (l){
            return Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                highlightColor: black(opacity: .09),
                splashColor: Colors.blue[100],
                onTap: (){
                  _answered(i);

                  var rv = int.parse(qv[l]);
                  setState(() {
                    switch (i) {
                      case 0: rv0 = g['g1'] = rv; break;
                      case 1: rv1 = g['g2'] = rv; break;
                      case 2: rv2 = g['g3'] = rv; break;
                      case 3: rv3 = g['g4'] = rv; break;
                      case 4: rv4 = g['g5'] = rv; break;
                      case 5: rv5 = g['g6'] = rv; break;
                      case 6: rv6 = g['g7'] = rv; break;
                      case 7: rv7 = g['g8'] = rv; break;
                    }
                  });
                },

                child: Container(
                  
                  child: Row(
                    children: [
                      new Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: int.parse(qv[l]),
                        groupValue: i == 0 ? rv0 : i == 1 ? rv1 : i == 2 ? rv2 : i == 3 ? rv3 : i == 4 ? rv4 : i == 5 ? rv5 : i == 6 ? rv6 : rv7,
                        onChanged: (int value){
                          _answered(i);

                          setState(() {
                            switch (i) {
                              case 0: rv0 = g['g1'] = value; break;
                              case 1: rv1 = g['g2'] = value; break;
                              case 2: rv2 = g['g3'] = value; break;
                              case 3: rv3 = g['g4'] = value; break;
                              case 4: rv4 = g['g5'] = value; break;
                              case 5: rv5 = g['g6'] = value; break;
                              case 6: rv6 = g['g7'] = value; break;
                              case 7: rv7 = g['g8'] = value; break;
                            }
                          });
                        },
                      ),
                      
                      text(ov[l])
                    ],
                  ),
                ),
              ),
            );
          }),
          )
        );
        
      }

      return listOptions[x];
    }

    // mengisi array listQuestions, 
    for (var i = 0; i < questions.length + 1; i++) {

      listQuestions.add(
        i == questions.length ? Container(
          margin: EdgeInsets.all(15),
          child: Material(
            color: answered.length < questions.length || isAnswered ? Colors.black26 : Colors.blue,
            borderRadius: BorderRadius.circular(5),
            child: InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: answered.length < questions.length || isAnswered ? null : _calculate,
              splashColor: Colors.blue[900],
              highlightColor: Colors.blue[700],
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 15, right: 15, top: 13, bottom: 13),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5)
                ),
                child: isAnswered ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    spiner(color: Colors.white, position: 'center', size: 17),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: text('Mohon menunggu...', color: Colors.white),
                    )
                  ]) : text('CEK HASIL', align: 'center', bold: true, color: Colors.white, spacing: 1),
              ),
            ),
          ),
        ) :

        Container(
          padding: EdgeInsets.only(bottom: 15, left: 15, right: 15, top: 25),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black12)),
            color: i % 2 == 0 ? black(opacity: .02) : Colors.white
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              text((i+1).toString()+'. '+questions[i], size: 15.5), _options(i)
            ],
          )
        )
      );
    }

    return listQuestions; // mengembalikan widget
  }

  void _calculate(){
    setState(() { isAnswered = true; });

    timer = Timer(Duration(seconds: 1), (){   
      setState(() { isAnswered = false; });

      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext _) {
          return Container(
            height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
            child: Result(data: g),
          );
        }
      );
    });
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now; toast('Tekan sekali lagi untuk keluar'); return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  void initState() { 
    super.initState();
    totalQuestion = questions.length;
  }

  @override
  void dispose() {
    super.dispose();

    if(timer != null){ timer.cancel(); }
  }


  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: appBar(context, title: 'Pertanyaan', back: true, actions: <Widget>[
          
          Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.black12)
              )
            ), 
            child: IconButton(
              icon:  text(answered.length.toString()+'/'+totalQuestion.toString(), size: 17),
              onPressed: (){
                answered.length == questions.length ?
                box(context, message: answered.length.toString()+' dari '+questions.length.toString()+' pertanyaan terjawab, cek hasilnya sekarang!') :
                box(context, message: answered.length.toString()+' dari '+questions.length.toString()+' pertanyaan terjawab, lengkapi '+(questions.length - answered.length).toString()+' pertanyaan lainnya');
              },
            ),
          ),

          IconButton(
            icon: Icon(Icons.info, color: Colors.blue),
            onPressed: (){
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (BuildContext _) {
                  return QuestionInfo();
                }
              );
            },
          )
          
        ]),

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: initQuestions(),
          ),
        ),
      )
    );
  }
}

class QuestionInfo extends StatefulWidget {
  @override
  _QuestionInfoState createState() => _QuestionInfoState();
}

class _QuestionInfoState extends State<QuestionInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160, padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15)
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: html(
              '<b>INFORMASI CARA PEMAKAIAN</b> <br><br>'
              'Silahkan jawab pertanyaan dengan cara menyentuh icon bulat setelah tanda <b>"?"</b> pada setiap pertanyaan. Setelah semua pertanyaan dicentang silahkan sentuh tombol <b>"CEK HASIL"</b>.'
            ),
          ),

        ],
      )
      
    );
  }
}