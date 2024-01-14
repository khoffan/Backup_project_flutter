import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:purchaseassistant/pages/auth/login_screen.dart';
import 'package:purchaseassistant/pages/testPage.dart';
import 'package:purchaseassistant/routes/routes.dart';
import '../pages/chat/chat_user_list.dart';
import '../pages/dashboard_screen.dart';
import '../pages/profile/profile_screen.dart';
import '../pages/qrScreen.dart';
import '../services/auth_service.dart';
import '../services/user_provider.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  double amout = 10.0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _NavigateTohome() {
    _onItemTapped(0);
  }

  List<Widget> _widgetOptions = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildSignOutWidget() {
    return Container(
      // Customize this container with your sign-out UI
      child: ElevatedButton(
        onPressed: () async {
          await AuthServices().Signoutuser(context);
          await UserLogin.setLogin(true);
          Navigator.pushReplacementNamed(context, AppRoute.login);
        },
        child: Text("Sign Out"),
      ),
    );
  }

  void initState() {
    super.initState();
    assert(_NavigateTohome != null, "Error: _NavigateTohome is null.");
    if (_NavigateTohome == null) {
      // If _NavigateTohome is null, navigate to the LoginScreen
      _widgetOptions = [buildSignOutWidget()];
    } else {
      _widgetOptions = <Widget>[
        DashboardScreen(),
        ListUserchat(),
        PullToRefreshApp(),
        ProfileScreenApp(myNavigate: _NavigateTohome),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        floatingActionButton: FloatingActionButton(
          child: Text(
            "บริการ",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green,
          onPressed: () {
            // if (amout < 20.00) {
            //   Fluttertoast.showToast(
            //     msg: "เงินคงเหลือไม่เพียงพอ กรุณาเติมเงิน",
            //   );
            //   amout += 5;
            // } else {
            //   Navigator.pushNamed(context, AppRoute.service);
            // }
            Navigator.pushNamed(context, AppRoute.service);
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
                              'หน้าหลัก',
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
                              'แชต',
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
                    // MaterialButton(
                    //   minWidth: 50,
                    //   onPressed: () {
                    //     _onItemTapped(2);
                    //   },
                    //   child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Icon(Icons.qr_code_scanner_rounded,
                    //             color: _selectedIndex == 2
                    //                 ? Colors.green
                    //                 : Colors.grey),
                    //         Text(
                    //           'Scan',
                    //           style: TextStyle(
                    //               color: _selectedIndex == 2
                    //                   ? Colors.green
                    //                   : Colors.grey),
                    //         ),
                    //       ]),
                    // ),
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
                              'ตั้งค่า',
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
