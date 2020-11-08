import 'package:flutter/material.dart';
import 'package:safeworkout/ExerciseBloc.dart';
import 'package:safeworkout/api/ApiResponse.dart';
import 'package:safeworkout/ExerciseInfo.dart';

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
        onRefresh: () => _exerciseBloc.fetchExerciseList(),
        child: StreamBuilder<ApiResponse<List<Exercise>>>(
          stream: _exerciseBloc.exerciseListStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return Loading(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  return ExerciseList(exerciseList: snapshot.data.data);
                  break;
                case Status.ERROR:
                  return Error(
                    errorMessage: snapshot.data.message,
                    onRetryPressed: () => _exerciseBloc.fetchExerciseList(),
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

  const ExerciseList({Key key, this.exerciseList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: exerciseList.length,
      /*gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5 / 1.8,
      ),*/
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
                  child: Text(
                    exerciseList[index].name,
                    style: TextStyle(color: Colors.black)
                  )
              ),
            ),
          ),
        );
      },
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