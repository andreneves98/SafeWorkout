import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:safeworkout/models/parks.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController mapController;
  //Map<PermissionGroup, PermissionStatus> permissions;

  //final PermissionHandler permissionHandler = PermissionHandler();
  String _heading;
  final LatLng _center = const LatLng(45.521563, -122.677433);
  Position _currentPosition;
  List<Park> _nearparks=[];
  Map<MarkerId,Marker> parkmarkers = {};

  //final Geolocator geolocator = Geolocator.forceAndroidLocationManager;

  static const String kGoogleApiKey="AIzaSyAQmfkIAie_uuVOs9WaqOrOUXVinaqoJkU";
  
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  
  @override
  void initState(){
    super.initState();
    _heading="Suggestions";
  }
  //search for parks based on current location
  void getLocationResults()async{
    //results:
    String baseUrl='https://maps.googleapis.com/maps/api/place/nearbysearch/json';   
    String type="park";
    String radius="radius=1000"; //radius of 1500m
    _getCurrentLocation();//get current location 
    String location="${_currentPosition.latitude},${_currentPosition.longitude}";
    print(location);
    String request='$baseUrl?location=$location&$radius&type=$type&key=$kGoogleApiKey';//google maps request 
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

  _updateMarkers()async{
    getLocationResults();

    Map<MarkerId,Marker>tmpmark={};
    
    for (var p in _nearparks) {
      MarkerId markerId=MarkerId(p.name);
      Marker m=Marker(
        position: LatLng(
          double.parse(p.longitude),
          double.parse(p.latitude),

          ),
          infoWindow: InfoWindow(),
          onTap: (){
          },
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
  _getCurrentLocation() {
    Geolocator
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
    Geolocator.getPositionStream().listen((currentLocation) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(currentLocation.latitude, currentLocation.longitude),zoom: 15)));
      });     
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
      floatingActionButton: new FloatingActionButton(   
              child: Icon(
                Icons.directions_run,
                color:Colors.white,
                ),
              
              backgroundColor:Colors.blueAccent ,
              onPressed:() async{
                _updateMarkers();
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
          markers:Set.of(parkmarkers.values),

        ),
      ),
    );
  }

  void searchParks() async {
    print("Searching for parks...");
    print(await Geolocator.isLocationServiceEnabled());
    Prediction p = await PlacesAutocomplete.show(
                context: context, apiKey: kGoogleApiKey);
            displayPrediction(p);
      
    //print((await Geocoder.local.findAddressesFromQuery("Parques")));
  }

 Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      var address = await Geocoder.local.findAddressesFromQuery(p.description);

      print(lat);
      print(lng);
    }
  }
}
