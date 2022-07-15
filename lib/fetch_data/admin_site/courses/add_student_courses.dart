import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_assignment_mobile/Constants.dart';
import 'package:student_assignment_mobile/fetch_data/domain/course_model.dart';
import 'package:student_assignment_mobile/fetch_data/admin_site/groups/course_group.dart';
import 'package:student_assignment_mobile/fetch_data/teacher_site/audit_student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../login_screen/login_screen.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CourseTitle>(
      create: (context) {
        return CourseTitle();
      },
      child: const Course(),
    );
  }
}

class Course extends StatefulWidget {
  const Course({Key? key}) : super(key: key);

  @override
  _CourseState createState() => _CourseState();
}

class _CourseState extends State<Course> {
  CourseTitle course = CourseTitle();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    CourseTitle courseProvider =
        Provider.of<CourseTitle>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xff382f28),
      // backgroundColor: Colors.amberAccent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Courses'),
        backgroundColor: const Color(0xff382f28),
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpScreen(),
                  ));
            },
            child:Icon(Icons.login_outlined,color: Colors.white,),
          )
        ],
      ),
      body: Container(
        width: width,
        height: height,
        child: FutureBuilder<QuerySnapshot>(
          future: course.getCourseTitle(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong!'),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return GridView.builder(
                itemCount: allData.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        ds = snapshot.data?.docs[index];
                        documentCollection = ds?.id;
                        print(
                            '..................course ID................$documentCollection');
                        courseProvider.notifyCourseTitle();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const CourseGrouping();
                            },
                          ),
                        );
                      },
                      child: Container(
                        height: height * 0.30,
                        decoration: BoxDecoration(
                          // color:Constants.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Card(
                          color: Constants.primaryColor,
                          elevation: 5,
                          child: Center(
                            child: Column(
                              children: [
                                Container(
                                    width: 50,
                                    height: 50,
                                    child: const Image(
                                      color: Colors.white,
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'assets/images/courseIcon.png'),
                                    )),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  '${allData[index]}',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        ds = snapshot.data?.docs[index];
                                        titleId = ds?.id;
                                        courseProvider.notifyCourseTitle();
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor:
                                                  const Color(0xff382f28),
                                              title: TextField(
                                                style: TextStyle(
                                                    color: Colors.white),
                                                onChanged: (value) {
                                                  title = value;
                                                  courseProvider
                                                      .notifyCourseTitle();
                                                },
                                                decoration: const InputDecoration(
                                                    hintText:
                                                        'Enter Course Title',
                                                    hintStyle: TextStyle(
                                                        color: Colors.white),
                                                    border:
                                                        OutlineInputBorder()),
                                              ),
                                              actions: [
                                                Container(
                                                  width: width * 0.2,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border(
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
                                                      courseProvider
                                                          .updateCourseTitle();
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
                                                    border: Border(
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
                                        ds = snapshot.data?.docs[index];
                                        titleId = ds?.id;
                                        courseProvider.notifyCourseTitle();

                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor:
                                                  const Color(0xff382f28),
                                              content: const Text(
                                                'Do you want to reject?',
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
                                                    border: const Border(
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
                                                      courseProvider
                                                          .deleteCourseTitle();
                                                      setState(() {});

                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('delete',
                                                        style: TextStyle(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.7))),
                                                  ),
                                                ),
                                                Container(
                                                  width: width * 0.2,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: const Border(
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
                                                    child: Text('Cancel',
                                                        style: TextStyle(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.7))),
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
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
                backgroundColor: const Color(0xff382f28),
                title: TextField(
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {
                    title = value;
                    courseProvider.notifyCourseTitle();
                  },
                  decoration: const InputDecoration(
                      hintText: 'Enter Course Title',
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder()),
                ),
                actions: [
                  Container(
                    width: width * 0.2,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border(
                        left: BorderSide(
                            color: Constants.primaryColor, width: .5),
                        right: BorderSide(
                            color: Constants.primaryColor, width: .5),
                        top: BorderSide(
                            color: Constants.primaryColor, width: .5),
                        bottom: BorderSide(
                            color: Constants.primaryColor, width: .5),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        courseProvider.addCourseTitle();
                        Navigator.pop(context);
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                  Container(
                    width: width * 0.2,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: Constants.primaryColor, width: .5),
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
        label: Text('Add Course'),
      ),
    );
  }
}
