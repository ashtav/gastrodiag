// last update : 12/12/2019

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';

class PreventScrollGlow extends ScrollBehavior { // this class is to prevent scroll glow
  @override
  Widget buildViewportChrome(
    BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

final oCcy = new NumberFormat("#,##0", "en_US");

number(String n){
  var x = int.parse(n);
  return "${oCcy.format(x)}".replaceAll(',', '.');
}

ucwords(str){
  if(str != '' && str != null){
    var splitStr = str.toLowerCase().split(' ');
    for (var i = 0; i < splitStr.length; i++) {
      splitStr[i] = splitStr[i][0].toUpperCase() + splitStr[i].substring(1);     
    }
    return splitStr.join(' ');
  }else{
    return '';
  }
}

toast(String msg){
  return Fluttertoast.showToast(
    msg: msg == null ? 'Kesalahan Server' : msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    
    timeInSecForIos: 1,
    backgroundColor: Color.fromRGBO(0, 0, 0, .8),
    textColor: Colors.white,
    fontSize: 14.0
  );
}


// encode & decode, encode('string'); decode(datajson);
encode(data){ return json.encode(data); }
decode(data){ return json.decode(data); }

// set data ke local storage, setPrefs('user', data, true);
setPrefs(key, data, {enc: false}) async{
  var prefs = await SharedPreferences.getInstance();
  prefs.setString(key, enc ? encode(data) : data);
}

// get data dari local storage, getPrefs('key').then((res){ print(res); });
getPrefs(key, {dec: false}) async{
  var prefs = await SharedPreferences.getInstance();
  var data = prefs.getString(key);
  return data == null ? 'null' : dec ? decode(data) : data;
}

// check data local storage, checkPrefs();
checkPrefs() async{
  var prefs = await SharedPreferences.getInstance();
  print(prefs.getKeys());
}

// clear all local storage, clearPrefs(['user']); -> kecuali data user
clearPrefs({List except}) async{
  var prefs = await SharedPreferences.getInstance(), keys = prefs.getKeys();
  for (var i = 0; i < keys.toList().length; i++) {
    if( except.indexOf(keys.toList()[i]) < 0 ){
      prefs.remove(keys.toList()[i]);
    }
  }
}


appBar(context, {title, elevation = 1, back: false, spacing: 15, List<Widget> actions, autoLeading: false}){
  return back ? new AppBar(
    backgroundColor: Colors.white,
    automaticallyImplyLeading: autoLeading,
    titleSpacing: 0,
    elevation: elevation.toDouble(),
    leading: IconButton( onPressed: (){ Navigator.pop(context); }, icon: Icon(Icons.arrow_back), color: Colors.black87, ),
    title: title is Widget ? title : text(title, color: black(), size: 20, bold: true ),
    actions: actions,
  ) : 
  new AppBar(
    backgroundColor: Colors.white,
    automaticallyImplyLeading: autoLeading,
    titleSpacing: spacing.toDouble(),
    elevation: elevation.toDouble(),
    title: title is Widget ? title : text(title, color: black(), size: 20, bold: true ),
    actions: actions,
  );
}

box(context, {dismiss: true, title, message}){
  showDialog(
    context: context,
    barrierDismissible: dismiss,
    builder: (BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(30),
              padding: EdgeInsets.only(bottom: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    title == null ? ListTile(
                      subtitle: Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Html(data: message, defaultTextStyle: TextStyle(fontFamily: 'sans'),),
                      ),
                    ) :

                    ListTile(
                      title: Container(
                        margin: EdgeInsets.only(left: 3),
                        child: text(title, bold: true)),
                      subtitle: Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Html(data: message, defaultTextStyle: TextStyle(fontFamily: 'sans'),),
                      ),
                      
                    ),
                    
                  ],
                )
            )
          )
        ],
      );
      
    },
  );
}

emailValidate(String email){
  return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
}

dateTime({format: 'datetime'}){ // datetime, date, time
  var date = new DateTime.now().toString().split('.');
  var dateTime = date[0].split(' ');
  return format == 'datetime' ? date[0] : format == 'date' ? dateTime[0] : dateTime[1];  
}

