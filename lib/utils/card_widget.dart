import 'package:bikeapp_v0/model/bike_model.dart';
import 'package:bikeapp_v0/screens/reservation/bikedetails_screen.dart';
import 'package:bikeapp_v0/utils/config.dart';
import 'package:bikeapp_v0/utils/next_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardWidget extends StatelessWidget {
  Stream stream;
  CardWidget({Key? key, required this.stream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _darkMode =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: StreamBuilder(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text("Something was wrong");
          } else if (snapshot.hasData) {
            List bikes = snapshot.data as List<Map<String, dynamic>>;
            return GridView.builder(
              itemCount: bikes.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                return Stack(//alignment: AlignmentDirectional.center,
                    children: <Widget>[
                  GestureDetector(
                    onTap: () => nextScreen(
                        context,
                        BikeDetailsScreen(
                            bike: BikeModel.fromMap(bikes[index]))),
                    child: Card(
                      // shadowColor: Colors.black,
                      color: Provider.of<ThemeProvider>(context).themeMode ==
                              ThemeMode.dark
                          ? Theme.of(context).primaryIconTheme.color
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          children: [
                            // const SizedBox(
                            //   height: 6,
                            // ),
                            Hero(
                              tag: bikes[index]['bid'],
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 110,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30)),
                                  image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      image: AssetImage(bikes[index]['image'])),

                                  // child: Image.network(
                                  //   bikes[index]['image'],
                                  //   width: 155,
                                  //   height: 110,
                                  //   fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Text(
                              "${bikes[index]['brand']}",
                              style: TextStyle(
                                  color: _darkMode
                                      ? Theme.of(context)
                                          .scaffoldBackgroundColor
                                      : Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text("${bikes[index]['speed']} Km/h",
                                style: TextStyle(
                                  color: _darkMode
                                      ? Theme.of(context)
                                          .scaffoldBackgroundColor
                                      : Colors.black,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0.0,
                    child: SizedBox(
                      height: 30,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                                color: _darkMode ? Colors.white : kTextColor),
                          ),
                          primary: _darkMode
                              ? Theme.of(context).primaryIconTheme.color
                              : Colors.white,
                          backgroundColor: _darkMode
                              ? Theme.of(context).scaffoldBackgroundColor
                              : kTextColor,
                        ),
                        onPressed: () {},
                        child: Row(children: [
                          const Icon(
                            Icons.star,
                            size: 17,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            "${bikes[index]['rating']}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 14),
                          )
                        ]),
                      ),
                    ),
                  ),
                ]);
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

Stream<List<Map<String, dynamic>>> readBikes() => FirebaseFirestore.instance
    .collection('bikes')
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
