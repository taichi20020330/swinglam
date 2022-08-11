import 'package:flutter/material.dart';
import 'package:swinglam/views/post/pages/hero_image.dart';

class EnlargeImageScreen extends StatelessWidget {
  final Image image;
  EnlargeImageScreen({required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: HeroImage(
          image: image,
          onTap: () => Navigator.pop(context)
        ),
      ),
    );
  }
}
