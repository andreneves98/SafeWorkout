import 'package:flutter/material.dart';
import 'package:safeworkout/backend/ExerciseBloc.dart';
import 'package:safeworkout/api/ApiResponse.dart';
import 'package:safeworkout/backend/ExerciseInfo.dart';
import 'package:safeworkout/backend/ExerciseImageInfo.dart';
import 'package:safeworkout/globals.dart' as globals;
import 'package:safeworkout/views/LogIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safeworkout/views/FavoritesPage.dart';


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

  /*List<bool> _indexesSelected;
  void _selected(index) {
    setState(() {
      //List<bool> _indexesSelected = new List<bool>(exercises_images.length);
    /*for(var index = 0; index < exercises_images.length; index++) {
      _indexesSelected[index] = false;
    }*/
    _indexesSelected.insert(index, true);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    final String args = ModalRoute.of(context).settings.arguments;
    final int categoryIndex = int.parse(args.split("-")[0]);
    final String categoryName = args.split("-")[1];

    //final ExerciseBloc exerciseBloc = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: RefreshIndicator(
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
    );
  }

  @override
  void dispose() {
    _exerciseBloc.dispose();
    super.dispose();
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
      if(!globals.favorites.contains(widget.exercises_images[index])) {
        widget.exercises_images[index].favorite = true;
        globals.favorites.add(widget.exercises_images[index]);
        print("Exercise " + index.toString() + " added! Length: " + globals.favorites.length.toString());
        result = true;
      }
      else {
        widget.exercises_images[index].favorite = false;
        globals.favorites.remove(widget.exercises_images[index]);
        print("Exercise " + index.toString() + " removed! Length: " + globals.favorites.length.toString());
        result = false;
      }

      print("\nList of favs:");
      for(var fav in globals.favorites) {
        print(fav.toString());
      }

    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.clear_all, color: Colors.black, size: 30,),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        title: Text("SafeWorkout", style: TextStyle(color: Colors.red[500], fontSize: 25),),
      ),

      body: Center(
        child: Container(
          color: Colors.grey[100],
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
                        /*onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MovieDetail(movieList[index].id)));
                        },*/
                        child: Card(
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
                                  trailing: IconButton(
                                    icon: Icon(Icons.star_border),
                                    onPressed: () {
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
                                  ),
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
      /*bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_label),
            label: 'Videos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[300],
        onTap: _onItemTapped,
      ),*/
      
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 270,
              width: 200,
              child: DrawerHeader(
                child: Text(""),
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  image: DecorationImage (
                    image: AssetImage('images/logo.jpg'),
                    fit: BoxFit.fitWidth
                  )
                ),
              ),
            ),
            ListTile(
              leading: globals.isLogged ? CircleAvatar(backgroundImage: NetworkImage("https://banner2.cleanpng.com/20180626/fhs/kisspng-avatar-user-computer-icons-software-developer-5b327cc98b5780.5684824215300354015708.jpg"))
              : CircleAvatar(backgroundImage: NetworkImage("https://www.plataformadialetica.com/images/2020/04/10/team1.jpg")),
              title: Text("Signed in as"),
              subtitle: globals.isLogged ? 
                      Text(globals.user.email)
                      : Text('Guest'),
            ),

            Divider(
              height: 30,
            ),

            ListTile(
              leading: Icon(Icons.star_border, color: Colors.yellow[600],),
              title: Text('Favorites'),
              enabled: globals.isLogged,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesPage()));
              }
            ),
            ListTile(
              leading: Icon(Icons.pie_chart_outlined, color: Colors.green[300],),
              title: Text('Nutrition'),
              enabled: globals.isLogged,
            ),
            ListTile(
              leading: Icon(Icons.qr_code, color: Colors.blue[300],),
              title: Text('Share'),
              enabled: globals.isLogged,
              onTap: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesPage()));
              }
            ),

            Divider(
              height: 30,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: RaisedButton(
                color: Colors.red,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.white,),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("Sign out", style: TextStyle(color: Colors.white),)
                    )
                  ],
                ),
                onPressed: () async {
                  dynamic result=await signOut();
                  if(result==null) {
                    print("There are no user logedIn");
                  } else {
                    print(result);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  }
                },
            )
            )
            
          ],
        ),
      )
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
