import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gifticon_box/data/db.dart';
import 'package:flutter_gifticon_box/data/db_card.dart';
import 'package:flutter_gifticon_box/ui_card.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      DatabaseHelper.instance.remove(idx);
      dataList = DatabaseHelper.instance.getDbCard();
    });
  }

  File? _image;

  Future getImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      }
    });
  }

  void deletePhoto() {
    setState(() {
      _image = null;
    });
  }

  Color getRandomColor() {
    Random random = Random();
    int r = random.nextInt(256);
    int g = random.nextInt(256);
    int b = random.nextInt(256);
    return Color.fromARGB(255, r, g, b);
  }

  void updateDbList() {
    setState(() {
      dataList = DatabaseHelper.instance.getDbCard();
    });
  }

  late Future<List<DbCard>> dataList;

  @override
  void initState() {
    super.initState();
    dataList = DatabaseHelper.instance.getDbCard();
  }

  final _companyCtl = TextEditingController();
  final _infoCtl = TextEditingController();
  final _couponCtl = TextEditingController();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: dataList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('Loading..'),
            );
          }
          return Scaffold(
            floatingActionButton: Builder(builder: (context) {
              return FloatingActionButton(
                  onPressed: () {
                    _image = null;
                    showAddDialog(context);
                  },
                  child: const Icon(
                    Icons.add,
                    size: 50,
                  ));
            }),
            body: Container(
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(
                    height: 120,
                  ),
                  Text(
                    "You Have ${snapshot.data!.length} Coupon",
                    style: const TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Colors.black),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final item = snapshot.data![index];

                        return GestureDetector(
                          onLongPress: () {
                            showDeleteDialog(context, item.id!,
                                Color(snapshot.data![index].color));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: CardView(
                                couponNumber: item.couponNumber == ""
                                    ? null
                                    : item.couponNumber,
                                name: item.name,
                                color: Color(item.color),
                                info: item.info,
                                image: item.file != null ? item.file! : null),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
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
              'Add Coupon',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.black),
            ),
            content: Column(children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text(
                    "Company",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 15),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _companyCtl,
                      decoration: const InputDecoration(
                          alignLabelWithHint: true,
                          hintStyle: TextStyle(fontSize: 15),
                          hintText: "Input Company"),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const Text(
                    "Info",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 15),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _infoCtl,
                      decoration: const InputDecoration(
                          alignLabelWithHint: true,
                          hintStyle: TextStyle(fontSize: 15),
                          hintText: "Input Info"),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const Text(
                    "Coupon Number",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 15),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _couponCtl,
                      decoration: const InputDecoration(
                          alignLabelWithHint: true,
                          hintStyle: TextStyle(fontSize: 15),
                          hintText: "Input Coupon Number"),
                    ),
                  )
                ],
              ),
              _image == null
                  ? const SizedBox()
                  : Expanded(child: Image.file(_image!)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _image != null
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[600]),
                          child: const Text(
                            "Delete Photo",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          onPressed: () => {deletePhoto()},
                        )
                      : const SizedBox(),
                ],
              )
            ]),
            actions: <Widget>[
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.grey[500]),
                child: const Text(
                  "Select Photo",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                onPressed: () => {getImageFromGallery()},
              ),
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
                  onPressed: () => {
                        if (_companyCtl.text != "" && _infoCtl.text != "")
                          {
                            setState(() {
                              DatabaseHelper.instance.add(DbCard(
                                  name: _companyCtl.text,
                                  info: _infoCtl.text,
                                  color: getRandomColor().value,
                                  file: _image == null ? null : _image!.path,
                                  couponNumber: _couponCtl.text));

                              updateDbList();
                            })
                          },
                        Navigator.pop(context)
                      }),
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
