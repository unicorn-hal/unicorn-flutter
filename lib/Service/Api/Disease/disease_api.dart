import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

class DiseaseApi extends ApiCore with Endpoint {
  DiseaseApi() : super(Endpoint.diseases);
}
