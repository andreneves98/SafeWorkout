import 'package:flutter/material.dart';
import 'package:safeworkout/globals.dart' as globals;
import 'package:safeworkout/backend/ExerciseCategory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safeworkout/repository/databaseExercise.dart';
import 'package:safeworkout/views/ExerciseInfoPage.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {

  void selected(index) {
    setState(() {
      //globals.favorites[index].favorite = !globals.favorites[index].favorite;
      removeExercise(globals.favorites[index]);
      globals.favorites.removeAt(index);
      globals.updateFavorite();    });
  }

  String categoryName(int cat, List<Map<String, Object>> list) {
    String name;
    for(var map in list) {
      if(cat == map['id'])
        name = map['name'];
    }

    return name;
  }

  @override 
  Widget build(BuildContext context) {
    var category = ExerciseCategory.muscleGroups;

    return Scaffold(
      appBar:globals.myAppBar,
      body: Container(
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
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text("Your favorite exercises", 
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                      )
                    )
                  )
                            
                ],
              ),
            globals.favorites.length > 0 ? Expanded(
              child: ListView.builder(
                itemCount: globals.favorites.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ExerciseInfoPage(globals.favorites[index].image, 
                              globals.favorites[index].name, globals.favorites[index].description, 
                              categoryName(globals.favorites[index].category, category))));
                      },
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Image.network(globals.favorites[index].image, width: 50),
                                title: Text(globals.favorites[index].name,
                                  style: TextStyle(fontSize: 20),),
                                  subtitle: Text(categoryName(globals.favorites[index].category, category)),
                                trailing:globals.isLogged? IconButton(
                                  icon: Icon(Icons.star_border),
                                  onPressed: () {
                                    selected(index);
                                    //globals.updateFavorite();

                                    final snackBar = SnackBar(
                                      content: Text("Exercise removed from your favorites!"),
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
                                  color: globals.favorites[index].favorite ? Colors.yellow[600] : Colors.grey,
                                ):null,
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
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            child:
                              Text(
                              "You haven't selected any favorite exercises!",
                                style: TextStyle(fontSize:18,
                                color: const Color(0xFF000000),),
                              ),
        
                            padding: const EdgeInsets.only(top: 200, left:20, bottom: 15),
                          )
                        ]
                      ),
                    ]
                  ),
                  RaisedButton(
                    color: Colors.blue,
                    child: Text("Go to Home Page", style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ]
            )
          ]
        )
      ),

      drawer: globals.myDrawer(context),
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