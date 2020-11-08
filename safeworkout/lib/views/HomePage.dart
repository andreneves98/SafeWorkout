import 'package:flutter/material.dart';
import 'package:safeworkout/WorkoutData.dart';
import 'package:safeworkout/views/MapPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var workoutData = WorkoutData.muscleGroups;

    /* LIST IMPLEMENTATION */

    /*return Scaffold(
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: workoutData.length,
                itemBuilder: (content, index) {
                  return Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    height: 200,
                    width: double.maxFinite,
                    child: Card(
                      elevation: 7,
                      child: Padding(
                        padding: EdgeInsets.all(7),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 60),
                              child: Stack(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10, top: 5),
                                    child: Column(
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.center,
                                          child: Row(
                                            children: [
                                              workoutNameSymbol(workoutData[index]),
                                              Spacer(),
                                              cardIcon(workoutData[index]),
                                              
                                            ],
                                          )
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            )
                          ],
                        )
                      )
                    ),
                  );
                }
              )
            )
          ],
        ),
      )
    );*/

    /* GRID IMPLEMENTATION */
    return Scaffold(
      body: Container(
        color: Colors.grey[100],
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text("Exercises", 
                  style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                  )
                )
              ,)
            ),
            Expanded(
              child: GridView.builder(
                itemCount: workoutData.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () { 
                      /*Navigator.push(
                        context, MaterialPageRoute(builder: (context) => MapPage()),
                      );*/
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      height: 200,
                      width: double.maxFinite,
                      child: Card(
                        elevation: 7,
                        child: Padding(
                          padding: EdgeInsets.all(7),
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Stack(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment.center,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(bottom: 15, right:10),
                                                  child: Image.asset(workoutData[index]['image'], width: 70, ),
                                                ),
                                                Row(
                                                  children: [workoutGroup(workoutData[index]),
                                                    Spacer(),
                                                    Padding(
                                                      padding: EdgeInsets.only(top: 3),
                                                      child: Icon(
                                                        Icons.keyboard_arrow_right,
                                                        color: Colors.black,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            )
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              )
                            ],
                          )
                        )
                      ),
                    ),
                  );
                }
              )
            )
          ],
        ),
      )
    );
  }

  Widget workoutGroup(data) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: '${data['name']}',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
          ),
        ),
    );
  }
}