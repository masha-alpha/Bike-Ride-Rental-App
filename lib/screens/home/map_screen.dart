import 'dart:async';

import 'package:bikeapp_v0/model/station_model.dart';
import 'package:bikeapp_v0/screens/home/favoris_screen.dart';
import 'package:bikeapp_v0/screens/reservation/station_screen.dart';
import 'package:bikeapp_v0/utils/next_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  //add multiple markers on the map
  final Completer<GoogleMapController> _controller = Completer();
  List<Marker> markers = [];

  @override
  void initState() {
    intialize();
    super.initState();
  }

  intialize() {
    // StreamBuilder(
    //   stream: readStations(),
    //   builder: (BuildContext context, AsyncSnapshot snapshot) {
    //     if (snapshot.hasError) {
    //       return const Text("Something was wrong");
    //     } else if (snapshot.hasData) {
    //       List stations = snapshot.data as List<Map<String, dynamic>>;
    //       return -1.1049261389042577, 37.013886257444845
    //       -1.1039714469037558, 37.01767351172671
    //       -1.106191902855416, 37.0151951505679
    Marker firstMarker = Marker(
      markerId: const MarkerId('Juja Square'),
      position: const LatLng(-1.1049261389042577, 37.013886257444845),
      infoWindow: const InfoWindow(title: 'Juja Square'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );
    Marker secondMarker = Marker(
      markerId: const MarkerId('Juja Police Station'),
      position: const LatLng(-1.1039714469037558, 37.01767351172671),
      infoWindow: const InfoWindow(title: 'Juja Police Station'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );
    Marker thirdMarker = Marker(
      markerId: const MarkerId('Equity Bank - Juja'),
      position: const LatLng(-1.106191902855416, 37.0151951505679),
      infoWindow: const InfoWindow(title: 'Equity Bank - Juja'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      // onTap: () => nextScreen(context, -1.107060776512933, 37.01462652223737
      // StationScreen(station: Station.fromMap(stations[index]))),
    );
    Marker forthMarker = Marker(
      markerId: const MarkerId('Juja Ecomatt Supermarket'),
      position: const LatLng(-1.107060776512933, 37.01462652223737),
      infoWindow: const InfoWindow(title: 'Juja Ecomatt Supermarket'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    ); //-1.1058164635776282, 37.01606418627528
    Marker fifthMarker = Marker(
      markerId: const MarkerId('Senate Hotel'),
      position: const LatLng(-1.1058164635776282, 37.01606418627528),
      infoWindow: const InfoWindow(title: 'Senate Hotel'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );
    markers.add(firstMarker);
    markers.add(secondMarker);
    markers.add(thirdMarker);
    markers.add(forthMarker);
    markers.add(fifthMarker);
    //     }
    //   },
    // );

    setState(() {});
  }

// -1.0909718344932822, 37.01169543886637
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(-1.0909718344932822, 37.01169543886637),
    zoom: 11.5,
  );

//late final GoogleMapController _googleMapController;
/*
Marker _origin=Marker(
            markerId: const MarkerId('origin'),
            infoWindow: const InfoWindow(title: 'Origin'),
            icon: 
                  BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          );
Marker _destination=Marker(
          markerId: const MarkerId('destination'),
            infoWindow: const InfoWindow(title: 'Destination'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            );
            */

//  @override
//  void dispose() {
//   _googleMapController.dispose();
//   super.dispose();
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: true,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: markers.map((e) => e).toSet(),
        /*
        markers: {
          if(_origin != null) _origin,
          if(_destination != null) _destination
        },

        onLongPress: _addMarker,
        */
      ),
      /*
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () => _googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(_initialCameraPosition),
        ),
        child: const Icon(Icons.center_focus_strong),
      ),
      */
    );
  }

  // void _addMarker(LatLng pos) {
  //   if(_origin==null || (_origin != null && _destination != null)) {
  //       setState(() {
  //         _origin = Marker(
  //           markerId: const MarkerId('origin'),
  //           infoWindow: const InfoWindow(title: 'Origin'),
  //           icon:
  //                 BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
  //           position: pos,
  //         );
  //         //Reset Destination
  //       late final _destination=null;
  //       });
  //   } else {
  //       // Origin is already set
  //       // Set destination
  //       setState(() {
  //         _destination=Marker(
  //         markerId: const MarkerId('destination'),
  //           infoWindow: const InfoWindow(title: 'Destination'),
  //           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  //           position: pos,
  //           );
  //       });
  //   }
  //}
}

Stream<List<Map<String, dynamic>>> readStations() => FirebaseFirestore.instance
    .collection('stations')
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
