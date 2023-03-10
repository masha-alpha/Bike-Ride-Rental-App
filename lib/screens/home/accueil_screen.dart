import 'package:bikeapp_v0/utils/card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/config.dart';

class AccueilScreen extends StatefulWidget {
  const AccueilScreen({Key? key}) : super(key: key);

  @override
  State<AccueilScreen> createState() => _AccueilScreenState();
}

class _AccueilScreenState extends State<AccueilScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0)
      ..addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool _darkMode =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark;
    return Column(
      children: [
        Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 4),
              child: Text(
                "Choose your bike",
                style: TextStyle(
                  color: kTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 23,
                ),
              ),
            ),
            TabBar(
              isScrollable: true,
              indicatorPadding: const EdgeInsets.all(0),
              labelPadding:
                  const EdgeInsets.only(left: 18, right: 18, top: 5, bottom: 5),
              labelColor: _darkMode
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Colors.white,
              labelStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              indicator: BoxDecoration(
                color: _darkMode ? Colors.white : kNavyBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              unselectedLabelColor: _darkMode ? Colors.white : kNavyBlue,
              controller: _tabController,
              tabs: const [
                Text(
                  'All',
                  style: TextStyle(fontFamily: 'Varela_Round'),
                ),
                Text(
                  'Favorites',
                  style: TextStyle(fontFamily: 'Varela_Round'),
                ),
                Text('Classic', style: TextStyle(fontFamily: 'Varela_Round')),
                Text('??lectric', style: TextStyle(fontFamily: 'Varela_Round')),
              ],
            ),
          ],
        )),
        Expanded(
          child: TabBarView(controller: _tabController, children: [
            CardWidget(
              stream: readAllBikes(),
            ),
            CardWidget(
              stream: readAllBikes(),
            ),
            CardWidget(
              stream: readClassicBikes(),
            ),
            CardWidget(
              stream: readElectricBikes(),
            ),
          ]),
        )
      ],
    );
  }
}
// body: Column(
//   crossAxisAlignment: CrossAxisAlignment.start,
//   children: <Widget>[
//     Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 30),
//       child: Text(
//         "Choisir votre v??lo",
//         style: TextStyle(
//             color: Colors.blue,
//             fontWeight: FontWeight.bold,
//             fontSize: 23),
//       ),
//     ),
//     Types(),
// Expanded(
//   child: Padding(
//     padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
//     child: GridView.builder(
//         itemCount: bikes.length,
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           mainAxisSpacing: kDefaultPaddin,
//           crossAxisSpacing: kDefaultPaddin,
//           childAspectRatio: 0.75,
//         ),
//         itemBuilder: (context, index) => ItemCard(
//               product: bikes[index],
//               press: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => DetailsScreen(
//                       product: bikes[index],
//                     ),
//                   )),
//             )),
//   ),
// ),
//   ],
// ));

// // the logout function
// Future<void> logout(BuildContext context) async {
//   await FirebaseAuth.instance.signOut();
//   Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (context) => LoginScreen()));
// }
Stream<List<Map<String, dynamic>>> readAllBikes() => FirebaseFirestore.instance
    .collection('bikes')
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

// Stream<List<Map<String, dynamic>>> readFavorisBikes() => FirebaseFirestore.instance.collection('bikes').where('favoris', arrayContains: FirebaseAuth.instance.currentUser!.uid).snapshots().map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

Stream<List<Map<String, dynamic>>> readElectricBikes() =>
    FirebaseFirestore.instance
        .collection('bikes')
        .where("type", isEqualTo: "electric")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

Stream<List<Map<String, dynamic>>> readClassicBikes() =>
    FirebaseFirestore.instance
        .collection('bikes')
        .where("type", isEqualTo: "classic")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
