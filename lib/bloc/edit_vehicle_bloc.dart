import 'dart:async';

import 'package:final_exam/bloc/base_bloc.dart';
import 'package:final_exam/models/vehicle.dart';
import 'package:final_exam/services/vehicle_services.dart';

class EditVehicleBloC extends BaseBloC {
  static final EditVehicleBloC _instance = EditVehicleBloC._();
  EditVehicleBloC._() {
    _vehicleServices = VehicleServices();
  }

  static EditVehicleBloC getInstance() {
    return _instance;
  }

  late VehicleServices _vehicleServices;
  late Vehicle _vehicle;

  set vehicle(Vehicle value) {
    _vehicle = value;
  }

  set lincencePlate(String value) {
    _vehicle.licencePlate = value;
  }

  set seatsNumber(String value) {
    _vehicle.seatsNumber = value;
  }

  set driver(String value) {
    _vehicle.driver = value;
  }

  set carCompany(String value) {
    _vehicle.carCompany = value;
  }

  Future<bool> updateVehicle() async {
    showLoading();
    bool result = await _vehicleServices.editVehicle(_vehicle);
    hideLoading();
    return result;
  }

  @override
  void clearData() {
    hideLoading();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
