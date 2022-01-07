import 'dart:convert';

import 'package:final_exam/models/vehicle.dart';
import 'package:final_exam/services/file_services.dart';
import 'package:flutter/services.dart';

class VehicleServices extends FileServices {
  final String fileName = 'vehicle.json';

  ///trả về default data từ assets nếu không có dữ liệu từ file
  Future<List<Vehicle>> getListVehicle() async {
    try {
      String data = await readData(fileName);
      List jsonData = json.decode(data);
      return jsonData.map<Vehicle>((e) => Vehicle.fromJson(e)).toList();
    } catch (error) {
      String vehicleData =
          await rootBundle.loadString('assets/json/vehicle_data.json');
      await writeData(fileName, vehicleData);
      List jsonData = json.decode(vehicleData);
      return jsonData.map<Vehicle>((e) => Vehicle.fromJson(e)).toList();
    }
  }

  Future<bool> addVehicle(Vehicle vehicle) async {
    List<Vehicle> listUser = await getListVehicle();
    int index = listUser
        .indexWhere((element) => element.licencePlate == vehicle.licencePlate);
    if (index != -1) {
      throw Exception('Xe đã tồn tại');
    }
    listUser.insert(0, vehicle);
    List<Map<String, dynamic>> list = [];
    listUser.forEach((element) {
      list.add(element.toJson());
    });
    await writeData(fileName, list);
    return true;
  }

  Future<bool> deleteVehicle(Vehicle vehicle) async {
    List<Vehicle> listUser = await getListVehicle();
    int index = listUser
        .indexWhere((element) => element.licencePlate == vehicle.licencePlate);
    if (index == -1) {
      throw Exception('Xe không tồn tại');
    }
    listUser.removeAt(index);
    List<Map<String, dynamic>> list = [];
    listUser.forEach((element) {
      list.add(element.toJson());
    });
    await writeData(fileName, list);
    return true;
  }

  Future<bool> editVehicle(Vehicle vehicle) async {
    List<Vehicle> listUser = await getListVehicle();
    int index = listUser
        .indexWhere((element) => element.licencePlate == vehicle.licencePlate);
    if (index == -1) {
      throw Exception('Xe không tồn tại');
    }
    listUser[index] = vehicle;
    List<Map<String, dynamic>> list = [];
    listUser.forEach((element) {
      list.add(element.toJson());
    });
    await writeData(fileName, list);
    return true;
  }
}
