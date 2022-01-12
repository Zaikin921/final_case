import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/todo.dart';
import '../utils/constants.dart';
import '../widgets/drawer.dart';

ListView _detailsListView(data) {
  return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        return _detailsListTile(
          data['email'],
          data['address']['city'],
          data['address']['street'],
          data['address']['suite'],
          data['company']['name'],
        );
      });
}

SingleChildScrollView _detailsListTile(
  String email,
  String city,
  String street,
  String suite,
  String company,
) =>
    SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Email: ' + email),
          Divider(),
          Text('Address:'),
          Text('City: ' + city),
          Text('Street: ' + street),
          Text('Suite: ' + suite),
          Divider(),
          Text('Company: ' + company),
        ],
      ),
    );

ListView _todosListView(data) {
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _todoListTile(
          data[index].title,
          data[index].completed,
        );
      });
}

CheckboxListTile _todoListTile(
  String title,
  bool completed,
) =>
    CheckboxListTile(
      title: Text(title),
      value: completed,
      secondary: completed == true
          ? const Icon(Icons.done)
          : const Icon(Icons.hourglass_empty),
      onChanged: (bool? value) {},
    );

class UserDetailsScreen extends StatefulWidget {
  late Future<List<Todo>> futureTodosList;
  late Future<Map<String, dynamic>> userDetails;
  late int _userId;

  UserDetailsScreen(this._userId);

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late List<Todo> todoListData;
  late Map<String, dynamic> UserDetailsListData;

  Future<List<Todo>> _fetchTodosList() async {
    final response = await http
        .get(Uri.parse(URL_GET_TODOS_BY_USER + widget._userId.toString()));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((todo) => Todo.fromJson(todo)).toList();
    } else {
      throw Exception('Failed to load user todos from API');
    }
  }

  Future<Map<String, dynamic>> _fetchUserDetails() async {
    final response = await http
        .get(Uri.parse(URL_GET_USERS_LIST + '/' + widget._userId.toString()));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse;
      //.map((userdetails) => UserDetails.fromJson(userdetails));
    } else {
      throw Exception('Failed to load user details');
    }
  }

  @override
  void initState() {
    super.initState();
    widget.futureTodosList = _fetchTodosList();
    widget.userDetails = _fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Детали по юзеру'),
      ),
      drawer: drawer(context),
      body: Column(
        children: [
          Container(
            height: 150,
            child: Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: widget.userDetails,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    UserDetailsListData = snapshot.data!;
                    return _detailsListView(UserDetailsListData);
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Todo>>(
              future: widget.futureTodosList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  todoListData = snapshot.data!;
                  return _todosListView(todoListData);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
          Container(
            height: 80,
            width: 150,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(10)),
            child: FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Назад',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
