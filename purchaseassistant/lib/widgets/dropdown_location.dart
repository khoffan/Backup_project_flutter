import 'package:flutter/material.dart';

// ไม่ใช้แล้ว
const List<String> list = <String>[
  'ศูนย์อาหารโรงช้าง',
  'ภายในเขตหอพักนักศึกษา',
  'ภายในมหาวิทยาลัยสงขลานครินทร์',
  'ตลาดศรีตรัง',
  'โลตัส สาขา ม.อ.',
  'สถานีขนส่ง หาดใหญ่',
  'เซนทรัลเฟตติวัลหาดใหญ่'
];

void main() => runApp(const DropdownLocation());

class DropdownLocation extends StatelessWidget {
  const DropdownLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return const DropdownButtonLoca();
  }
}

class DropdownButtonLoca extends StatefulWidget {
  const DropdownButtonLoca({super.key});

  @override
  State<DropdownButtonLoca> createState() => _DropdownButtonLocaState();
}

class _DropdownButtonLocaState extends State<DropdownButtonLoca> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      menuMaxHeight: 150,
      elevation: 16,
      style: const TextStyle(
        color: Colors.deepPurple,
        fontSize: 16.0,
      ),
      // underline: Container(
      isExpanded: true,
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
        print(list.indexOf(value!).toString());
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
