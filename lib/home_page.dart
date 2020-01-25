import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position currentPosition;
  String currentAddress;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("location"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if(currentPosition!=null)
              Text(currentAddress),
              //Text("LATITUDE: ${currentPosition.latitude},LONGITUDE ${currentPosition.longitude}"),
            FlatButton(
              child: Text("get location"),
              onPressed: () {
                getCurrentLocation();
              },
            )
          ],
        ),
      )
    );
  }

  getCurrentLocation() {
    //final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((Position position) {
      setState(() {
        currentPosition = position;
      });

      getAddressFromLatLong();
    }).catchError((e) {
      print(e);
    });
  }

  getAddressFromLatLong() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
        currentPosition.latitude,currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        currentAddress = "${place.locality},${place.postalCode},${place.country}";
      });
    } catch(e){
      print(e);
    }
  }
}
