import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocalIcon extends StatelessWidget {
  final String iconSrc;
  final Function press;
  final Color color;
  const SocalIcon({Key key, this.iconSrc, this.press, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        height: 60,
        width: 60,
        margin: EdgeInsets.symmetric(horizontal: 1),
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            width: 1,
            color: Colors.white,
          ),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          iconSrc,
          height: 30,
          width: 30,
        ),
      ),
    );
  }
}
