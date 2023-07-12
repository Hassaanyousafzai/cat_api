import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Button Stuff
  int randomNumber() {
    Random random = Random();
    return random.nextInt(catList.length);
  }

  int num = 0;

  // API STUFF
  List<String> catList = [];
  Future getFact() async {
    final response = await https.get(
      Uri.parse('https://cat-fact.herokuapp.com/facts'),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      catList.clear();

      for (var fact in data) {
        catList.add(fact["text"]);
      }
    } else {
      print('Failed to fetch cat facts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.android,
              size: 27,
            ),
            SizedBox(
              width: 20,
            ),
            Text("Cats Data using API"),
          ],
        ),
        elevation: 5,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
          ),
          const Center(
            child: Text(
              "Catto Fact?",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: FutureBuilder(
                future: getFact(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 10),
                          child: Text(
                            catList[num], // Cat Facts
                            style: const TextStyle(fontSize: 20),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 150.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    num = randomNumber();
                  });
                },
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    // border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "Click for a Fact :D",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
