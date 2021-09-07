import 'package:flutter/material.dart';

class AppBarWithTap extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onTap;
  final AppBar appBar;

  const AppBarWithTap({Key? key, this.onTap, required this.appBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: appBar);
  }

  // TODO: implement preferredSize
  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
