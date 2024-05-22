import 'package:calculator/calculator/presentation/cubit/calculate_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/enum/enum.dart';

class ClacButtons extends StatelessWidget {
  const ClacButtons({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    final isNo = RegExp(r'[0-9]$').hasMatch(text);
    final clear = RegExp(r'[C]$').hasMatch(text);
    final equal = RegExp(r'[=]$').hasMatch(text);
    final operator = RegExp(r'[+\-−*/÷×%]$').hasMatch(text);
    return InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        onTap: () {
          final cubit = context.read<CalculateCubit>();

          switch (text) {
            case 'C':
              cubit.onEvent(CalculatorEvent.clear, text);
              break;
            case '=':
              cubit.onEvent(CalculatorEvent.equals, text);
              break;
            case '.':
              cubit.onEvent(CalculatorEvent.decimal, text);
              break;
            case '(':
              cubit.onEvent(CalculatorEvent.openParenthesis, text);
              break;
            case ')':
              cubit.onEvent(CalculatorEvent.closeParenthesis, text);
              break;
            default:
              if (RegExp(r'[0-9]').hasMatch(text)) {
                cubit.onEvent(CalculatorEvent.number, text);
              } else {
                cubit.onEvent(CalculatorEvent.operator, text);
              }
          }
        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
              color: isNo
                  ? const Color.fromARGB(147, 96, 177, 243)
                  : equal
                      ? const Color.fromARGB(255, 71, 171, 79)
                      : const Color.fromARGB(154, 40, 188, 89),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Text(
            text,
            style: TextStyle(
                color: isNo
                    ? Colors.black
                    : clear
                        ? Colors.red
                        : operator
                            ?const Color.fromARGB(255, 104, 105, 39)
                            : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),
        ));
  }
}
