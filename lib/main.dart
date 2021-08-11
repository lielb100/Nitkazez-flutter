import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nitkazez/providers/UserProvider.dart';
import 'package:nitkazez/screens/HomeScreen.dart';
import 'package:nitkazez/screens/LoginScreen.dart';
import 'package:nitkazez/providers/DarkThemeProvider.dart';
import 'package:nitkazez/theme/Styles.dart';
import 'package:provider/provider.dart';
import 'models/User.dart' as UserModel;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAnalytics analytics = FirebaseAnalytics();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InitializerWidget();
  }
}

class InitializerWidget extends StatefulWidget {
  const InitializerWidget({Key? key}) : super(key: key);

  @override
  _InitializerWidgetState createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget> {
  User? _user;
  UserProvider userChangeProvider = UserProvider();
  bool isLoading = true;
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    FirebaseAuth _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    isLoading = false;
    getCurrentAppTheme();
    if (_user != null) getCurrentUser(_user!.uid);
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  void getCurrentUser(String uid) async {
    if (await userChangeProvider.isUserExist(uid)) {
      userChangeProvider.currentUser =
          await userChangeProvider.getCurrentUser(uid);
    } else {
      userChangeProvider.currentUser = await userChangeProvider.createUser(uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        userChangeProvider.currentUser = UserModel.User("", "");
      } else {
        getCurrentUser(user.uid);
      }
    });
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return themeChangeProvider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return userChangeProvider;
          },
        ),
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget? child) {
          return MaterialApp(
              title: 'Welcome to Flutter',
              theme: Styles.themeData(themeChangeProvider.darkTheme, context),
              debugShowCheckedModeBanner: true,
              home: isLoading
                  ? Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _user == null
                      ? LoginScreen()
                      : HomeScreen());
        },
      ),
    );
  }
}
