import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:studentlist/s.dart';

import 'dart:async';
import 'package:studentlist/sql.dart';
import 'package:studentlist/studentmodel.dart';
import 'package:sqflite/sqflite.dart';

class Studentlist extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   return studentstate();
  }
}


  

class studentstate extends State<Studentlist> {
  SQL_Helper helper=new SQL_Helper();
  List<Student>studentlist;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if(studentlist==null){
      studentlist=new List<Student>();
      updateListView();
    }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("student"),
      ),
      body: getstudent(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          navigate(Student('','',1,''),"Add student");
        },
        tooltip: 'add student',
        child:Icon(Icons.add),
      ),

    );
  }


  ListView getstudent() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position){
        return Card(
          color:Colors.white,
        elevation:2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:isPassed(this.studentlist[position].pass),
            child:  getIcon((this.studentlist[position].description+"|"+this.studentlist[position].date) as int),

            ),
            title: Text(this.studentlist[position].name),
            subtitle: Text(this.studentlist[position].description+"|"+this.studentlist[position].date),

trailing:GestureDetector(child:
Icon(Icons.delete,color:Colors.grey) ,
            onTap: (){
            _delete(context,this.studentlist[position]);
            },


          ),
onTap: (){
              navigate(this.studentlist[position],"Edit student");
}),
        );
      },
    );
  }
  Color isPassed(int value) {
    switch (value) {
      case 1:
        return Colors.amber;
        break;
      case 2:
        return Colors.red;
        break;
      default:
        return Colors.amber;
    }
  }

  Icon getIcon(int value) {
    switch (value) {
      case 1:
        return Icon(Icons.check);
        break;
      case 2:
        return Icon(Icons.close);
        break;
      default:
        return Icon(Icons.check);
    }
  }

  void _delete(BuildContext context, Student student) async {
    int ressult = await helper.deleteStudent(student.id);
    if (ressult != 0) {
      _showSenckBar(context, "Student has been deleted");
      updateListView();
    }
  }

  void _showSenckBar(BuildContext context, String msg) {
    final snackBar = SnackBar(content: Text(msg),);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> db = helper.initializedDatabase();
    db.then((database) {
      Future<List<Student>> students = helper.getStudentList();
      students.then((theList) {
        setState(() {
          this.studentlist = theList;
          this.count = theList.length;
        });
      });
    });
  }
  void navigate(Student student,String appTitle) async {
    bool result=await Navigator.push(context,MaterialPageRoute(builder: (context){
      return
        detial(student,appTitle);
    }));
    if(result){
      updateListView();
    }
  }
}