import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sky_cast/weather_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WeatherController controller = Get.put(WeatherController());

    return Scaffold(
      appBar: AppBar(title: const Text('SkyCast Weather')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onSubmitted: controller.updateCity,
              decoration: const InputDecoration(
                labelText: 'Enter City Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => Text(
              'City: ${controller.city}',
              style: const TextStyle(fontSize: 20),
            )),
            Obx(() => Text(
              'Temperature: ${controller.temperature}°C',
              style: const TextStyle(fontSize: 20),
            )),
            Obx(() => Text(
              'Condition: ${controller.condition}',
              style: const TextStyle(fontSize: 20),
            )),
          ],
        ),
      ),
    );
  }
}
