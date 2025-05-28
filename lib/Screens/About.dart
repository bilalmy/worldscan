import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class About extends StatefulWidget {
  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  String version = 'Loading...';
  String information = 'Loading...';

  @override
  void initState() {
    super.initState();
    fetchAboutData();
  }

  void fetchAboutData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('AboutMe')
          .doc('about')
          .get();

      if (doc.exists) {
        setState(() {
          version = doc.data()?['version'] ?? 'N/A';
          information = doc.data()?['information'] ?? 'No information found.';
        });
      } else {
        setState(() {
          version = 'N/A';
          information = 'No information found.';
        });
      }
    } catch (e) {
      setState(() {
        version = 'Error loading version';
        information = 'Error loading information';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,  // light black background
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade700,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('About', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),

            // Your circular world icon
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.indigo.shade700,
              child: Icon(
                Icons.public,  // world icon
                size: 50,
                color: Colors.white,
              ),
            ),

            SizedBox(height: 20),

            // World Scan text
            Text(
              'WORLD SCAN',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),

            SizedBox(height: 8),

            Text(
              'Version $version',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),

            SizedBox(height: 30),

            // Information paragraph from Firestore
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  information,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    height: 1.8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
