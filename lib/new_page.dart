import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:widget_mask/widget_mask.dart';

double opacityImg = 0.0;

class NewPage extends StatefulWidget {
  const NewPage({Key? key}) : super(key: key);

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  List<String> effects = [
    'red',
    'black',
    'teal',
  ];
  List<String> textures = [
    'texture1',
    'texture2',
    'texture3',
    'texture4',
    'texture5',
  ];

  List<String> grunge = [
    'assets/tex7.jpg',
    'assets/tex3.jpg',
    'assets/tex4.jpg',
    'assets/tex5.jpg',
    'assets/grunge-texture-1.jpg',
  ];

  Color color = Colors.teal;
  Color color1 = Colors.white.withOpacity(opacityImg);

  Color color2 = Colors.white;
  Color color3 = Colors.white;

  ScreenshotController screenshotController = ScreenshotController();

  double opa = 0.3;
  Widget val = const SizedBox(
    height: 30,
    child: Center(
      child: Text('Select an Option!'),
    ),
  );

  Widget layer = Builder(
    builder: ((context) {
      return const SizedBox(
          // height: MediaQuery.of(context).size.height * .65,
          // width: MediaQuery.of(context).size.width,

          );
    }),
  );

  File? imageFile;
  // Image? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);
      setState(() => imageFile = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  // late SimpleStack _controller;

  // @override
  // void initState() {
  //   _controller = SimpleStack<Image>(
  //     Image.asset('assets/img1.jpg'),
  //     onUpdate: (val) {
  //       if (mounted) {
  //         setState(() {
  //           print('New Value -> $val');
  //         });
  //       }
  //     },
  //   );
  //   super.initState();
  // }

  bool isSelected = false;
  bool isSelected1 = false;

  @override
  Widget build(BuildContext context) {
    // final count = _controller.state;
    return Scaffold(
      appBar: AppBar(
        // title: const Text('insta overlay'),
        actions: [
          Row(
            children: <Widget>[
              isSelected ? cancelImg() : Container(),
              isSelected1 ? shaderRemove() : Container(),
              ElevatedButton(
                onPressed: () {
                  saveToGallery(context);
                },
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),

          // cancelImg()
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Screenshot(
              controller: screenshotController,
              child: Stack(
                children: [
                  // Image.asset(
                  //   'assets/img1.jpg',
                  //   height: 400,
                  //   width: 300,
                  //   // width: MediaQuery.of(context).size.width,
                  //   // color: Colors.black.withOpacity(opaImage),
                  //   // colorBlendMode: BlendMode.modulate,
                  //   fit: BoxFit.cover,
                  // ),

                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: buildBlurredImage(),
                  ),

                  // ColorFiltered(
                  //   colorFilter: ColorFilter.mode(color1, BlendMode.hue),
                  //   child: Container(
                  //     height: MediaQuery.of(context).size.height * .65,
                  //     width: MediaQuery.of(context).size.width,
                  //     color: color1,
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                val,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      splashColor: Colors.amber,
                      splashRadius: 20,
                      onPressed: () {
                        setState(() {
                          // isSelected = !isSelected;
                          val = effectPoint();
                        });
                      },
                      icon: const Icon(Icons.deblur_rounded),
                    ),
                    // IconButton(
                    //   splashColor: Colors.amber,
                    //   splashRadius: 20,
                    //   onPressed: () {
                    //     setState(() {
                    //       val = colorEffect();
                    //     });
                    //   },
                    //   icon: const Icon(Icons.emoji_emotions),
                    // ),
                    IconButton(
                      splashColor: Colors.amber,
                      splashRadius: 20,
                      onPressed: () {
                        setState(() {
                          // isSelected1 = !isSelected1;
                          val = shaderEffect();
                        });
                      },
                      icon: const Icon(Icons.wb_shade),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget blurredImage() => Center(
  //       child: WidgetMask(
  //         blendMode: BlendMode.overlay,
  //         childSaveLayer: true,
  //         mask: Image.asset(
  //           'assets/img1.jpg',
  //           height: MediaQuery.of(context).size.height * 65,
  //           fit: BoxFit.fitWidth,
  //         ),
  //         child: layer,
  //       ),
  //     );

  saveToGallery(BuildContext context) {
    screenshotController.capture().then((Uint8List? image) {
      saveImage(image!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image saved to gallery.'),
        ),
      );
    }).catchError((err) => print(err));
  }

  saveImage(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = "screenshot_$time";
    await requestPermission(Permission.storage);
    await ImageGallerySaver.saveImage(bytes, name: name, quality: 100);
  }

  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Widget buildBlurredImage() => GestureDetector(
        onTap: () {
          pickImage();
          // setState(() {
          //   image = imageFile.toString();
          // });
          print('clicked');
        },
        child: Stack(
          children: [
            imageFile != null
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * .65,
                    child: Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            color2,
                            color3,
                          ],
                        ).createShader(bounds),
                        child: WidgetMask(
                          blendMode: BlendMode.overlay,
                          childSaveLayer: true,
                          mask: layer,
                          child: Image.file(
                            imageFile!,
                            // height: MediaQuery.of(context).size.height * .65,
                            // width: MediaQuery.of(context).size.width,
                            // width: MediaQuery.of(context).size.width,
                            // color: Colors.black.withOpacity(opaImage),
                            // colorBlendMode: BlendMode.modulate,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height * .65,
                    child: Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            color2,
                            color3,
                          ],
                        ).createShader(bounds),
                        child: WidgetMask(
                          mask: layer,
                          // blendMode: BlendMode.overlay,
                          // mask: const Center(
                          //   child: Text(
                          //     'Negative',
                          //     style: TextStyle(
                          //       fontSize: 80,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // ),
                          child: Image.asset(
                            'assets/img1.jpg',
                            // height: MediaQuery.of(context).size.height * .65,
                            // width: MediaQuery.of(context).size.width,
                            // width: MediaQuery.of(context).size.width,
                            // color: Colors.black.withOpacity(opaImage),
                            // colorBlendMode: BlendMode.modulate,
                            fit: BoxFit.fill,
                            // scale: .8,
                          ),
                          // child: layer,
                        ),
                      ),
                    ),
                  ),
            Opacity(
              opacity: opa,
              // child: layer,
            ),
          ],
        ),
      );

  // Widget buildBlurredImage() => GestureDetector(
  //       onTap: () => pickImage(),
  //       child: imageFile != null
  //           ? Stack(
  //               children: [
  //                 ShaderMask(
  //                   shaderCallback: (bounds) => LinearGradient(
  //                     begin: Alignment.topLeft,
  //                     end: Alignment.bottomRight,
  //                     colors: [
  //                       color2,
  //                       color3,
  //                     ],
  //                   ).createShader(bounds),
  //                   child: Image.file(
  //                     imageFile!,
  //                     height: MediaQuery.of(context).size.height * .65,
  //                     width: MediaQuery.of(context).size.width,
  //                     // width: MediaQuery.of(context).size.width,
  //                     // color: Colors.black.withOpacity(opaImage),
  //                     // colorBlendMode: BlendMode.modulate,
  //                     fit: BoxFit.fill,
  //                   ),
  //                 ),
  //                 Opacity(
  //                   opacity: opa,
  //                   child: layer,
  //                 ),
  //               ],
  //             )
  //           : Stack(
  //               children: [
  //                 ShaderMask(
  //                   shaderCallback: (bounds) => LinearGradient(
  //                     begin: Alignment.topLeft,
  //                     end: Alignment.bottomRight,
  //                     colors: [
  //                       color2,
  //                       color3,
  //                     ],
  //                   ).createShader(bounds),
  //                   child: Image.asset(
  //                     'assets/img1.jpg',
  //                     height: MediaQuery.of(context).size.height * .65,
  //                     width: MediaQuery.of(context).size.width,
  //                     // width: MediaQuery.of(context).size.width,
  //                     // color: Colors.black.withOpacity(opaImage),
  //                     // colorBlendMode: BlendMode.modulate,
  //                     fit: BoxFit.fill,
  //                   ),
  //                 ),
  //                 Opacity(
  //                   opacity: opa,
  //                   child: layer,
  //                 ),
  //               ],
  //             ),
  //     );

  Widget addColor() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              color1 = Colors.red.withOpacity(.1);
            });

            print('Hit');
          },
          child: const Text('red'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              color1 = Colors.black.withOpacity(.1);
            });
          },
          child: const Text('black'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              color1 = Colors.yellow.withOpacity(.1);
            });
          },
          child: const Text('yellow'),
        ),
      ],
    );
  }

  Widget cancelImg() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          // const NewPage();
          // isSelected1 = !isSelected1;
          layer = const SizedBox();

          // val = const Text('cancel');
        });

        print('cancelled');
      },
      child: const Text('remove texture'),
    );
  }

  colors(Color color) {
    setState(() {
      ColorFiltered(
        colorFilter: ColorFilter.mode(color, BlendMode.color),
        child: layer,
      );
    });
  }

  Widget shaderColor() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              color2 = Colors.red;
              color3 = Colors.black;
            });

            print('Hit');
          },
          child: const Text('red'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              color2 = Colors.black;
              color3 = Colors.yellow;
            });
          },
          child: const Text('black'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              color2 = Colors.yellow;
              color3 = Colors.purple;
            });
          },
          child: const Text('yellow'),
        ),
      ],
    );
  }

  Widget shaderRemove() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          color2 = Colors.white;
          color3 = Colors.white;
        });

        print('Hit');
      },
      child: const Text('remove shade'),
    );
  }

  Widget shaderEffect() {
    isSelected1 = true;
    // isSelected1 = !isSelected1;
    // isSelected1 = !isSelected1;
    return
        // TextButton(
        //   onPressed: () {
        //     print('2nd hit');
        //     setState(
        //       () {
        val = SizedBox(
      height: 30,
      child: shaderColor(),
    );
    // val = StatefulBuilder(
    //   builder: (context, state) {
    //     return Slider(
    //         value: opacityImg,
    //         max: .8,
    //         onChanged: (value) {
    //           state(
    //             () {},
    //           );
    //           setState(() => opacityImg = value);
    //         });
    //   },
    // );
    //       },
    //     );
    //   },
    //   child: const Text(
    //     'Shaders',
    //   ),
    // );
  }

  Widget colorEffect() {
    return TextButton(
      onPressed: () {
        print('2nd hit');
        setState(
          () {
            val = addColor();
            // val = StatefulBuilder(
            //   builder: (context, state) {
            //     return Slider(
            //         value: opacityImg,
            //         max: .8,
            //         onChanged: (value) {
            //           state(
            //             () {},
            //           );
            //           setState(() => opacityImg = value);
            //         });
            //   },
            // );
          },
        );
      },
      child: const Text(
        'Colors',
      ),
    );
  }

  Widget colorEffectPoint() {
    return TextButton(
      onPressed: () {
        print('3st hit');
        setState(
          () {
            val = SizedBox(
              height: 30,
              // width: 250,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: effects.length,
                itemBuilder: ((context, index) {
                  return TextButton(
                    onPressed: (() {
                      setState(() {
                        val = addColor();
                        // layer = Opacity(
                        //   opacity: opa,
                        //   child: Image.asset(
                        //     grunge[index],
                        //     height: 400,
                        //     width: 300,
                        //     fit: BoxFit.cover,
                        //   ),
                        // );
                      });
                      // val = StatefulBuilder(
                      //   builder: (context, state) {
                      //     return Slider(
                      //         value: opacityImg,
                      //         max: .8,
                      //         onChanged: (value) {
                      //           state(
                      //             () {},
                      //           );
                      //           setState(() => opacityImg = value);
                      //         });
                      //   },
                      // );
                    }),
                    child: Text(effects[index]),
                  );
                }),
              ),
            );
          },
        );
      },
      child: const Text(
        'Colors',
      ),
    );
  }

  Widget effectPoint() {
    isSelected = true;
    // isSelected = !isSelected;
    // isSelected = !isSelected1;
    // return TextButton(
    //   onPressed: () {
    //     print('1st hit');
    return val = SizedBox(
      height: 30,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: grunge.length,
        itemBuilder: ((context, index) {
          return TextButton(
            onPressed: (() {
              setState(() {
                layer = Image.asset(
                  grunge[index],

                  colorBlendMode: BlendMode.overlay,
                  opacity: const AlwaysStoppedAnimation(.2),
                  height: MediaQuery.of(context).size.height * .65,
                  // width: MediaQuery.of(context).size.width,
                  // width: MediaQuery.of(context).size.width,
                  // color: Colors.black.withOpacity(opaImage),
                  // colorBlendMode: BlendMode.modulate,
                  fit: BoxFit.fill,
                );
                // layer = Image.asset(
                //   grunge[index],
                //   color: Colors.white.withOpacity(opa),
                //   colorBlendMode: BlendMode.overlay,
                //   height: MediaQuery.of(context).size.height * .65,
                //   fit: BoxFit.fill,
                // );
              });
              // val = SizedBox(
              //   height: 25,
              //   width: 300,
              //   child: Center(
              //     child: StatefulBuilder(
              //       builder: (context, state) {
              //         return Center(
              //           child: Slider(
              //               value: opa,
              //               max: .8,
              //               onChanged: (value) {
              //                 state(
              //                   () {},
              //                 );
              //                 setState(() => opa = value);
              //               }),
              //         );
              //       },
              //     ),
              //   ),
              // );
            }),
            child: Text(textures[index]),
          );
        }),
      ),
    );
  }

  //     child: const Text(
  //       'Textures',
  //     ),
  //   );
  // }
}
