import 'package:flutter/material.dart';
import 'package:speekup_v2/screens/common/search_bar.dart';

import '../../../contants.dart';

final List<String> list = [
  'Trái với quan điểm chung của số đông, Lorem Ipsum không phải chỉ là một đoạn văn bản ngẫu nhiên.',
  'Có rất nhiều biến thể của Lorem Ipsum mà bạn có thể tìm thấy, nhưng đa số được biến đổi bằng cách thêm các yếu tố hài hước, các từ ngẫu nhiên có khi không có vẻ gì là có ý nghĩa.n',
  'Sinh hoạt ở nhà',
  'Thủ tục văn bản hành chính',
  'Văn hóa',
  'Mua hàng',
  'Làm quen người khác',
  'Sinh hoạt ở nhà',
  'Thủ tục văn bản hành chính',
  'Văn hóa',
  'Mua hàng',
  'Làm quen người khác',
];

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: SearchBar()),
        Expanded (child: Padding(
            padding: EdgeInsets.all(24),
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(
                height: 16,
              ),
              itemCount: list.length,
              itemBuilder: (context, index) => Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: op20BlackColor,
                    )),
                padding: EdgeInsets.all(16),
                child: Row(
                  // alignment: WrapAlignment.spaceBetween,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded (child: Text(list[index],
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 14))),
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: () {
                        print("adasda");
                      },
                      child: Icon(Icons.more_horiz, color: primaryColor),
                      )
                  ],
                ),
              ),
            )))
      ],
    );
  }
}
