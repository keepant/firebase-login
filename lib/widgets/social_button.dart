import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SocialButton extends StatelessWidget {
  final String assetName;
  final VoidCallback onPressed;

  const SocialButton({Key key, this.assetName, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: assetName,
      elevation: 1,
      backgroundColor: Colors.white,
      mini: true,
      child: SvgPicture.asset(
        'assets/icons/$assetName.svg',
        width: 25,
      ),
      onPressed: onPressed,
    );
  }
}
