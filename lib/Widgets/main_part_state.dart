import 'dart:math';

import 'package:flutter/material.dart';

class Dice extends StatefulWidget {
  const Dice({super.key});
  @override
  State<Dice> createState() {
    return _DiceState();
  }
}

class _DiceState extends State<Dice> {
  var dynamicValue = "assets/images/dice-1.png";
  var random = Random();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image(
          width: 200,
          image: AssetImage(dynamicValue),
        ),
        const SizedBox(
          height: 20,
        ),
        OutlinedButton(
            onPressed: () {
              _onChangeHandler();
            },
            child: const Text("Change"))
      ],
    );
  }

  _onChangeHandler() {
    setState(() {
      int value = random.nextInt(6) + 1;
      dynamicValue = "assets/images/dice-$value.png";
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
