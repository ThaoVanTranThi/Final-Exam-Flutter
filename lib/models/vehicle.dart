
class Vehicle {
  String? licencePlate;
  String? seatsNumber;
  String? driver;
  String? carCompany;

  Vehicle(
      {this.licencePlate,
      this.seatsNumber,
      this.driver,
      this.carCompany});

  Vehicle.fromJson(Map<String, dynamic> json) {
    licencePlate = json['licencePlate'];
    seatsNumber = json['seatsNumber'];
    driver = json['driver'];
    carCompany = json['carCompany'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['licencePlate'] = this.licencePlate;
    data['seatsNumber'] = this.seatsNumber;
    data['driver'] = this.driver;
    data['carCompany'] = this.carCompany;
    return data;
  }

  bool isFullInformation() {
    if (licencePlate == null ||
        seatsNumber == null ||
        driver == null ||
        carCompany == null ) {
      return false;
    }
    return licencePlate!.isNotEmpty &&
        seatsNumber!.isNotEmpty &&
        driver!.isNotEmpty &&
        carCompany!.isNotEmpty;
  }
}
