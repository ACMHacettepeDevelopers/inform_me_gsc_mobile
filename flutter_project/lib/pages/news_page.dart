// HOME PAGE
import 'package:flutter/material.dart';
import 'package:loginpage/pages/categories.dart';

import '../podcast_properties.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Tabbar(
          onCategorySelected: (category) =>
              handleCategorySelection(category)), // Include the Tabbar widget
    );
  }

  void handleCategorySelection(String category) async {
    print('Selected category in HomePage: $category');
    PodcastProperties.query = category.toLowerCase();
  }
}
