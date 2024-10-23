import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

class DepartmentApi extends ApiCore with Endpoint {
  DepartmentApi() : super(Endpoint.departments);
}
