import 'package:calc/button_values.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String num1 = ""; //0-9
  String operand = ""; // + - x /
  String num2 = ""; // 0-9

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        bottom: true,

        child: Column(
          children: [
            //output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),

                  child: Text(
                    "$num1$operand$num2".isEmpty ? "0" : "$num1$operand$num2",

                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),

                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),

            //buttons
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                      width: value == Btn.n0
                          ? screenSize.width / 2
                          : (screenSize.width / 4),
                      height: screenSize.width / 5,
                      child: buildButton(value),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // #######
  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value), //or
        // color: [Btn.del, Btn.clr].contains(value)
        //     ? Colors.blueGrey
        //     : [
        //         Btn.add,
        //         Btn.calc,
        //         Btn.div,
        //         Btn.mul,
        //         Btn.per,
        //         Btn.calc,
        //       ].contains(value)
        //     ? Colors.orange
        //     : Colors.black87,
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(color: Colors.white24),
        ),

        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  //##########
  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }

    if (value == Btn.clr) {
      clearAll();
      return;
    }

    if (value == Btn.per) {
      convertToPercentage();
      return;
    }

    if (value == Btn.calc) {
      calculate();
      return;
    }

    appendValue(value);
  }

  //################ calculate the result
  void calculate() {
    if (num1.isEmpty) return;
    if (operand.isEmpty) return;
    if (num2.isEmpty) return;

    final double number1 = double.parse(num1);
    final double number2 = double.parse(num2);

    var result = 0.0;
    switch (operand) {
      case Btn.add:
        result = number1 + number2;
        break;
      case Btn.mul:
        result = number1 * number2;
        break;
      case Btn.div:
        result = number1 / number2;
        break;
      case Btn.sub:
        result = number1 - number2;
        break;
      default:
    }

    setState(() {
          num1 = "$result";

          if (num1.endsWith(".0")) {
            num1 = num1.substring(0, num1.length - 2);
          }

          operand = "";
          num2 = "";
        });
    }
  

  //################
  void convertToPercentage() {
    if (num1.isNotEmpty && operand.isNotEmpty && num2.isNotEmpty) {
      //calculate before concersion
      //TODO
      // final res = num1 operand num2;
      // num1 = res;
      calculate();
    }

    if (operand.isNotEmpty) {
      return;
    }

    final number = double.parse(num1);
    setState(() {
      num1 = "${(number / 100)}";
      operand = "";
      num2 = "";
    });
  }

  //################
  void delete() {
    if (num2.isNotEmpty) {
      //12323 => 1232
      num2 = num2.substring(0, num2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (num1.isNotEmpty) {
      num1 = num1.substring(0, num1.length - 1);
    }

    setState(() {
      num1;
      num2;
      operand;
    });
  }

  // ##############
  void clearAll() {
    setState(() {
      num1 = "";
      operand = "";
      num2 = "";
    });
  }

  //##########
  // append value to the end.
  void appendValue(String value) {
    //num1  operand   num2
    // 23     +       10

    // if is operand and not "."
    if (value != Btn.dot && int.tryParse(value) == null) {
      //operand pressed
      if (operand.isNotEmpty && num2.isNotEmpty) {
        //TODO calculate the eq before assign new operand
        calculate();
      }
      operand = value;
    }
    // assign value to num1 variable
    else if (num1.isEmpty || operand.isEmpty) {
      //check if vlaue is "."
      // num1 = ""  opernad= "" num1 cant be empty
      if (value == Btn.dot && num1.contains(Btn.dot)) {
        return;
      }
      //num1 is empty= "" or num1 =0
      if (value == Btn.dot && (num1 == Btn.dot || num1.isEmpty)) {
        value = "0.";
      }
      num1 += value;
    }
    // assign value to num2 variable
    else if (num2.isEmpty || operand.isNotEmpty) {
      // num1 = ""  opernad= "" num1 cant be empty
      if (value == Btn.dot && num2.contains(Btn.dot)) {
        return;
      }
      //num1 is empty= "" or num1 =0
      if (value == Btn.dot && (num2 == Btn.dot || num2.isEmpty)) {
        value = "0.";
      }
      num2 += value;
    }

    setState(() {
      // num1 += value;
      // operand += value;
      // num2 += value;
    });
  }

  Color getBtnColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
            Btn.add,
            Btn.calc,
            Btn.div,
            Btn.sub,
            Btn.mul,
            Btn.per,
            Btn.calc,
          ].contains(value)
        ? Colors.orange
        : Colors.black87;
  }
}
