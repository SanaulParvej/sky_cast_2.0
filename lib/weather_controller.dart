import 'package:get/get.dart';

class WeatherController extends GetxController {
  var city = ''.obs;
  var temperature = 0.0.obs;
  var condition = ''.obs;

  void updateCity(String value) {
    city.value = value;
    // পরে এখানে API call implement করা হবে
  }
}
