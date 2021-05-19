import 'package:flutter/material.dart';
import 'package:epub_view/epub_view.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Uint8List> _loadFromAssets(String assetName) async {
    final bytes = await rootBundle.load(assetName);
    return bytes.buffer.asUint8List();
  }

  EpubController _epubController;


  @override
  void initState() {
    _epubController = EpubController(
      // Load document
      document: EpubReader.readBook(_loadFromAssets('assets/bible.epub')),
      // Set start point
      epubCfi: 'epubcfi(/6/6[chapter-2]!/4/2/1612)',
    );
    super.initState();
  }


  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      // Show actual chapter name
      title: EpubActualChapter(
        controller: _epubController,
        builder: (chapterValue) => Text(
          'Chapter ${chapterValue.chapter ?? ''}',
          textAlign: TextAlign.start,
        ),
      ),
    ),
    // Show table of contents
    drawer: Drawer(
      child: EpubReaderTableOfContents(
        controller: _epubController,
      ),
    ),
    // Show epub document
    body: EpubView(
      controller: _epubController,
    ),
  );
}
