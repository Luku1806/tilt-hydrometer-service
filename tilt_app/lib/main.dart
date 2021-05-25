import 'package:binary_music_tools/blocs/brew_db/bloc.dart';
import 'package:binary_music_tools/blocs/signin_cubit.dart';
import 'package:binary_music_tools/blocs/tilt/tilt_bloc.dart';
import 'package:binary_music_tools/pages/brew_list/brew_list_page.dart';
import 'package:binary_music_tools/pages/calculator/calculator_page.dart';
import 'package:binary_music_tools/pages/tilt/tilt_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'blocs/debug_bloc_delegate.dart';

void main() {
  Bloc.observer = DebugBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SigninCubit()),
        BlocProvider(create: (context) => BrewDbBloc()),
        BlocProvider(create: (context) => TiltBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Brewers Tools',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(
          title: "Brewers Tools",
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _widgetOptions = <Widget>[
    TiltPage(),
    BrewListPage(),
    CalculatorPage(onSave: () => {}),
  ];

  @override
  void initState() {
    super.initState();
    context.read<BrewDbBloc>().add(GetBrewList());
  }

  @override
  Widget build(BuildContext context) {
    final account = context.select<SigninCubit, GoogleSignInAccount?>(
      (signin) => signin.state,
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
        backgroundColor: Colors.green[900],
        actions: [
          if (account?.photoUrl != null)
            IconButton(
              icon: ClipOval(child: Image.network(account!.photoUrl!)),
              onPressed: () => {},
            ),
        ],
      ),
      backgroundColor: Colors.green[900],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green[900],
        unselectedItemColor: Colors.white30,
        selectedItemColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.thermostat_outlined),
            label: 'Tilt',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.format_list_bulleted),
            label: 'Beers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate_outlined),
            label: 'Calculator',
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: BlocListener<BrewDbBloc, BrewDbState>(
          listener: (BuildContext context, BrewDbState state) {
            if (state is SaveBrewSuccess || state is DeleteBrewSuccess) {
              context.read<BrewDbBloc>().add(GetBrewList());
            }
          },
          child: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ),
      ),
    );
  }
}