// date format must be 2019-07-30 13:39:45
dateFormat(date, {format: 'd-M-y', type: 'short'}){
  var dateParse = DateTime.parse(date);
  var bln = ['Januari','Februari','Maret','April','Mei','Juni','Juli','Agustus','September','Oktoberr','November','Desember'];
 
  var x = date.split(' ')[0],
  d = int.parse(x.split('-')[2]).toString().length,
  m = int.parse(x.split('-')[1]).toString().length;

  var dd = 'd', mm = 'M';

  if(d == 1){ dd = '0d'; }
  if(m == 1){ mm = '0M'; }

  _d(dt){ return DateFormat( dt ).format(dateParse); }

  switch (format) {
    case 'd': return DateFormat(d == 1 ? '0d' : 'd').format(dateParse); break;
    case 'M': return DateFormat('MMM').format(dateParse); break;
    case 'F': return DateFormat('MMMM').format(dateParse); break;
    case 'Y': return DateFormat('y').format(dateParse); break;
    default: return type == 'short' ? DateFormat( dd+'-'+mm+'-y' ).format(dateParse) : _d(dd)+' '+bln[int.parse(_d(mm)) - 1]+' '+_d('y');
  }
}

api(url){
  // return 'https://kpm-api.kembarputra.com/'+url;
  return 'https://kpm-api.webku.org/'+url;
}

text(text, {color, size: 15, bold: false, align: 'left', spacing: 0, font: 'sans'}){
  return Text(text.toString(), softWrap: true, textAlign: align == 'center' ? TextAlign.center : align == 'right' ? TextAlign.end : TextAlign.start, style: TextStyle(
      color: color == null ? Color.fromRGBO(60, 60, 60, 1) : color, 
      fontFamily: font,
      fontSize: size.toDouble(),
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      letterSpacing: spacing.toDouble(),
    ),
  );
}

nodata({message: '', img: 'no-data.png', Function onRefresh}){
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

      children: <Widget>[
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/img/'+img, height: 100),
              Container(
                padding: EdgeInsets.all(10),
                child: text(message, color: Colors.black54, size: 15, align: 'center')
              ),
              Container(
                child: onRefresh != null ? IconButton(
                  icon: Icon(Icons.refresh, color: Colors.black54,),
                  onPressed: onRefresh,
                ) : SizedBox.shrink(),
              )
            ],
          ),
          padding: EdgeInsets.all(10),
        )
      ],
    )
  );
}

class Comp{

  textSparate(list, {color: Colors.white}){
    List<Widget> wList = [];

    for (var i = 0; i < list.length; i++) {
      wList.add(
        Container(
          padding: EdgeInsets.only(right: i == list.length - 1 ? 0 : 15),
          margin: EdgeInsets.only(right: i == list.length - 1 ? 0 : 15),
          decoration: BoxDecoration(
            border: Border(right: BorderSide(color: i == list.length - 1 ? Colors.transparent : white(opacity: .5)))
          ),
          child: text(list[i], color: color),
        )
      );
    }

    return wList;
  }
}

html(message, {borderBottom, padding: 0}){
  return Container(
    padding: EdgeInsets.all(padding.toDouble()),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: borderBottom == null ? Colors.transparent : borderBottom
        )
      )
    ),
    child: Html(data: message, defaultTextStyle: TextStyle(fontFamily: 'sans'))
  );
}


class Hover extends StatelessWidget {
  final child, radius; 
  final Function onTap, onDoubleTap;
  Hover({this.child, this.radius: 0, this.onTap, this.onDoubleTap});

  @override
  Widget build(BuildContext context) {
      return new Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(this.radius.toDouble()),
        child: new InkWell(
          borderRadius: BorderRadius.circular(this.radius.toDouble()),
          // highlightColor: Colors.transparent,
          // splashColor: Colors.blue[50],
          hoverColor: Colors.blue[50],
          focusColor: Colors.blue[50],
          onTap: onTap,
          onDoubleTap: (){},
          child: this.child
        )
      );
  }
}

alertInfo(message){
  return Container(
    child: text(message),
    margin: EdgeInsets.only(bottom: 15),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Color.fromRGBO(218, 234, 251, 1),
      border: Border.all(color: Color.fromRGBO(204, 226, 250, 1)),
      borderRadius: BorderRadius.circular(5)
    ),
  );
}

