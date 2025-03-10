import 'package:get/get.dart';
import 'package:prosystem_dashboard/app/core/helpers/environments.dart';
import 'package:prosystem_dashboard/app/core/rest/http/http_rest_client.dart';
import 'package:prosystem_dashboard/app/core/rest/rest_client.dart';


class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RestClient>(() => HttpRestClient(baseUrl: Environments.get("URL_BASE") ?? ""), fenix: true);
  }
}