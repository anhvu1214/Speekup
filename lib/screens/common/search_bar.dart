
import 'package:flutter/material.dart';

import '../../contants.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  FocusNode _focus = FocusNode();
  TextEditingController _controller = TextEditingController();
  bool _isTapped = false;

  void _handleTap() {
    setState(() {
      _isTapped = !_isTapped;
    });
  }

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isTapped = !_isTapped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
            // onTap: _handleTap,
            onPanCancel: () {
              _isTapped = false;
            },
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _isTapped ? primaryColor : lightBlackColor,
                  )),
              child: TextField(
                // onTap: _handleTap,
                focusNode: _focus,
                decoration: InputDecoration(
                    hintText: "Tìm kiếm",
                    contentPadding: EdgeInsets.all(16),
                    hintStyle: TextStyle(fontSize: 14),
                    suffixIcon: Icon(
                      Icons.search,
                      color: _isTapped ? primaryColor : lightBlackColor,
                    ),
                    border: InputBorder.none),
              ),
            ));
  }
}
