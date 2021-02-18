import 'package:EvRec/providers/facebook.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfoBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FacebookModel>(
      builder: (context, facebookModel, child) => FutureBuilder(
          future: facebookModel.getUserProfile(),
          builder: (context, AsyncSnapshot<Map<String, String>> snapshot) {
            if (snapshot.hasData)
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.network(snapshot.data["pictureUrl"]),
                  Text(snapshot.data["name"]),
                  RaisedButton(
                    child: Text("登出"),
                    onPressed: () => facebookModel.logout(),
                  ),
                  RaisedButton(
                    child: Text("GET"),
                    onPressed: () {
                      facebookModel.getUserFeed();
                    },
                  )
                ],
              ));
            else
              return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
