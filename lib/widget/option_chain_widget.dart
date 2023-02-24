
import 'package:flutter/material.dart';

import '../constants/constant.dart';
class OptionChainTitle extends StatelessWidget {
  const OptionChainTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Container(
          alignment: Alignment.center,
          width: (MediaQuery.of(context).size.width / 5) * 2,
          height: 40.0,
          color: Colors.black,
          child: Text(Strings.call.toUpperCase(), style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / 5,
          height: 40.0,
          color: Colors.black,
          child: const Text(Strings.strikePrice,
              style: TextStyle(color: Colors.white)),
        ),
        Container(
          alignment: Alignment.center,
          width: (MediaQuery.of(context).size.width / 5) * 2,
          height: 40.0,
          color: Colors.black,
          child: Text(Strings.put.toUpperCase(), style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
