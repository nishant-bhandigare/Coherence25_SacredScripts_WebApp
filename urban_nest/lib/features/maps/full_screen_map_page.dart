// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
//
// class FullScreenMapPage extends StatefulWidget {
//   const FullScreenMapPage({super.key});
//
//   @override
//   _FullScreenMapPageState createState() => _FullScreenMapPageState();
// }
//
// class _FullScreenMapPageState extends State<FullScreenMapPage> {
//   // Google Maps controller
//   GoogleMapController? _mapController;
//
//   // Current position
//   Position? _currentPosition;
//
//   // Markers
//   Set<Marker> _markers = {};
//
//   // Map type control
//   MapType _currentMapType = MapType.normal;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkLocationPermission();
//   }
//
//   // Check and request location permission
//   Future<void> _checkLocationPermission() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       _showLocationServiceAlert();
//       return;
//     }
//
//     // Check location permissions
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         _showPermissionDeniedAlert();
//         return;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       _showPermanentDenialAlert();
//       return;
//     }
//
//     // Get current location
//     _getCurrentLocation();
//   }
//
//   // Show alerts for different location service scenarios
//   void _showLocationServiceAlert() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Location Services Disabled'),
//         content: const Text('Please enable location services to use the map.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showPermissionDeniedAlert() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Location Permission Denied'),
//         content: const Text('Location permissions are required to use the map.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showPermanentDenialAlert() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Location Permission Permanently Denied'),
//         content: const Text('You must enable location permissions in app settings.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Get current location
//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//
//       setState(() {
//         _currentPosition = position;
//
//         // Update markers with current location
//         _markers = {
//           Marker(
//             markerId: const MarkerId('current_location'),
//             position: LatLng(position.latitude, position.longitude),
//             infoWindow: const InfoWindow(
//               title: 'My Location',
//               snippet: 'Current Position',
//             ),
//             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//           ),
//         };
//       });
//
//       // Move camera to current location
//       _mapController?.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             target: LatLng(position.latitude, position.longitude),
//             zoom: 15,
//           ),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error getting location: $e')),
//       );
//     }
//   }
//
//   // Toggle map type
//   void _toggleMapType() {
//     setState(() {
//       _currentMapType = _currentMapType == MapType.normal
//           ? MapType.satellite
//           : MapType.normal;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Full screen Google Map
//           _currentPosition == null
//               ? const Center(child: CircularProgressIndicator())
//               : GoogleMap(
//             // Initial camera position
//             initialCameraPosition: CameraPosition(
//               target: LatLng(
//                 _currentPosition!.latitude,
//                 _currentPosition!.longitude,
//               ),
//               zoom: 15,
//             ),
//
//             // Map type
//             mapType: _currentMapType,
//
//             // Enable map interaction
//             zoomGesturesEnabled: true,
//             zoomControlsEnabled: true,
//             scrollGesturesEnabled: true,
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//
//             // Add markers
//             markers: _markers,
//
//             // Callback when map is created
//             onMapCreated: (GoogleMapController controller) {
//               _mapController = controller;
//             },
//           ),
//
//           // Top-left back button
//           Positioned(
//             top: 40,
//             left: 16,
//             child: SafeArea(
//               child: FloatingActionButton(
//                 mini: true,
//                 backgroundColor: Colors.white,
//                 foregroundColor: Colors.black,
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Icon(Icons.arrow_back),
//               ),
//             ),
//           ),
//
//           // Bottom-right map type toggle button
//           Positioned(
//             bottom: 16,
//             right: 16,
//             child: FloatingActionButton(
//               backgroundColor: Colors.white,
//               foregroundColor: Colors.black,
//               onPressed: _toggleMapType,
//               child: Icon(
//                 _currentMapType == MapType.normal
//                     ? Icons.satellite_alt
//                     : Icons.map_outlined,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
