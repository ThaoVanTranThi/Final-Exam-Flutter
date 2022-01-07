import 'dart:async';

import 'package:final_exam/bloc/base_bloc.dart';
import 'package:final_exam/models/vehicle.dart';
import 'package:final_exam/services/vehicle_services.dart';

class HomeBloC extends BaseBloC {
  static final HomeBloC _instance = HomeBloC._();
  HomeBloC._() {
    _studentServices = VehicleServices();
  }

  static HomeBloC getInstance() {
    return _instance;
  }

  late VehicleServices _studentServices;

  StreamController<List<Vehicle>> _listStudentsController =
      StreamController<List<Vehicle>>.broadcast();

  Stream<List<Vehicle>> get listStudentStream => _listStudentsController.stream;

  Future<List<Vehicle>> getListVehicle() async {
    List<Vehicle> list = await _studentServices.getListVehicle();
    _listStudentsController.sink.add(list);
    return list;
  }

  Future<bool> deleteVehicle(Vehicle student) async {
    bool deleteSuccess = await _studentServices.deleteVehicle(student);
    await getListVehicle();
    return deleteSuccess;
  }

  @override
  void clearData() {}

  @override
  void dispose() {
    _listStudentsController.close();
    super.dispose();
  }
}
