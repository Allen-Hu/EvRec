import 'package:flutter/material.dart';
import 'package:background_location/background_location.dart';
import 'package:location_permissions/location_permissions.dart';

class LocationModel extends ChangeNotifier {
  Future<void> init() async {
    // check and request permission
    PermissionStatus status =
        await LocationPermissions().checkPermissionStatus();
    switch (status) {
      case PermissionStatus.unknown:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
        LocationPermissions().requestPermissions(
            permissionLevel: LocationPermissionLevel.locationAlways);
        break;
      case PermissionStatus.granted:
    }

    await BackgroundLocation.setAndroidNotification(
      title: "EvRec 位置服務",
      message: "EvRec 需要此通知才能取得您的位置",
      icon: "@mipmap/ic_launcher",
    );
    await BackgroundLocation.setAndroidConfiguration(1000);
  }

  void start() {
    BackgroundLocation.startLocationService();

    BackgroundLocation.getLocationUpdates((location) {
      print("Got Location");
      print(location.latitude);
      print(location.longitude);
    });
  }

  void stop() {
    BackgroundLocation.stopLocationService();
  }
}
