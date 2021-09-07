import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Info"),
        centerTitle: true,
      ),
      body: const Text(
          """In magna sit cupidatat sit nulla irure nostrud sit officia exercitation sunt sit aliqua. Incididunt dolor sunt enim laboris sint labore officia. Cillum aute ea tempor minim qui do. Sint Lorem sint esse incididunt. Ex elit commodo labore quis deserunt ex incididunt. Consectetur reprehenderit commodo minim magna cillum aute ea amet mollit anim Lorem ipsum.

Officia exercitation labore sunt velit aliqua proident anim minim id. Velit voluptate quis enim velit aliqua cupidatat cillum cillum exercitation sint nulla. Irure esse eu pariatur deserunt culpa sit nisi est qui magna est laboris mollit fugiat. Elit reprehenderit duis duis aute irure nulla exercitation ullamco occaecat amet. Incididunt non laboris quis voluptate nostrud ullamco consequat.

Excepteur labore exercitation mollit et irure eiusmod amet labore eiusmod minim. Laborum dolore aute incididunt aliqua consequat esse incididunt non duis ex magna cupidatat quis laborum. Amet dolor et cupidatat ullamco anim excepteur. Magna dolor consectetur adipisicing qui reprehenderit nulla non sint excepteur dolor ullamco. Labore excepteur nulla incididunt duis aliqua elit anim dolore excepteur nulla dolor cupidatat."""),
    );
  }
}
