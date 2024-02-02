import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:studentlist/sql.dart';
import 'package:studentlist/studentmodel.dart';
class detial extends StatefulWidget{
  String screentitle;
  Student student;
  detial(this.student,this.screentitle);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return students(this.student,screentitle);
  }

}
class students extends State<detial>{
  String screentitle;
  Student student;
  SQL_Helper helper=new SQL_Helper();
  students(this.student,this.screentitle);
  static var _status=["successed","failed"];

TextEditingController studentname=new TextEditingController();
  TextEditingController studentdetial=new TextEditingController();
  @override
  Widget build(BuildContext context) {

    //TODO: implement build
    //ignore:deprecated_member_use widget build

    TextStyle textStyle=Theme.of(context).textTheme.titleLarge;
    studentname.text=student.name;
    studentdetial.text=student.description;
    return WillPopScope(onWillPop: (){
      debugPrint("button");
      goBack();
    },
        child:
      Scaffold(
      appBar: AppBar(
        title: Text(screentitle),
    leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: (){
      goBack();
    }),
    ),

      body:
      Padding(padding: EdgeInsets.only(top:15,left:10,right:10),
        child: ListView(
          children:<Widget> [
            ListTile(
              title: DropdownButton(

                items: _status.map((String dropdown){
                  return  DropdownMenuItem<String>(
                  value:dropdown,
                    child:Text(dropdown),
                  );
                }).toList(),
style: textStyle,
value: getPassing(student.pass),
    onChanged: (selectedItem){
                  setState(() {
                    setPassing(selectedItem);
                  });
    },
              ),
            ),
       Padding(padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
         child: TextField(
           controller: studentname,
           style: textStyle,
           onChanged: (value){
            student.name=value;
           },
           decoration: InputDecoration(
             labelText: "Name :",
             labelStyle: textStyle,
             border: OutlineInputBorder(
               borderRadius: BorderRadius.circular(5.0),
             )
           ),
         ),

    ),
         Padding(padding: EdgeInsets.only(top:15.0,bottom: 15.0),
           child: TextField(
             controller: studentdetial,
             style: textStyle,
             onChanged: (value){
               student.description=value;
             },
             decoration: InputDecoration(
               labelText: "Description",
               labelStyle: textStyle,
               border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(5.0)
               )
             ),
           ),
         ),
         Padding(padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
           child: Row(
             children:<Widget> [
       Expanded(
       child: ElevatedButton(
       style: ElevatedButton.styleFrom(primary:Colors.lightBlueAccent),
         //textColor: Theme.of(context).primaryColorLight,
       child: Text(
       'SAVE', textScaleFactor: 1.5,
          ),
         onPressed: () {
       setState(() {
        debugPrint("User Click SAVED");
        _save();
        });
      },
      ),
    ),

    Container(width: 5.0,),
    Expanded(
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(primary:Colors.lightBlueAccent ),
   // textColor: Theme.of(context).primaryColorLight,
    child: Text(
    'Delete', textScaleFactor: 1.5,
    ),
    onPressed: () {
    setState(() {
    debugPrint("User Click Delete");
    _delete();
    });
    },
    ),
    ),
    ],
           ),
         )

          ],
        ),
      )
      )
    ) ;
  }

  void goBack() {
    Navigator.pop(context, true);
  }

  void setPassing(String value) {
    switch(value) {
      case "successed":
        student.pass = 1;
        break;
      case "failed":
        student.pass = 2;
        break;
    }
  }

  String getPassing(int value) {
    String path;
    switch(value){
      case 1:
        path = _status[0];
        break;
      case 2:
        path = _status[1];
        break;
    }
    return 'path';
  }

  void _save() async {

    goBack();

    student.date = DateFormat.yMMMd().format(DateTime.now());

    int result;
    if (student.id == null) {
      result =  await helper.insertStudent(student);
    } else {
      result = await helper.updateStudent(student);
    }

    if (result == 0) {
      showAlertDialog('Sorry', "Student not saved");
    } else {
      showAlertDialog('Congratulations', 'Student has been saved successfully');
    }
  }

  void showAlertDialog(String title, String msg){
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(msg),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _delete() async {
    goBack();

    if (student.id == null){
      showAlertDialog('Ok Delete', "No student was deleted");
      return;
    }

    int result = await helper.deleteStudent(student.id);
    if (result == 0) {
      showAlertDialog('Ok Delete', "No student was deleted");
    } else {
      showAlertDialog('Ok Delete', "Student has been deleted");
    }

  }

}

