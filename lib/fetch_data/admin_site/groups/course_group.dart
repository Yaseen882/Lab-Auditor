import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_assignment_mobile/Constants.dart';
import 'package:student_assignment_mobile/fetch_data/domain/course_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_assignment_mobile/fetch_data/admin_site/student_data/student_list.dart';
import 'package:student_assignment_mobile/fetch_data/domain/student_model.dart';
import 'package:student_assignment_mobile/main.dart';

import '../../domain/group_model.dart';

String? documentCollection;
DocumentSnapshot? studentDS;
class CourseGrouping extends StatelessWidget {
  const CourseGrouping({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupTitle>(
      create: (context) {
        return GroupTitle();
      },
      child: const Groups(),
    );
  }
}

class Groups extends StatefulWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  final GroupTitle _groupTitle = GroupTitle();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    GroupTitle groupProvider = Provider.of<GroupTitle>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xff382f28),
      appBar: AppBar(
        backgroundColor: const Color(0xff382f28),
        title: const Text('Groups'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        width: width,
        height: height,

        child:FutureBuilder<QuerySnapshot>(
          future: _groupTitle.getGroupTitle(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong!'),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              print('..................Group data................${groupData.length}');
              return  groupData.isNotEmpty ?  GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: groupData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        studentDS = snapshot.data?.docs[index];
                        studentCollection = studentDS?.id;
                        print('...............Student Collection................$studentCollection');
                        groupProvider.notifyGroupTitle();
                        setTheState;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StudentData(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          height: height * 0.33,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Card(
                            color: Constants.primaryColor,
                            elevation: 5,
                            child: Center(
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.school,
                                    size: 50,
                                    color: Colors.white,
                                  ),

                                  Text(
                                    '${groupData[index]}',
                                    style:  TextStyle(
                                        color: Colors.white.withOpacity(0.8), fontSize: 20),
                                  ),
                                  SizedBox(height: 15,),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            studentDS = snapshot.data?.docs[index];
                                            groupId = studentDS?.id;

                                            print('.......................update ID.............$groupId');
                                            groupProvider.notifyGroupTitle();
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor:
                                                  const Color(0xff382f28),
                                                  title: TextField(
                                                    style: TextStyle(color: Colors.white),
                                                    onChanged: (value) {
                                                      group = value;
                                                      groupProvider
                                                          .notifyGroupTitle();
                                                    },
                                                    decoration:
                                                    const InputDecoration(hintText: 'Enter Group Title',hintStyle:  TextStyle(
                                                        color: Colors.white),border: OutlineInputBorder()),
                                                  ),
                                                  actions: [
                                                    Container(
                                                      width: width * 0.2,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                        border:  const Border(
                                                          left: BorderSide(
                                                              color: Constants
                                                                  .primaryColor,
                                                              width: .5),
                                                          right: BorderSide(
                                                              color: Constants
                                                                  .primaryColor,
                                                              width: .5),
                                                          top: BorderSide(
                                                              color: Constants
                                                                  .primaryColor,
                                                              width: .5),
                                                          bottom: BorderSide(
                                                              color: Constants
                                                                  .primaryColor,
                                                              width: .5),
                                                        ),
                                                      ),
                                                      child: TextButton(
                                                        onPressed: () {
                                                          groupProvider
                                                              .updateGroupTitle();
                                                          Navigator.pop(context);
                                                        },
                                                        child: const Text('update'),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: width * 0.2,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                        border:  const Border(
                                                          left: BorderSide(
                                                              color: Constants
                                                                  .primaryColor,
                                                              width: .5),
                                                          right: BorderSide(
                                                              color: Constants
                                                                  .primaryColor,
                                                              width: .5),
                                                          top: BorderSide(
                                                              color: Constants
                                                                  .primaryColor,
                                                              width: .5),
                                                          bottom: BorderSide(
                                                              color: Constants
                                                                  .primaryColor,
                                                              width: .5),
                                                        ),
                                                      ),
                                                      child: TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: const Text('Cancel'),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.edit_outlined,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            groupDS = snapshot.data?.docs[index];
                                            groupId = groupDS?.id;

                                            groupProvider.notifyGroupTitle();

                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor:
                                                  const Color(0xff382f28),
                                                  content: const Text(
                                                    'Do you want to delete?',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  actions: [
                                                    Container(
                                                      width: width * 0.2,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                        border:  const Border(
                                                          left: BorderSide(
                                                              color: Constants
                                                                  .primaryColor,
                                                              width: .5),
                                                          right: BorderSide(
                                                              color: Constants
                                                                  .primaryColor,
                                                              width: .5),
                                                          top: BorderSide(
                                                              color: Constants
                                                                  .primaryColor,
                                                              width: .5),
                                                          bottom: BorderSide(
                                                              color: Constants
                                                                  .primaryColor,
                                                              width: .5),
                                                        ),
                                                      ),
                                                      child: TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: const Text('Cancel'),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: width * 0.2,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                        border:  const Border(
                                                          left: BorderSide(
                                                              color: Constants
                                                                  .primaryColor,
                                                              width: .5),
                                                          right: BorderSide(
                                                              color: Constants
                                                                  .primaryColor,
                                                              width: .5),
                                                          top: BorderSide(
                                                              color: Constants
                                                                  .primaryColor,
                                                              width: .5),
                                                          bottom: BorderSide(
                                                              color: Constants
                                                                  .primaryColor,
                                                              width: .5),
                                                        ),
                                                      ),
                                                      child: TextButton(
                                                        onPressed: () {
                                                          groupProvider
                                                              .deleteGroupTitle();
                                                          setState(() {});

                                                          Navigator.pop(context);
                                                        },
                                                        child: const Text('delete'),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ):const Center(child: Text('Oop\'s Empty!',style: TextStyle(color: Colors.white),),);
            } else {
              const Center(
                child: Text('Document does not exist!'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor:
                const Color(0xff382f28),
                title: TextField(
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {
                    group = value;
                   groupProvider.notifyGroupTitle();
                  },
                  decoration:
                  const InputDecoration(hintText: 'Enter Group Title',hintStyle:  TextStyle(
                      color: Colors.white),border: OutlineInputBorder()),

                ),
                actions: [
                  Container(
                    width: width * 0.2,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(
                          10),
                      border:  Border(
                        left: BorderSide(
                            color: Constants
                                .primaryColor,
                            width: .5),
                        right: BorderSide(
                            color: Constants
                                .primaryColor,
                            width: .5),
                        top: BorderSide(
                            color: Constants
                                .primaryColor,
                            width: .5),
                        bottom: BorderSide(
                            color: Constants
                                .primaryColor,
                            width: .5),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        groupProvider.addGroupTitle();

                        Navigator.pop(context);
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                  Container(
                    width: width * 0.2,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(
                          10),
                      border:   Border.all(color: Constants
                          .primaryColor,
                          width: .5),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              );
            },
          );
        }, label: Text('Add Group'),
      ),
    );
  }
}

//