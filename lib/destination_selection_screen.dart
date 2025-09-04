import 'dart:convert'; // For jsonDecode
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
// Import the new QR Scanner screen
import 'qr_scanner_screen.dart';

// --- YOUR SPECIFIED GOOGLE MAPS API KEY ---
// IMPORTANT: Replace with your actual Google Maps API Key
const String YOUR_Maps_API_KEY = "AIzaSyAfgLw2AOcyc_Vpk-Sk3U4Lp_LQlnLufGQ";

// --- Location Data ---
const Map<String, Map<String, dynamic>> unimasLocations = {
  'Faculty of Cognitive Sciences and Human Development': {
    'description':
    'Premier destination for cognitive sciences and human development studies.',
    'arUrl': 'assets/fschd_to_petary/index.html',
    'imageAsset': 'assets/images/fcshd.png',
    'category': 'FCSHD',
    'icon': 'psychology',
    'latitude': 1.462878,
    'longitude': 110.429267,
  },
  'PETARY': {
    'description':
    'Central library and learning resource hub for academic excellence.',
    'arUrl': 'assets/fschd_to_petary/index.html',
    'imageAsset': 'assets/images/PETARY.png',
    'category': 'Library',
    'icon': 'library_books',
    'latitude': 1.463876,
    'longitude': 110.426717,
  },
  'Faculty of Engineering': {
    'description':
    'State-of-the-art engineering facilities and innovation center.',
    'arUrl': 'assets/fschd_to_petary/index.html',
    'imageAsset': 'assets/images/FE.png',
    'category': 'FENG',
    'icon': 'engineering',
    'latitude': 1.469160,
    'longitude': 110.426946,
  },
  'Student Pavilion': {
    'description':
    'Dynamic student hub for activities, dining, and social interaction.',
    'arUrl': 'assets/fschd_to_petary/index.html',
    'imageAsset': 'assets/images/Pavillion.png',
    'category': 'Student Food Pavilion',
    'icon': 'groups',
    'latitude': 1.467990,
    'longitude': 110.430315,
  },
  'Faculty of Computer Science and Information Technology': {
    'description':
    'Dynamic student hub for activities, dining, and social interaction.',
    'arUrl': 'assets/fschd_to_petary/index.html',
    'imageAsset': 'assets/images/FCSIT.png',
    'category': 'FCSIT',
    'icon': 'groups',
    'latitude': 1.468055,
    'longitude': -249.570867,
  },
  'Faculty of Economic and Business': {
    'description':
    'Dynamic student hub for activities, dining, and social interaction.',
    'arUrl': 'assets/fschd_to_petary/index.html',
    'imageAsset': 'assets/images/FEB.png',
    'category': 'FEB',
    'icon': 'groups',
    'latitude': 1.463924,
    'longitude': -249.569948,
  },
  'Faculty of Education, Language, and Communication': {
    'description':
    'Dynamic student hub for activities, dining, and social interaction.',
    'arUrl': 'assets/fschd_to_petary/index.html',
    'imageAsset': 'assets/images/FLC.png',
    'category': 'FELC',
    'icon': 'groups',
    'latitude': 1.464155,
    'longitude': 470.428714,
  },
  'Faculty of Applied and Creative Arts': {
    'description':
    'Dynamic student hub for activities, dining, and social interaction.',
    'arUrl': 'assets/fschd_to_petary/index.html',
    'imageAsset': 'assets/images/FACA.png',
    'category': 'FACA',
    'icon': 'groups',
    'latitude': 1.463470,
    'longitude': -249.571915,
  },
  'Stadium UNIMAS': {
    'description':
    'Dynamic student hub for activities, dining, and social interaction.',
    'arUrl': 'assets/fschd_to_petary/index.html',
    'imageAsset': 'assets/images/STADIUM.png',
    'category': 'STADIUM',
    'icon': 'groups',
    'latitude': 1.463736,
    'longitude': 470.434122,
  },
  'PITAS': {
    'description':
    'Dynamic student hub for activities, dining, and social interaction.',
    'arUrl': 'assets/fschd_to_petary/index.html',
    'imageAsset': 'assets/images/PITAS.png',
    'category': 'PITAS',
    'icon': 'groups',
    'latitude': 1.470760,
    'longitude': -249.564972,
  },
  'TAZ': {
    'description':
    'Dynamic student hub for activities, dining, and social interaction.',
    'arUrl': 'assets/fschd_to_petary/index.html',
    'imageAsset': 'assets/images/TAZ.png',
    'category': 'TUN ABDUL ZAINAL COLLEGE',
    'icon': 'groups',
    'latitude': 1.465511,
    'longitude': -249.564208,
  },
  'BRC': {
    'description':
    'Dynamic student hub for activities, dining, and social interaction.',
    'arUrl': 'assets/fschd_to_petary/index.html',
    'imageAsset': 'assets/images/BUNGA RAYA.png',
    'category': 'BUNGA RAYA COLLEGE',
    'icon': 'groups',
    'latitude': 1.467898,
    'longitude': -249.564162,
  },
  'CEMPAKA': {
    'description':
    'Dynamic student hub for activities, dining, and social interaction.',
    'arUrl': 'assets/fschd_to_petary/index.html',
    'imageAsset': 'assets/images/CEMPAKA.png',
    'category': 'CEMPAKA COLLEGE',
    'icon': 'groups',
    'latitude': 1.465525,
    'longitude': -249.567596,

  'Faculty of Medicine and Health Science': {
    'description':
    'Dynamic student hub for activities, dining, and social interaction.',
    'arUrl': 'assets/fschd_to_petary/index.html',
    'imageAsset': 'assets/images/FMHS.png',
    'category': 'FMHS',
    'icon': 'groups',
    'latitude': 1.463627,
    'longitude': -249.568326,
  },
  'CTF 3 AND CTF 4': {
    'description':
    'Dynamic student hub for activities, dining, and social interaction.',
    'arUrl': 'assets/fschd_to_petary/index.html',
    'imageAsset': 'assets/images/CTF_4_AND_CTF_3.png',
    'category': 'CENTRAL TEACHING FACILITIES',
    'icon': 'groups',
    'latitude': 1.463735,
    'longitude': -249.569257,
  },
  'Faculty of Social Sciences and Humanities': {
    'description':
    'Dynamic student hub for activities, dining, and social interaction.',
    'arUrl': 'assets/fschd_to_petary/index.html',
    'imageAsset': 'assets/images/FSSH.png',
    'category': 'FSSH',
    'icon': 'groups',
    'latitude': 1.463691,
    'longitude': -249.570774,
  },
  'DETAR': {
    'description':
    'Dynamic student hub for activities, dining, and social interaction.',
    'arUrl': 'assets/fschd_to_petary/index.html',
    'imageAsset': 'assets/images/DETAR.png',
    'category': 'UNIMAS HALL',
    'icon': 'groups',
    'latitude': 1.466953,
    'longitude': -249.574390,
  },
  'CTF 1': {
    'description':
    'Dynamic student hub for activities, dining, and social interaction.',
    'arUrl': 'assets/fschd_to_petary/index.html',
    'imageAsset': 'assets/images/CTF_1.png',
    'category': 'CENTRAL TEACHING FACILITIES',
    'icon': 'groups',
    'latitude': 1.467001,
    'longitude': -249.571994,
  },
  'CUBE': {
    'description':
    'Dynamic student hub for activities, dining, and social interaction.',
    'arUrl': 'assets/fschd_to_petary/index.html',
    'imageAsset': 'assets/images/CUBE.png',
    'category': 'CENTRAL UNIMAS BUILDING FOR EDUCATORS',
    'icon': 'groups',
    'latitude': 1.467116,
    'longitude': -249.570986,
  },
  'SAKURA': {
    'description':
    'Dynamic student hub for activities, dining, and social interaction.',
    'arUrl': 'assets/fschd_to_petary/index.html',
    'imageAsset': 'assets/images/SAKURA.png',
    'category': 'SAKURA COLLEGE',
    'icon': 'groups',
    'latitude': 1.469290,
    'longitude': -249.570173,
  },
  'Faculty of Resource Science and Technology': {
    'description':
    'Dynamic student hub for activities, dining, and social interaction.',
    'arUrl': 'assets/fschd_to_petary/index.html',
    'imageAsset': 'assets/images/FRST.png',
    'category': 'FRST',
    'icon': 'groups',
    'latitude': 1.469799,
    'longitude': -249.571790,
  },
  },
  'ALLAMANDA': {
    'description':
    'Dynamic student hub for activities, dining, and social interaction.',
    'arUrl': 'assets/fschd_to_petary/index.html',
    'imageAsset': 'assets/images/ALLAMANDA.png',
    'category': 'ALLAMANDA COLLEGE',
    'icon': 'groups',
    'latitude': 1.471023,
    'longitude': -249.569332,
  },
  'DAHLIA': {
    'description':
    'Dynamic student hub for activities, dining, and social interaction.',
    'arUrl': 'assets/fschd_to_petary/index.html',
    'imageAsset': 'assets/images/DAHLIA.png',
    'category': 'DAHLIA COLLEGE',
    'icon': 'groups',
    'latitude': 1.473088,
    'longitude': -249.570608,
  },
};