timeAgo(datetime){
  Duration compare(DateTime x, DateTime y) {
    return Duration(microseconds: (x.microsecondsSinceEpoch - y.microsecondsSinceEpoch).abs());
  }

  var split = datetime.toString().split(' ');
  var date = split[0].split('-');
  var time = split[1].split(':');

  DateTime x = DateTime.now();
  DateTime y = DateTime(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]), int.parse(time[0]), int.parse(time[1]), int.parse(time[2]));  
  
  var diff = compare(x, y);

  // return 'minute: '+diff.inMinutes.toString()+', second: '+diff.inSeconds.toString();

  if(diff.inSeconds >= 60){
    if(diff.inMinutes >= 60){
      if(diff.inHours >= 24){
        return diff.inDays.toString()+' hari yang lalu';
      }else{
        return diff.inHours.toString()+' jam yang lalu';
      }
    }else{
      return diff.inMinutes.toString()+' menit yang lalu';
    }
  }else{
    return 'baru saja';
  }
}

getDay(datetime){
  Duration compare(DateTime x, DateTime y) {
    return Duration(microseconds: (x.microsecondsSinceEpoch - y.microsecondsSinceEpoch).abs());
  }

  var split = datetime.toString().split(' ');
  var date = split[0].split('-');
  var time = split[1].split(':');

  DateTime x = DateTime.now();
  DateTime y = DateTime(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]), int.parse(time[0]), int.parse(time[1]), int.parse(time[2]));  
  
  var diff = compare(x, y);
  return diff.inDays;
}


  calculateAge(date){
    var today = DateTime.now();
    var birthDate = DateTime.parse(date);
    var age = today.year - birthDate.year;
    var m = today.month - birthDate.month;
    if (m < 0 || (m == 0 && today.day < birthDate.day)) {
        age--;
    }

    return age.toString();
  }

  Widget searchField({Function onChange, hint: '', size: 16, focus: true, enable: true}){
    return new TextField(
      autofocus: focus,
      enabled: enable,
      decoration: InputDecoration(
        hintText: hint,
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.black54)
      ),
      style: TextStyle(color: Colors.black87, fontSize: size.toDouble()),
      onChanged: onChange,
    ); 
  }

  sparator({height: 30, color, space: 0}){
    return Container(
      margin: EdgeInsets.only(left: space.toDouble(), right: space.toDouble()),
      height: height.toDouble(),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: color == null ? black() : color
          )
        )
      ),
      child: Text(''),
    );
  }

  alert(String value) {
    BuildContext context;
    Widget cancelButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () { Navigator.pop(context); },
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Alert"),
          content: Text(value),
          actions: [
            cancelButton,
          ],
        );
      },
    );
  }

  

  snackToast(scaffold, msg){
    final snackBar = SnackBar(
      content: Text(msg),
      // action: SnackBarAction(
      //   label: 'Undo',
      //   onPressed: () {
          
      //   },
      // ),
    );
    scaffold.currentState.showSnackBar(snackBar);
  }
  
  generate(){
    return DateTime.now().millisecondsSinceEpoch;
  }

  loader({message: 'Loading...', size: 15.0, color: 'blue'}){
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            child: new Container(
              padding: EdgeInsets.all(1),
              child: new CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation( color == 'blue' ? Colors.blue : Colors.white),
                strokeWidth: 2.0),
            ),
            height: size,
            width: size,
          ),

          Container(
            margin: EdgeInsets.only(left: message == '' ? 0 : 10),
            child: Text(message),
          )
        ],
      )
    );
  }
  
  

  formControl(controller, {
    mt: 0.0, mb: 0.0, ml: 0.0, mr: 0.0, m: 0.0,
    keyboardType: 'text', length: 255, enabled: true,
    autofocus: false, obsecure: false, hint: ''
  }){
    return Container(
      margin: m != 0.0 ? EdgeInsets.all(m) : EdgeInsets.only(top: mt, bottom: mb, left: ml, right: mr),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: new TextField(
        inputFormatters: [ LengthLimitingTextInputFormatter(length) ],
        controller: controller,
        enabled: enabled,
        autofocus: autofocus,
        obscureText: obsecure,
        keyboardType: keyboardType == 'text' ? TextInputType.text : keyboardType == 'phone' ? TextInputType.phone : keyboardType == 'email' ? TextInputType.emailAddress : TextInputType.number,
        decoration: new InputDecoration(
          hintText: hint,
          contentPadding: EdgeInsets.all(15),
            border: new OutlineInputBorder( ),
          ),
      ),
    );
  }

  

  outlineInputBorder({circular: 25}){
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black12),
      borderRadius: BorderRadius.circular(circular.toDouble())
    );
  }

  blueColor(){
    return Color.fromRGBO(125, 204, 255, 1);
  }

  black({opacity: 1}){
    return Color.fromRGBO(60, 60, 60, opacity.toDouble());
  }

  white({opacity: 1}){
    return Color.fromRGBO(255, 255, 255, opacity.toDouble());
  }

  background(){
    return Color.fromRGBO(245, 247, 251, 1);
  }
  
  

