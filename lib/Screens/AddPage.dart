import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddPage extends StatefulWidget {
  final Map? todo;
  const AddPage({
    super.key,
    this.todo,
  });

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo =widget.todo;
    if(todo != null){
      isEdit = true;
      final title = todo['title'];
      final desc = todo['description'];
      titlecontroller.text=title;
      descriptioncontroller.text=desc;
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            isEdit ? "Edit an Item":"Add an Item"),
      ),
      body:ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(decoration: InputDecoration(
            hintText: "Title",
          ),
          controller: titlecontroller,),
          SizedBox(height: 20,),
          TextField(decoration: InputDecoration(
            hintText: "Description",),
          minLines: 5,
            maxLines: 15,
          controller: descriptioncontroller,
          keyboardType: TextInputType.multiline,),
          SizedBox(height: 20,),
          ElevatedButton(
              onPressed:
              isEdit?updateData:submitData,

              child: Text(
              isEdit?"Update":"Submit"))
        ],
      ),

    );
  }
  Future<void>updateData() async{
    final todo = widget.todo;
    if(todo == null){
      print("you cant call updated without todo data");
      return;
    }
    final title = titlecontroller.text;
    final desc = descriptioncontroller.text;
    final id = todo['_id'];
    final body = {
      "title":title,
      "descrpition":desc,
      "is_completed":false,
    };
    //Submit data to server
    final url = 'https://api.nstack.in/v1/todos/$id';
    //convert url into uri
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body:jsonEncode(body),
      headers: {'Content-Type':'application/json'},
    );
    print(response.body);
    if(response.statusCode==200){
      showMessage('Updation Success');
    }else{
      showMessage("Failed");
    }

  }

  Future<void> submitData() async {
    //get the data from form
    final title = titlecontroller.text;
    final desc = descriptioncontroller.text;
    final body ={
      "title": title,
      "description": desc,
      "is_completed": false
    };
    //Submit data to the server
    final url = 'https://api.nstack.in/v1/todos';
    //convert url into uri
    final uri = Uri.parse(url);
    final response = await http.post(
        uri,
        body:jsonEncode(body),
      headers: {'Content-Type':'application/json'},
    );
    if(response.statusCode==201){
      titlecontroller.text='';
      descriptioncontroller.text='';
      showMessage('creation Success');
    }else{
      showMessage("Failed");
    }
  }
  
  //Show success message
void showMessage(String Message){
    final snackBar = SnackBar(content:Text(Message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
}

