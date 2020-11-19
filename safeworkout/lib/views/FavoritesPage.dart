import 'package:flutter/material.dart';
import 'package:safeworkout/globals.dart' as globals;
import 'package:safeworkout/backend/ExerciseCategory.dart';
import 'package:safeworkout/views/LogIn.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {

  void selected(index) {
    setState(() {
      //globals.favorites[index].favorite = !globals.favorites[index].favorite;
      globals.favorites.removeAt(index);
    });
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
      body: Container(
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
                                leading: Image.network(globals.favorites[index].image, width: 50),
                                title: Text(globals.favorites[index].name,
                                  style: TextStyle(fontSize: 20),),
                                  subtitle: Text(categoryName(globals.favorites[index].category, category)),
                                trailing: IconButton(
                                  icon: Icon(Icons.star_border),
                                  onPressed: () {
                                    selected(index);
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