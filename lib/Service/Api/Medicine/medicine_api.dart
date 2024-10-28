import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

class MedicineApi extends ApiCore with Endpoint {
  MedicineApi() : super(Endpoint.medicines);
}
