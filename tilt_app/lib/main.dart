import 'package:binary_music_tools/apis/tilt_repository.dart';
import 'package:binary_music_tools/blocs/signin_cubit.dart';
import 'package:binary_music_tools/blocs/tilt_list_cubit.dart';
import 'package:binary_music_tools/pages/calculator/calculator_page.dart';
import 'package:binary_music_tools/pages/signin/signin_page.dart';
import 'package:binary_music_tools/pages/tilt/tilt_page.dart';
import 'package:binary_music_tools/widgets/navigation_bar.dart';
import 'package:binary_music_tools/widgets/user_avatar_button.dart';
import 'package:binary_music_tools/widgets/user_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'blocs/debug_bloc_delegate.dart';

void main() {
  Bloc.observer = DebugBlocDelegate();

  final tiltRepo = TiltRepository(adapterId: "simple-test");

  final signinCubit = SigninCubit();
  final tiltListCubit = TiltListCubit(
    signinCubit: signinCubit,
    tiltRepository: tiltRepo,
  );

  runApp(TiltApp(signinCubit: signinCubit, tiltListCubit: tiltListCubit));
}

class TiltApp extends StatefulWidget {
  final SigninCubit signinCubit;
  final TiltListCubit tiltListCubit;

  TiltApp({
    required this.signinCubit,
    required this.tiltListCubit,
  });

  @override
  _TiltAppState createState() => _TiltAppState();
}

class _TiltAppState extends State<TiltApp> {
  @override
  void initState() {
    super.initState();
    widget.signinCubit.signinSilent();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TiltRepository(adapterId: "simple-test"),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => widget.signinCubit),
          BlocProvider(create: (context) => widget.tiltListCubit),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Brewers Tools',
          theme: ThemeData(
            primarySwatch: Colors.green,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: BlocBuilder<SigninCubit, SigninCubitState>(
            builder: (context, state) {
              if (state is SigninCubitLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is SigninCubitSignedIn) {
                return StartPage();
              } else {
                return SignInPage();
              }
            },
          ),
        ),
      ),
    );
  }
}

class StartPage extends StatefulWidget {
  StartPage({Key? key, this.title = "Brewers Tools"}) : super(key: key);
  final String title;

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final isMobile = defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static final _tiltPage = TiltPage();
  static final _calculatorPage = CalculatorPage();

  final pages = [_tiltPage, _calculatorPage];

  var indexToShow = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  void _onItemTapped(int index) {
    setState(() => indexToShow = index);
  }

  VoidCallback _navigatorAction(BuildContext context, VoidCallback function) {
    return () {
      function();
      Navigator.pop(context);
    };
  }

  @override
  Widget build(context) {
    return BlocBuilder<SigninCubit, SigninCubitState>(
      builder: (context, state) {
        final account = state is SigninCubitSignedIn ? state.account : null;

        final handleLogout = () {
          if (account != null) {
            onLogout(context, account);
          }
        };

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.green[900],
          drawer: UserDrawer(
            account: account,
            onLogout: handleLogout,
            actions: [
              ListTile(
                leading: Icon(Icons.calculate),
                title: Text('Calculator'),
                onTap: _navigatorAction(context, () {
                  setState(() => indexToShow = pages.indexOf(_calculatorPage));
                }),
              ),
              ListTile(
                leading: Icon(Icons.thermostat_outlined),
                title: Text('Tilt'),
                onTap: _navigatorAction(context, () {
                  setState(() => indexToShow = pages.indexOf(_tiltPage));
                }),
              ),
            ],
          ),
          appBar: AppBar(
            title: Text(widget.title),
            elevation: 0,
            backgroundColor: Colors.green[900],
            actions: [
              UserAvatarButton(onPressed: handleLogout),
            ],
          ),
          bottomNavigationBar: isMobile
              ? NavigationBar(
                  indexToShow: indexToShow,
                  itemPressed: _onItemTapped,
                )
              : null,
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: pages[indexToShow],
          ),
        );
      },
    );
  }

  void onLogout(BuildContext context, GoogleSignInAccount account) {
    showDialog<SimpleDialog>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        titlePadding: EdgeInsets.all(8),
        title: ListTile(
          leading: ClipOval(child: Image.network(account.photoUrl ?? "")),
          title: Text(account.displayName ?? account.email),
          subtitle: Text(account.email),
        ),
        children: [
          SimpleDialogOption(
            child: ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<SigninCubit>().signout();
            },
          )
        ],
      ),
    );
  }
}
