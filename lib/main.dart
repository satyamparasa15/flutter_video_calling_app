import 'package:flutter/material.dart';
import 'package:flutter_video_call_app/screens/call/call_model.dart';
import 'package:flutter_video_call_app/screens/home/home_model.dart';
import 'package:provider/provider.dart';

import 'screens/home/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: HomeNotifier()),
        ChangeNotifierProvider.value(value: CallNotifier()),
      ],
      child: MaterialApp(
        title: 'Video call app',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(),
      ),
    );
  }
}
