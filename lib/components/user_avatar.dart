import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatefulWidget {
  const UserAvatar(
      {Key? key,
      required this.userName,
      this.radius = 20.0,
      this.showUnderText = true})
      : super(key: key);
  final bool showUnderText;
  final double radius;
  final String userName;
  @override
  _UserAvatarState createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CachedNetworkImage(
          imageUrl: "https://robohash.org/${widget.userName}?bgset=bg1",
          imageBuilder: (context, imageProvider) => CircleAvatar(
            backgroundImage: imageProvider,
            radius: widget.radius,
          ),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => CircleAvatar(
            child: Text(widget.userName[0].toUpperCase()),
            radius: widget.radius,
          ),
        ),
        if (widget.showUnderText) Text(widget.userName)
      ],
    );
  }
}
