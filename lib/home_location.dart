import 'dart:developer';

import 'package:beamer/beamer.dart';
import 'package:bottom_navigation_2/main.dart';
import 'package:flutter/material.dart';

class HomeLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => [
        '/',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    log("URI HOME LOCATION: ${state.uri.path}");

    final initialIndex = state.queryParameters['tab'] == 'articles' ? 1 : 0;

    final List<BeamPage> pageStack = [];
    pageStack.add(
      BeamPage(
        key: ValueKey('homescreen'),
        child: HomeScreen(initialIndex: initialIndex),
      ),
    );

    return pageStack;
  }
}