spiner({size: 15, color: 'blue', stroke: 2, margin: 0, marginX: 0, message: 'loading', position: 'default'}){
  Widget spinerWidget(){
    return Container(
      margin: margin == 0 ? EdgeInsets.only(left: marginX.toDouble(), right: marginX.toDouble()) : EdgeInsets.all(margin.toDouble()),
      child: SizedBox(
        child: new Container(
          padding: EdgeInsets.all(1),
          child: new CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation( color == 'blue' ? Colors.blue : Colors.white),
            strokeWidth: stroke.toDouble()),
        ),
        height: size.toDouble(),
        width: size.toDouble(),
      )
    );
  }  

  return position == 'center' ?

  Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[ spinerWidget() ],
    )
  ) : spinerWidget();
}

spin({size: 15, color: 'blue', stroke: 2, margin: 0, marginX: 0, message: 'loading', position: 'default'}){
  Widget spinerWidget(){
    return Container(
      margin: margin == 0 ? EdgeInsets.only(left: marginX.toDouble(), right: marginX.toDouble()) : EdgeInsets.all(margin.toDouble()),
      child: SizedBox(
        child: new Container(
          padding: EdgeInsets.all(1),
          child: new CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation( color == 'blue' ? Colors.blue : Colors.white),
            strokeWidth: stroke.toDouble()),
        ),
        height: size.toDouble(),
        width: size.toDouble(),
      )
    );
  }  

  return position == 'center' ?

  Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[ spinerWidget() ],
    )
  ) : spinerWidget();
}

getFirstChar(string, {length: 2}){
  var str = string.split(' ');
  var char = '';

  for (var i = 0; i < str.length; i++) {
    if(i < length){
      char += str[i].substring(0, 1);
    }
  }

  return char.toUpperCase();
}

listSidebar(icon, label, {onTap: Function, subtitle}){
  return Container(
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.black12))
    ),
    child: subtitle == null ?
      ListTile(
        title: Row(
          children: <Widget>[
            Icon(icon, color: Colors.black54),
            Container(
              padding: EdgeInsets.only(left: 15),
              child: text(label, bold: true)
            )
          ],
        ),
        onTap: onTap
      ) :

      ListTile(
        title: Row(
          children: <Widget>[
            Icon(icon, color: Colors.black54),
            Container(
              padding: EdgeInsets.only(left: 15),
              child: text(label, bold: true)
            )
          ],
        ),
        subtitle: Container(
          margin: EdgeInsets.only(left: 35),
          child: text(subtitle),
        ),
        onTap: onTap
      )
  );
}

class BottomSheetContainer extends StatelessWidget{
  final List<Widget> children;
  BottomSheetContainer({this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190.0,
      padding: EdgeInsets.only(top: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10)
        )
      ),
      child: Column(
        children: children,
      )
    );
  }

  
}


class FormControl {
    final context, font = 'sans';
    FormControl(this.context);

