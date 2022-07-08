import 'dart:developer';

import 'package:beamer/beamer.dart';
import 'package:bottom_navigation_2/main.dart';
import 'package:flutter/material.dart';

class BooksLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => [
        '/books/:bookId',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    log("URI BOOK LOCATION: ${state.uri.path}");

    final List<BeamPage> pageStack = [];
    pageStack.add(
      BeamPage(
        key: ValueKey('bookscreen'),
        child: BooksScreen(),
      ),
    );
    if (state.uri.pathSegments.contains('books') && state.pathParameters.containsKey('bookId')) {
      final bookId = state.pathParameters['bookId'];
      final book = books.firstWhere((book) => book['id'] == bookId);

      pageStack.add(
        BeamPage(
          key: ValueKey('book-$bookId'),
          title: book['title'],
          child: BookDetailsScreen(book: book),
        ),
      );
    }

    return pageStack;
  }
}
