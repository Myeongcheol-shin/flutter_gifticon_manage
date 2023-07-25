import 'package:flutter/material.dart';
import 'package:flutter_gifticon_box/data/card.dart';
import 'package:flutter_gifticon_box/ui_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void deleteItem(int idx) {
    setState(() {
      items.removeAt(idx);
    });
  }

  List<dynamic> items = [
    Cards("Starbucks", "30000원 쿠폰", Colors.blue, true, null),
    Cards("Vips", "20000원 쿠폰", Colors.amber, false, null)
  ];
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: () {
              showAddDialog(context);
            },
          );
        }),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(
                height: 120,
              ),
              Text(
                "You Have ${items.length} Coupon",
                style: const TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return GestureDetector(
                      onLongPress: () {
                        showDeleteDialog(context, index, item.color);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: CardView(
                          name: item.name,
                          color: item.color,
                          info: item.info,
                          hasImage: item.hasImage,
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showAddDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            title: const Text(
              'ADD Coupon',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.black),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange[200]),
                child: const Text(
                  "Cancle",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange[200]),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  onPressed: () => {Navigator.pop(context)}),
              const SizedBox(
                width: 5,
              )
            ],
          );
        });
  }

  Future<void> showDeleteDialog(
      BuildContext context, int idx, Color color) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(color: color.withOpacity(0.5), width: 5.0),
            ),
            title: const Text(
              'Delete This Coupon?',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.black),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: color.withOpacity(0.8)),
                child: const Text(
                  "Cancle",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: color.withOpacity(0.8)),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  onPressed: () => {deleteItem(idx), Navigator.pop(context)}),
              const SizedBox(
                width: 5,
              )
            ],
          );
        });
  }
}
