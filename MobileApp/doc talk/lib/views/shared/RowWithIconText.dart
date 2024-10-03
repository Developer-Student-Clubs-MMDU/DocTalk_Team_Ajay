
import 'package:flutter/material.dart';

class ListTileWithIconText extends StatelessWidget {
  final IconData suffixIcon;
  final String data;
  final IconData prefixIcon;
  final GestureTapCallback? onTap;

  const ListTileWithIconText({super.key, this.suffixIcon = Icons.arrow_forward_ios, required this.data, required this.prefixIcon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: ListTile(
              trailing:  Icon(suffixIcon),
              title: Text(data) ,
              leading: Icon(prefixIcon),
              onTap: onTap,
              iconColor: Colors.green,
            ),
      ),
    );
  }
}
