import 'package:flutter/material.dart';
import 'package:safeworkout/ExerciseBloc.dart';
import 'package:safeworkout/api/ApiResponse.dart';
import 'package:safeworkout/ExerciseInfo.dart';
import 'package:safeworkout/ExerciseImageInfo.dart';

class ExercisePage extends StatefulWidget {
  @override _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  ExerciseBloc _exerciseBloc;

  @override
  void initState() {
    super.initState();
    _exerciseBloc = ExerciseBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _exerciseBloc.mergeImages(),
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
                    onRetryPressed: () => _exerciseBloc.mergeImages(),
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
    return Expanded(
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
                            child: Image.network(exercises_images[index].image, width: 70),
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
