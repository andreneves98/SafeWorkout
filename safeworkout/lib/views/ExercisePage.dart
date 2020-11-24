import 'package:flutter/material.dart';
import 'package:safeworkout/backend/ExerciseBloc.dart';
import 'package:safeworkout/api/ApiResponse.dart';
import 'package:safeworkout/backend/ExerciseInfo.dart';
import 'package:safeworkout/backend/ExerciseImageInfo.dart';
import 'package:safeworkout/globals.dart' as globals;
import 'package:safeworkout/repository/databaseExercise.dart';
import 'package:safeworkout/views/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safeworkout/views/ExerciseInfoPage.dart';


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

  _ExercisePageState([this._exerciseBloc]);

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final String args = ModalRoute.of(context).settings.arguments;
    final int categoryIndex = int.parse(args.split("-")[0]);
    final String categoryName = args.split("-")[1];

    //final ExerciseBloc exerciseBloc = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      
        body:WillPopScope(
          onWillPop: _onBackPressed,
          child: RefreshIndicator(
          onRefresh: () => _exerciseBloc.mergeImages(categoryIndex),
          child: StreamBuilder(
          stream: _exerciseBloc.exerciseImageListStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return Loading(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  return ExerciseList(exercises_images: snapshot.data.data, categoryName: categoryName, exerciseBloc: _exerciseBloc,);
                  break;
                case Status.ERROR:
                  return Error(
                    errorMessage: snapshot.data.message,
                    onRetryPressed: () => _exerciseBloc.mergeImages(categoryIndex),
                  );
                  break;
              }
            }
            return Container();
          },
        ),
      ),
    )
    );
  }

  @override
  void dispose() {
    _exerciseBloc.dispose();
    super.dispose();
  }
  
  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('You are going to exit the application!!'),
            actions: <Widget>[
              FlatButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('YES'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)  {
                  return  HomePage();
                }));                },
              ),
            ],
          );
        });
  }
}

class ExerciseList extends StatefulWidget {
  final List<Exercise> exerciseList;
  final List<ExerciseImage> exerciseImageList;
  final List<Exercise> exercises_images;
  final ExerciseBloc exerciseBloc;
  final String categoryName;

  const ExerciseList({Key key, this.exerciseList, this.exerciseImageList, this.exercises_images, this.categoryName, this.exerciseBloc}) : super(key: key);
  
  @override _ExerciseListState createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  List<bool> indexesSelected;
  GlobalKey<NavigatorState> _key = GlobalKey();

  //List<Exercise> favorites;
  @override
  void initState() {
    super.initState();
    indexesSelected = new List(widget.exercises_images.length);
    //favorites = new List();
    for(var index = 0; index < widget.exercises_images.length; index++) {
      indexesSelected[index] = false;
      //print("CONTAINS? " + globals.favorites.contains(widget.exercises_images[index]).toString());
    }
  }

  bool selected(index) {
    bool result; // 0 removed, 1 added
    print("\nexercises_images:");
    setState(() {
      for(var exercise in widget.exercises_images) {
        print(exercise.toString());
      }

      //print(widget.exercises_images[index].toString());
      //widget.exercises_images[index].favorite = !widget.exercises_images[index].favorite;
      if(!globals.favContainsExercise(widget.exercises_images[index])) {
        widget.exercises_images[index].favorite = true;
        //globals.favorites.add(widget.exercises_images[index]);
        saveExercise(widget.exercises_images[index]);

        print("Exercise " + index.toString() + " added! Length: " + globals.favorites.length.toString());
        result = true;
      }
      else {
        widget.exercises_images[index].favorite = false;
        //globals.favorites.remove(widget.exercises_images[index]);
        removeExercise(widget.exercises_images[index]);

        print("Exercise " + index.toString() + " removed! Length: " + globals.favorites.length.toString());
        result = false;
      }

      print("\nList of favs:");
      for(var fav in globals.favorites) {
        print(fav.toString());
      }
      globals.updateFavorite();

    });

    return result;
  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      
      
      appBar: globals.myAppBar,
      body: 
        WillPopScope(
          
          onWillPop: () async {
            print("I am doing something here");
            if (Navigator.canPop(context)) {

              Navigator.pop(context);
              return false;
            }
            return true;
            },
        child:Center(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ]
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(widget.categoryName + " exercises", 
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                          )
                        )
                      )
                    ]
                  )                
                ],
              ),
              
              Expanded(
                child: ListView.builder(
                  itemCount: widget.exercises_images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ExerciseInfoPage(widget.exercises_images[index].image, 
                              widget.exercises_images[index].name, widget.exercises_images[index].description, 
                              widget.categoryName)));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: Image.network(widget.exercises_images[index].image, width: 50),
                                  title: Text(widget.exercises_images[index].name,
                                    style: TextStyle(fontSize: 20),),
                                
                                  trailing: globals.isLogged ? IconButton(
                                    icon:Icon(Icons.star_border),
                                    onPressed:() {
                                      //enabled:globals.isLogged;
                                      var text = selected(index);
                                      final snackBar = SnackBar(
                                        content: Text(text ? "Exercise added to your favorites!" : "Exercise removed from your favorites!"),
                                        action: SnackBarAction(
                                          label: 'Close',
                                          onPressed: () {
                                            // Some code to undo the change.
                                          },
                                        ),
                                      );
                                      Scaffold.of(context).showSnackBar(snackBar);
                                    },
                                    //color: globals.favorites.contains(widget.exercises_images[index]) ? Colors.yellow : Colors.grey,
                                    color: widget.exercises_images[index].favorite ? Colors.yellow[600] : Colors.grey,
                                  ) : null,
                                ),
                              ],
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
      ),
    ),
    drawer:globals.myDrawer,

    );
  }

}

Future signOut() async{
  try {
    User user= (await FirebaseAuth.instance.currentUser);
    await FirebaseAuth.instance.signOut();
    return user.uid;
  } catch(e) {
    print(e.toString());
    return null;
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
            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
          ),
        ],
      ),
    );
  }
}
