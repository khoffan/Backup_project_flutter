import 'package:flutter/material.dart';

class PopupMenuScreen extends StatefulWidget {
  const PopupMenuScreen({super.key});

  @override
  State<PopupMenuScreen> createState() => _PopupMenuScreenState();
}

class _PopupMenuScreenState extends State<PopupMenuScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

void _handleMenuItemTap(String selectedItem) {
  // Implement your logic for handling the selected item here
  if (selectedItem == "เข้าสู่ช่องฃแชท") {
    // Handle the "เข้าสู่ช่องฃแชท" action
  } else if (selectedItem == "ตอบกลับ") {
    // Handle the "ตอบกลับ" action
  } else if (selectedItem == "รายงาน") {
    // Handle the "รายงาน" action
  }
}
