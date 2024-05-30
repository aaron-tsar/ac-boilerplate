import 'package:boilerplate/models/notification_model.dart';

import '../services/api_service/api_clients/api_client.dart';
import '../services/api_service/api_response/base_api_response.dart';
import '../services/api_service/api_routes/api_routes.dart';

abstract class NotificationRepos {
  Future<(List<NotificationModel>, int)> getSystemNotification({int page = 1, int limit = 10});
  Future<(List<NotificationModel>, int)> getCustomerNotification({int page = 1, int limit = 10});
}

class NotificationReposImpl extends NotificationRepos {
  final BaseAPIClient apiClient;

  NotificationReposImpl(this.apiClient);

  @override
  Future<(List<NotificationModel>, int)> getCustomerNotification({int page = 1, int limit = 10}) async {
    final response = await apiClient.request<APIListResponse<NotificationModel>>(
      params: {
        "page": page,
        "limit": limit,
      },
      route: APIRoute(
        apiType: APIType.getCustomerNotification,
      ),
      create: (res) => APIListResponse<NotificationModel>(
        response: res,
        decodedData: NotificationModel(),
      ),
    );
    return (response.decodedList, response.total ?? 0);
  }

  @override
  Future<(List<NotificationModel>, int)> getSystemNotification({int page = 1, int limit = 10}) async {
    final response = await apiClient.request<APIListResponse<NotificationModel>>(
      params: {
        "page": page,
        "limit": limit,
      },
      route: APIRoute(
        apiType: APIType.getSystemNotification,
      ),
      create: (res) => APIListResponse<NotificationModel>(
        response: res,
        decodedData: NotificationModel(),
      ),
    );
    return (response.decodedList, response.total ?? 0);
  }


}
