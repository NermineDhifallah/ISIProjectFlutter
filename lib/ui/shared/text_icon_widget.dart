import 'package:flutter/cupertino.dart';

class TextIconWidget extends StatelessWidget {
  final IconData iconData;
  final String text;
  const TextIconWidget({super.key, required this.iconData, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(iconData, size: 15),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
          child: Flexible(
              child: Text(text,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15))),
        )
      ],
    );
  }
}
