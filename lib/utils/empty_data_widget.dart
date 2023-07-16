import 'package:flutter/material.dart';

class EmptyData extends StatelessWidget {
  const EmptyData({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning,
            size: width * 0.3,
          ),
          Text(
            'Data Kosong',
            style: TextStyle(
              fontSize: width * 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
