import 'package:EvRec/providers/facebook.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfoBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final facebookModel = Provider.of<FacebookModel>(context, listen: false);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("已登入"),
          RaisedButton(
            child: Text("登出"),
            onPressed: () => facebookModel.logout(),
          )
        ],
      ),
    );
  }
}
