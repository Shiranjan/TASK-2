import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:share_plus/share_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class FavouritesScreen extends StatefulWidget {
  final Set<String> favouriteQuotes;
  FavouritesScreen({Key? key, required this.favouriteQuotes}) : super(key: key);

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final qbox = Hive.box("qbox");
  @override
  void initState() {
    if (qbox.get(1) != null) {
      qbox.get(1);
    } else {
      qbox.put(1, widget.favouriteQuotes);
    }
    // TODO: implement initState
    super.initState();
  }

  void shareQuote(String quote, String author) {
    Share.share('$quote - $author');
  }

  void removeFromFavorites(int index) {
    setState(() {
      widget.favouriteQuotes.remove(widget.favouriteQuotes.toList()[index]);
      qbox.delete(1);
      qbox.put(1, widget.favouriteQuotes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite Quotes'),
      ),
      body: ListView.builder(
        itemCount: widget.favouriteQuotes.length,
        itemBuilder: (context, index) {
          return ListTile(
              title: Text(widget.favouriteQuotes.toList()[index]),
              trailing: IconButton(
                icon: Icon(Icons.disabled_by_default_rounded),
                onPressed: () {
                  removeFromFavorites(index);
                },
              ));
        },
      ),
    );
  }
}
