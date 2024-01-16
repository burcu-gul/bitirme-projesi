// ignore_for_file: file_names

import 'package:bitirme_projesi/screens/gpt.dart';
import 'package:bitirme_projesi/screens/profil_page.dart';
import 'package:bitirme_projesi/services/firebase_services.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/material.dart';
import 'package:bitirme_projesi/screens/gunluk_page.dart';
import 'package:bitirme_projesi/screens/premium_page.dart';
import 'package:lottie/lottie.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool isPremium = false;
  final user = FirebaseAuth.instance.currentUser;
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Ana Sayfa'),
    Text('Profil'),
    Text('Günlük'),
    Text('Gpt'),
    Text('Premium'),
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilPage(),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GunlukPage(),
        ),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Gpt(),
        ),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PremiumPage(),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  _onLoad() async {
    try {
      FirebaseServices firebase = FirebaseServices();
      final existingUser =
          await firebase.users.where("email", isEqualTo: user?.email).get();
      if (existingUser.docs[0]['plan'] == "premium") {
        setState(() {
          isPremium = true;
        });
      }
    } catch (e) {}
  }

  @override
  void initState() {
    _onLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ana Sayfa'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white70,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Uygulamamıza Hoş Geldiniz 😊',
              style: TextStyle(
                color: Colors.deepPurpleAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Lottie.asset(
              'assets/animations/anasayfa.json',
              width: 180,
              height: 230,
              fit: BoxFit.cover,
              animate: true,
            ),
          ),
          _widgetOptions.elementAt(_selectedIndex),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Günlük',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: 'Gpt',
          ),
          if (!isPremium)
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Premium',
            ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
