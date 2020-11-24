import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safeworkout/models/parks.dart';
import 'dart:math' as math;

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController mapController;

  final  LatLng _center = const LatLng(45.521563, -122.677433);
  Position _currentPosition;
  List<Park> _nearparks=[];
  Map<MarkerId,Marker> parkmarkers = {};
  bool _enableMarkers=false;
  //final Geolocator geolocator ;;

  

  //search for parks based on current location
  Future<void> getLocationResults()async{
    //results:
    String baseUrl='https://maps.googleapis.com/maps/api/place/nearbysearch/json';   
    String type="park";
    String radius="radius=1000"; //radius of 1000m
    await _getCurrentLocation();//get current location 
    if(_currentPosition!=null){
      String location="${_currentPosition.latitude},${_currentPosition.longitude}";
      String request='$baseUrl?location=$location&$radius&type=$type&key=AIzaSyAQmfkIAie_uuVOs9WaqOrOUXVinaqoJkU';//google maps request 
      Response response=await Dio().get(request);
      final predictions=response.data['results'];
      List<Park> _newParks=[];
      if (predictions!=null){
        for (var i = 0; i < predictions.length; i++) {
          String latitude="${predictions[i]['geometry']['location']['lat']}";
          String longitude="${predictions[i]['geometry']['location']['lng']}";
          String name="${predictions[i]['name']}";
          Park p=Park(name,latitude,longitude);
          if(p!=null){
            _newParks.add(p);
          }
        }
      }
      setState(() {
        _nearparks=_newParks;
      });
    }
  
  }

  _updateMarkers()async{
    await getLocationResults();

    Map<MarkerId,Marker>tmpmark={};
    
    for (var p in _nearparks) {
      MarkerId markerId=MarkerId(p.name);
      double longitude= double.parse(p.longitude);
      double latitude=double.parse(p.latitude);
     // double distance=Geolocator.distanceBetween(_convertRadiansTodegrees(_currentPosition.latitude), _convertRadiansTodegrees(_currentPosition.longitude),_convertRadiansTodegrees(latitude),_convertRadiansTodegrees(longitude));
      Marker m=Marker(
        position: LatLng(
         longitude,
         latitude,
          ),
          infoWindow: InfoWindow(
            title: p.name,
           ) ,
         
          markerId: markerId,
          visible: true,
          icon: BitmapDescriptor.defaultMarker,
          draggable: true,
          zIndex: 1,
        );
      tmpmark[markerId]=m;
      setState((){
        parkmarkers=tmpmark;
      });
    }
  }
  Future _getCurrentLocation()async {
    await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  void _onMapCreated(GoogleMapController _controller) async {
     mapController = _controller;
     if(await Geolocator.isLocationServiceEnabled()){
        Geolocator.getPositionStream().listen((currentLocation) {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(currentLocation.latitude, currentLocation.longitude),zoom: 15)));
        });     
     }
     setState(() {
       _controller=mapController;
     });
  }
  _convertRadiansTodegrees(double radians){
     double degrees = (180 /math.pi) * radians;
     return (degrees);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
      floatingActionButton: new FloatingActionButton(   
              child: Icon(
                Icons.park,
                color:Colors.white,
                ),
              backgroundColor:Colors.blueAccent ,
              onPressed:() async{
              
                InfoWindow(title: "Searching for parks...");
                await _updateMarkers();
                setState(() {
                    _enableMarkers=!_enableMarkers;
                });
              } 
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        body: GoogleMap(
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          mapType: MapType.normal,
          scrollGesturesEnabled: true,
          zoomControlsEnabled: true,
          
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(41.150335, -8.557672),
            zoom: 10.0,
          ),
          markers:_enableMarkers?Set.of(parkmarkers.values):{},

        ),
      ),
    );
  }
}
