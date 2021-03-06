import 'package:final_exam/bloc/home_bloc.dart';
import 'package:final_exam/models/vehicle.dart';
import 'package:final_exam/ui/home/edit_vehicle_screen.dart';
import 'package:final_exam/utils/app_color.dart';
import 'package:final_exam/utils/app_dialog.dart';
import 'package:final_exam/utils/app_text_style.dart';
import 'package:final_exam/utils/string_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VehicleItem extends StatefulWidget {
  final Animation<double> animation;
  final Vehicle vehicle;
  final Function()? onRemoved;
  const VehicleItem(
      {Key? key,
      required this.vehicle,
      required this.animation,
      this.onRemoved})
      : super(key: key);

  @override
  _VehicleItemState createState() => _VehicleItemState();
}

class _VehicleItemState extends State<VehicleItem> {
  late Vehicle vehicle;
  @override
  void initState() {
    vehicle = widget.vehicle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: widget.animation,
      axis: Axis.vertical,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Color(0xff141A1A1A),
              blurRadius: 32,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    '''${vehicle.licencePlate}''',
                    style: AppTextStyle.mediumBlack1A.copyWith(fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                ),
                _buildButton(context, 'S???a', editVehicle,
                    color: AppColor.colorGreen),
                SizedBox(width: 5.0),
                _buildButton(context, 'Xo??', deleteVehicle,
                    color: AppColor.colorRed),
              ],
            ),
            SizedBox(height: 10.0),
            Text(
              'S??? ch??? ng???i: ${vehicle.seatsNumber}',
              style: AppTextStyle.regularBlack1A,
              textAlign: TextAlign.left,
            ),
            Text(
              'T??i x???: ${vehicle.driver}',
              style: AppTextStyle.regularBlack1A,
              textAlign: TextAlign.left,
            ),
            Text(
              'H??ng xe: ${vehicle.carCompany}',
              style: AppTextStyle.regularBlack1A,
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String label, void Function()? onPressed,
      {Color color = AppColor.colorGreen}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color,
        elevation: 0.0,
      ),
      child: Text(label),
    );
  }

  void editVehicle() {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => EditVehicleScreen(vehicle: vehicle)));
  }

  void deleteVehicle() {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return confirmDialog(
            context, 'Xo??', 'B???n ch???c ch???n mu???n xo?? ph????ng ti???n n??y?');
      },
    ).then((acceptDelete) {
      if (acceptDelete ?? false) {
        HomeBloC.getInstance().deleteVehicle(vehicle).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(StringUtil.stringFromException(error))));
        });
        if (widget.onRemoved != null) {
          widget.onRemoved!.call();
        }
      }
    });
  }
}
