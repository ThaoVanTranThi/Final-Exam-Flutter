import 'package:final_exam/bloc/edit_vehicle_bloc.dart';
import 'package:final_exam/bloc/home_bloc.dart';
import 'package:final_exam/models/vehicle.dart';
import 'package:final_exam/utils/app_color.dart';
import 'package:final_exam/utils/app_dialog.dart';
import 'package:final_exam/utils/app_text_style.dart';
import 'package:final_exam/utils/string_util.dart';
import 'package:final_exam/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class EditVehicleScreen extends StatefulWidget {
  final Vehicle vehicle;
  const EditVehicleScreen({Key? key, required this.vehicle}) : super(key: key);

  @override
  _EditVehicleScreenState createState() => _EditVehicleScreenState();
}

class _EditVehicleScreenState extends State<EditVehicleScreen> {
  TextEditingController _lincencePlateController = TextEditingController();
  TextEditingController _seatsNumberController = TextEditingController();
  TextEditingController _driverController = TextEditingController();
  TextEditingController _carCompanyController = TextEditingController();
  FocusNode _seatsNumberNode = FocusNode();
  FocusNode _driverNode = FocusNode();
  FocusNode _carCompanyNode = FocusNode();
  EditVehicleBloC _editBloC = EditVehicleBloC.getInstance();
  late Vehicle vehicle;

  @override
  void initState() {
    _editBloC.clearData();
    _editBloC.vehicle = widget.vehicle;
    vehicle = widget.vehicle;
    _lincencePlateController.text = '${vehicle.licencePlate}';
    _seatsNumberController.text = '${vehicle.seatsNumber}';
    _driverController.text = '${vehicle.driver}';
    _carCompanyController.text = '${vehicle.carCompany}';
    super.initState();
  }

  @override
  void dispose() {
    _lincencePlateController.dispose();
    _seatsNumberController.dispose();
    _driverController.dispose();
    _carCompanyController.dispose();
    _seatsNumberNode.dispose();
    _driverNode.dispose();
    _carCompanyNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Stack(
        children: [
          Scaffold(
            appBar: _buildAppBar(context),
            backgroundColor: Theme.of(context).backgroundColor,
            resizeToAvoidBottomInset: true,
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _lincencePlateController,
                          labelText: 'Biển số xe',
                          onChanged: (value) => _editBloC.lincencePlate = value,
                          onSubmitted: (value) {
                            _seatsNumberNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _seatsNumberController,
                          focusNode: _seatsNumberNode,
                          labelText: 'Số chỗ ngồi',
                          keyboardType: TextInputType.number,
                          onChanged: (value) => _editBloC.seatsNumber = value,
                          onSubmitted: (value) {
                            _driverNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _driverController,
                          focusNode: _driverNode,
                          labelText: 'Tài xế',
                          keyboardType: TextInputType.name,
                          onChanged: (value) => _editBloC.driver = value,
                          onSubmitted: (value) {
                            _carCompanyNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _carCompanyController,
                          focusNode: _carCompanyNode,
                          labelText: 'Hãng xe',
                          keyboardType: TextInputType.name,
                          onChanged: (value) => _editBloC.carCompany = value,
                          onSubmitted: (value) {},
                        ),
                        SizedBox(height: 18.0),
                      ],
                    ),
                  ),
                ),
                _saveButton(context),
              ],
            ),
          ),
          _loadingState(context),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      leading: BackButton(),
      title: Text(
        'Thông tin phương tiện',
        style: AppTextStyle.mediumBlack1A.copyWith(fontSize: 18),
      ),
      centerTitle: true,
    );
  }

  Widget _saveButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: AppColor.colorWhite,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        disabledColor: AppColor.colorGrey97,
        minWidth: double.infinity,
        height: 54,
        color: AppColor.colorDarkBlue,
        onPressed: updateVehicle,
        child: Text(
          'Cập nhật',
          style: TextStyle(
            color: AppColor.colorWhite,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        padding: EdgeInsets.all(0),
      ),
    );
  }

  Widget _loadingState(BuildContext context) {
    return StreamBuilder<bool>(
        stream: _editBloC.loadingState,
        builder: (_, snapshot) {
          bool isLoading = snapshot.data ?? false;
          if (isLoading) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: AppColor.colorGrey97.withOpacity(0.5),
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }
          return SizedBox.shrink();
        });
  }

  void updateVehicle() {
    WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
    _editBloC.updateVehicle().then((success) {
      HomeBloC.getInstance().getListVehicle();
      showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return succesfulMessageDialog(context, content: 'Cập nhật');
        },
      ).then((value) => Navigator.pop(context));
    }).catchError((error) {
      _editBloC.hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(StringUtil.stringFromException(error))));
    });
  }
}
