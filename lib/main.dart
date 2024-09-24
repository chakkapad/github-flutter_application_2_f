// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
//           useMaterial3: true,
//         ),
//         //home: const SigninScreen() //TodoApp(),
//         );
//   }
// }

// class TodoApp extends StatefulWidget {
//   const TodoApp({
//     super.key,
//   });

//   @override
//   State<TodoApp> createState() => _TodoAppState();
// }

// class _TodoAppState extends State<TodoApp> {
//   late TextEditingController _texteditController;
//   late TextEditingController _descriptionController;

//   final List<String> _myList = [];
//   @override
//   void initState() {
//     super.initState();
//     _texteditController = TextEditingController();
//     _descriptionController = TextEditingController();
//   }

//   void addTodoHandle(BuildContext context) {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: const Text("Add new task"),
//             content: SizedBox(
//               width: 120,
//               height: 140,
//               child: Column(
//                 children: [
//                   TextField(
//                     controller: _texteditController,
//                     decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: "Input your task"),
//                   ),
//                   const SizedBox(
//                     height: 8,
//                   ),
//                   TextField(
//                     controller: _descriptionController,
//                     decoration: const InputDecoration(
//                         border: OutlineInputBorder(), labelText: "Description"),
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                   onPressed: () {
//                     CollectionReference Tasks =
//                         FirebaseFirestore.instance.collection("tasks");
//                     Tasks.add({'name': _texteditController.text}).then((res) {
//                       print(res);
//                     }).catchError((onError) {
//                       print("Field to add new Task");
//                     });
//                     setState(() {
//                       _myList.add(_texteditController.text);
//                     });
//                     _texteditController.text = "";
//                     Navigator.pop(context);
//                   },
//                   child: const Text("Save"))
//             ],
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Todo"),
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       ),
//       body: StreamBuilder(
//           stream: FirebaseFirestore.instance.collection("tasks").snapshots(),
//           builder: (context, snapshot) {
//             return snapshot.data != null
//                 ? ListView.builder(
//                     itemCount: snapshot.data?.docs.length,
//                     itemBuilder: (context, index) {
//                       var item = snapshot.data?.docs[index].data();
//                       return TaskItem(item: item);
//                     })
//                 : const Text("No data");
//           }),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           addTodoHandle(context);
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// class TaskItem extends StatefulWidget {
//   TaskItem({
//     super.key,
//     required this.item,
//   });

//   late Map<String, dynamic>? item;

//   @override
//   State<TaskItem> createState() => _TaskItemState();
// }

// class _TaskItemState extends State<TaskItem> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(children: [
//         Checkbox(
//             value: widget.item?["status"] ?? false,
//             onChanged: (value) {
//               setState(() {});
//             }),
//         Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               widget.item?["name"],
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             if (widget.item?["note"] != null) Text(widget.item?["note"]),
//           ],
//         )
//       ]),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';  // เปิดการใช้งาน Firebase Auth
import 'package:firebase_core/firebase_core.dart';
import 'package:todotask1/screen/signin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF9B4F87)),
        useMaterial3: true,
      ),
      home: const SigninScreen(),
    );
  }
}

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodaAppState();
}

class _TodaAppState extends State<TodoApp> {
  late TextEditingController _texteditController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _texteditController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  // ฟังก์ชัน logout
  void _logout(BuildContext context) async {
    // await FirebaseAuth.instance.signOut();  // ใช้ FirebaseAuth ในการ sign out

    // เมื่อ logout แล้ว ให้ไปยังหน้า Signin
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SigninScreen()),
    );
  }

  void addTodoHandle(BuildContext context, [DocumentSnapshot? doc]) {
    if (doc != null) {
      _texteditController.text = doc['name'];
      _descriptionController.text = doc['detail'];
    } else {
      _texteditController.clear();
      _descriptionController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                doc != null ? Icons.edit : Icons.add,
                color: const Color(0xFF259b24),
              ),
              const SizedBox(width: 8),
              Text(
                doc != null ? "Edit task" : "Add new task",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _texteditController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Task title",
                      prefixIcon: Icon(Icons.title),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Description",
                      prefixIcon: Icon(Icons.description),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFF44336), // Text color
              ),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (doc != null) {
                  // Update existing task
                  FirebaseFirestore.instance
                      .collection("tasks")
                      .doc(doc.id)
                      .update({
                    'name': _texteditController.text,
                    'detail': _descriptionController.text,
                  }).then((_) {
                    print("Task updated");
                  }).catchError((onError) {
                    print("Failed to update task");
                  });
                } else {
                  // Add new task
                  FirebaseFirestore.instance.collection("tasks").add({
                    'name': _texteditController.text,
                    'detail': _descriptionController.text,
                    'status': false,
                  }).then((res) {
                    print("Task added");
                  }).catchError((onError) {
                    print("Failed to add task");
                  });
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green, // Text color
              ),
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void deleteTask(String id) {
    FirebaseFirestore.instance.collection("tasks").doc(id).delete().then((_) {
      print("Task deleted");
    }).catchError((onError) {
      print("Failed to delete task");
    });
  }

  void toggleStatus(String id, bool status) {
    FirebaseFirestore.instance.collection("tasks").doc(id).update({
      'status': !status,
    }).then((_) {
      print("Task status updated");
    }).catchError((onError) {
      print("Failed to update task status");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Todo",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true, // Center the title
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context), // เรียกใช้ฟังก์ชัน logout
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("tasks").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No tasks available"));
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              var task = snapshot.data!.docs[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 10,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    task['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(task['detail']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          task['status']
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: task['status']
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFF9E9E9E),
                        ),
                        onPressed: () => toggleStatus(task.id, task['status']),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xFF259b24)),
                        onPressed: () => addTodoHandle(context, task),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteTask(task.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTodoHandle(context);
        },
        backgroundColor: Color(0xFF259b24),
        child: const Icon(Icons.add),
      ),
    );
  }
}
