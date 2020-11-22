import 'package:flutter/material.dart';
import 'package:safeworkout/backend/ExerciseCategory.dart';
import 'package:safeworkout/views/ExercisePage.dart';
import 'package:safeworkout/backend/ExerciseBloc.dart';

class FeedPage extends StatefulWidget {

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  
  @override
  Widget build(BuildContext context) {
    //ExerciseBloc _exerciseBloc = ExerciseBloc();
    
    var exerciseCategory = ExerciseCategory.muscleGroups;

    /* GRID IMPLEMENTATION */
    return Scaffold(
      body: Container(
        color: Colors.white,
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
                  fontSize: 24,
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
                      ExerciseBloc _exerciseBloc = ExerciseBloc();
                      print("TAPPED CATEGORY: " + exerciseCategory[index]['name']);
                      _exerciseBloc.mergeImages(exerciseCategory[index]['id']);
                      Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) => ExercisePage(_exerciseBloc),
                          settings: RouteSettings(
                            arguments: exerciseCategory[index]['id'].toString() + "-" + exerciseCategory[index]['name'],
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
                                          Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(bottom: 15, right:10),
                                                child: Image.asset(exerciseCategory[index]['image'], width: 70, ),
                                              ),
                                                workoutGroup(exerciseCategory[index]),
                                                //Spacer(),
                                            ],
                                          )
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [ 
        Text('${data['name']}',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
          ),
        Padding(
          padding: EdgeInsets.only(top: 3),
          child: Icon(
            Icons.keyboard_arrow_right,
            color: Colors.black,
          ),
        )
      ]
    );
  }
}