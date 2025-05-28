import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CountryDetails extends StatefulWidget {
  final String countryId;
  const CountryDetails({super.key, required this.countryId});

  @override
  State<CountryDetails> createState() => _CountryDetailsState();
}

class _CountryDetailsState extends State<CountryDetails> {
  Map<String, dynamic>? countryData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Countries')
        .where('countryId', isEqualTo: widget.countryId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        countryData = querySnapshot.docs.first.data();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;

    if (countryData == null) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
    backgroundColor: Colors.indigo.shade700),
    body: Container(
          color: Colors.black,
          child: Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.indigo.shade700,
          centerTitle: true,
          title: Text(
            countryData!['name'],
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        body: Container(
          height: height,
          width: width,
          color:Colors.indigo.shade700,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: Colors.white,
                  height: 5,
                ),

                // Official Name section
                Container(
                  width: width,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      countryData!['officalName'],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.1,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 4,
                            color: Colors.blueAccent.withOpacity(0.7),
                          ),
                          Shadow(
                            offset: Offset(-1, -1),
                            blurRadius: 4,
                            color: Colors.purpleAccent.withOpacity(0.7),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                Center(
                  child: Text(
                    'National Symbols',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                 Row(
                  children: [
                    // Flag
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            countryData!['flag'] != ''
                                ? Image.network(
                              countryData!['flag'],
                              height: 120,
                              fit: BoxFit.contain,
                            )
                                : Container(
                              height: 120,
                              width: 120,
                              alignment: Alignment.center,
                              child: Icon(Icons.flag, size: 60, color: Colors.white70),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Flag',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Emblem
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            countryData!['coatOfArms'] != ''
                                ? Image.network(
                              countryData!['coatOfArms'],
                              height: 120,
                              fit: BoxFit.contain,
                            )
                                : Container(
                              height: 120,
                              width: 120,
                              alignment: Alignment.center,
                              child: Icon(Icons.shield, size: 60, color: Colors.white70),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Emblem',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Replace Expanded widgets with normal Column + SizedBox for spacing
                SizedBox(height: 50),

                // First color grid
                Container(
                  height: 0.50 * height,
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      // Row 1
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                              //  color: Colors.red,
                                border: Border.all(color: Colors.white,width: 3)
                              ),
                              height: (0.50 * height - 4 * 8) / 5,

                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.area_chart,
                                    color: Colors.white,
                                    size: 40,  // slightly smaller icon to fit better
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Continents',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              letterSpacing: 1.1,
                                              shadows: [
                                                Shadow(
                                                  offset: Offset(1, 1),
                                                  blurRadius: 2,
                                                  color: Colors.black45,
                                                ),
                                              ],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            countryData!['continents'][0].toString(),
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.5,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(width: 6),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                //  color: Colors.red,
                                  border: Border.all(color: Colors.white,width: 3)
                              ),
                              height: (0.50 * height - 4 * 8) / 5,

                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.group,
                                    color: Colors.white,
                                    size: 40,  // slightly smaller icon to fit better
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Population',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              letterSpacing: 1.1,
                                              shadows: [
                                                Shadow(
                                                  offset: Offset(1, 1),
                                                  blurRadius: 2,
                                                  color: Colors.black45,
                                                ),
                                              ],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            countryData!['population'].toString(),
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.5,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),

                      // Row 2
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                //  color: Colors.red,
                                  border: Border.all(color: Colors.white,width: 3)
                              ),
                              height: (0.50 * height - 4 * 8) / 5,

                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.terrain,
                                    color: Colors.white,
                                    size: 40,  // slightly smaller icon to fit better
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Area',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              letterSpacing: 1.1,
                                              shadows: [
                                                Shadow(
                                                  offset: Offset(1, 1),
                                                  blurRadius: 2,
                                                  color: Colors.black45,
                                                ),
                                              ],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            countryData!['area'].toString(),
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.5,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(width: 6),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                //  color: Colors.red,
                                  border: Border.all(color: Colors.white,width: 3)
                              ),
                              height: (0.50 * height - 4 * 8) / 5,

                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_city,
                                    color: Colors.white,
                                    size: 40,  // slightly smaller icon to fit better
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Capital City',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              letterSpacing: 1.1,
                                              shadows: [
                                                Shadow(
                                                  offset: Offset(1, 1),
                                                  blurRadius: 2,
                                                  color: Colors.black45,
                                                ),
                                              ],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            countryData!['capital'][0].toString(),
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.5,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                //  color: Colors.red,
                                  border: Border.all(color: Colors.white,width: 3)
                              ),
                              height: (0.50 * height - 4 * 8) / 5,

                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.currency_exchange_sharp,
                                    color: Colors.white,
                                    size: 40,  // slightly smaller icon to fit better
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text('Currency ${countryData!['currencySymbol'].toString()}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              letterSpacing: 1.1,
                                              shadows: [
                                                Shadow(
                                                  offset: Offset(1, 1),
                                                  blurRadius: 2,
                                                  color: Colors.black45,
                                                ),
                                              ],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            countryData!['currencyName'].toString(),
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 0.5,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(width: 6),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                //  color: Colors.red,
                                  border: Border.all(color: Colors.white,width: 3)
                              ),
                              height: (0.50 * height - 4 * 8) / 5,

                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.travel_explore,
                                    color: Colors.white,
                                    size: 40,  // slightly smaller icon to fit better
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Internet Code',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              letterSpacing: 1.1,
                                              shadows: [
                                                Shadow(
                                                  offset: Offset(1, 1),
                                                  blurRadius: 2,
                                                  color: Colors.black45,
                                                ),
                                              ],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            countryData!['tld'][0].toString(),
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.5,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15),

                      // Row 4
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                //  color: Colors.red,
                                  border: Border.all(color: Colors.white,width: 3)
                              ),
                              height: (0.50 * height - 4 * 8) / 5,

                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.map,
                                    color: Colors.white,
                                    size: 40,  // slightly smaller icon to fit better
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Region',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              letterSpacing: 1.1,
                                              shadows: [
                                                Shadow(
                                                  offset: Offset(1, 1),
                                                  blurRadius: 2,
                                                  color: Colors.black45,
                                                ),
                                              ],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            countryData!['region'].toString(),
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.5,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(width: 6),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                //  color: Colors.red,
                                  border: Border.all(color: Colors.white,width: 3)
                              ),
                              height: (0.50 * height - 4 * 8) / 5,

                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.timelapse,
                                    color: Colors.white,
                                    size: 40,  // slightly smaller icon to fit better
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Time Zone',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              letterSpacing: 1.1,
                                              shadows: [
                                                Shadow(
                                                  offset: Offset(1, 1),
                                                  blurRadius: 2,
                                                  color: Colors.black45,
                                                ),
                                              ],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            countryData!['timezones'].toString(),
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.5,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),

                    ],
                  ),
                ),
             Center(
               child: FloatingActionButton.extended(
                onPressed: () async {
                  if (countryData != null && countryData!['map'] != null) {
                    final url = Uri.parse(countryData!['map'].toString());
                    try {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } catch (e) {
                      print('Could not launch $url: $e');
                    }
                  }
                },
                icon: Icon(Icons.place_rounded, color: Colors.white),
                label: Text('Open Map', style: TextStyle(color: Colors.white)),
                 backgroundColor: Colors.black,
                           ),
             ),
                        ],
            ),
          ),
        ),
      );
    }
  }
}
