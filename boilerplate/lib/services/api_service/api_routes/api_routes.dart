import 'package:dio/dio.dart';

import 'base_api_routes.dart';

enum APIType {
  login(APIMethod.post, "/v1/user/sign-in"),
  signUp(APIMethod.post, "/v1/user/sign-up"),
  getProfile(APIMethod.get, "/v1/user/profile", authorize: true),

  getSystemNotification(APIMethod.get, "/v1/notification/system", authorize: true),
  getCustomerNotification(APIMethod.get, "/v1/notification/customer", authorize: true),

  logout(APIMethod.post, "/v1/user/sign-out", authorize: true),
  updateProfile(APIMethod.put, "/v1/user/profile", authorize: true),
  changePassword(APIMethod.put, "/v1/user/password", authorize: true),
  forgotPassword(APIMethod.put, "/v1/user/password/forgot/:email"),

  getUserExchangeRate(APIMethod.get, "/v1/exchange-rate", authorize: true),
  getWallet(APIMethod.get, "/v1/user/wallet", authorize: true),
  getStatOrder(APIMethod.get, "/v1/stats-order", authorize: true),

  rapidTaobao(APIMethod.get, "/BatchGetItemFullInfo", baseUrl: "https://taobao-tmall1.p.rapidapi.com"),
  rapid1688(APIMethod.get, "/BatchGetItemFullInfo", baseUrl: "https://otapi-1688.p.rapidapi.com"),
  rapidPinduoduo(APIMethod.get, "/BatchGetItemFullInfo", baseUrl: "https://otapi-pinduoduo.p.rapidapi.com"),

  orderProduct(APIMethod.post, "/v1/product/order", authorize: true),
  getOrders(APIMethod.get, "/v1/product/order", authorize: true),
  getOrder(APIMethod.get, "/v1/product/order/:id", authorize: true),
  acceptOrder(APIMethod.put, "/v1/product/order/:id", authorize: true),

  getAddressList(APIMethod.get, "/v1/user/address", authorize: true),
  addAddress(APIMethod.post, "/v1/user/address", authorize: true),
  deleteAddress(APIMethod.delete, "/v1/user/address/:id", authorize: true),
  updateAddress(APIMethod.put, "/v1/user/address/:id", authorize: true),
  updateAddressToDefault(APIMethod.put, "/v1/user/address/:id/default", authorize: true),

  getTransactions(APIMethod.get, "/v1/transaction", authorize: true),
  getTransaction(APIMethod.get, "/v1/transaction/:id", authorize: true),

  depositRequestCreate(APIMethod.post, "/v1/deposit/request", authorize: true),
  getDepositRequests(APIMethod.get, "/v1/deposit/request", authorize: true),
  getDepositRequest(APIMethod.get, "/v1/deposit/request/:id", authorize: true),
  ;
  const APIType(this.method, this.path,
      {this.authorize = false, this.baseUrl});

  final String method;
  final String path;
  final bool? authorize;
  final String? baseUrl;
}

class APIRoute extends APIRouteConfigurable<RequestOptions,
    BaseOptions, APIType> {
  static const String authorizeKey = "Authorize";
  final String v1 = "v1";

  final Map<String, dynamic>? pathParameters;

  APIRoute({
    required super.apiType,
    super.authorize = true,
    super.method = APIMethod.get,
    super.baseUrl,
    super.path = "",
    this.pathParameters,
    super.responseType = ResponseType.json,
  });

  @override
  RequestOptions getConfig(BaseOptions baseOption) {
    method = apiType.method;
    path = apiType.path;
    if(pathParameters?.isNotEmpty == true) {
      path = apiType.path.split("/").map((e) {
        final key = e.replaceAll(":", "");
        if(e.startsWith(":") && pathParameters!.containsKey(key)) {
          e = "${pathParameters![key]}";
        }
        return e;
      }).join("/");
    }
    authorize = apiType.authorize ?? authorize;
    baseUrl = apiType.baseUrl ?? baseUrl;
    final options = Options(
            extra: {APIRoute.authorizeKey: authorize},
            responseType: responseType,
            method: method)
        .compose(
      baseOption,
      path,
    );
    if (baseUrl != null) {
      options.baseUrl = baseUrl!;
    }
    return options;
  }
}

class APIMethod {
  static const get = 'get';
  static const post = 'post';
  static const put = 'put';
  static const patch = 'patch';
  static const delete = 'delete';
}
