import 'package:flutter/material.dart';
import '../pages/service_screen.dart';
import '../pages/dashboard_screen.dart';
import '../pages/test_setting.dart';
import '../pages/profilePage.dart';
// import '../utils/constants.dart';

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    ),
    Text(
      'Index 1: Chat',
      style: optionStyle,
    ),
    Text(
      'Index 2: Scan',
      style: optionStyle,
    ),
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileScreenApp(),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ServiceScreen(),
            ));
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      minWidth: 50,
                      onPressed: () {
                        _onItemTapped(0);
                      },
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.home_outlined,
                                color: _selectedIndex == 0
                                    ? Colors.green
                                    : Colors.grey),
                            Text(
                              'Home',
                              style: TextStyle(
                                  color: _selectedIndex == 0
                                      ? Colors.green
                                      : Colors.grey),
                            ),
                          ]),
                    ),
                    MaterialButton(
                      minWidth: 50,
                      onPressed: () {
                        _onItemTapped(1);
                      },
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_outlined,
                                color: _selectedIndex == 1
                                    ? Colors.green
                                    : Colors.grey),
                            Text(
                              'Chat',
                              style: TextStyle(
                                  color: _selectedIndex == 1
                                      ? Colors.green
                                      : Colors.grey),
                            ),
                          ]),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      minWidth: 50,
                      onPressed: () {
                        _onItemTapped(2);
                      },
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.qr_code_scanner_rounded,
                                color: _selectedIndex == 2
                                    ? Colors.green
                                    : Colors.grey),
                            Text(
                              'Scan',
                              style: TextStyle(
                                  color: _selectedIndex == 2
                                      ? Colors.green
                                      : Colors.grey),
                            ),
                          ]),
                    ),
                    MaterialButton(
                      minWidth: 50,
                      onPressed: () {
                        _onItemTapped(3);
                      },
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.settings,
                                color: _selectedIndex == 3
                                    ? Colors.green
                                    : Colors.grey),
                            Text(
                              'Setting',
                              style: TextStyle(
                                  color: _selectedIndex == 3
                                      ? Colors.green
                                      : Colors.grey),
                            ),
                          ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}





      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       // backgroundColor: Color.fromARGB(255, 243, 237, 170),
      //       icon: Icon(
      //         Icons.home_outlined,
      //         // color: Colors.blue,
      //       ),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       // backgroundColor: Color.fromARGB(255, 243, 237, 170),
      //       icon: Icon(
      //         Icons.qr_code_scanner_rounded,
      //         // color: Colors.blue,
      //       ),
      //       label: 'scan',
      //     ),
      //     BottomNavigationBarItem(
      //       // backgroundColor: Color.fromARGB(255, 243, 237, 170),
      //       icon: Icon(
      //         Icons.chat_outlined,
      //         // color: Colors.blue,
      //       ),
      //       label: 'chat',
      //     ),
      //     BottomNavigationBarItem(
      //       // backgroundColor: Color.fromARGB(255, 243, 237, 170),
      //       icon: Icon(
      //         Icons.notifications_outlined,
      //         // color: Colors.blue,
      //       ),
      //       label: 'notification',
      //     ),
      //     BottomNavigationBarItem(
      //       // backgroundColor: Color.fromARGB(255, 243, 237, 170),
      //       icon: Icon(
      //         Icons.sensor_occupied_rounded,
      //         // color: Colors.grey,
      //       ),
      //       label: 'profile',
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.amber[800],
      //   unselectedItemColor: themeIcon,
      //   onTap: _onItemTapped,
      // ),
//     );
//   }
// }
