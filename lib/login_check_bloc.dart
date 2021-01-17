import 'package:shared_preferences/shared_preferences.dart';

class login_credentials {
  Future logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('phone', null);
    pref.setBool('login', null);
  }

  Future login({String phone}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('phone', phone);

    pref.setBool('login', true);
  }

  login_status() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var x = await pref.get('login');
    return x;
  }

  Future getdata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var x = await pref.getString('phone');
    return x.toString();
  }
}
