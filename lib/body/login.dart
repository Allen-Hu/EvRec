import 'package:EvRec/providers/facebook.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:provider/provider.dart';

class LoginBody extends StatelessWidget {
  _facebookLoginHandler(BuildContext context) async {
    final facebookModel = Provider.of<FacebookModel>(context, listen: false);
    final resultStatus = await facebookModel.login();
    var notice = '';

    switch (resultStatus) {
      case FacebookLoginStatus.loggedIn:
        notice = "登入成功";
        break;
      case FacebookLoginStatus.cancelledByUser:
        notice = "登入取消";
        break;
      case FacebookLoginStatus.error:
        notice = "錯誤";
        break;
    }
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(notice)));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        color: Color.fromRGBO(59, 89, 152, 1),
        child: Text(
          "Facebook 登入",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () => _facebookLoginHandler(context),
      ),
    );
  }
}
