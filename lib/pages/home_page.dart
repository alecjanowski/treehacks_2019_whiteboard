import 'package:flutter/material.dart';
import 'package:treehacks_2019_whiteboard/AppServices.dart';
import 'package:treehacks_2019_whiteboard/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:treehacks_2019_whiteboard/models/todo.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> _todoList;

  var listMessage;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _textEditingController = TextEditingController();
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;

  Query _todoQuery;

  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();

    _checkEmailVerification();

    _todoList = new List();
    _todoQuery = _database
        .reference()
        .child("todo")
        .orderByChild("userId")
        .equalTo(widget.userId);
    _onTodoAddedSubscription = _todoQuery.onChildAdded.listen(_onEntryAdded);
    _onTodoChangedSubscription = _todoQuery.onChildChanged.listen(_onEntryChanged);
  }

  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _resentVerifyEmail(){
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resent link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _onTodoAddedSubscription.cancel();
    _onTodoChangedSubscription.cancel();
    super.dispose();
  }

  _onEntryChanged(Event event) {
    var oldEntry = _todoList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _todoList[_todoList.indexOf(oldEntry)] = Todo.fromSnapshot(event.snapshot);
    });
  }

  _onEntryAdded(Event event) {
    setState(() {
      _todoList.add(Todo.fromSnapshot(event.snapshot));
    });
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  _addNewTodo(String todoItem) {
    if (todoItem.length > 0) {

      Todo todo = new Todo(todoItem.toString(), widget.userId, false);
      _database.reference().child("todo").push().set(todo.toJson());
    }
  }

  _updateTodo(Todo todo){
    //Toggle completed
    todo.completed = !todo.completed;
    if (todo != null) {
      _database.reference().child("todo").child(todo.key).set(todo.toJson());
    }
  }

  _deleteTodo(String todoId, int index) {
    _database.reference().child("todo").child(todoId).remove().then((_) {
      print("Delete $todoId successful");
      setState(() {
        _todoList.removeAt(index);
      });
    });
  }

  _showDialog(BuildContext context) async {
    _textEditingController.clear();
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Row(
              children: <Widget>[
                new Expanded(child: new TextField(
                  controller: _textEditingController,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: 'How are you?',
                  ),
                ))
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('Post'),
                  onPressed: () {
                    AppServices.getMessageService().postMessage(_textEditingController.text.toString());
                    _addNewTodo(_textEditingController.text.toString());
                    Navigator.pop(context);
                  })
            ],
          );
        }
    );
  }

  Widget _showTodoList() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider(key: UniqueKey(), height: 1.0, color: Colors.grey,); /*2*/
          final index = i ~/ 2; /*3*/
          if (index < _comments.length) {
            return _buildRow(_comments[index]);
          }
        });
  }

  var _comments = <String>['I am happy. I am happy. I am happy. I am happy. I am happy. I am happy. I am happy. I am happy. I am happy. I am happy. I am happy. I am happy. I am happy. I am happy. I am happy. I am happy. I am happy. I am happy. ', 'I am tired', 'I am excited'];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final Set<String> _likedComments = new Set<String>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            'Whiteboard',
            style: new TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(color: Colors.white)),
                onPressed: _signOut),
//            IconButton(
//              icon: Icon(Icons.add),
//              onPressed: () {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => PostRoute()),
//                );
//              },
//            ),
          ],
        ),
        body: StreamBuilder(
          stream: AppServices.getFB().getFirestore().collection('messages').snapshots(), //gets data from firestore
          builder: (context, snapshot) { //builds the message list from snapshot data
            /*if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff7e00))));
          } else {*/
            listMessage = snapshot.data.documents;
            return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemBuilder: /*1*/ (context, i) {
                  if (i.isOdd) return Divider(key: UniqueKey(), height: 1.0, color: Colors.grey,); /*2*/
                  final index = i ~/ 2; /*3*/
                  if (index < snapshot.data.documents.length) {
                    return _buildRow(listMessage[index]['message']);
                  }
                },
              reverse: true,
            );
          },
        ),
//        body: _showTodoList(),
//        bottomNavigationBar: buildBar(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            _showDialog(context);
          },
          tooltip: 'Increment',
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        )
    );
  }

  Widget _buildRow(String comment) {
    final bool alreadyLiked = _likedComments.contains(comment);
    return ListTile(
      title: Text(
        comment,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadyLiked ? Icons.favorite : Icons.favorite_border,
        color: alreadyLiked ? Colors.red : null,
      ),
      onTap: () {      // Add 9 lines from here...
        setState(() {
          if (alreadyLiked) {
            _likedComments.remove(comment);
          } else {
            _likedComments.add(comment);
          }
        });
      },
    );
  }

  Widget buildBar(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [

                Tab(icon: Icon(IconData(0xe88a, fontFamily: 'MaterialIcons'))),
                Tab(icon: Icon(IconData(0xe553, fontFamily: 'MaterialIcons'))),
                Tab(icon: Icon(IconData(0xe80e, fontFamily: 'MaterialIcons'))),
              ],
            ),
            title: Text('TabBar'),
          ),
          body: TabBarView(
            children: [
              Center( child: Text("Home")),
              Center( child: Text("Hot")),
              Center( child: Text("Events")),
            ],
          ),
        )
    );
  }
}

