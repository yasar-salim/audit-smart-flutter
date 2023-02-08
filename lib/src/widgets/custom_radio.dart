import 'package:flutter/material.dart';
import 'package:orison/src/utils/app_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomRadio extends StatefulWidget {
  final String value;
  final String selectedValue;
  final double size;
  final double iconSize;
  final Color selectedColor;
  final Color selectedIconColor;
  final ValueChanged<String> onSelect;
  final String text;
  final double textFontSize;

  CustomRadio(
      { @required this.onSelect,
        this.value,
      this.size,
      this.iconSize,
      this.selectedColor,
      this.selectedIconColor, this.text='I agree with the above terms.', this.textFontSize = 14, this.selectedValue});

  @override
  _CustomRadioState createState() => _CustomRadioState();
}

class _CustomRadioState extends State<CustomRadio> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.onSelect(widget.value);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: Transform.scale(
                  scale: 1.4,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        unselectedWidgetColor: AppConfig.textFieldFillColor,
                        disabledColor: AppConfig.textFieldFillColor
                    ),
                    child: Radio(
                      value: widget.value,
                      onChanged: (val) {
                        widget.onSelect(val);
                      },
                      groupValue: widget.selectedValue,
                      activeColor: AppConfig.primaryColor,
                    ),
                  )),
            ),
            SizedBox(width: 12,),
            Expanded(
              child: Text(
                '${widget.text}',
                style: TextStyle(
                  fontSize: widget.textFontSize.sp,
                  color: widget.value==widget.selectedValue ? AppConfig.primaryButtonColor : AppConfig.hintTextColor,
                  fontWeight:widget.value==widget.selectedValue ? FontWeight.bold : FontWeight.normal
                ),
                textAlign: TextAlign.left,
              ),
            )
          ],
        ),
      ),
    );
  }
}
