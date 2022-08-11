import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swinglam/views/activities/page/activities_page.dart';
import 'package:swinglam/views/post/pages/post_page.dart';
import 'package:swinglam/views/profile/pages/profile_page.dart';
import 'package:swinglam/views/search/pages/search_page.dart';

import 'feed/pages/feed_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> _pages = [];
  int _currentIndex = 0;

  @override
  void initState() {
    _pages = [
      FeedPage(),
      SearchPage(),
      PostPage(),
      ActivitiesPage(),
      ProfilePage(),
    ];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState((){
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.house),
            label: ("")
          ),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
              label: ("")
          ),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.squarePlus),
              label: ("")
          ),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.heart),
              label: ("")
          ),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.user),
              label: ("")
          ),

        ],
      ),
    );
  }
}
