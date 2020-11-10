import 'package:flutter/material.dart';
import 'package:safeworkout/backend/ExerciseCategory.dart';
import 'package:safeworkout/views/MapPage.dart';
import 'package:safeworkout/views/ExercisePage.dart';
import 'package:safeworkout/backend/ExerciseBloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    ExerciseBloc _exerciseBloc = ExerciseBloc();
    
    var exerciseCategory = ExerciseCategory.muscleGroups;

    /* LIST IMPLEMENTATION */

    /*return Scaffold(
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: exerciseCategory.length,
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
                                              workoutNameSymbol(exerciseCategory[index]),
                                              Spacer(),
                                              cardIcon(exerciseCategory[index]),
                                              
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
                child: Text("What are we training today?", 
                  style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                  )
                )
              ,)
            ),
            Expanded(
              child: GridView.builder(
                itemCount: exerciseCategory.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () { 
                      _exerciseBloc.mergeImages(exerciseCategory[index]['id']);
                      Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) => ExercisePage(_exerciseBloc),
                          settings: RouteSettings(
                            arguments: exerciseCategory[index]['id'],
                          ),
                        ),
                      );
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
                                                  child: Image.asset(exerciseCategory[index]['image'], width: 70, ),
                                                ),
                                                Row(
                                                  children: [workoutGroup(exerciseCategory[index]),
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