
import 'package:boilerplate/services/api_service/api_response/base_api_response.dart';

enum GenericStateType { loading, error, succeed, initial }

class GenericState<T> {
  final GenericStateType type;
  final T? value;
  final ErrorResponse? errorMessage;

  GenericState({required this.type, this.value, this.errorMessage});
}
