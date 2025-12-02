import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_netpool_station_platform_admin/core/responsive/responsive.dart';
import 'package:web_netpool_station_platform_admin/core/theme/app_colors.dart';
import 'package:web_netpool_station_platform_admin/core/utils/debug_logger.dart';
import 'package:web_netpool_station_platform_admin/core/utils/utf8_encoding.dart';
import 'package:web_netpool_station_platform_admin/feature/0_Authentication/0.1_Authentication/model/account_info_response_model.dart';
import 'package:web_netpool_station_platform_admin/feature/0_Authentication/0.1_Authentication/repository/authentication_repository.dart';
import 'package:web_netpool_station_platform_admin/feature/0_Authentication/0.1_Authentication/shared_preferences/auth_shared_preferences.dart';
import 'package:web_netpool_station_platform_admin/feature/Common/landing_page_top_menu/controller/navigation_controller.dart';
import 'package:web_netpool_station_platform_admin/feature/Common/landing_page_top_menu/widget/side_menu.dart';
import 'package:web_netpool_station_platform_admin/feature/Common/landing_page_top_menu/widget/top_navigation_bar.dart';
import 'package:web_netpool_station_platform_admin/feature/Common/role/models/role_response_model.dart';
import 'package:web_netpool_station_platform_admin/feature/Common/role/repository/role_repository.dart';

class LandingPage extends StatefulWidget {
  LandingPage({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String roleName = "Đang tải...";
  String avatarUrl = "";
  Future<void> _fetchRoleName() async {
    // Đợi lấy dữ liệu thật
    String resultRoleName = await getRole();
    String resultAvatar = await getAvatarUrl();

    // 3. Kiểm tra 'mounted' để tránh lỗi nếu màn hình đã bị đóng trước khi tải xong
    if (mounted) {
      setState(() {
        roleName = resultRoleName; // Cập nhật biến và vẽ lại UI
        avatarUrl = resultAvatar; // Cập nhật biến và vẽ lại UI
      });
    }
  }

  //! Call API GetRole
  Future<String> getRole() async {
    final String roleCode = AuthenticationPref.getRoleCode();
    try {
      var results = await RoleRepository().roles();
      var responseSuccess = results['success'];
      var responseBody = results['body'];
      if (responseSuccess) {
        RoleModelResponse roleModelResponse =
            RoleModelResponse.fromJson(responseBody);

        if (roleModelResponse.data != null) {
          for (var dataRole in roleModelResponse.data!) {
            if (dataRole.roleCode == roleCode) {
              return Utf8Encoding().decode(dataRole.roleName ?? "");
            }
          }
        }
      }
      return roleCode;
    } catch (e) {
      DebugLogger.printLog(e.toString());
      return roleCode;
    }
  }

  //! Call API GetRole
  Future<String> getAvatarUrl() async {
    final int accountId = AuthenticationPref.getAcountId();
    try {
      var results =
          await AuthenticationRepository().getDetailAccount(accountId);
      var responseSuccess = results['success'];
      var responseBody = results['body'];
      if (responseSuccess) {
        AccountInfoModelResponse accountInfoModelResponse =
            AccountInfoModelResponse.fromJson(responseBody);

        if (accountInfoModelResponse.data != null) {
          return accountInfoModelResponse.data?.avatar ?? "";
        }
      }
      return "";
    } catch (e) {
      DebugLogger.printLog(e.toString());
      return "";
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchRoleName();
  }

  @override
  Widget build(BuildContext context) {
    final userName = AuthenticationPref.getUsername();
    return Scaffold(
      key: widget.scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: topNavigationBar(
          context, widget.scaffoldKey, roleName, userName, avatarUrl),
      drawer: const Drawer(
        child: SideMenu(),
      ),
      body: ResponsiveWidget(
          //* Large Screen *//
          largeScreen: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //$ nav bar
              Container(width: 280, child: SideMenu()),

              //$ main body
              Expanded(
                flex: 5,
                child: Container(
                  color: AppColors.bgDark,
                  child: Container(
                    margin: EdgeInsets.only(top: 80),
                    decoration: BoxDecoration(
                      color: AppColors.bgDark,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                      ),
                      border: Border(
                        top: BorderSide(
                          color: AppColors.primaryGlow, // MÀU VIỀN TRÊN
                          width: 1.0, // ĐỘ DÀY VIỀN
                        ),
                        left: BorderSide(
                          color: AppColors.primaryGlow, // MÀU VIỀN TRÁI
                          width: 1.0, // ĐỘ DÀY VIỀN
                        ),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                      ),
                      child: localNavigator(),
                    ),
                  ),
                ),
              )
            ],
          ),
          smallScreen: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.bgDark,
              border: Border(
                top: BorderSide(
                  color: AppColors.primaryGlow, // MÀU VIỀN TRÊN
                  width: 1.0, // ĐỘ DÀY VIỀN
                ),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
              ),
              child: localNavigator(),
            ),
          )),
    );
  }
}
