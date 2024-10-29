import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

class FamilyEmailApi extends ApiCore with Endpoint {
  FamilyEmailApi() : super(Endpoint.familyEmails);
}
