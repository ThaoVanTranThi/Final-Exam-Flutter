import 'dart:async';

import 'package:final_exam/bloc/base_bloc.dart';
import 'package:final_exam/models/vehicle.dart';
import 'package:final_exam/services/vehicle_services.dart';

class AddVehicleBloC extends BaseBloC {
  static final AddVehicleBloC _instance = AddVehicleBloC._();
  AddVehicleBloC._() {
    _vehicleServices = VehicleServices();
  }

  static AddVehicleBloC getInstance() {
    return _instance;
  }

  late VehicleServices _vehicleServices;
  late Vehicle _vehicle;

  StreamController<bool> _saveButtonController =
      StreamController<bool>.broadcast();

  Stream<bool> get saveButtonState => _saveButtonController.stream;

  set lincencePlate(String value) {
    _vehicle.licencePlate = value.trim();
    _saveButtonController.sink.add(_vehicle.isFullInformation());
  }

  set seatsNumber(String value) {
    _vehicle.seatsNumber = value.trim();
    _saveButtonController.sink.add(_vehicle.isFullInformation());
  }

  set driver(String value) {
    _vehicle.driver = value.trim();
    _saveButtonController.sink.add(_vehicle.isFullInformation());
  }

  set carCompany(String value) {
    _vehicle.carCompany = value.trim();
    _saveButtonController.sink.add(_vehicle.isFullInformation());
  }

  Future<bool> addVehicle() async {
    showLoading();
    bool result = await _vehicleServices.addVehicle(_vehicle);
    hideLoading();
    return result;
  }

  @override
  void clearData() {
    hideLoading();
    _saveButtonController.sink.add(false);
    _vehicle = Vehicle();
  }

  @override
  void dispose() {
    _saveButtonController.close();
    super.dispose();
  }
}
