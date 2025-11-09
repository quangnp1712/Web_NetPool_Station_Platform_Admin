import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:web_netpool_station_platform_admin/core/responsive/responsive.dart';
import 'package:web_netpool_station_platform_admin/core/router/routes.dart';
import 'package:web_netpool_station_platform_admin/core/theme/app_colors.dart';
import 'package:web_netpool_station_platform_admin/feature/Common/landing_page/controller/menu_controller.dart';
import 'package:web_netpool_station_platform_admin/feature/Common/landing_page/controller/navigation_controller.dart';
import 'package:web_netpool_station_platform_admin/feature/Common/landing_page/widget/side_menu_item.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      color: AppColors.bgDark,
      child: Column(children: [
        if (ResponsiveWidget.isSmallScreen(context))
          Container(
            height: 80,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/logo_no_bg.png",
                    width: 270,
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView(
            children: [
              //! Mục 1: Tổng quan (Không có con)
              SideMenuItem(
                itemName: dashboardPageName,
                icon: Icons.pie_chart, // Icon từ ảnh
                onTap: () {
                  if (!menuController.isActive(dashboardPageName)) {
                    menuController.changeActiveItemTo(dashboardPageName);
                    if (ResponsiveWidget.isSmallScreen(context)) Get.back();
                    navigationController.navigateAndSyncURL(dashboardPageRoute);
                  }
                },
              ),

              //! Mục 2: Quản lý Tài khoản
              CustomExpansionItem(
                parentName: accountParentName,
                icon: Icons.person_outline,
                children: [
                  //$ 2.1 Danh sách tài khoản - con
                  SideMenuChildItem(
                    itemName: accountListPageName,
                    onTap: () {
                      if (!menuController.isActive(accountListPageName)) {
                        menuController.changeActiveItemTo(accountListPageName,
                            parentName: accountParentName);
                        if (ResponsiveWidget.isSmallScreen(context)) Get.back();
                        navigationController
                            .navigateAndSyncURL(accountListPageRoute);
                      }
                    },
                  ),
                  //$ 2.2 Tạo tài khoản - con
                  SideMenuChildItem(
                    itemName: accountCreatePageName,
                    onTap: () {
                      if (!menuController.isActive(accountCreatePageName)) {
                        menuController.changeActiveItemTo(accountCreatePageName,
                            parentName: accountParentName);
                        if (ResponsiveWidget.isSmallScreen(context)) Get.back();
                        navigationController
                            .navigateAndSyncURL(accountCreatePageRoute);
                      }
                    },
                  )
                ],
              ),
              //! Mục 3: Quản lý Admin - Quản trị vieen
              CustomExpansionItem(
                parentName: adminParentName,
                icon: Icons.person_outline,
                children: [
                  //$ 3.1 Danh sách admin - con
                  SideMenuChildItem(
                    itemName: adminListPageName,
                    onTap: () {
                      if (!menuController.isActive(adminListPageName)) {
                        menuController.changeActiveItemTo(adminListPageName,
                            parentName: adminParentName);
                        if (ResponsiveWidget.isSmallScreen(context)) Get.back();
                        navigationController
                            .navigateAndSyncURL(adminListPageRoute);
                      }
                    },
                  ),

                  //$ 3.2 Tạo admin - con
                  SideMenuChildItem(
                    itemName: adminCreatePageName,
                    onTap: () {
                      if (!menuController.isActive(adminCreatePageName)) {
                        menuController.changeActiveItemTo(adminCreatePageName,
                            parentName: adminParentName);
                        if (ResponsiveWidget.isSmallScreen(context)) Get.back();
                        navigationController
                            .navigateAndSyncURL(adminCreatePageRoute);
                      }
                    },
                  ),
                ],
              ),
              //! Mục 4: Quản lý Station
              CustomExpansionItem(
                parentName: stationParentName,
                icon: Icons.store_outlined,
                children: [
                  //$ 4.1 Duyệt station - con
                  SideMenuChildItem(
                    itemName: stationApprovalPageName,
                    onTap: () {
                      if (!menuController.isActive(stationApprovalPageName)) {
                        menuController.changeActiveItemTo(
                            stationApprovalPageName,
                            parentName: stationParentName);
                        if (ResponsiveWidget.isSmallScreen(context)) Get.back();
                        navigationController
                            .navigateAndSyncURL(stationApprovalPageRoute);
                      }
                    },
                  ),

                  //$ 4.2 Danh sách station - con
                  SideMenuChildItem(
                    itemName: stationListPageName,
                    onTap: () {
                      if (!menuController.isActive(stationListPageName)) {
                        menuController.changeActiveItemTo(stationListPageName,
                            parentName: stationParentName);
                        if (ResponsiveWidget.isSmallScreen(context)) Get.back();
                        navigationController
                            .navigateAndSyncURL(stationListPageRoute);
                      }
                    },
                  ),
                ],
              ),

              //! Mục 5: Quản lý tài chính
              CustomExpansionItem(
                parentName: paymentParentName,
                icon: Icons.category_outlined,
                children: [
                  SideMenuChildItem(
                      itemName: paymentReportPageName,
                      onTap: () {
                        if (!menuController.isActive(paymentReportPageName)) {
                          menuController.changeActiveItemTo(
                              paymentReportPageName,
                              parentName: paymentParentName);
                          if (ResponsiveWidget.isSmallScreen(context))
                            Get.back();
                          navigationController
                              .navigateAndSyncURL(paymentReportPageRoute);
                        }
                      }),
                  SideMenuChildItem(
                      itemName: paymentHistoryPageName,
                      onTap: () {
                        if (!menuController.isActive(paymentHistoryPageName)) {
                          menuController.changeActiveItemTo(
                              paymentHistoryPageName,
                              parentName: paymentParentName);
                          if (ResponsiveWidget.isSmallScreen(context))
                            Get.back();
                          navigationController
                              .navigateAndSyncURL(paymentHistoryPageRoute);
                        }
                      }),
                ],
              ),
            ],
          ),
        ),

        // MỤC ĐĂNG XUẤT (Ở DƯỚI CÙNG)
        Divider(color: Colors.grey[800]),
        SideMenuItem(
          itemName: logoutName,
          icon: Icons.logout, // Icon từ ảnh
          isLogout: true, // Flag để tô màu đỏ
          onTap: () {
            menuController.logout();
          },
        ),
      ]),
    );
  }
}