// --- Campus and Fixed Start Location ---
const LatLng unimasCampusCenter = LatLng(1.4671, 110.4503);
const LatLng youAreHereLocation = LatLng(1.464813, -249.577146);
const String youAreHereKey = "My Current Location";


class DestinationSelectionScreen extends StatefulWidget {
  @override
  _DestinationSelectionScreenState createState() =>
      _DestinationSelectionScreenState();
}

class _DestinationSelectionScreenState extends State<DestinationSelectionScreen>
    with SingleTickerProviderStateMixin {
  // We no longer need _selectedStartLocationKey, as it's fixed.
  String? _selectedDestinationKey;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  GoogleMapController? _mapController;
  final Set<Polyline> _polylines = {};
  List<LatLng> _routePoints = [];
  final Set<Marker> _markers = {};

  // _startLocationCoords is now fixed.
  final LatLng _startLocationCoords = youAreHereLocation;
  LatLng? _destinationLocationCoords;

  bool _isRouteLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    // Set the fixed start location and marker when the screen loads
    _setInitialMarker();

    _animationController.forward();

    const String genericPlaceholder = "YOUR_ACTUAL_Maps_API_KEY_HERE";
    if (YOUR_Maps_API_KEY == genericPlaceholder ||
        YOUR_Maps_API_KEY == "AIzaSyCQQQ0eox0rpbmkz_H0pQLWrOCHpmsJ36k" ||
        (YOUR_Maps_API_KEY.startsWith("AIzaSy") && YOUR_Maps_API_KEY.length < 39)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showApiKeyWarningDialog();
      });
    }
  }

  void _setInitialMarker() {
    // This function sets up the "You are here" marker from the start.
    _markers.add(Marker(
      markerId: MarkerId('start_location'),
      position: _startLocationCoords,
      infoWindow: InfoWindow(title: youAreHereKey),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ));
  }

  void _showApiKeyWarningDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange[700]),
            SizedBox(width: 10),
            Text('API Key Issue')
          ]),
          content: Text(
              'The Google Maps API key in the code might be a placeholder or invalid. Please ensure you have used your actual Google Maps API key. This key needs "Directions API" and "Maps SDK for Android/iOS" enabled in Google Cloud Console, and billing active for your project.'),
          actions: <Widget>[
            TextButton(
              child: Text('Understood'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // Animate to the user's fixed starting location when the map is created.
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_startLocationCoords, 17.0));
  }

  Future<void> _updateMapWithSelections() async {
    // Clear previous markers except for the fixed start location.
    _markers.removeWhere((m) => m.markerId.value == 'destination_location');
    _polylines.clear();
    _destinationLocationCoords = null;

    // The "You are here" marker is already set in initState, so we don't need to add it again.

    if (_selectedDestinationKey != null) {
      final destData = unimasLocations[_selectedDestinationKey!];
      if (destData != null && destData['latitude'] != null && destData['longitude'] != null) {
        _destinationLocationCoords = LatLng(destData['latitude']!, destData['longitude']!);
        _markers.add(Marker(
          markerId: MarkerId('destination_location'),
          position: _destinationLocationCoords!,
          infoWindow: InfoWindow(title: 'Destination: $_selectedDestinationKey'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ));
      }
    }

    if (_destinationLocationCoords != null) {
      await _getRouteAndDrawPolyline();
    } else {
      _polylines.clear();
      _routePoints.clear();
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_startLocationCoords, 17.0));
      setState(() {});
    }
  }

  Future<void> _getRouteAndDrawPolyline() async {
    const String genericPlaceholder = "YOUR_ACTUAL_Maps_API_KEY_HERE";
    if (_destinationLocationCoords == null ||
        YOUR_Maps_API_KEY == genericPlaceholder ||
        YOUR_Maps_API_KEY == "AIzaSyCQQQ0eox0rpbmkz_H0pQLWrOCHpmsJ36k" ||
        (YOUR_Maps_API_KEY.startsWith("AIzaSy") && YOUR_Maps_API_KEY.length < 39)) {
      setState(() { _polylines.clear(); _routePoints.clear(); _isRouteLoading = false; });
      return;
    }
    setState(() { _isRouteLoading = true; _polylines.clear(); _routePoints.clear(); });

    PolylinePoints polylinePoints = PolylinePoints();
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_startLocationCoords.latitude},${_startLocationCoords.longitude}&destination=${_destinationLocationCoords!.latitude},${_destinationLocationCoords!.longitude}&mode=walking&key=$YOUR_Maps_API_KEY';

    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == 'OK' && data['routes'] != null && (data['routes'] as List).isNotEmpty) {
          if (data['routes'][0]['overview_polyline'] != null && data['routes'][0]['overview_polyline']['points'] != null) {
            String encodedPolyline = data['routes'][0]['overview_polyline']['points'];
            List<PointLatLng> decodedPolylinePoints = polylinePoints.decodePolyline(encodedPolyline);
            _routePoints = decodedPolylinePoints.map((point) => LatLng(point.latitude, point.longitude)).toList();
            if (_routePoints.isNotEmpty) {
              _polylines.add(Polyline(
                polylineId: PolylineId('route_${DateTime.now().millisecondsSinceEpoch}'),
                points: _routePoints,
                color: Colors.teal[600]!, width: 6,
                startCap: Cap.roundCap, endCap: Cap.roundCap, jointType: JointType.round,
              ));
              _animateMapToRoute();
            } else { _showSnackBar('No route points found in the API response.'); }
          } else { _showSnackBar('Error fetching route: Polyline data is missing.'); }
        } else { _showSnackBar('Error fetching route from API: ${data['status']} - ${data['error_message'] ?? 'Unknown API error.'}'); }
      } else { _showSnackBar('Failed to connect to Directions API. Status: ${response.statusCode}.'); }
    } catch (e) { _showSnackBar('Error calculating route: $e'); }
    finally { setState(() { _isRouteLoading = false; }); }
  }

  void _animateMapToRoute() {
    if (_mapController == null || _routePoints.isEmpty || _destinationLocationCoords == null) return;
    LatLng southwest = _routePoints.reduce((value, element) => LatLng(
        value.latitude < element.latitude ? value.latitude : element.latitude,
        value.longitude < element.longitude ? value.longitude : element.longitude));
    LatLng northeast = _routePoints.reduce((value, element) => LatLng(
        value.latitude > element.latitude ? value.latitude : element.latitude,
        value.longitude > element.longitude ? value.longitude : element.longitude));
    LatLngBounds bounds = LatLngBounds(southwest: southwest, northeast: northeast);
    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70.0));
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'psychology': return Icons.psychology_alt_outlined;
      case 'library_books': return Icons.local_library_outlined;
      case 'engineering': return Icons.engineering_outlined;
      case 'groups': return Icons.groups_outlined;
      default: return Icons.location_on_outlined;
    }
  }

  void _navigateToArJsView(String destinationName) {
    if (!unimasLocations.containsKey(destinationName)) {
      _showSnackBar("Destination details are missing.");
      return;
    }

    final locationData = unimasLocations[destinationName]!;
    String arAssetPathValue = locationData['arUrl'] as String? ?? "";

    if (arAssetPathValue.isEmpty || !arAssetPathValue.startsWith("assets/")) {
      _showSnackBar(
          "The AR asset path for '$destinationName' is not configured correctly. It should start with 'assets/'.");
      return;
    }

    if (_routePoints.isEmpty) {
      _showSnackBar("Route not calculated. AR guidance might be limited if the AR scene expects route data.");
    }

    print("Navigating to WebAR screen with AR Map: $arAssetPathValue");

    // Replace this with your actual navigation logic to the AR screen
    // Navigator.of(context).push(MaterialPageRoute(
    //   builder: (context) => ArJsViewScreen(
    //     arAssetPath: arAssetPathValue,
    //     // You might want to pass route points to your AR screen
    //     // routePoints: _routePoints,
    //   ),
    // ));
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline_rounded, color: Colors.white.withOpacity(0.9)),
            SizedBox(width: 12),
            Expanded(child: Text(message, style: TextStyle(fontSize: 15, color: Colors.white))),
          ],
        ),
        backgroundColor: Colors.redAccent[400]?.withOpacity(0.95),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.fromLTRB(15, 5, 15, 20),
        elevation: 6.0,
        duration: Duration(seconds: 4),
      ),
    );
  }

  Widget _buildLocationDisplayItem(String? locationKey, Map<String, dynamic>? locationData) {
    if (locationKey == null || locationData == null) {
      return Text('Select...', style: TextStyle(color: Colors.grey[500]));
    }
    String? imagePath = locationData['imageAsset'] as String?;
    String iconName = locationData['icon'] as String? ?? 'location_on';

    return Row(
      children: <Widget>[
        Container(
          width: 32,
          height: 32,
          margin: const EdgeInsets.only(right: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.teal[50],
          ),
          child: imagePath != null && imagePath.isNotEmpty
              ? ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(_getIconData(iconName), color: Colors.teal[700], size: 18),
            ),
          )
              : Icon(_getIconData(iconName), color: Colors.teal[700], size: 18),
        ),
        Flexible(
          child: Text(
            locationKey,
            style: TextStyle(fontSize: 16, color: Colors.grey[850]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final List<String> locationsList = unimasLocations.keys.toList();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false, pinned: true, elevation: 3.0,
            backgroundColor: Color(0xFF004D40),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              title: Text('UNIMAS AR Navigator', textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w600,
                      shadows: <Shadow>[Shadow(offset: Offset(0.0, 1.0), blurRadius: 2.0, color: Colors.black.withOpacity(0.5))])),
              background: Stack(fit: StackFit.expand, children: <Widget>[
                Image.asset(
                    'assets/images/Unimas.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [Color(0xFF00796B), Color(0xFF004D40)],
                              begin: Alignment.topLeft, end: Alignment.bottomRight),
                        ),
                        child: const Center(child: Icon(Icons.school_outlined, color: Colors.white70, size: 70)),
                      );
                    }),
                Container(decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.black.withOpacity(0.65), Colors.transparent, Colors.black.withOpacity(0.55)],
                        begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [0.0, 0.5, 1.0]))),
              ]),
            ),
          ),
          SliverToBoxAdapter(
            child: FadeTransition(opacity: _fadeAnimation, child: SlideTransition(position: _slideAnimation,
              child: Padding(padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 32.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                  _buildWelcomeCard(), SizedBox(height: 28),
                  // *** EDITED: Replaced selector with a static card ***
                  _buildYouAreHereCard(),
                  SizedBox(height: 20),
                  _buildDestinationSelector(locationsList), SizedBox(height: 28),
                  _buildMapCard(), SizedBox(height: 28),

                  // --- MODIFICATION START ---
                  // This new button for the QR scanner is added here.
                  SizedBox(height: 12),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.qr_code_scanner, size: 22),
                    label: const Text(
                      'UNIMAS AR MAP',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.3),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.teal[800],
                      backgroundColor: Colors.teal[50]?.withOpacity(0.5),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                      side: BorderSide(color: Colors.teal.shade200),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => QrScannerScreen(),
                      ));
                    },
                  ),
                  // --- MODIFICATION END ---

                  SizedBox(height: 20),
                  if (_selectedDestinationKey != null && !_isRouteLoading)
                    Padding(padding: const EdgeInsets.only(top: 12.0),
                        child: _buildSelectedRouteCard()),
                ]),
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(elevation: 6.0, shadowColor: Colors.teal[200]?.withOpacity(0.5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.0), gradient: LinearGradient(colors: [Colors.teal[50]!, Colors.white], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        padding: EdgeInsets.all(24.0),
        child: Column(children: <Widget>[
          Icon(Icons.explore_outlined, size: 52, color: Colors.teal[700]), SizedBox(height: 18),
          Text('Plan Your Route', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[850]), textAlign: TextAlign.center),
          SizedBox(height: 10),
          Text('Your starting point is set. Choose a destination to see the route, then launch the AR navigation.',
              style: TextStyle(fontSize: 15.5, color: Colors.grey[600], height: 1.45), textAlign: TextAlign.center),
        ]),
      ),
    );
  }

  // *** NEW WIDGET: Replaces the start location dropdown ***
  Widget _buildYouAreHereCard() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Static Location Point',
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800])
            ),
            SizedBox(height: 8), // Added space

            Text('Please go to this point for the AR experience to start correctly.',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700], height: 1.4)
            ),
            SizedBox(height: 16),// Added space

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.grey[300]!)
              ),
              child: Row(
                children: [
                  Icon(Icons.my_location_rounded, color: Colors.teal[700], size: 22),
                  SizedBox(width: 12),
                  Text(
                    youAreHereKey,
                    style: TextStyle(fontSize: 16, color: Colors.grey[850]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationSelector(List<String> destinations) {
    return Card(elevation: 4.0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      child: Padding(padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Text('Choose Your Destination', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: Colors.grey[800])),
          SizedBox(height: 18),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(hintText: 'Select a destination...', hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
                border: OutlineInputBorder( borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey[350]!)),
                enabledBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey[350]!, width: 1.0)),
                focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.teal[700]!, width: 2.0)),
                filled: true, fillColor: Colors.white, contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
                prefixIcon: Icon(Icons.flag_outlined, color: Colors.teal[700], size: 22)),
            value: _selectedDestinationKey, isExpanded: true, icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.grey[700], size: 28),
            dropdownColor: Colors.grey[50], itemHeight: null,
            items: destinations.map((String value) {
              final locationData = unimasLocations[value]!;
              return DropdownMenuItem<String>(
                  value: value,
                  // A destination is enabled if it has coordinates.
                  enabled: locationData['latitude'] != null,
                  child: _buildDropdownItem(value, locationData, isDisabled: locationData['latitude'] == null));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() { _selectedDestinationKey = newValue; });
              _updateMapWithSelections();
            },
            selectedItemBuilder: (BuildContext context) {
              if (_selectedDestinationKey == null) return <Widget>[];
              return <Widget>[
                _buildLocationDisplayItem(
                    _selectedDestinationKey,
                    unimasLocations[_selectedDestinationKey!]
                )
              ];
            },
          ),
        ]),
      ),
    );
  }

  Widget _buildDropdownItem(String value, Map<String, dynamic> locationData, {bool isDisabled = false}) {
    String? imagePath = locationData['imageAsset'] as String?;
    String iconName = locationData['icon'] as String? ?? 'location_on';
    bool hasCoords = locationData['latitude'] != null && locationData['longitude'] != null;
    bool effectivelyDisabled = isDisabled || !hasCoords;
    Color itemColor = effectivelyDisabled ? Colors.grey[400]! : Colors.grey[850]!;
    Color categoryColor = effectivelyDisabled ? Colors.grey[400]! : Colors.grey[600]!;
    Color iconColor = effectivelyDisabled ? Colors.grey[400]! : Colors.teal[700]!;


    return Opacity(opacity: effectivelyDisabled ? 0.5 : 1.0,
      child: Padding(padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(children: <Widget>[
          Container(width: 48, height: 48,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.teal[50]?.withOpacity(effectivelyDisabled ? 0.3 : 0.7)),
              child: imagePath != null && imagePath.isNotEmpty
                  ? ClipRRect(borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(imagePath, fit: BoxFit.cover,
                      color: effectivelyDisabled ? Colors.grey.withOpacity(0.5) : null, colorBlendMode: effectivelyDisabled ? BlendMode.saturation : null,
                      errorBuilder: (context, error, stackTrace) => Center(child: Icon(_getIconData(iconName), color: iconColor, size: 26))))
                  : Center(child: Icon(_getIconData(iconName), color: iconColor, size: 26))),
          SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: itemColor), maxLines: 2, overflow: TextOverflow.ellipsis),
            SizedBox(height: 3),
            Text(locationData['category'] as String? ?? 'Campus Location', style: TextStyle(fontSize: 13, color: categoryColor, fontWeight: FontWeight.w400)),
            if (!hasCoords) Padding(padding: const EdgeInsets.only(top: 2.0),
                child: Text('(No coordinates available)', style: TextStyle(fontSize: 11, color: Colors.red[400], fontStyle: FontStyle.italic))),
          ])),
        ]),
      ),
    );
  }

  Widget _buildMapCard() {
    return Card(elevation: 4.0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)), clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 12.0),
          child: Row(children: [
            Icon(Icons.map_outlined, color: Colors.teal[700], size: 24), SizedBox(width: 10),
            Text('Route Preview', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: Colors.grey[800])),
            Spacer(),
            if (_isRouteLoading) SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(Colors.teal))),
          ]),
        ),
        Container(height: 250,
            child: (YOUR_Maps_API_KEY == "YOUR_ACTUAL_Maps_API_KEY_HERE" ||
                YOUR_Maps_API_KEY == "AIzaSyCQQQ0eox0rpbmkz_H0pQLWrOCHpmsJ36k" ||
                !YOUR_Maps_API_KEY.startsWith("AIzaSy"))
                ? Center(child: Padding(padding: const EdgeInsets.all(16.0),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.key_off_outlined, color: Colors.red[600], size: 40), SizedBox(height: 10),
                  Text("Google Maps API Key is missing or invalid. Please set your API key to view the map.",
                      textAlign: TextAlign.center, style: TextStyle(color: Colors.red[700], fontSize: 16, fontWeight: FontWeight.w500))])) )
                : GoogleMap(onMapCreated: _onMapCreated,
                // The initial position is now the fixed start location.
                initialCameraPosition: CameraPosition(target: _startLocationCoords, zoom: 17.0),
                polylines: _polylines, markers: _markers, myLocationButtonEnabled: true, myLocationEnabled: true,
                zoomControlsEnabled: true, mapToolbarEnabled: false,
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())})),
        if (!_isRouteLoading && _destinationLocationCoords != null)
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Text(
                  _routePoints.isNotEmpty
                      ? "Route calculated. Ready for AR Navigation."
                      : "Could not calculate route. Check selections or API key.",
                  style: TextStyle(
                      color: _routePoints.isNotEmpty ? Colors.green[700] : Colors.orange[800],
                      fontSize: 14, fontWeight: FontWeight.w500)))
        else if (!_isRouteLoading && _destinationLocationCoords == null)
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Text("Select a destination to see the route preview.", style: TextStyle(color: Colors.blueGrey[600], fontSize: 14))),
      ]),
    );
  }

  Widget _buildSelectedRouteCard() {
    if (_selectedDestinationKey == null ||
        !unimasLocations.containsKey(_selectedDestinationKey!)) {
      return SizedBox.shrink();
    }

    final destinationData = unimasLocations[_selectedDestinationKey!]!;

    // Create a simple map for the "You are here" display
    final startLocationData = {
      'icon': 'my_location', // A custom identifier for the icon
    };

    return FadeTransition(opacity: _animationController,
      child: SlideTransition(position: Tween<Offset>(begin: Offset(0, 0.1), end: Offset.zero).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic)),
        child: Card(elevation: 8.0, shadowColor: Colors.teal[300]?.withOpacity(0.6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.0), gradient: LinearGradient(colors: [Colors.white, Colors.teal[50]!.withOpacity(0.6)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
            padding: EdgeInsets.all(20.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Row(children: <Widget>[
                Icon(Icons.route_outlined, color: Colors.teal[700], size: 26), SizedBox(width: 10),
                Text('Your Selected Route', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.teal[800]))]),
               Padding(padding: const EdgeInsets.symmetric(vertical: 10.0),

                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                    _buildRoutePointDisplay(youAreHereKey, startLocationData),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
                        child: Icon(Icons.arrow_forward_ios_rounded, size: 28, color: Colors.teal[600])),
                    _buildRoutePointDisplay(_selectedDestinationKey, destinationData)])),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildRoutePointDisplay(String? locationName, Map<String, dynamic>? locationData) {
    if (locationName == null || locationData == null) return Expanded(child: Center(child: Text("N/A", style: TextStyle(color: Colors.grey[500], fontSize: 13))));

    String? imagePath = locationData['imageAsset'] as String?;
    String iconName = locationData['icon'] as String? ?? 'location_on';

    // Special handling for the "You are here" icon
    bool isYouAreHere = locationName == youAreHereKey;
    IconData displayIcon = isYouAreHere ? Icons.my_location : _getIconData(iconName);

    double imageSize = 60.0;

    return Expanded(child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Container(width: imageSize, height: imageSize,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: Colors.teal[50]?.withOpacity(0.8),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 5, offset: Offset(0,2))]),
          child: (imagePath != null && imagePath.isNotEmpty && !isYouAreHere)
              ? ClipRRect(borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(imagePath, fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(child: Icon(displayIcon, color: Colors.teal[700], size: imageSize * 0.5))))
              : Center(child: Icon(displayIcon, color: Colors.teal[700], size: imageSize * 0.5))),
      SizedBox(height: 10),
      Text(locationName, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey[800]), maxLines: 2, overflow: TextOverflow.ellipsis),
    ]));
  }
}