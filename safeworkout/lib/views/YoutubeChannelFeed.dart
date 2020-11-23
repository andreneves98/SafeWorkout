import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:safeworkout/models/channel_model.dart';
import 'package:safeworkout/screens/home_screen.dart';

import 'package:safeworkout/globals.dart' as globals;
import 'package:safeworkout/services/api_services.dart';

class YoutubeVPage extends StatefulWidget {
  @override
  _YoutubeVPage createState() => new _YoutubeVPage();
}

class _YoutubeVPage extends State<YoutubeVPage> {
           /*  ['UCOFCwvhDoUvYcfpD7RJKQwA','UCgBTevPW8fsH4pQNrLufOsQ'
              ,'UCkbRJKtiIoQ330fAZiE9_sg','UCK5PP5Up6Dz80dv5G4XuiiA',
              'UC68TLK0mAEzUyHx5x5k','UCqjwF8rxRsotnojGl4gM0Zw',
              '_faz2gINcwGEf9A6ZZg','UCEtMRF1ywKMc4sf3EXYyDzw'
             ];*/
  
  //List<Channel> _channeList=[];
/*
  @override
  void initState() {
    super.initState();
    _initChannel();
  }

  _initChannel() async {
    await _createvideoList();
  }*/

//  _YoutubeVPage(this._channeList);
  @override
  Widget build(BuildContext context) {
     
    // TODO: implement build
    return WillPopScope(
      child: Scaffold(
      appBar: globals.myAppBar,
      drawer: globals.myDrawer,
      //bottomNavigationBar: globals.myBottomNavigationBar(context,_selectedIndex,_onItemTapped),
      body: 
      Container(
          color: Colors.white,
        child:Column(
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
                        child: Text("Famous workout channels", 
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
            child:FutureBuilder(
              future: _createvideoList(),
              builder:(context,AsyncSnapshot snapshot){
                if(snapshot.connectionState==ConnectionState.none && snapshot.hasData==null){
                    return Container();
                }
                else if(snapshot.connectionState==ConnectionState.waiting){
                    return Center(
                      child:Loading(
                      indicator: BallPulseIndicator(), 
                      size: 100.0,
                      color: Colors.black,
                      ),
                    
                    );
                }  

              else{
                    return ListView.builder (
                      itemCount:6, 
                      itemBuilder:( context, index){
                          return GestureDetector(
                            onTap:(){
                            // globals.channelID= channeList[index].id;
                              globals.channel=snapshot.data[index];
                              //final String chInfo=channeList[index];
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                          },
                        
                      child://BuildYoutubeCard(context,index,channelID[index])  ,
                        Card(
                          elevation: 5,
                              child:Row(
                                children: <Widget>[
                                    Container(
                                      width:100,
                                      height:100,
                                      child: Image.network("${snapshot.data[index].profilePictureUrl}"),
                                    ),
                                  Padding(
                                    padding:const EdgeInsets.only(top:8.0,bottom:8.0),
                                    child: Row(children: <Widget>[
                                    Text ("${snapshot.data[index].title}",
                                          style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black
                                          )),

                              ],
                              ),
                            )
                          ],
                        ) 
                        )
                      );
                    }
                  );
              }
            }
          )
          ),
        ],
      )
   )
  ),
  onWillPop: _onBackPressed,

  );
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
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }
 _createvideoList() async {
    List<Channel> tmpList=[];
    List<String>  channelsID  =
        ['UCOFCwvhDoUvYcfpD7RJKQwA','UCgBTevPW8fsH4pQNrLufOsQ'
        ,'UCkbRJKtiIoQ330fAZiE9_sg','UCK5PP5Up6Dz80dv5G4XuiiA',
        /*'UCC7AJ-P3n4j02i-YzReHCNw',*/'UCqjwF8rxRsotnojGl4gM0Zw',
       /*'_faz2gINcwGEf9A6ZZg',*/'UCEtMRF1ywKMc4sf3EXYyDzw'
        ];
    for (var channelID in channelsID) {
        print("$channelID");
        Channel channel = await APIService.instance
        .fetchChannel(channelId: channelID); 
        print(channel.title);      
        tmpList.add(channel);
    }
         /* setState(() {
            _channeList=tmpList;
          });*/
      return tmpList;
}
  
}