import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nitkazez/components/app_bar_with_tap.dart';
import 'package:nitkazez/components/transaction_list.dart';
import 'package:nitkazez/models/ledger.dart';
import 'package:nitkazez/screens/ledger_info_screen.dart';
import 'package:nitkazez/screens/modals/create_transaction_modal.dart';

class LedgerScreen extends StatefulWidget {
  const LedgerScreen({Key? key, required this.ledger}) : super(key: key);
  final Ledger ledger;
  @override
  _LedgerScreenState createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithTap(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LedgerInfoScreen(
                        ledger: widget.ledger,
                      )));
        },
        appBar: AppBar(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CachedNetworkImage(
                  imageUrl:
                      "https://picsum.photos/seed/${widget.ledger.ledgerName}/300/300",
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    backgroundImage: imageProvider,
                    radius: 20.0,
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => CircleAvatar(
                    child: Text(widget.ledger.ledgerName[0].toUpperCase()),
                    radius: 20.0,
                  ),
                ),
              ),
              Text(widget.ledger.ledgerName),
            ],
          ),
        ),
      ),
      body: TransactionList(
        ledger: widget.ledger,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => CreateTransactionModal(
                ledger: widget.ledger,
              ),
              fullscreenDialog: true,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
