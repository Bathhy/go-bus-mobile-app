class NetworkConstant {
  static String baseurl = "http://$local_back_ip:8000/api";
  static String baseurlMobile = "http://$local_ip:8000/api";
  static String productionUrl =
      "http://192.168.15.247:3000";
  static String register = "/register";
  static String login = "/login";
  static String logout = "/logout";
  static String userProfile = "/user";
  static String eventEndPoint = "/event";
  static String bookingEndpoint = "/booking";
  static String categoryEndpoint = "/category";
  static String payment_method_Endpoint = "/payment_method";
  static String payment_endpoint = "/payment";
  static String ticket_endpoint = "/ticket";

  // static const String _local = "localhost";
  static const local_ip = "192.168.8.104";
  static const local_back_ip = "127.0.0.1";
}

class AdminNetworkConstant {
  static String getAllUser = "/admin/user";
  static String getSummary = "/dashboard";
  static String refund_endpoint = "/refund";
  static String report_endpoint = "/reports";
  static String report_list_endpoint = "/reports_list";
}

String getAdminUrl(String pathEndpoint, {int? id}) {
  if (id == null) {
    return "/admin$pathEndpoint";
  } else {
    return "/admin$pathEndpoint/$id";
  }
}