    numberPicker({initValue,  Function onChange, List<int> options}){
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context){
          return Container(
            height: 150.0,
            padding: EdgeInsets.only(top: 9),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10)
              )
            ),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: initValue,
                      ),
                      itemExtent: 40.0,
                      backgroundColor: Colors.white,
                      onSelectedItemChanged: onChange,
                      children: new List<Widget>.generate(
                      options.length, (int i) {
                        return new Center(
                          child: text(options[i], size: 17),
                        );
                      }
                    )),
                  ),

                ],
              ),
          );
        }
      );
    }

    selector({label: '', controller, Function onTap, enabled: true, marginT: 0, marginB: 10}){
      return Container(
        margin: EdgeInsets.only(bottom: marginB.toDouble()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: marginT.toDouble(), bottom: 5),
              child: text(label, bold: true),
            ),

            new Material(
              borderRadius: BorderRadius.circular(3),
              color: enabled ? Colors.white : black(opacity: .04),
              child: InkWell(
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(5),
                splashColor: Colors.blue[50],
                onTap: enabled ? onTap : null,
                child: Container(
                  padding: EdgeInsets.only(left: 15, top: 10, bottom: 10, right: 15),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(color: enabled ? Colors.black38 : Colors.black12, ),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: text(controller == null ? '' : controller.text)
                )
              )
            )

          ],
        ),
      );
    }

    formControl(controller, {
      mt: 0.0, mb: 0.0, ml: 0.0, mr: 0.0, m: 0.0,
      keyboardType: 'text', length: 255, enabled: true,
      autofocus: false, obsecure: false, hint: ''
    }){
      return Container(
        margin: m != 0.0 ? EdgeInsets.all(m) : EdgeInsets.only(top: mt, bottom: mb, left: ml, right: mr),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: new TextField(
          inputFormatters: [ LengthLimitingTextInputFormatter(length) ],
          controller: controller,
          enabled: enabled,
          autofocus: autofocus,
          obscureText: obsecure,
          keyboardType: keyboardType == 'text' ? TextInputType.text : keyboardType == 'phone' ? TextInputType.phone : keyboardType == 'email' ? TextInputType.emailAddress : TextInputType.number,
          decoration: new InputDecoration(
            hintText: hint,
            contentPadding: EdgeInsets.all(15),
              border: new OutlineInputBorder( ),
            ),
        ),
      );
    }

    input({label: '', controller, maxLength: 255, focusNode, type, action, Function onSubmit, Function trailing, obsecure: false, hint: '', bottom: 5, top: 10, enabled: true}){
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: label == '' ? 0 : top.toDouble(), bottom: 5),
              child: text(label, bold: true),
            ),
            
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Stack(
                alignment: const Alignment(1, -1),
                children: <Widget>[

                  Align(
                    alignment: Alignment.topLeft,
                      child: Container(
                      height: 40,
                      width: trailing is Function ? MediaQuery.of(context).size.width - 90 : MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 0, bottom: bottom.toDouble()),
                      decoration: BoxDecoration(
                        color: enabled ? Colors.white : black(opacity: 0.05),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextField(
                        style: TextStyle(fontFamily: font),
                        obscureText: obsecure,
                        focusNode: focusNode,
                        decoration: new InputDecoration(
                          hintText: hint,
                          contentPadding: EdgeInsets.only(left: 15, right: 15),
                          border: new OutlineInputBorder( ),
                        ),
                        enabled: enabled,
                        controller: controller,
                        keyboardType: type == null ? TextInputType.text : type,
                        textInputAction: action == null ? TextInputAction.done : action,
                        onSubmitted: onSubmit,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(maxLength),
                        ],
                      ),
                    ),
                  ),

                  trailing is Function ?
                    IconButton(
                      icon: Icon(Icons.assignment, color: Colors.black54,),
                      onPressed: trailing,
                    ) : SizedBox.shrink()
                ]
              ),
                
            )
          ],
        ),
      );
    }

    textarea({label: 'Label', hint: '', controller, maxlines: 2, bottom: 0}){
      return Container(
        margin: EdgeInsets.only(bottom: bottom.toDouble()),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            label == '' ? SizedBox.shrink() :
            new Container(
              margin: EdgeInsets.only(bottom: 5, top: 15),
              child: text(label, bold: true),
            ),

            new Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5)
              ),

              child: new TextField(
                style: TextStyle(fontFamily: font),
                keyboardType: TextInputType.text,
                maxLines: maxlines,
                controller: controller,
                decoration: new InputDecoration(
                  hintText: hint,
                  contentPadding: EdgeInsets.only(left: 15, right: 15),
                  border: new OutlineInputBorder( ),
                ),
                
              ),
            )
            
          ],
        ),
      );
    }

    button({label, Function onPressed, width: 'block', marginY: 15, marginX: 0, color: Colors.blueAccent}){
      return ConstrainedBox( constraints: BoxConstraints(minWidth: width == 'block' ?  double.infinity : width.toDouble()),
        child: new Container(
        margin: EdgeInsets.only(bottom: marginY.toDouble(), top: marginY.toDouble(), left: marginX.toDouble(), right: marginX.toDouble()),
          child: new RaisedButton(
            child: label,
            color: color,
            padding: const EdgeInsets.all(5.0),
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
            splashColor: Color.fromRGBO(255, 255, 255, .2),
            onPressed: onPressed
          )
        ),
      );
    }

    picker({label: '', initialItem: 0, controlButton = false, bottom: 0, options: List, Function onChange, Function onSelect }){
      return Container(
        margin: EdgeInsets.only(bottom: bottom.toDouble()),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.transparent
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 5, top: 15),
              child: text(label, bold: true)
            ),
            GestureDetector(
              onTap: (){
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context){
                    return Container(
                      height: 150.0,
                      padding: EdgeInsets.only(top: 9),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)
                        )
                      ),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            
                            controlButton ? 
                              CupertinoButton(
                                child: Icon(Icons.close),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ) : SizedBox.shrink(),

                            Expanded(
                              child: CupertinoPicker(
                                
                                scrollController: FixedExtentScrollController(
                                  initialItem: initialItem,
                                ),
                                itemExtent: 40.0,
                                backgroundColor: Colors.white,
                                onSelectedItemChanged: onChange,
                                children: new List<Widget>.generate(
                                options.length, (int index) {
                                  return new Center(
                                    child: text( ucwords(options[index]) , size: 17),
                                  );
                                }
                              )),
                            ),
                            
                            controlButton ? 
                              CupertinoButton(
                                child: Icon(Icons.check),
                                onPressed: onSelect
                              ) : SizedBox.shrink(),

                          ],
                        ),
                    );
                  }
                );
              },
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white
                ),
                width: MediaQuery.of(context).size.width,
                child: text( ucwords(options[initialItem]) ),
              )
            )
          ],
        )
        
      );
    }
  }


