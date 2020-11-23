import 'package:flutter/material.dart';
import 'package:safeworkout/globals.dart' as globals;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class SharePage extends StatefulWidget {
  @override 
  _SharePageState createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:globals.myAppBar,
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
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
                  child: Text("Share your favorite exercises", 
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                    )
                  )
                )
                          
              ],
            ),
            
            Container(
              margin: EdgeInsets.all(30),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 10,
                child: 
                Column(
                  children: [
                    QrImage(
                      data: "123456789",
                      version: QrVersions.auto,
                      size: 230,
                      //backgroundColor: Colors.lightBlue,
                      foregroundColor: Colors.lightBlue,
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        globals.user.email,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    )
                  ],
                ) 
              )
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      RaisedButton(
                        color: Colors.white,
                        onPressed: () async {
                          String cameraScanResult = await scanner.scan();
                          print("SCANNNNNNN: " + cameraScanResult);
                          showAlertDialog(context, cameraScanResult);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.blue)
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.camera_alt_outlined),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text("Read QR code", style: TextStyle(fontSize: 15),),
                            ),
                          ],
                        )
                      )
                    ],
                  ),
                ),
              ),
            )
          ]
        )
      )
    );
  }

  showAlertDialog(BuildContext context, String result) { 
    // configura o button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    // configura o  AlertDialog
    AlertDialog alerta = AlertDialog(
      title: Text("Resultados"),
      content: Text(result),
      actions: [
        okButton,
      ],
    );
    // exibe o dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alerta;
      },
    );
  }
}