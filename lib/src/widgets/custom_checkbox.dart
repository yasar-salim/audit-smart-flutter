import 'package:flutter/material.dart';
import 'package:orison/src/utils/app_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCheckbox extends StatefulWidget {
  final bool isChecked;
  final double size;
  final double iconSize;
  final Color selectedColor;
  final Color selectedIconColor;
  final ValueChanged<bool> onSelect;
  final String text;
  final double textFontSize;

  CustomCheckbox(
      { @required this.onSelect,
        this.isChecked,
      this.size,
      this.iconSize,
      this.selectedColor,
      this.selectedIconColor, this.text='I agree with the above terms.', this.textFontSize = 14});

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool _isSelected = false;

  @override
  void initState() {
    _isSelected = widget.isChecked ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
          widget.onSelect(_isSelected);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.fastLinearToSlowEaseIn,
              decoration: BoxDecoration(
                  color: _isSelected
                      ? widget.selectedColor ?? AppConfig.primaryColor
                      : AppConfig.textFieldFillColor,
                  borderRadius: BorderRadius.circular(5.0),
                  border: _isSelected
                      ? null
                      : Border.all(
                          color: AppConfig.textFieldFillColor,
                          width: 2.0,
                        )),
              width: widget.size ?? 30.w,
              height: widget.size ?? 30.w,
              child: _isSelected
                  ? Icon(
                      Icons.check,
                      color: widget.selectedIconColor ?? Colors.white,
                      size: widget.iconSize ?? 22,
                    )
                  : null,
            ),
            SizedBox(width: 10,),
            Expanded(
              child: Text(
                '${widget.text}',
                style: TextStyle(
                  fontSize: widget.textFontSize.sp,
                  color: _isSelected ? AppConfig.primaryButtonColor : AppConfig.hintTextColor,
                  fontWeight: _isSelected ? FontWeight.bold : FontWeight.normal
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
