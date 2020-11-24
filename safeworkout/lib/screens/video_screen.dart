import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:safeworkout/globals.dart' as globals;

class VideoScreen extends StatefulWidget {

  final String id;

  VideoScreen({this.id});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {

  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: globals.myAppBar,
      drawer: globals.myDrawer(context),
      body:
      
        Container(
         child:Column(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [   
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_outlined),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
       YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        
        onReady: () {
          print('Player is ready.');
        },
       ), 
      ],
      ),
    )
    );
  }
}