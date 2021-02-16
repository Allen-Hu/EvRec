import 'package:EvRec/body/info.dart';
import 'package:EvRec/body/login.dart';
import 'package:EvRec/providers/facebook.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FacebookModel(),
      child: MaterialApp(
        title: 'EvRec',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('EvRec'),
          ),
          body: BodyWrapper(),
        ),
      ),
    );
  }
}

class BodyWrapper extends StatefulWidget {
  @override
  _BodyWrapperState createState() => _BodyWrapperState();
}

class _BodyWrapperState extends State<BodyWrapper> {
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    final facebookModel = Provider.of<FacebookModel>(context, listen: false);
    facebookModel.init().then((value) {
      setState(() {
        loading = false;
      });
    });

    if (loading)
      return Center(child: CircularProgressIndicator());
    else
      return Consumer<FacebookModel>(
        builder: (context, facebookModel, child) {
          if (facebookModel.isLoggedIn)
            return InfoBody();
          else
            return LoginBody();
        },
      );
  }
}
