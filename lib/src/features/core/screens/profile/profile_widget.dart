import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:nutriscale/src/constants/colors.dart';

class profileWidget extends StatelessWidget {
  const profileWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  });
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.greenAccent.shade100,
        ),
        child: Icon(icon, color: appBlack),
      ),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing:
          endIcon
              ? Icon(LineAwesomeIcons.angle_right_solid, color: appBlack)
              : null,
    );
  }
}