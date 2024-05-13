import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todoapp/Screens/AddPage.dart';
import 'package:http/http.dart' as http ;
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List items=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodo();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App"),
      ),
      body:RefreshIndicator(
        onRefresh: fetchTodo,
        child:ListView.builder(
        itemCount: items.length,
        padding: EdgeInsets.all(12),
        itemBuilder: (context, index){
          final item = items[index] as Map;
          final id = item['_id'] as String;
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Text('${index + 1}'),),
              title: Text(item['title']),
              subtitle: Text(item['description']),
              trailing: PopupMenuButton(
                onSelected: (value){
                  if(value=='edit'){
                    //open edit page
                    navigagteToEditPage(item);
                  }else if(value=='Delete'){
                    //delete and remove the item
                    deleteById(id);
                  }
                },
                itemBuilder: (context){
                  return [
                    PopupMenuItem(
                        child: Text('Edit'),
                      value: 'edit',
                    ),
                    PopupMenuItem(
                      child: Text('Delete'),
                    value: 'Delete',
                    ),
                  ];
                },
              ),
            ),
          );
        },),),
      floatingActionButton: FloatingActionButton.extended(
          onPressed:navigagteToAddPage,
          label: Text("Add")),
    );
  }
  void navigagteToAddPage() async{
    final route = MaterialPageRoute(builder: (context) => AddPage());
    Navigator.push(context,route);
  }

  void navigagteToEditPage(Map item){
    final route = MaterialPageRoute(builder: (context) => AddPage(todo : item));
    Navigator.push(context,route);
  }

  Future<void>deleteById(String id) async{
    //Delete the item
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    print(response.body);
    //Remove item form the list
    if(response.statusCode==200){
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items= filtered;
      });
    }else{
      //error message
    }

  }

  Future<void> fetchTodo() async{
    final url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.body);
    if(response.statusCode==200){
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }else{

    }
  }
}

