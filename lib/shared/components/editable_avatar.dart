import 'package:flutter/material.dart';

class EditableAvatar extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onPressed;

  const EditableAvatar({
    super.key,
    required this.imageUrl,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          radius: 80,
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
