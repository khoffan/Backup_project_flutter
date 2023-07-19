import 'package:flutter/material.dart';

const List<String> list = <String>[
  'ศูนย์อาหารโรงช้าง',
  'ภายในเขตหอพักนักศึกษา',
  'ภายในมหาวิทยาลัยสงขลานครินทร์',
  'ตลาดศรีตรัง',
  'โลตัส สาขา ม.อ.',
  'สถานีขนส่ง หาดใหญ่',
  'เซนทรัลเฟตติวัลหาดใหญ่'
];

void main() => runApp(const DropdownButtonApp());

class DropdownButtonApp extends StatelessWidget {
  const DropdownButtonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const DropdownButtonExample();
  }
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      menuMaxHeight: 150,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple, fontSize: 14.0),
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
