import 'dart:developer';

import 'package:beamer/beamer.dart';
import 'package:bottom_navigation_2/article_location.dart';
import 'package:bottom_navigation_2/books_location.dart';
import 'package:bottom_navigation_2/home_location.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// boolean state provider to trigger rebuild of root widget.
final booleanStateProvider = StateProvider<bool>((ref) {
  return true;
});

final routerDelegate = BeamerDelegate(
  locationBuilder: BeamerLocationBuilder(
    beamLocations: [
      HomeLocation(),
    ],
  ),
);

final beamerDelegates = [
  BeamerDelegate(
    locationBuilder: (_, __) => BooksLocation(),
  ),
  BeamerDelegate(
    locationBuilder: (_, __) => ArticlesLocation(),
  ),
];

// DATA
const List<Map<String, String>> books = [
  {
    'id': '1',
    'title': 'Stranger in a Strange Land',
    'author': 'Robert A. Heinlein',
  },
  {
    'id': '2',
    'title': 'Foundation',
    'author': 'Isaac Asimov',
  },
  {
    'id': '3',
    'title': 'Fahrenheit 451',
    'author': 'Ray Bradbury',
  },
];

const List<Map<String, String>> articles = [
  {
    'id': '1',
    'title': "Learning Flutter’s new navigation and routing system",
    'author': 'John Ryan',
  },
  {
    'id': '2',
    'title': 'Explaining Flutter Nav 2.0 and Beamer',
    'author': 'Toby Lewis',
  },
];

// SCREENS
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.initialIndex}) : super(key: key);

  final int initialIndex;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: beamerDelegates.map((delegate) => Beamer(routerDelegate: delegate)).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(label: 'Books', icon: Icon(Icons.book)),
          BottomNavigationBarItem(label: 'Articles', icon: Icon(Icons.article)),
        ],
        onTap: (index) {
          beamerDelegates[index].update(rebuild: false, replaceRouteInformation: true);
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}

class BooksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books'),
      ),
      body: ListView(
        children: books
            .map(
              (book) => ListTile(
                title: Text(book['title']!),
                subtitle: Text(book['author']!),
                onTap: () => context.beamToNamed('/books/${book['id']}'),
              ),
            )
            .toList(),
      ),
    );
  }
}

class BookDetailsScreen extends HookConsumerWidget {
  const BookDetailsScreen({required this.book});
  final Map<String, String> book;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book['title']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Author: ${book['author']!}'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text(ref.read(booleanStateProvider).toString()),
        onPressed: () {
          ref.read(booleanStateProvider.state).state = !ref.read(booleanStateProvider);
        },
      ),
    );
  }
}

class ArticlesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Articles')),
      body: ListView(
        children: articles
            .map(
              (article) => ListTile(
                title: Text(article['title']!),
                subtitle: Text(article['author']!),
                onTap: () => context.beamToNamed('/articles/${article['id']}'),
              ),
            )
            .toList(),
      ),
    );
  }
}

class ArticleDetailsScreen extends HookConsumerWidget {
  const ArticleDetailsScreen({required this.article});
  final Map<String, String> article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article['title']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Author: ${article['author']!}'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text(ref.read(booleanStateProvider).toString()),
        onPressed: () {
          ref.read(booleanStateProvider.state).state = !ref.read(booleanStateProvider);
        },
      ),
    );
  }
}

// APP
class MyApp extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(booleanStateProvider);
    log("BUILDING HOME");
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: routerDelegate,
      routeInformationParser: BeamerParser(),
      backButtonDispatcher: BeamerBackButtonDispatcher(
        delegate: routerDelegate,
      ),
    );
  }
}

void main() => runApp(ProviderScope(child: MyApp()));
