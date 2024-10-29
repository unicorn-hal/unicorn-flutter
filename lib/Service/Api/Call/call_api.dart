import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

class CallApi extends ApiCore with Endpoint {
  CallApi() : super(Endpoint.calls);
}
