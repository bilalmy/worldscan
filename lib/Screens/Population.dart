import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:world_scan/Screens/CountryDetails.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Population extends StatefulWidget {
  @override
  State<Population> createState() => PopulationState();
}

class PopulationState extends State<Population> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isOffline = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkInternet();
  }

  void checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isOffline = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isOffline) {
      return Scaffold(
        body: Center(
          child: Text(
            "⚠️ No Internet Connection",
            style: TextStyle(fontSize: 20, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Population Ranking",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        backgroundColor: Colors.indigo.shade700,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [

            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Countries').orderBy('population',descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No data found'));
                  }
                  var countries = snapshot.data?.docs;

                  return ListView.builder(
                    itemCount: countries?.length,
                    itemBuilder: (context, index) {
                      var country = countries?[index];

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CountryDetails(countryId: country?['countryId']),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.black,
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 16),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min, // Make Row take minimal space
                                    children: [
                                      CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Colors.white,
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          country?['flag'] ?? '',
                                          width: 50,
                                          height: 40,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            width: 50,
                                            height: 40,
                                            color: Colors.grey,
                                            child: Icon(Icons.flag, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                ),
                                title: Text(
                                  country?['name'] ?? 'No name',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  country?['population'].toString()??'000000',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 5,
                                color: Colors.white70,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
