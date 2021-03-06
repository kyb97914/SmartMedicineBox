import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static final _storage = FlutterSecureStorage();

  static const _keyToken = 'usertoken';

  static const _keydeviceToken = 'devicetoken';

  static const _keyUserId = 'userid';

  static const _keyBottleId = 'bottleid';

  static const _keyMedicineId = 'medicineid';

  static const _keyhubId = 'hubid';

  static const _keyusertype = 'usertype';

  //User Type: [Social]: 소셜 로그인 [Local]: Local 로그인
  static Future setUserType(String usertype) async =>
      await _storage.write(key: _keyusertype, value: usertype);

  static Future<String> getUserType() async =>
      await _storage.read(key: _keyusertype);

  static Future setUserId(String userid) async =>
      await _storage.write(key: _keyUserId, value: userid);

  static Future<String> getUserID() async =>
      await _storage.read(key: _keyUserId);

  static Future setDeviceToken(String devicetoken) async =>
      await _storage.write(key: _keydeviceToken, value: devicetoken);

  static Future<String> getDeviceToken() async =>
      await _storage.read(key: _keydeviceToken);

  static Future setUserToken(String userToken) async =>
      await _storage.write(key: _keyToken, value: userToken);

  static Future<String> getUserToken() async =>
      await _storage.read(key: _keyToken);

  static Future setBottleId(String bottleid) async =>
      await _storage.write(key: _keyBottleId, value: bottleid);

  static Future<String> getBottleId() async =>
      await _storage.read(key: _keyBottleId);

  static Future setMedicineId(String medicineid) async =>
      await _storage.write(key: _keyMedicineId, value: medicineid);

  static Future<String> getMedicineId() async =>
      await _storage.read(key: _keyMedicineId);

  static Future setHubId(String hubid) async =>
      await _storage.write(key: _keyhubId, value: hubid);

  static Future<String> getHubId() async => await _storage.read(key: _keyhubId);
}
