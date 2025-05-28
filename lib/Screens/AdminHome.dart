import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:world_scan/Screens/LoginScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});
  @override
  State<AdminHome> createState() => _AdminHomeState();
}
List<Map<String?,dynamic>> fetchedcountries=[];

class _AdminHomeState extends State<AdminHome> {
  bool isOffline = false;

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


  bool isloading=false;

  Future<void> fetchDataFromApi() async{

final response = await http.get(Uri.parse("https://restcountries.com/v3.1/all"));

if(response.statusCode==200)
  {
    final List data=await jsonDecode(response.body);

    setState(() {
      fetchedcountries = data.map<Map<String,dynamic>>((country) {
        final currencies = country['currencies'];
        final firstCurrency = (currencies != null && currencies is Map && currencies.isNotEmpty)
            ? currencies.entries.first.value
            : null;

        return {
          'name':(country['name']['common']??'N/A'),
          'coatOfArms':country['coatOfArms']['png']??'',
          'lower': (country['name']['common'] ?? 'N/A').toLowerCase(),
          'officalName':country['name']['official']??'N/A',
          'currencyName': firstCurrency?['name'] ?? 'Unknown',
          'currencySymbol': firstCurrency?['symbol'] ?? '',
          'capital':country['capital']??'N/A',
          'flag':country['flags']['png']??'',
          'region':country['region']??'N/A',
          'subregion':country['subregion']??'N/A',
          'area':country['area']??'N/A',
          'map':country['maps']['googleMaps']??'',
          'population':country['population']??'N/A',
          'timezones':country['timezones']??'N/A',
          'continents':country['continents']??'N/A',
          'countryId':country['ccn3']??country['name']['common']??'Unknown Id',
          'countryCode':country['cca2']??'N/A',
          'tld':country['tld']??'N/A',
        };
      }).toList();
    });
  }

  }

  Future<String?> UploadData() async {
    setState(() {
      isloading=true;
    });

    try {
      for (var listOfCountry in fetchedcountries) {
        await FirebaseFirestore.instance.collection('Countries').doc(listOfCountry['countryId']).set({
          'countryId':listOfCountry['countryId'],
          'name': listOfCountry['name'],
          'officalName': listOfCountry['officalName'],
          'currencyName': listOfCountry['currencyName'],
          'currencySymbol': listOfCountry['currencySymbol'],
          'capital': listOfCountry['capital'],
          'flag': listOfCountry['flag'],
          'region': listOfCountry['region'],
          'subregion': listOfCountry['subregion'],
          'area': listOfCountry['area'],
          'map': listOfCountry['map'],
          'population': listOfCountry['population'],
          'timezones': listOfCountry['timezones'],
          'continents': listOfCountry['continents'],
          'lower': listOfCountry['lower'],
          'coatOfArms':listOfCountry['coatOfArms'],
          'countryCode':listOfCountry['cca2'],
          'tld':listOfCountry['tld'],
        });
      }
      setState(() {
        isloading=false;
      });
      return 'Data uploaded successfully';
    } catch (e) {
      setState(() {
        isloading=false;
      });
      return 'Error uploading data: $e';
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
            "Admin DashBoard",
            style: TextStyle(color: Colors.white,           // clean and readable
              fontSize: 22,                  // slightly larger
              fontWeight: FontWeight.bold,   // bold for impact
              letterSpacing: 1.2,            // slight spacing
            ),
          ),
        ),
        backgroundColor: Colors.indigo.shade700,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 30)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: Icon(Icons.logout, color: Colors.white, size: 30)),
        ],
      ),


      body: Container(
        color: Colors.black,
        child: fetchedcountries.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (await Connectivity().checkConnectivity()==ConnectivityResult.none)
                    {ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                  content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(
                  child: Text(
                  "Check Your Internet Connection",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                  ),
                  ),
                  ],
                  ),
                  backgroundColor: Colors.green[600], // You can use other colors like Colors.blue, etc.
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  ),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  duration: Duration(seconds: 3),
                  elevation: 8,
                  ),
                    );
                  return ;
                        }

                  await fetchDataFromApi();
                  print(fetchedcountries[150]['tld'][0]);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  'Fetch Data From API',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        )
            : Column(
      children: [
      // 🔵 Upload Button
      Container(
      alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: isloading ? CircularProgressIndicator() :
        ElevatedButton.icon(
          onPressed:() async{
           String? result = await UploadData();
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Icon(Icons.check_circle, color: Colors.white),
                   SizedBox(width: 8),
                   Expanded(
                     child: Text(
                       '$result',
                       style: TextStyle(fontSize: 16, color: Colors.white),
                       textAlign: TextAlign.center,
                     ),
                   ),
                 ],
               ),
               backgroundColor: Colors.green[600], // You can use other colors like Colors.blue, etc.
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(12),
               ),
               behavior: SnackBarBehavior.floating,
               margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
               duration: Duration(seconds: 3),
               elevation: 8,
             ),
           );
           fetchedcountries.clear();
          },
          icon: Icon(Icons.upload_file,color: Colors.white,),
          label: Text("Upload"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),

      // 🔶 List of cards
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          itemCount: fetchedcountries.length,
          itemBuilder: (context, index) {
            final country = fetchedcountries[index];

            return Card(
              color: Colors.black,
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        country['flag'],
                        width: 50,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      country['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      country['region'] ?? 'Unknown region',
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
