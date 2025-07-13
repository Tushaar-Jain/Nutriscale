import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkManager {
  static Future<bool> isConnected() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
