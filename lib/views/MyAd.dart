import 'package:alumni/helper/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class MyAd extends StatefulWidget {
  const MyAd({Key? key}) : super(key: key);

  @override
  _MyAdState createState() => _MyAdState();
}

class _MyAdState extends State<MyAd> {
  late String email;
  late String category;
  late int counter;

  initState() {
    email = Constants.myName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("MyAds"),
          backgroundColor: Color(0xffb000080),
          actions: [],
        ),
        body: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('URL_Br_Year_Name_Price_Email')
                .where("Email", isEqualTo: email)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {

              if (streamSnapshot.data == null) {
                counter = 0;
              } else {
                counter = streamSnapshot.data!.docs.length as int;
              }
              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: counter,
                itemBuilder: (ctx, index) => streamSnapshot.data!.docs[index]
                            ['Branch'] ==
                        "Misc."
                    ? SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 450,
                          child: Card(
                            child: Container(
                              child: Card(
                                shadowColor: Color(0xffb000080),
                                elevation: 80,
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Column(
                                  ///Text(streamSnapshot.data!.docs[index]['Email']),
                                  children: [
                                    Stack(
                                      children: [
                                        Ink.image(
                                          image: NetworkImage(
                                            streamSnapshot
                                                .data!.docs[index]['URL'],
                                          ),
                                          height: 240,
                                          fit: BoxFit.cover,
                                        ),
                                        Positioned(
                                          bottom: 16,
                                          right: 16,
                                          left: 16,
                                          child: streamSnapshot
                                              .data!.docs[index]
                                          ['Price']!=""?Text(
                                            streamSnapshot
                                                .data!.docs[index]
                                            ['Price'] as String ,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 24,
                                            ),
                                          ):Text(   "Negotiable",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 24,
                                            ),),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(16)
                                          .copyWith(bottom: 0),
                                      child: Text(
                                        streamSnapshot.data!.docs[index]
                                        ['Name'] as String,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    ButtonBar(
                                      alignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        FlatButton(
                                          child: Text('Delete'),
                                          onPressed: () {
                                            DocumentSnapshot ds = streamSnapshot.data!.docs[index];
                                            FirebaseFirestore.instance
                                                .collection("URL_Br_Year_Name_Price_Email")
                                                .doc(ds.id)
                                                .delete();
                                          },
                                        ),

                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                )
                    : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 450,
                          child: Card(
                            child: Container(
                              child: Card(
                                shadowColor: Color(0xffb000080),
                                elevation: 80,
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Column(
                                  ///Text(streamSnapshot.data!.docs[index]['Email']),
                                  children: [
                                    Stack(
                                      children: [
                                        Ink.image(
                                          image: NetworkImage(
                                            streamSnapshot
                                                .data!.docs[index]['URL'],
                                          ),
                                          height: 240,
                                          fit: BoxFit.cover,
                                        ),
                                        Positioned(
                                          bottom: 16,
                                          right: 16,
                                          left: 16,
                                          child:  streamSnapshot
                                              .data!.docs[index]
                                          ['Price'] !=""?Text(
                                            streamSnapshot
                                                .data!.docs[index]
                                            ['Price'] as String ,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 24,
                                            ),
                                          ):Text("Negotiable" ,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 24,
                                            ),),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(16)
                                          .copyWith(bottom: 0),
                                      child: Text(
                                        streamSnapshot.data!.docs[index]
                                        ['Name'] as String,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    SizedBox(height: 12,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text("Branch - " +
                                            streamSnapshot.data!.docs[index]
                                            ['Branch'],
                                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.blue[900]),
                                        ),
                                        Text("Year - " +
                                            streamSnapshot.data!.docs[index]
                                            ['Semester'],
                                          style: TextStyle(fontSize: 16,fontWeight:  FontWeight.bold,color: Colors.blue[900]),
                                        ),
                                      ],

                                    ),
                                    ButtonBar(
                                      alignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        FlatButton(
                                          child: Text('Delete'),
                                          onPressed: () {
                                            DocumentSnapshot ds = streamSnapshot.data!.docs[index];
                                            FirebaseFirestore.instance
                                                .collection("URL_Br_Year_Name_Price_Email")
                                                .doc(ds.id)
                                                .delete();
                                          },
                                        ),

                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
