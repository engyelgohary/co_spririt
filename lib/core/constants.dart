import 'package:co_spirit/data/api/auth_api.dart';
import 'package:hive/hive.dart';

late final Box hiveBox;
late final UserData userData;
const userDB = "user";
const emailRegex = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
const authApiUrl = "http://10.100.102.6:5204/api/v1/authentication/";
const userApiUrl = "http://10.100.102.6:5204/api/v1/user/";
