import 'package:flutter/material.dart';

class ShowPost extends StatefulWidget {
  const ShowPost({super.key});

  @override
  State<ShowPost> createState() => _ShowPostState();
}

class _ShowPostState extends State<ShowPost> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    child: Image(
                      image: NetworkImage(
                        "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                      ),
                      width: 40.0,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    child: Text("ชื่อทดสอบ นามสกุลลองดู"),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.more_vert,
                    size: 15,
                  ),
                  SizedBox(
                    width: 15,
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text("ทดสอบข้อความโพสรับหิ้วสินค้าจากอเมริกาโน่ 1 ช้อนตักแกง"),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Image(
                  image: NetworkImage(
                      "https://mpics.mgronline.com/pics/Images/556000003471001.JPEG"),
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
