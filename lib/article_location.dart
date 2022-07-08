import 'dart:developer';

import 'package:beamer/beamer.dart';
import 'package:bottom_navigation_2/main.dart';
import 'package:flutter/material.dart';

class ArticlesLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => [
        'articles/:articleId',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    log("URI ARTICLES LOCATION: ${state.uri.path}");
    final List<BeamPage> pageStack = [];
    pageStack.add(
      BeamPage(
        key: ValueKey('articlescreen'),
        child: ArticlesScreen(),
      ),
    );
    if (state.uri.pathSegments.contains('articles') && state.pathParameters.containsKey('articleId')) {
      final articleId = state.pathParameters['articleId'];
      final article = articles.firstWhere((article) => article['id'] == articleId);

      pageStack.add(
        BeamPage(
          key: ValueKey('articles-$articleId'),
          title: article['title'],
          child: ArticleDetailsScreen(article: article),
        ),
      );
    }

    return pageStack;
  }
}
