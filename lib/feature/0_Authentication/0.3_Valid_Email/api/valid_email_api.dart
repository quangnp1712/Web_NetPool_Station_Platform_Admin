//! Valid Email !//
import 'package:web_netpool_station_platform_admin/core/network/api/api_endpoints.dart';

class ValidEmailApi {
  final String SendVerificationCodeUrl =
      "$domainUrl/v1/pub/email-verification/send";
  final String VerifyEmailUrl = "$domainUrl/v1/pub/email-verification/verify";
}
