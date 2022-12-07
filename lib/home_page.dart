import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:insta_overlay/new_page.dart';

final List<String> imgList = [
  'assets/tex7.jpg',
  'assets/tex5.jpg',
  'assets/tex3.jpg',
  'assets/tex4.jpg',
];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> imageSliders = imgList
      .map(
        (item) => Container(
          margin: const EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                Image.asset(item, fit: BoxFit.cover, width: 1000.0),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(12),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(13),
            //   child: Image.asset(
            //     'assets/img1.jpg',
            //     height: 400,
            //     fit: BoxFit.fitWidth,
            //   ),
            // ),
            Expanded(
              child: CarouselSlider(
                options: CarouselOptions(
                  // aspectRatio: 2.0,
                  initialPage: 2,
                  viewportFraction: .8,
                  enlargeCenterPage: true,
                ),
                items: imageSliders,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Customize Your Picture With Insta Overlay App',
              overflow: TextOverflow.fade,
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 150,
              height: 70,
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: (() {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) => const NewPage()),
                    ),
                  );
                }),
                child: const Text('Start Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
