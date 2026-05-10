import 'package:flutter/material.dart';

class ImageViewerScreen extends StatefulWidget {

  final List<String> images;
  final int initialIndex;

  const ImageViewerScreen({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<ImageViewerScreen> createState() =>
      _ImageViewerScreenState();
}

class _ImageViewerScreenState
    extends State<ImageViewerScreen> {

  late PageController pageController;

  late int currentIndex;

  @override
  void initState() {
    super.initState();

    currentIndex = widget.initialIndex;

    pageController = PageController(
      initialPage: currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      body: Stack(
        children: [

          /// IMAGE VIEWER
          PageView.builder(

            controller: pageController,

            itemCount: widget.images.length,

            onPageChanged: (index) {

              setState(() {
                currentIndex = index;
              });
            },

            itemBuilder: (context, index) {

              return InteractiveViewer(

                minScale: 1,
                maxScale: 4,

                child: Center(
                  child: Image.asset(
                    widget.images[index],

                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),

          /// TOP BAR
          Positioned(
            top: 50,
            left: 16,
            right: 16,

            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

              children: [

                /// CLOSE
                GestureDetector(

                  onTap: () {
                    Navigator.pop(context);
                  },

                  child: Container(
                    padding:
                    const EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      color: Colors.black45,

                      borderRadius:
                      BorderRadius.circular(
                          100),
                    ),

                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),

                /// COUNT
                Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.black45,

                    borderRadius:
                    BorderRadius.circular(20),
                  ),

                  child: Text(
                    "${currentIndex + 1} / ${widget.images.length}",

                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}