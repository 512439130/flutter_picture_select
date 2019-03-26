import 'package:simple_permissions/simple_permissions.dart';

/**
 * 权限请求辅助类
 */
class PermissionUtil {


  //检查权限（false：未开启，true：开启）
  static Future<bool> checkPermission(Permission permission) async {
    final res = await SimplePermissions.checkPermission(permission);
    print("permission is " + res.toString());
    return res;
  }

  //获取权限
   static Future<PermissionStatus> requestPermission(Permission permission) async {
    final res = await SimplePermissions.requestPermission(permission);
    print("permission request result is " + res.toString());
    return res;
  }

  //查看权限状态（PermissionStatus.denied：被拒绝，PermissionStatus.authorized：已开启）
  static Future<PermissionStatus> getPermissionStatus(Permission permission) async {
    final res = await SimplePermissions.getPermissionStatus(permission);
    print("permission status is " + res.toString());
    return res;
  }

  //打开设置页面
  static  openPermissionSetting() async {
    await SimplePermissions.openSettings();

  }
}
