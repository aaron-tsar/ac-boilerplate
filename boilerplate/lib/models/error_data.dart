
import '../services/api_service/decoder.dart';

abstract class ErrorData extends Decoder<DefaultErrorData> {}

class DefaultErrorData extends ErrorData {
  final String? message;

  DefaultErrorData({this.message});

  @override
  DefaultErrorData decode(Map<String, dynamic> json) =>
      DefaultErrorData(message: json["message"]);
}
