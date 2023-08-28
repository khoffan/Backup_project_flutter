import 'package:flutter/material.dart';

class DelivererScreen extends StatefulWidget {
  const DelivererScreen({super.key});

  @override
  State<DelivererScreen> createState() => _DelivererScreenState();
}

class _DelivererScreenState extends State<DelivererScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _txtControllerBody = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deliverer'),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.black38,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: TextFormField(
                      controller: _txtControllerBody,
                      keyboardType: TextInputType.multiline,
                      maxLines: 10,
                      validator: (val) => val!.isEmpty
                          ? 'กรุณาใส่ข้อความก่อนทำการอัปโหลด'
                          : null,
                      decoration: InputDecoration(
                        hintText: 'พิมพ์ข้อความรับหิ้วสินค้า',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: TextButton(
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue),
                    onPressed: () => {
                      if (_formKey.currentState!.validate()) {print('Ok')}
                    },
                    child: Text('อัปโหลด'),
                  ),
                )
              ],
            ),
    );
  }
}
