abstract class Decoder<T> {

  T decode(Map<String, dynamic> json);
}
typedef GenericObject<T> = T Function(dynamic _);
