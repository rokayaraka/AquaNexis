import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';

class LogoAnimation extends StatefulWidget {
  const LogoAnimation({super.key,  required this.width,this.text="aquanexis"});
  final double width;
  final String text ;
  @override
  State<LogoAnimation> createState() => _LogoAnimationState();
}

class _LogoAnimationState extends State<LogoAnimation> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: DefaultTextStyle(
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 60.0, fontFamily: 'Arthaus', color: AppColors.textColorDarkSecondary),
        child: AnimatedTextKit(
        repeatForever: true,
          animatedTexts: [
            TyperAnimatedText(
              widget.text,
              speed: const Duration(milliseconds: 400),
            ),
          ],
        ),
      ),
    );
  }
}
