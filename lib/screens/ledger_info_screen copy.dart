import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nitkazez/components/user_list.dart';
import 'package:nitkazez/models/ledger.dart';

class LedgerInfoScreen extends StatefulWidget {
  final Ledger ledger;

  const LedgerInfoScreen({Key? key, required this.ledger}) : super(key: key);

  @override
  _LedgerInfoScreenState createState() => _LedgerInfoScreenState();
}

class _LedgerInfoScreenState extends State<LedgerInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.ledger.ledgerName),
          flexibleSpace: FlexibleSpaceBar(
            background: CachedNetworkImage(
              fit: BoxFit.fill,
              imageUrl:
                  "https://picsum.photos/seed/${widget.ledger.ledgerName}/300/300",
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => CircleAvatar(
                child: Text(widget.ledger.ledgerName[0].toUpperCase()),
                radius: 40.0,
              ),
            ),
          ),
        ),
        body: UserList(
          ledger: widget.ledger,
        ));
  }
}
