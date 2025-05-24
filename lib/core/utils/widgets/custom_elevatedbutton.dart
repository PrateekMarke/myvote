
import 'package:flutter/material.dart';
import 'package:myvote/core/utils/device/device_utils.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isDisabled;
 

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isDisabled = false,

  });

  @override
  Widget build(BuildContext context) {
    final buttonTheme = Theme.of(context).elevatedButtonTheme.style;

    return SizedBox(
  width: MyDeviceUtils.responsiveWidth(context, 0.65), // 65% of screen width
  height: MyDeviceUtils.responsiveHeight(context, 0.06), // 6% of screen height
  child: ElevatedButton(
    onPressed: isDisabled ? null : onPressed,
    style: buttonTheme,
    child: Text(text, style: buttonTheme?.textStyle?.resolve({})),
  ),
);
  }
}