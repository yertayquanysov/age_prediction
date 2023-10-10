import 'package:flutter/material.dart';

class PreviewImage extends StatelessWidget {
  final String _imageURL;

  PreviewImage(this._imageURL);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      child: Image.network(_imageURL),
    );
  }
}
