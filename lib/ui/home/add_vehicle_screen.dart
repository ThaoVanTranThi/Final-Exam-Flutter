import 'package:final_exam/bloc/add_vehicle_bloc.dart';
import 'package:final_exam/bloc/home_bloc.dart';
import 'package:final_exam/utils/app_color.dart';
import 'package:final_exam/utils/app_dialog.dart';
import 'package:final_exam/utils/app_text_style.dart';
import 'package:final_exam/utils/string_util.dart';
import 'package:final_exam/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({Key? key}) : super(key: key);

  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  TextEditingController _lincencePlateController = TextEditingController();
  TextEditingController _seatsNumberController = TextEditingController();
  TextEditingController _driverController = TextEditingController();
  TextEditingController _carCompanyController = TextEditingController();
  FocusNode _seatsNmberNode = FocusNode();
  FocusNode _driverNode = FocusNode();
  FocusNode _carCompanyNode = FocusNode();
  late AddVehicleBloC _addVehicleBloC;

  @override
  void initState() {
    _addVehicleBloC = AddVehicleBloC.getInstance();
    _addVehicleBloC.clearData();
    super.initState();
  }

  @override
  void dispose() {
    _lincencePlateController.dispose();
    _seatsNumberController.dispose();
    _driverController.dispose();
    _carCompanyController.dispose();
    _seatsNmberNode.dispose();
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
                        textField(
                          context,
                          controller: _lincencePlateController,
                          labelText: 'Biển số xe: ',
                          textCapitalization: TextCapitalization.characters,
                          onChanged: (value) =>
                              _addVehicleBloC.lincencePlate = value,
                          onSubmitted: (value) {
                            _seatsNmberNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _seatsNumberController,
                          labelText: 'Số chỗ ngồi',
                          keyboardType: TextInputType.number,
                          focusNode: _seatsNmberNode,
                          textCapitalization: TextCapitalization.words,
                          maxLength: 60,
                          onChanged: (value) =>
                              _addVehicleBloC.seatsNumber = value,
                          onSubmitted: (value) {
                            _driverNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _driverController,
                          focusNode: _driverNode,
                          labelText: 'Tài xế: ',
                          textCapitalization: TextCapitalization.characters,
                          keyboardType: TextInputType.name,
                          onChanged: (value) => _addVehicleBloC.driver = value,
                          onSubmitted: (value) {
                            _carCompanyNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _carCompanyController,
                          focusNode: _carCompanyNode,
                          labelText: 'Hãng xe: ',
                          textCapitalization: TextCapitalization.characters,
                          keyboardType: TextInputType.name,
                          onChanged: (value) => _addVehicleBloC.carCompany = value,
                          onSubmitted: (value) {
                          },
                        ),
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
        'Thêm phương tiện',
        style: AppTextStyle.mediumBlack1A.copyWith(fontSize: 18),
      ),
      centerTitle: true,
    );
  }

  Widget _saveButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: AppColor.colorWhite,
      child: StreamBuilder<bool>(
          stream: _addVehicleBloC.saveButtonState,
          builder: (_, snapshot) {
            bool isEnable = snapshot.data ?? false;
            return MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              disabledColor: AppColor.colorGrey97,
              minWidth: double.infinity,
              height: 54,
              color: AppColor.colorDarkBlue,
              onPressed: isEnable ? addVehicle : null,
              child: Text(
                'Thêm',
                style: TextStyle(
                  color: AppColor.colorWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              padding: EdgeInsets.all(0),
            );
          }),
    );
  }

  Widget _loadingState(BuildContext context) {
    return StreamBuilder<bool>(
        stream: _addVehicleBloC.loadingState,
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

  void addVehicle() {
    WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
    _addVehicleBloC.addVehicle().then((sucess) {
      HomeBloC.getInstance().getListVehicle();
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return succesfulMessageDialog(context, content: 'Thêm phương tiện');
        },
      ).then((_) {
        Navigator.pop(context);
      });
    }).catchError((error) {
      _addVehicleBloC.hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(StringUtil.stringFromException(error))));
    });
  }
}