class Button extends StatelessWidget{
  final Function onTap; 
  final style;
  final label;

  Button({this.onTap, this.style: 'default', this.label: 'OK'});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(10),
      child: Hover(
        radius: 5,
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(5),
            color: black(opacity: .05)
          ),
          child: text(label, spacing: 1, bold: true, color: Colors.blue, align: 'center'),
        ) 
      ),
    );

  }
}

class AnimatedCount extends StatefulWidget {
  AnimatedCount({this.count, this.bold: false, this.n: ''}); final count, bold, n;
  
  @override
  createState() => new AnimatedCountState();
}

class AnimatedCountState extends State<AnimatedCount> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = _controller;
    super.initState();

    _animation = new Tween<double>(
      begin: _animation.value,
      end: widget.count.toDouble(),
    ).animate(new CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: _controller,
    ));

    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget child) {
        return text( _animation.value.toStringAsFixed(0)+widget.n, bold: widget.bold);
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


class ShowUp extends StatefulWidget {
  final Widget child;
  final int delay;

  ShowUp({@required this.child, this.delay});

  @override
  _ShowUpState createState() => _ShowUpState();
}

class _ShowUpState extends State<ShowUp> with TickerProviderStateMixin {
  AnimationController _animController;
  Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    final curve =
        CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffset =
        Tween<Offset>(begin: const Offset(0.0, 0.35), end: Offset.zero)
            .animate(curve);

    if (widget.delay == null) {
      _animController.forward();
    } else {
      Timer(Duration(milliseconds: widget.delay), () {
        _animController.forward();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
      opacity: _animController,
    );
  }
}
