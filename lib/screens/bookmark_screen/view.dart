import 'package:flutter/material.dart';
import 'package:renergy_app/components/components.dart';

class BookmarkScreenView extends StatelessWidget {
  const BookmarkScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: const Center(
        child: Text('Bookmark Screen'),
      ),
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: 2,
      ),
    );
  }
}
