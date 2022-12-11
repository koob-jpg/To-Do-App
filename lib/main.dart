import 'dart:developer';
import 'dart:html';
import 'dart:ui';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'Stuff.dart';
import 'dart:math';

void main() {
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'To Do List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

var indexes = [];
var map = <int, Info>{};

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textFieldController1 = TextEditingController();
  final TextEditingController _textFieldController2 = TextEditingController();
  TimeOfDay time = TimeOfDay(hour: 10, minute: 30);
  DateTime date = DateTime(2022, 1, 1);

  Future<Future> _displayDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a task to you list'),
          content: Column(
            children: [
              TextField(
                controller: _textFieldController1,
                decoration:
                    const InputDecoration(hintText: 'Enter task name here'),
              ),
              TextField(
                controller: _textFieldController2,
                decoration:
                    const InputDecoration(hintText: 'Enter task details here'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () async {
                        TimeOfDay? newTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (newTime == null) return;

                        setState(() {
                          time = newTime;
                        });
                      },
                      child: const Text('Enter Time')),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () async {
                      DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2050),
                      );

                      if (newDate == null) return;

                      setState(() {
                        date = newDate;
                      });
                    },
                    child: const Text('Enter Date'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('ADD'),
              onPressed: () {
                Navigator.of(context).pop();
                _addTask(Info(_textFieldController1.text,
                    _textFieldController2.text, time, date));
              },
            ),
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _addTask(Info stuff) {
    setState(() {
      int temp = Random().nextInt(1000);
      indexes.add(temp);
      map[temp] = stuff;
    });
    _textFieldController1.clear();
    _textFieldController2.clear();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: (indexes.length != 0)
          ? ListView.separated(
              padding: const EdgeInsets.all(8.0),
              itemCount: indexes.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    (Navigator.push(context,
                        MaterialPageRoute(builder: ((context) {
                      return TaskDetails(
                        title: map[indexes[index]]!.name,
                        stuff: map[indexes[index]]!,
                      );
                    })))).then(
                      (value) {
                        setState(() {});
                      },
                    );
                  },
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.alarm),
                          title: Text(map[indexes[index]]!.name),
                          trailing: IconButton(
                            icon: const Icon(Icons.cancel_outlined),
                            tooltip: 'Remove Task',
                            onPressed: () {
                              setState(() {
                                int temp = indexes[index];
                                indexes.remove(temp);
                                map.remove(temp);
                              });
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                                '${map[indexes[index]]!.time.hour.toString().padLeft(2, '0')}:${map[indexes[index]]!.time.minute.toString().padLeft(2, '0')}'),
                            const SizedBox(width: 8),
                            Text(
                                '${map[indexes[index]]!.date.month}/${map[indexes[index]]!.date.day}/${map[indexes[index]]!.date.year}'),
                            const SizedBox(width: 8),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            )
          : const Center(child: Text('Add a Task!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(context),
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class TaskDetails extends StatefulWidget {
  const TaskDetails({super.key, required this.title, required this.stuff});

  final String title;
  final Info stuff;

  @override
  State<TaskDetails> createState() => TaskDetailPageState();
}

class TaskDetailPageState extends State<TaskDetails> {
  final TextEditingController _textFieldController1 = TextEditingController();
  final TextEditingController _textFieldController2 = TextEditingController();
  TimeOfDay time = TimeOfDay(hour: 10, minute: 30);
  DateTime date = DateTime(2022, 1, 1);

  Future<Future> _displayDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit task'),
          content: Column(
            children: [
              TextField(
                controller: _textFieldController1,
                decoration:
                    const InputDecoration(hintText: 'Edit task name here'),
              ),
              TextField(
                controller: _textFieldController2,
                decoration:
                    const InputDecoration(hintText: 'Edit task details here'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () async {
                        TimeOfDay? newTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (newTime == null) return;

                        setState(() {
                          time = newTime;
                        });
                      },
                      child: const Text('Edit Time')),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () async {
                      DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2050),
                      );

                      if (newDate == null) return;

                      setState(() {
                        date = newDate;
                      });
                    },
                    child: const Text('Edit Date'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Edit'),
              onPressed: () {
                Navigator.of(context).pop();
                editTask(_textFieldController1.text, _textFieldController2.text,
                    time, date);
              },
            ),
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void editTask(String name, String details, TimeOfDay time, DateTime date) {
    String n2 = widget.stuff.name;
    String d2 = widget.stuff.details;
    TimeOfDay t2 = widget.stuff.time;
    DateTime day = widget.stuff.date;
    if (name != '') {
      n2 = name;
      setState(() {
        widget.stuff.name = name;
      });
    }
    if (details != '') {
      d2 = details;
      setState(() {
        widget.stuff.details = details;
      });
    }
    if (time != TimeOfDay(hour: 10, minute: 30)) {
      t2 = time;
      setState(() {
        widget.stuff.time = time;
      });
    }
    if (date != DateTime(2022, 1, 1)) {
      day = date;
      setState(() {
        widget.stuff.date = date;
      });
    }
    setState(() {
      var key =
          map.keys.firstWhere((k) => map[k] == widget.stuff, orElse: () => 0);
      map[key] = Info(n2, d2, t2, day);
    });
    _textFieldController1.clear();
    _textFieldController2.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.stuff.details,
                style: const TextStyle(fontSize: 50),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '${widget.stuff.time.hour.toString().padLeft(2, '0')}:${widget.stuff.time.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 32),
                  ),
                  Text(
                    '${widget.stuff.date.month}/${widget.stuff.date.day}/${widget.stuff.date.year}',
                    style: const TextStyle(fontSize: 32),
                  ),
                ],
              ),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('GO BACK')),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(context),
        tooltip: 'Edit Task',
        child: const Icon(Icons.add_comment),
      ),
    );
  }
}
