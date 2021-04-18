import 'package:flutter/material.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

class PreviewImage extends StatelessWidget {
  final String _imageURL;

  PreviewImage(this._imageURL);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: ShapeDecoration(
        shape: SuperellipseShape(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Image.network(_imageURL),
    );
  }
}
