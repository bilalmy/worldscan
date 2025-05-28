import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:world_scan/Screens/About.dart';
import 'package:world_scan/Screens/Area.dart';
import 'package:world_scan/Screens/CountryDetails.dart';
import 'package:world_scan/Screens/LoginScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:world_scan/Screens/Population.dart';

import '../UserAuthentication/AuthUser.dart';



class UserHome extends StatefulWidget{
  @override
  State<UserHome> createState() => _UserHomeState();
}


class _UserHomeState extends State<UserHome> {


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthUser _authUser=AuthUser();
  bool isOffline = false;
  bool filter=false;
 TextEditingController searchController=TextEditingController();
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
      key: _scaffoldKey,

      appBar: AppBar(
        title: const Center(
          child: Text(
            "Countries",
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
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Icon(Icons.menu, color: Colors.white, size: 30),
        ),
      ),

      // ✅ Custom Full-Height Drawer
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          child: Column(
            children: [
              Container(
                color: Colors.black,
                padding: EdgeInsets.symmetric(vertical:80),
                width: double.infinity,
                child: Column(
                  children: [
                    Icon(Icons.public, size: 60, color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      'WorldScan',
                      style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // ✅ 5 Colored Rows
              Expanded(
                child: Column(
                  children: [
                    InkWell(
                      onTap: ()
                      {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserHome(),));
                      },
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(16),
                          width: double.infinity,
                          child:ListTile(
                            leading: Icon(Icons.home,size: 20,color:Colors.indigo.shade700,),
                            title: Text(
                              'Home',
                              style: TextStyle(color: Colors.indigo.shade700,fontWeight: FontWeight.w600),
                            ),
                          )
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 1,
                    ),
                    InkWell(
                      onTap: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Population(),));
                      },
                      child: Center(
                        child: Container(
                            padding: EdgeInsets.all(16),
                            width: double.infinity,
                            child:ListTile(
                              leading: Icon(Icons.auto_graph,size: 20,color:Colors.indigo.shade700),
                              title: Text(
                                'Population Ranking',
                                style: TextStyle(color: Colors.indigo.shade700,fontWeight: FontWeight.w600),
                              ),
                            )
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 1,
                    ),
                    InkWell(
                      onTap: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Area(),));
                      },
                      child: Center(
                        child: Container(
                            padding: EdgeInsets.all(16),
                            width: double.infinity,
                            child:ListTile(
                              leading: Icon(Icons.area_chart,size: 20,color:Colors.indigo.shade700),
                              title: Text(
                                'Area Ranking',
                                style: TextStyle(color: Colors.indigo.shade700,fontWeight: FontWeight.w600),
                              ),
                            )
                        ),
                      ),
                    ),
    Divider(
      color: Colors.grey,
      height: 1,
    ),
                    InkWell(
                      onTap: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => About(),));
                      },
                      child: Center(
                        child: Container(
                            padding: EdgeInsets.all(16),
                            width: double.infinity,
                            child:ListTile(
                              leading: Icon(Icons.info,size: 20,color:Colors.indigo.shade700,),
                              title: Text(
                                'About Us',
                                style: TextStyle(color: Colors.indigo.shade700,fontWeight: FontWeight.w600),
                              ),
                            )
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 1,
                    ),

                    InkWell(
                      onTap: ()
                      {
                        _authUser.logout();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                      },
                      child: Center(
                        child: Container(
                            padding: EdgeInsets.all(16),
                            width: double.infinity,
                            child:ListTile(
                              leading: Icon(Icons.logout,size: 20,color:Colors.indigo.shade700,),
                              title: Text(
                                'Logout',
                                style: TextStyle(color: Colors.indigo.shade700,fontWeight: FontWeight.w600),
                              ),
                            )
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Search Field (Small)
                  Expanded(
                    child: SizedBox(
                      height: 35,  // set your desired height here
                      child: TextField(
                        controller: searchController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          hintText: 'Enter country name',
                          hintStyle: TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),


                  SizedBox(width: 10),

                  // Search Button
                  SizedBox(
                    height: 35,   // Set height here
                    child: ElevatedButton(
                      onPressed: () {
                        if (searchController.text == '') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Please Enter Country Name",
                                      style: TextStyle(fontSize: 16, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: Colors.green[600],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              duration: Duration(seconds: 3),
                              elevation: 8,
                            ),
                          );
                          return;
                        } else {
                          setState(() {
                            filter = true;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade700,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0), // vertical padding 0 to fit height 35
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        minimumSize: Size(0, 35),  // ensures button is at least height 35
                      ),
                      child: Icon(Icons.search, color: Colors.white, size: 20), // smaller icon to fit height
                    ),
                  ),

                ],
              ),
            ),

            if (filter==false)
            // Show list or message
          StreamBuilder(stream: FirebaseFirestore.instance.collection('Countries').snapshots(),
              builder: (context, snapshot)
              {
            if(snapshot.connectionState==ConnectionState.waiting)
              {
                return Center(child: CircularProgressIndicator());
              }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No data found'));
            }
            var countries=snapshot.data?.docs;

            return Expanded(
              child: ListView.builder(itemCount: countries?.length,itemBuilder: (context, index){
                var country=countries?[index];

                return InkWell(
                  onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context) => CountryDetails(countryId: country?['countryId']),));
                    },
                  child: Card(
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
                              country?['flag'],
                              width: 50,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            country?['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            country?['region'] ?? 'Unknown region',
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
              },),
            );
              },)

            else
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Countries')
                    .where('lower', isGreaterThanOrEqualTo: searchController.text.trim().toLowerCase())
                    .where('lower', isLessThan: searchController.text.trim().toLowerCase() + 'z')
                    .snapshots(),
                builder: (context, snapshot)
                {
                  if(snapshot.connectionState==ConnectionState.waiting)
                  {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('❌ No country found'),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          duration: Duration(seconds: 2),
                        ),
                      );

                      // Reset the filter safely
                      if (mounted) {
                        setState(() {
                          searchController.text='';
                          filter = false;
                        });
                      }
                    });

                    // Return an empty widget to avoid build error
                    return SizedBox.shrink();
                  }


                  var countries=snapshot.data?.docs;

                  return Expanded(
                    child: ListView.builder(itemCount: countries?.length,itemBuilder: (context, index){
                      var country=countries?[index];

                      return InkWell(
                        onTap: ()
                        {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CountryDetails(countryId: country?['countryId']),));
                        },
                        child: Card(
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
                                    country?['flag'],
                                    width: 50,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  country?['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  country?['region'] ?? 'Unknown region',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                trailing: IconButton(
                                  onPressed: (){
                                  setState(() {
                                    searchController.text='';
                                    filter=false;
                                  });
                                  },
                                  icon: Icon(Icons.close,color: Colors.red,
                                  size: 20
                                    ,),
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
                    },),
                  );
               },

              )


          ],
        ),
      ),


    );
  }
}

