import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nitkazez/components/user_list.dart';
import 'package:nitkazez/models/ledger.dart';
// import 'package:nitkazez/models/user.dart' as local;
import 'package:nitkazez/providers/user_provider.dart';
import 'package:provider/provider.dart';

class LedgerInfoScreen extends StatefulWidget {
  final Ledger ledger;

  const LedgerInfoScreen({Key? key, required this.ledger}) : super(key: key);

  @override
  _LedgerInfoScreenState createState() => _LedgerInfoScreenState();
}

class _LedgerInfoScreenState extends State<LedgerInfoScreen> {
  @override
  Widget build(BuildContext context) {
    final userChange = Provider.of<UserProvider>(context);
    var currentUserAdmin =
        widget.ledger.creatorId == userChange.currentUser.uid;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
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
          currentUserAdmin
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                        "Created by you, ${DateFormat("dd.mm.yyyy").format((widget.ledger.createdAt.toDate().toLocal()))}"),
                  ),
                )
              : FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance
                      .collection("users")
                      .doc(widget.ledger.creatorId)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var date = DateFormat("dd.mm.yyyy")
                          .format(widget.ledger.createdAt.toDate().toLocal());
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Text(
                              "Created by ${snapshot.data!["userName"]}, $date"),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return SliverToBoxAdapter(
                        child: Text("ERORR"),
                      );
                    } else {
                      return SliverToBoxAdapter(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
          UserList(ledger: widget.ledger),
        ],
      ),
      bottomNavigationBar: Row(
        children: [
          currentUserAdmin
              ? Expanded(
                  flex: 1,
                  child: TextButton.icon(
                      onPressed: () async {
                        //TODO: handle navigation
                        await FirebaseFirestore.instance
                            .collection("ledgers")
                            .doc(widget.ledger.ledgerId)
                            .delete();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.delete),
                      label: const Text("Delete Group")),
                )
              : Expanded(
                  flex: 1,
                  child: TextButton.icon(
                      onPressed: () {
                        //TODO: handle no users
                        widget.ledger.members.removeWhere((element) =>
                            element.id == userChange.currentUser.uid);
                        FirebaseFirestore.instance
                            .collection("ledgers")
                            .doc(widget.ledger.ledgerId)
                            .update(widget.ledger.toMap());
                      },
                      icon: Icon(Icons.logout),
                      label: const Text("Leave Group")),
                )
        ],
      ),
    );
  }
}
