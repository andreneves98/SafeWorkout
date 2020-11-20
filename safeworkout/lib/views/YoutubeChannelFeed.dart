import 'package:flutter/material.dart';
import 'package:safeworkout/globals.dart';
//import 'package:safeworkout/models/channel_model.dart';
import 'package:safeworkout/screens/home_screen.dart';
//import 'package:safeworkout/services/api_services.dart';

import 'package:safeworkout/globals.dart' as globals;

class YoutubeVPage extends StatefulWidget {

  //const YoutubeVPage({Key key, this.channeList}) : super(key: key);
  @override
  _YoutubeVPage createState() => new _YoutubeVPage();
  
}
  

class _YoutubeVPage extends State<YoutubeVPage> {
   final List<String> channeList=
             ['UCOFCwvhDoUvYcfpD7RJKQwA','UCgBTevPW8fsH4pQNrLufOsQ'
              ,'UCkbRJKtiIoQ330fAZiE9_sg','UCK5PP5Up6Dz80dv5G4XuiiA',
              'UC68TLK0mAEzUyHx5x5k','UCqjwF8rxRsotnojGl4gM0Zw',
              '_faz2gINcwGEf9A6ZZg','UCEtMRF1ywKMc4sf3EXYyDzw'
             ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //createvideoList();

    return Scaffold(
      body:
        new ListView.builder(
          itemCount:8, 
          itemBuilder:(BuildContext context,int index){
              return GestureDetector(
                onTap:(){
                  globals.channelID= channeList[index];
                  //final String chInfo=channeList[index];
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
              },
             
              child://BuildYoutubeCard(context,index,channelID[index])  ,
                Card(
                      child:Row(
                        children: <Widget>[
                            Container(
                              width:100,
                              height:100,
                              child: Text("AQUI VAI SER A IMAGEM ???"),
                            ),
                          Padding(
                            padding:const EdgeInsets.only(top:8.0,bottom:8.0),
                            child: Row(children: <Widget>[
                            Text ("ChannelID=${channeList[index]}"),
                      ],
                      ),
                    )
                  ],
                ) 
                )
          );
          }
      )
    );

  }
    /*
    Widget BuildYoutubeCard(BuildContext context, int index,String channelID) {
        globals.channelID= channelID;
        final String chInfo=channeList[index];
            return new Card(
                    child:Row(
                      children: <Widget>[
                          Container(
                            width:100,
                            height:100,
                            child: Text("AQUI VAI SER A IMAGEM ???"),
                          ),
                        Padding(
                          padding:const EdgeInsets.only(top:8.0,bottom:8.0),
                          child: Row(children: <Widget>[
                          Text ("ChannelID=$chInfo"),
                    ],
                    ),
                  )
                ],
              ) 
           
          ); 
        }
    
      // ignore: non_constant_identifier_names
      Future<void> createvideoList() async {
         
          List<String>  channelsID  =
              ['UCOFCwvhDoUvYcfpD7RJKQwA','UCgBTevPW8fsH4pQNrLufOsQ'
              ,'UCkbRJKtiIoQ330fAZiE9_sg','UCK5PP5Up6Dz80dv5G4XuiiA',
              'UC68TLK0mAEzUyHx5x5k','UCqjwF8rxRsotnojGl4gM0Zw',
              '_faz2gINcwGEf9A6ZZg','UCEtMRF1ywKMc4sf3EXYyDzw'
              ];
          for (int i = 0; i < 2; i++) {
              print("$i=${channelsID[i]}");
              Channel channel = await APIService.instance
              .fetchChannel(channelId: channelsID[i]); 
              print(channel.title);      
              this.channeList[i]=channel;
          }
          
    }*/
}