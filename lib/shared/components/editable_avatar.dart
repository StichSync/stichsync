import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SsEditableAvatar extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onPressed;
  final double radius;
  bool? square = false;
  SsEditableAvatar({super.key, required this.imageUrl, required this.onPressed, required this.radius, this.square});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        square == true
            ? Image(
                image: NetworkImage(imageUrl),
                width: radius,
                fit: BoxFit.fill,
              )
            : CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
                radius: radius,
              ),
        Positioned(
          bottom: 4.0,
          right: 4.0,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(5.0),
                child: const Icon(
                  Icons.edit_outlined,
                  size: 32.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
