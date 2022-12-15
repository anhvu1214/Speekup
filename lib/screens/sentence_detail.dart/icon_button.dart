import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speekup_v2/db/category_table.dart';
import 'package:speekup_v2/model/category.dart';

import '../../contants.dart';

class CustomIconButton extends StatefulWidget {
  CustomIconButton(
      {super.key,
      required this.icon,
      required this.onPressed,
      this.iconColor = op60BlackColor,
      this.backgroundColor = lightGrayColor,
      this.borderColor = op60BlackColor,
      this.iconSize = 21,
      this.buttonSize = 28});

  final Widget icon;
  final Function onPressed;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;
  final double iconSize;
  final double buttonSize;

  @override
  _CustomIconButton createState() => _CustomIconButton();
}

class _CustomIconButton extends State<CustomIconButton> {
  // @override
  // void initState() {
  //   super.initState();
  //   setState(() {
  //     ctlInputCategoryName.text = widget.initText;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.buttonSize,
        width: widget.buttonSize,
        decoration: BoxDecoration(
            color: widget.backgroundColor,
            border: Border.all(color: widget.borderColor),
            borderRadius: BorderRadius.circular(50)),
        child: IconButton(
            onPressed: () {
              widget.onPressed();
            },
            iconSize: widget.iconSize,
            color: widget.iconColor,
            padding: EdgeInsets.zero,
            icon: widget.icon));
  }
}
