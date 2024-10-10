import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:http/http.dart' as http;


import 'package:package_info_plus/package_info_plus.dart';

class AppVersionChecker {
  /// The current version of the app.
  /// if [currentVersion] is null the [currentVersion] will take the Flutter package version
  final String? currentVersion;

  /// The id of the app (com.exemple.your_app).
  /// if [appId] is null the [appId] will take the Flutter package identifier
  final String? appId;

  bool gitHub = false;

  AppVersionChecker({
    this.currentVersion,
    this.appId,
    this.gitHub = false,
  });

  Future<AppVersionCheckerResult> checkUpdate() async {
    PackageInfo  packageInfo = await PackageInfo.fromPlatform();
    final _currentVersion = currentVersion ?? packageInfo.version;
    final _packageName = appId ?? packageInfo.packageName;

    if (gitHub) {
      return await _checkGithub(_currentVersion,_packageName);
    } else {
      throw UnimplementedError();
    }
  }
}

Future<AppVersionCheckerResult> _checkGithub(String currentVersion, String packageName) async {
  String? errorMsg;
  String? newVersion;
  String? url;
  var uri = Uri.https('api.github.com','repos/Baptou88/flutter_application_3/releases/latest');
  try {
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      errorMsg = "Unable to find $uri";
    } else {
      final jsonObj = jsonDecode(response.body);
      //log(jsonObj.toString());
      if (jsonObj['name']!= null) {
        newVersion = jsonObj['name'];
        url = jsonObj['html_url'];
      }
    }
  } catch (e) {
    errorMsg = '$e';
  }
  return AppVersionCheckerResult(currentVersion, newVersion, url, errorMsg);
}

class AppVersionCheckerResult {
  /// return the current app version
  final String currentVersion;

  /// return the new app version
  String? newVersion;

  ///return the app url
  final String? appUrl;

  final String? errorMessage;


  AppVersionCheckerResult(
    this.currentVersion,
    this.newVersion,
    this.appUrl,
    this.errorMessage,
  );

  bool get canUpdate{
    newVersion = newVersion?.substring(1);
    log('new version $newVersion');
    log('current $currentVersion');
    log('appurl $appUrl');

    if (newVersion == currentVersion) {
      return false;
    }

    return _shouldUpdate(currentVersion, (newVersion ?? currentVersion));
  }

  bool _shouldUpdate(String versionA, String versionB) {
    final versionNumbersA =
        versionA.split(".").map((e) => int.tryParse(e) ?? 0).toList();
    final versionNumbersB =
        versionB.split(".").map((e) => int.tryParse(e) ?? 0).toList();

    final int versionASize = versionNumbersA.length;
    final int versionBSize = versionNumbersB.length;
    int maxSize = math.max(versionASize, versionBSize);

    for (int i = 0; i < maxSize; i++) {
      if ((i < versionASize ? versionNumbersA[i] : 0) >
          (i < versionBSize ? versionNumbersB[i] : 0)) {
        return false;
      } else if ((i < versionASize ? versionNumbersA[i] : 0) <
          (i < versionBSize ? versionNumbersB[i] : 0)) {
        return true;
      }
    }
    return false;
  }
}