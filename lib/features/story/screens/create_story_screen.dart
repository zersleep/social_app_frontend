import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateStoryScreen extends StatefulWidget {
  const CreateStoryScreen({super.key});

  @override
  State<CreateStoryScreen> createState() =>
      _CreateStoryScreenState();
}

class _CreateStoryScreenState
    extends State<CreateStoryScreen> {

  final ImagePicker picker =
  ImagePicker();

  File? selectedImage;

  Future<void> pickImage() async {

    final XFile? file =
    await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (file != null) {

      setState(() {

        selectedImage =
            File(file.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      Colors.white,

      body: SafeArea(

        child: Column(
          children: [

            /// TOP BAR
            Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),

              child: Row(
                children: [

                  GestureDetector(

                    onTap: () {
                      Navigator.pop(context);
                    },

                    child: const Icon(
                      Icons.close,

                      size: 30,

                      color: Colors.black,
                    ),
                  ),

                  const Spacer(),

                  const Text(
                    "Create story",

                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),

                  const Spacer(),

                  Container(
                    width: 48,
                    height: 48,

                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                      BorderRadius.circular(12),

                      border: Border.all(
                        color: Colors.black12,
                      ),
                    ),

                    child: const Icon(
                      Icons.settings_outlined,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            /// TOP ACTIONS
            Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 18,
              ),

              child: Row(
                children: [

                  Expanded(
                    child: buildTopButton(
                      icon:
                      Icons.text_fields_rounded,
                      title: "Text",
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: buildTopButton(
                      icon:
                      Icons.music_note_rounded,
                      title: "Music",
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: buildTopButton(
                      icon:
                      Icons.grid_view_rounded,
                      title: "Collage",
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// GALLERY HEADER
            Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 18,
              ),

              child: Row(
                children: [

                  const Text(
                    "Gallery",

                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(width: 4),

                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 24,
                  ),

                  const Spacer(),

                  /// MULTIPLE
                  Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),

                    decoration: BoxDecoration(

                      borderRadius:
                      BorderRadius.circular(14),

                      border: Border.all(
                        color: Colors.black,
                        width: 1.2,
                      ),
                    ),

                    child: const Row(
                      children: [

                        Icon(
                          Icons.layers_rounded,
                          size: 17,
                          color: Colors.black,
                        ),

                        SizedBox(width: 6),

                        Text(
                          "Multiple",

                          style: TextStyle(
                            fontSize: 13,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// MAIN CONTENT
            Expanded(
              child: Stack(
                children: [

                  /// IMAGE PREVIEW
                  selectedImage != null

                      ? Padding(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 18,
                    ),

                    child: Image.file(
                      selectedImage!,

                      fit: BoxFit.cover,

                      width: double.infinity,
                    ),
                  )

                  /// GALLERY GRID
                      : GridView.builder(

                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 18,
                    ),

                    itemCount: 30,

                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(

                      crossAxisCount: 3,

                      crossAxisSpacing: 4,

                      mainAxisSpacing: 4,
                    ),

                    itemBuilder:
                        (context, index) {

                      return GestureDetector(

                        onTap: pickImage,

                        child: ClipRRect(

                          borderRadius:
                          BorderRadius.circular(6),

                          child: Container(

                            color:
                            Colors.grey.shade100,

                            child: index == 0

                                ? const Center(
                              child: Icon(
                                Icons.add_photo_alternate,

                                size: 34,

                                color: Colors.black54,
                              ),
                            )

                                : Image.asset(

                              index % 5 == 0
                                  ? 'assets/images/post1.jpg'
                                  : index % 4 == 0
                                  ? 'assets/images/post2.jpg'
                                  : index % 3 == 0
                                  ? 'assets/images/post3.jpg'
                                  : index % 2 == 0
                                  ? 'assets/images/post4.jpg'
                                  : 'assets/images/post5.jpg',

                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  /// FLOATING CAMERA
                  Positioned(
                    right: 20,
                    bottom: 20,

                    child: GestureDetector(

                      onTap: () {

                        /// CAMERA LATER
                      },

                      child: Container(

                        width: 56,
                        height: 56,

                        decoration: BoxDecoration(

                          color: Colors.white,

                          shape: BoxShape.circle,

                          boxShadow: [

                            BoxShadow(
                              color:
                              Colors.black.withValues(
                                alpha: 0.10,
                              ),

                              blurRadius: 14,

                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),

                        child: const Icon(
                          Icons.camera_alt_rounded,

                          size: 26,

                          color: Color(0xFF2F80ED),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTopButton({
    required IconData icon,
    required String title,
  }) {

    return Container(

      height: 76,

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(18),

        border: Border.all(
          color: Colors.black12,
        ),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withValues(
              alpha: 0.04,
            ),

            blurRadius: 8,

            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [

          Icon(
            icon,

            size: 22,

            color: Colors.black,
          ),

          const SizedBox(width: 8),

          Text(
            title,

            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}