import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:web_netpool_station_platform_admin/core/router/routes.dart';
import 'package:web_netpool_station_platform_admin/feature/0_Authentication/0.2_Login/bloc/login_bloc.dart';
import 'package:web_netpool_station_platform_admin/feature/0_Authentication/0.2_Login/pages/login_page.dart';
import 'package:web_netpool_station_platform_admin/feature/0_Authentication/0.3_Valid_Email/bloc/valid_email_bloc.dart';
import 'package:web_netpool_station_platform_admin/feature/0_Authentication/0.3_Valid_Email/pages/send_verify_page.dart';
import 'package:web_netpool_station_platform_admin/feature/0_Authentication/0.3_Valid_Email/pages/verify_email_page.dart';
import 'package:web_netpool_station_platform_admin/feature/Common/home_page.dart';
import 'package:web_netpool_station_platform_admin/feature/Common/landing_page/landing_page.dart';

class RouteGenerator {
  final LoginBloc loginPageBloc = LoginBloc();
  final ValidEmailBloc validEmailPageBloc = ValidEmailBloc();

  List<GetPage> routes() {
    return [
      GetPage(
        name: loginPageRoute,
        page: () => BlocProvider<LoginBloc>.value(
            value: loginPageBloc, child: LoginPage()),
      ),
      GetPage(
        name: validEmailPageRoute,
        page: () => BlocProvider<ValidEmailBloc>.value(
            value: validEmailPageBloc, child: ValidEmailPage()),
      ),
      GetPage(
        name: sendValidCodePageRoute,
        page: () => BlocProvider<ValidEmailBloc>.value(
            value: validEmailPageBloc, child: SendValidPage()),
      ),

      GetPage(
        name: HomePage.HomePageRoute,
        page: () => const HomePage(),
      ),

      // MENU //
      // rootRoute ("/") sẽ tự động chuyển hướng đến dashboard

      GetPage(
        name: rootRoute, // "/"
        page: () => LandingPage(),
      ),
    ];
  }
}
