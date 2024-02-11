import 'package:flutter/material.dart';
import 'package:purchaseassistant/pages/posted/show_post.dart';

import 'package:purchaseassistant/utils/constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isSearch = false;
  bool isDuration = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      isSearch = false;
    });

    // print(isDuration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeBg,
        title: const Text(
          'Purchase Assistant',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearch = !isSearch;
              });
            },
            icon: Icon(
              Icons.search_outlined,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (isSearch)
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: isSearch ? 50 : 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                color: Colors.grey[200],
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "ค้นหา",
                    hintStyle: TextStyle(textBaseline: TextBaseline.alphabetic),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 0, style: BorderStyle.none),
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {},
                ),
              ),
            ),
          SizedBox(
            height: 10,
          ),
          Expanded(child: ShowPost())
        ],
      ),
    );
  }
}
