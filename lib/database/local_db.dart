import 'package:shared_preferences/shared_preferences.dart';

class LocalDBKeys{

  static const name = "name";

}

class LocalDB {

  static LocalDB? _instance;
  LocalDB._();

  factory LocalDB() {
    _instance ??= LocalDB._();
    return _instance!;
  }

  static Future<void> save(String key, dynamic value) async{
    var preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, value);
  }

  static Future<dynamic> get(Type type, String key)async{
    var preferences = await SharedPreferences.getInstance();

    if(type.toString() == "String"){
      return preferences.getString(key);
    }else if(type.toString() == "bool"){
      return preferences.getBool(key);
    }else if(type.toString() == "int"){
      return preferences.getInt(key);
    }else{
      return "";
    }
  }

}