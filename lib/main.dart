import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:quotesapp/quotes_page.dart';

void main() async {
  await Hive.initFlutter();
  var box = Hive.openBox("qbox");
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromARGB(0, 144, 21, 21))),
      home: quotespage(),
    );
  }
}
