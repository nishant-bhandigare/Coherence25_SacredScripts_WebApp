import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:math' show asin, atan2, cos, sin, sqrt;

class FullScreenMapPage extends StatefulWidget {
  const FullScreenMapPage({super.key});

  @override
  _FullScreenMapPageState createState() => _FullScreenMapPageState();
}

class _FullScreenMapPageState extends State<FullScreenMapPage> {
  // Google Maps controller
  GoogleMapController? _mapController;

  // Current position
  Position? _currentPosition;

  // Markers and polylines
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final Set<Circle> _circles = {};
  final Set<Polygon> _polygons = {};

  // Map settings
  MapType _currentMapType = MapType.normal;
  bool _trafficEnabled = false;
  bool _showMyLocationButton = true;
  double _currentZoom = 15.0;

  // Search and navigation
  final TextEditingController _searchController = TextEditingController();
  LatLng? _destinationLocation;
  String _travelDistance = "";
  String _travelTime = "";
  bool _isNavigating = false;
  bool _isSearchVisible = false;

  // For geofencing
  final List<LatLng> _polygonPoints = [];
  bool _isDrawingPolygon = false;

  // For places and POI
  List<Placemark>? _nearbyPlaces;
  bool _showNearbyPlaces = false;

  // Polyline points
  PolylinePoints _polylinePoints = PolylinePoints();
  List<LatLng> _polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Check and request location permission
  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServiceAlert();
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showPermissionDeniedAlert();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showPermanentDenialAlert();
      return;
    }

    // Get current location
    _getCurrentLocation();
  }

  // Show alerts for different location service scenarios
  void _showLocationServiceAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Services Disabled'),
        content: const Text('Please enable location services to use the map.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Denied'),
        content: const Text('Location permissions are required to use the map.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPermanentDenialAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Permanently Denied'),
        content: const Text('You must enable location permissions in app settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Get current location
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;

        // Update markers with current location
        _markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: const InfoWindow(
              title: 'My Location',
              snippet: 'Current Position',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        );

        // Add circle representing accuracy
        _circles.add(
          Circle(
            circleId: const CircleId('accuracy_circle'),
            center: LatLng(position.latitude, position.longitude),
            radius: position.accuracy,
            fillColor: Colors.blue.withOpacity(0.1),
            strokeColor: Colors.blue,
            strokeWidth: 1,
          ),
        );
      });

      // Move camera to current location
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: _currentZoom,
            ),
          ),
        );
      }

      // Get nearby places
      _getNearbyPlaces(position);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    }
  }

  // Get nearby places
  Future<void> _getNearbyPlaces(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _nearbyPlaces = placemarks;
      });
    } catch (e) {
      debugPrint('Error getting nearby places: $e');
    }
  }

  // Search for location
  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;

    try {
      List<Location> locations = await locationFromAddress(query);

      if (locations.isNotEmpty) {
        final location = locations.first;
        final latLng = LatLng(location.latitude, location.longitude);

        setState(() {
          _destinationLocation = latLng;

          // Add destination marker
          _markers.add(
            Marker(
              markerId: const MarkerId('destination'),
              position: latLng,
              infoWindow: InfoWindow(
                title: 'Destination',
                snippet: query,
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            ),
          );
        });

        // Move camera to destination
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: latLng,
              zoom: _currentZoom,
            ),
          ),
        );

        // Get directions if we have both origin and destination
        if (_currentPosition != null) {
          _getDirections(
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            latLng,
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching location: $e')),
      );
    }
  }

  // Get directions between two points
  Future<void> _getDirections(LatLng origin, LatLng destination) async {
    try {
      // Clear previous polylines
      setState(() {
        _polylines.clear();
        _polylineCoordinates.clear();
      });

      // Get route directions
      // PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      //   "AIzaSyAs8Apb4VqDxuhIr7g92PeA64B5Ju6Ty3I",  // Replace with your actual API key
      //   PointLatLng(origin.latitude, origin.longitude),
      //   PointLatLng(destination.latitude, destination.longitude),
      //   travelMode: TravelMode.driving,
      // );

      PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: "AIzaSyAs8Apb4VqDxuhIr7g92PeA64B5Ju6Ty3I",
        request: PolylineRequest(
          origin: PointLatLng(origin.latitude, origin.longitude),
          destination: PointLatLng(destination.latitude, destination.longitude),
          mode: TravelMode.driving,
          // wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")],
        ),
      );

      // Convert points to LatLng for Google Maps
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      }

      // Calculate approximate distance and time
      double totalDistance = 0;
      for (int i = 0; i < _polylineCoordinates.length - 1; i++) {
        totalDistance += _calculateDistance(
          _polylineCoordinates[i].latitude,
          _polylineCoordinates[i].longitude,
          _polylineCoordinates[i + 1].latitude,
          _polylineCoordinates[i + 1].longitude,
        );
      }

      // Assuming average speed of 50 km/h
      final durationMinutes = (totalDistance / 50 * 60).round();

      setState(() {
        _travelDistance = "${totalDistance.toStringAsFixed(2)} km";
        _travelTime = "$durationMinutes min";

        // Create a polyline
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: _polylineCoordinates,
            color: Colors.blue,
            width: 5,
          ),
        );
      });
    } catch (e) {
      debugPrint('Error getting directions: $e');
    }
  }

  // Calculate distance between two coordinates using Haversine formula
  double _calculateDistance(
      double startLat, double startLng, double endLat, double endLng) {

    const int earthRadius = 6371; // km

    final dLat = _toRadians(endLat - startLat);
    final dLng = _toRadians(endLng - startLng);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(startLat)) * cos(_toRadians(endLat)) *
            sin(dLng / 2) * sin(dLng / 2);

    final c = 2 * asin(sqrt(a));
    return earthRadius * c;
  }

  // Convert degrees to radians
  double _toRadians(double degree) {
    return degree * (3.14159265359 / 180);
  }

  // Start navigation mode
  void _startNavigation() {
    if (_destinationLocation == null || _polylineCoordinates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Set a destination first')),
      );
      return;
    }

    setState(() {
      _isNavigating = true;
      _showMyLocationButton = false;

      // Change map perspective to 3D
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 17,
            tilt: 60,
            bearing: _calculateBearing(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
              _polylineCoordinates[1].latitude,
              _polylineCoordinates[1].longitude,
            ),
          ),
        ),
      );
    });
  }

  // Stop navigation mode
  void _stopNavigation() {
    setState(() {
      _isNavigating = false;
      _showMyLocationButton = true;

      // Reset map perspective
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: _currentZoom,
            tilt: 0,
          ),
        ),
      );
    });
  }

  // Calculate bearing for navigation
  double _calculateBearing(
      double startLat, double startLng, double endLat, double endLng) {

    final dLng = _toRadians(endLng - startLng);

    final y = sin(dLng) * cos(_toRadians(endLat));
    final x = cos(_toRadians(startLat)) * sin(_toRadians(endLat)) -
        sin(_toRadians(startLat)) * cos(_toRadians(endLat)) * cos(dLng);

    var brng = atan2(y, x);
    brng = (brng * 180 / 3.14159265359) % 360;

    return brng;
  }

  // Draw polygon geofence
  void _toggleDrawPolygon() {
    setState(() {
      _isDrawingPolygon = !_isDrawingPolygon;

      if (!_isDrawingPolygon && _polygonPoints.length > 2) {
        // Create polygon when drawing is complete
        _polygons.add(
          Polygon(
            polygonId: const PolygonId('geofence'),
            points: _polygonPoints,
            fillColor: Colors.red.withOpacity(0.2),
            strokeColor: Colors.red,
            strokeWidth: 2,
          ),
        );
      } else if (_isDrawingPolygon) {
        // Clear previous polygon
        _polygonPoints.clear();
        _polygons.clear();
      }
    });
  }

  // Add point to polygon
  void _addPolygonPoint(LatLng point) {
    if (_isDrawingPolygon) {
      setState(() {
        _polygonPoints.add(point);

        // Add marker for each point
        _markers.add(
          Marker(
            markerId: MarkerId('polygon_point_${_polygonPoints.length}'),
            position: point,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          ),
        );
      });
    }
  }

  // Toggle map type
  void _toggleMapType() {
    setState(() {
      if (_currentMapType == MapType.normal) {
        _currentMapType = MapType.satellite;
      } else if (_currentMapType == MapType.satellite) {
        _currentMapType = MapType.terrain;
      } else if (_currentMapType == MapType.terrain) {
        _currentMapType = MapType.hybrid;
      } else {
        _currentMapType = MapType.normal;
      }
    });
  }

  // Toggle traffic layer
  void _toggleTraffic() {
    setState(() {
      _trafficEnabled = !_trafficEnabled;
    });
  }

  // Show nearby places
  void _toggleNearbyPlaces() {
    setState(() {
      _showNearbyPlaces = !_showNearbyPlaces;
    });
  }

  // Clear map
  void _clearMap() {
    setState(() {
      // Keep only current location marker
      final currentLocationMarker = _markers.firstWhere(
            (marker) => marker.markerId == const MarkerId('current_location'),
        orElse: () => Marker(markerId: const MarkerId('not_found')),
      );

      _markers.clear();
      if (currentLocationMarker.markerId != const MarkerId('not_found')) {
        _markers.add(currentLocationMarker);
      }

      _polylines.clear();
      _polygons.clear();
      _polylineCoordinates.clear();
      _polygonPoints.clear();
      _destinationLocation = null;
      _travelDistance = "";
      _travelTime = "";
      _isNavigating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full screen Google Map
          _currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
            // Initial camera position
            initialCameraPosition: CameraPosition(
              target: LatLng(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
              ),
              zoom: _currentZoom,
            ),

            // Map type and features
            mapType: _currentMapType,
            trafficEnabled: _trafficEnabled,
            buildingsEnabled: true,
            indoorViewEnabled: true,

            // Enable map interaction
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false, // Custom zoom controls
            scrollGesturesEnabled: true,
            rotateGesturesEnabled: true,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: _showMyLocationButton,

            // Map elements
            markers: _markers,
            polylines: _polylines,
            circles: _circles,
            polygons: _polygons,

            // Callbacks
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            onCameraMove: (CameraPosition position) {
              _currentZoom = position.zoom;
            },
            onTap: (LatLng position) {
              _addPolygonPoint(position);
            },
          ),

          // Top bar with back button and search
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: SafeArea(
              child: Row(
                children: [
                  // Back button
                  FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back),
                  ),

                  const SizedBox(width: 8),

                  // Search bar (expandable)
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 40,
                      child: _isSearchVisible
                          ? TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search for a place',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              _searchLocation(_searchController.text);
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                        onSubmitted: (value) {
                          _searchLocation(value);
                        },
                      )
                          : ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _isSearchVisible = true;
                          });
                        },
                        icon: const Icon(Icons.search),
                        label: const Text('Search'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Navigation info panel (show when navigating)
          if (_isNavigating && _destinationLocation != null)
            Positioned(
              top: 100,
              left: 16,
              right: 16,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Navigation',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Distance'),
                              Text(
                                _travelDistance,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Time'),
                              Text(
                                _travelTime,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: _stopNavigation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Stop'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Direction info panel (show when route is calculated but not navigating)
          if (!_isNavigating && _destinationLocation != null && _travelDistance.isNotEmpty)
            Positioned(
              top: 100,
              left: 16,
              right: 16,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Distance'),
                              Text(
                                _travelDistance,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Time'),
                              Text(
                                _travelTime,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: _startNavigation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Start'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Nearby places panel
          if (_showNearbyPlaces && _nearbyPlaces != null)
            Positioned(
              top: 100,
              left: 16,
              right: 16,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: SizedBox(
                  height: 200,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Nearby Places',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  _showNearbyPlaces = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _nearbyPlaces!.length,
                          itemBuilder: (context, index) {
                            final place = _nearbyPlaces![index];
                            return ListTile(
                              leading: const Icon(Icons.place),
                              title: Text(place.name ?? 'Unknown Place'),
                              subtitle: Text(
                                '${place.street ?? ''}, ${place.locality ?? ''}, ${place.postalCode ?? ''}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                // Close panel and search for this place
                                setState(() {
                                  _showNearbyPlaces = false;
                                  _searchController.text = '${place.street}, ${place.locality}';
                                });
                                _searchLocation(_searchController.text);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Bottom control panels
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Map type button
                FloatingActionButton(
                  heroTag: 'mapType',
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  onPressed: _toggleMapType,
                  child: Icon(
                    _currentMapType == MapType.normal
                        ? Icons.satellite_alt
                        : _currentMapType == MapType.satellite
                        ? Icons.terrain
                        : _currentMapType == MapType.terrain
                        ? Icons.layers
                        : Icons.map_outlined,
                  ),
                ),

                const SizedBox(height: 8),

                // Traffic toggle
                FloatingActionButton(
                  heroTag: 'traffic',
                  backgroundColor: _trafficEnabled ? Colors.blue : Colors.white,
                  foregroundColor: _trafficEnabled ? Colors.white : Colors.black,
                  onPressed: _toggleTraffic,
                  child: const Icon(Icons.traffic),
                ),

                const SizedBox(height: 8),

                // Nearby places
                FloatingActionButton(
                  heroTag: 'places',
                  backgroundColor: _showNearbyPlaces ? Colors.blue : Colors.white,
                  foregroundColor: _showNearbyPlaces ? Colors.white : Colors.black,
                  onPressed: _toggleNearbyPlaces,
                  child: const Icon(Icons.place),
                ),

                const SizedBox(height: 8),

                // Geofence drawing
                FloatingActionButton(
                  heroTag: 'geofence',
                  backgroundColor: _isDrawingPolygon ? Colors.red : Colors.white,
                  foregroundColor: _isDrawingPolygon ? Colors.white : Colors.black,
                  onPressed: _toggleDrawPolygon,
                  child: const Icon(Icons.draw),
                ),

                const SizedBox(height: 8),

                // Clear map
                FloatingActionButton(
                  heroTag: 'clear',
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  onPressed: _clearMap,
                  child: const Icon(Icons.clear),
                ),

                const SizedBox(height: 8),

                // Zoom controls
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          _mapController?.animateCamera(
                            CameraUpdate.zoomIn(),
                          );
                        },
                      ),
                      const Divider(height: 2, thickness: 1),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          _mapController?.animateCamera(
                            CameraUpdate.zoomOut(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}