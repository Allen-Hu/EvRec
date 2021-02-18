import 'package:EvRec/body/info.dart';
import 'package:EvRec/body/login.dart';
import 'package:EvRec/providers/facebook.dart';
import 'package:EvRec/providers/location.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FacebookModel()),
        ChangeNotifierProvider(create: (context) => LocationModel()),
      ],
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

  FacebookModel facebookModel;
  LocationModel locationModel;

  Future<void> init() async {
    await facebookModel.init();
    await locationModel.init();
  }

  @override
  Widget build(BuildContext context) {
    // initialize providers
    facebookModel = Provider.of<FacebookModel>(context, listen: false);
    locationModel = Provider.of<LocationModel>(context, listen: false);

    if (loading) {
      init().then((value) {
        setState(() {
          loading = false;
        });
      });
      return Center(child: CircularProgressIndicator());
    } else {
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
}
