import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import "dart:math";
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

import 'package:quotesapp/favourite.dart';
import 'package:share_plus/share_plus.dart';

class quotespage extends StatefulWidget {
  const quotespage({super.key});

  @override
  State<quotespage> createState() => _quotespageState();
}

class _quotespageState extends State<quotespage> {
  List<String> quotecats = [
    "friendship",
    "books",
    "truth",
    "reading",
    "love",
    "inspirational",
    "life",
    "humor",
    "friends",
    "truth"
  ];
  List quotes = [];
  List author = [];
  bool isdata = false;
  @override
  void initState() {
    super.initState();
    quotesget();
  }

  void shareQuote(String quote, String author) {
    Share.share('$quote - $author');
  }

  static Set<String> favourite = {};

  void saveToFavourites(String quote, String author) {
    setState(() {
      favourite.add('$quote - $author');
    });
  }

  quotesget() async {
    late Random random = new Random();
    late int randno = random.nextInt(quotecats.length);
    String url = "https://quotes.toscrape.com/tag/${quotecats[randno]}/";
    Uri uri = Uri.parse(url);
    http.Response response = await http.get(uri);
    dom.Document document = parser.parse(response.body);
    final quotesclass = document.getElementsByClassName("quote");
    for (int i = 0; i < quotesclass.length; i++) {
      quotes.add(quotesclass[i].getElementsByClassName("text")[0].innerHtml);
    }
    for (int i = 0; i < quotesclass.length; i++) {
      author.add(quotesclass[i].getElementsByClassName("author")[0].innerHtml);
    }
    setState(() {
      isdata = true;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quotes app"), actions: [
        IconButton(
          onPressed: () async {
            setState(() {
              quotes.clear();
              author.clear();
              isdata = false;
            });
            await quotesget();
          },
          icon: Icon(Icons.replay_outlined),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        FavouritesScreen(favouriteQuotes: favourite)));
          },
          icon: Icon(Icons.favorite),
        )
      ]),
      body: isdata == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: quotes.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(12),
                  child: Card(
                      elevation: 10,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(quotes[index],
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: 5.0, left: 16, right: 16),
                            child: Text(author[index]),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(Icons.share),
                                onPressed: () async {
                                  await Share.share(
                                      '${quotes[index]} - ${author[index]}');
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.favorite_border),
                                onPressed: () {
                                  saveToFavourites(
                                      quotes[index], author[index]);
                                },
                              ),
                            ],
                          ),
                        ],
                      )),
                );
              }),
    );
  }
}
