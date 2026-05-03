import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../social/screens/feed_screen.dart';
import '../connection/screens/matches_screen.dart';
import '../connection/screens/chat_list_screen.dart';
import '../connection/screens/events_screen.dart';
import '../social/screens/profile_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final List<Widget> screens = [
    FeedScreen(),
    MatchesScreen(),
    ChatListScreen(currentUserId: FirebaseAuth.instance.currentUser?.uid ?? ''),
    EventsScreen(),
    ProfileScreen(),
  ];
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    //  Prevent crash if user is null
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    final List<Widget> screens = [
      const FeedScreen(),
      const MatchesScreen(),
      ChatListScreen(currentUserId: user!.uid),
      EventsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        child: screens[_currentIndex],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dynamic_feed),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}