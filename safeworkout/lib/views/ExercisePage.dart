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
  @override
  void initState() {
    super.initState();
    indexesSelected = new List(widget.exercises_images.length);
    for(var index = 0; index < widget.exercises_images.length; index++) {
      indexesSelected[index] = false;
    }
  }

  void selected(index) {
    setState(() {
      indexesSelected[index] = !indexesSelected[index];
    });
  }

  @override
  Widget build(BuildContext context) {

    bool isSearching=false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: !isSearching 
                ? Text('SafeWorkout', style: TextStyle(fontSize: 26),)
                :TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: "Search something here",
                    hintStyle: TextStyle(color: Colors.white))
                ),
        
        /*actions:<Widget>[
          isSearching?
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: (){
              setState((){
                this.isSearching=false;
              });
            },
          ):
           IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              setState((){
                this.isSearching=true;
              });
            },
          ),
        ],*/
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
                        padding: EdgeInsets.all(10),
                        child: Text(widget.categoryName + " exercises", 
                        style: TextStyle(
                          fontSize: 24,
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
                                    icon: Icon(Icons.favorite),
                                    onPressed: () {
                                      //_indexesSelected[index] = true;
                                      selected(index);
                                      print("FAVORITE!" + index.toString());
                                    },
                                    color: indexesSelected[index] ? Colors.redAccent : Colors.grey,
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
              height: 300,
              width: 200,
              child: DrawerHeader(
                child: Text(""),
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  image: DecorationImage (
                    image: AssetImage('images/logo.jpg'),
                    fit: BoxFit.cover
                  )
                ),
              ),
            ),
            
            ListTile(
              leading: Icon(Icons.pie_chart),
              title: Text('Nutrition'),
            ),
            ListTile(
              leading: Icon(Icons.fitness_center),
              title: Text('Workout Plan'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
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
