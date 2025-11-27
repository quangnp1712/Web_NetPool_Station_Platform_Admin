import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:web_netpool_station_platform_admin/core/router/routes.dart';
import 'package:web_netpool_station_platform_admin/core/utils/debug_logger.dart';
import 'package:web_netpool_station_platform_admin/core/utils/shared_preferences_helper.dart';
import 'package:web_netpool_station_platform_admin/feature/Common/landing_page_top_menu/repository/landing_repository.dart';
import 'package:web_netpool_station_platform_admin/feature/Common/snackbar/snackbar.dart';

MenuController menuController = MenuController.instance;

class MenuController extends GetxController {
  static MenuController instance = Get.find();
  var activeItem = dashboardPageName.obs;
  var hoverItem = "".obs;

  // MỚI: Thêm biến theo dõi mục cha đang active
  var activeParent = "".obs;

  changeActiveItemTo(String itemName, {String parentName = ""}) {
    activeItem.value = itemName;

    // Cập nhật mục cha đang active
    activeParent.value = parentName;
  }

  onHover(String itemName) {
    if (!isActive(itemName)) hoverItem.value = itemName;
  }

  isHovering(String itemName) => hoverItem.value == itemName;

  isActive(String itemName) => activeItem.value == itemName;

  // MỚI: Hàm kiểm tra xem mục cha có active không
  isParentActive(String parentName) => activeParent.value == parentName;

  logout() async {
    try {
      var results = await LandingRepository().logout();
      var responseMessage = results['message'];
      var responseStatus = results['status'];
      var responseSuccess = results['success'];
      var responseBody = results['body'];

      if (responseSuccess) {
        SharedPreferencesHelper.clearAll();
        Get.offAllNamed(loginPageRoute);
      } else {
        SharedPreferencesHelper.clearAll();
        Get.offAllNamed(loginPageRoute);
        DebugLogger.printLog("$responseMessage - đăng xuất");
      }
      ShowSnackBar("Đăng xuất thành công", true);
    } catch (e) {
      SharedPreferencesHelper.clearAll();
      Get.offAllNamed(loginPageRoute);
      DebugLogger.printLog("đăng xuất: Lỗi $e");
    }
  }
}
