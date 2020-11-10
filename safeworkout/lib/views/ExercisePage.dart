import 'package:flutter/material.dart';
import 'package:safeworkout/backend/ExerciseBloc.dart';
import 'package:safeworkout/api/ApiResponse.dart';
import 'package:safeworkout/backend/ExerciseInfo.dart';
import 'package:safeworkout/backend/ExerciseImageInfo.dart';

class ExercisePage extends StatefulWidget {
  ExerciseBloc exerciseBloc;

  ExercisePage([ExerciseBloc exerciseBloc]) {
    this.exerciseBloc = exerciseBloc;
  }

  ExerciseBloc getExerciseBloc() {
    return this.exerciseBloc;
  }

  @override _ExercisePageState createState() => _ExercisePageState(exerciseBloc);
}

class _ExercisePageState extends State<ExercisePage> {

  ExerciseBloc _exerciseBloc;

  _ExercisePageState(this._exerciseBloc);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int category = ModalRoute.of(context).settings.arguments;
    //final ExerciseBloc exerciseBloc = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _exerciseBloc.mergeImages(category),
        child: StreamBuilder<ApiResponse<List<Exercise>>>(
          stream: _exerciseBloc.exerciseImageListStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return Loading(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  return ExerciseList(exercises_images: snapshot.data.data);
                  break;
                case Status.ERROR:
                  return Error(
                    errorMessage: snapshot.data.message,
                    onRetryPressed: () => _exerciseBloc.mergeImages(category),
                  );
                  break;
              }
            }
            return Container();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _exerciseBloc.dispose();
    super.dispose();
  }
}

class ExerciseList extends StatelessWidget {
  final List<Exercise> exerciseList;
  final List<ExerciseImage> exerciseImageList;
  final List<Exercise> exercises_images;

  const ExerciseList({Key key, this.exerciseList, this.exerciseImageList, this.exercises_images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                padding: EdgeInsets.only(top: 50),
                child: Text("Page", 
                  style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                  )
                )
              ,)
            ), 
            Expanded(
              child: ListView.builder(
                itemCount: exercises_images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      /*onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MovieDetail(movieList[index].id)));
                      },*/
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          /*child: Text(
                            exerciseList[index].name,
                            style: TextStyle(color: Colors.black)
                          )*/
                          child: Row(
                            children: [
                              Column(children: [
                                Row(children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 5, right: 10),
                                    child: Image.network(exercises_images[index].image, width: 50),
                                  ),
                                  Text(
                                    exercises_images[index].name,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20)
                                  ),
                                ],)
                                
                                /*Text(
                                  exerciseList[index].description,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13)
                                ),*/
                              ],)
                            ]
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            )
          ]
        )
      ),
    );
  }
}

class Error extends StatelessWidget {
  final String errorMessage;

  final Function onRetryPressed;

  const Error({Key key, this.errorMessage, this.onRetryPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          RaisedButton(
            color: Colors.redAccent,
            child: Text(
              'Retry',
              style: TextStyle(
//                color: Colors.white,
                  ),
            ),
            onPressed: onRetryPressed,
          )
        ],
      ),
    );
  }
}

class Loading extends StatelessWidget {
  final String loadingMessage;

  const Loading({Key key, this.loadingMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            loadingMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
//              color: Colors.lightGreen,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 24),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen),
          ),
        ],
      ),
    );
  }
}
