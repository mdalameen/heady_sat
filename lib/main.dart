import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heady_sat/blocs/all_blocs.dart';
import 'package:heady_sat/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: AllBlocs.get(),
        child: MaterialApp(
          title: 'Heady SAT',
          theme: ThemeData(
            primarySwatch: Colors.yellow,
            primaryColor: Colors.white,
            brightness: Brightness.light,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: HomePage(),
        ));
  }
}
