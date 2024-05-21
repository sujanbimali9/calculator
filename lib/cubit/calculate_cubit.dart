import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

part 'calculate_state.dart';

class CalculateCubit extends Cubit<CalculateState> {
  final TextEditingController _controller;

  CalculateCubit(final TextEditingController controller)
      : _controller = controller,
        super(CalculateInitial());

  void _calculate() {
    if (_controller.text.isEmpty) return;
    var currentText = _controller.text;
    final openBracket =
        currentText.split('').where((element) => element == '(').length;

    final closeBracket =
        currentText.split('').where((element) => element == ')').length;

    if (openBracket > closeBracket) {
      currentText = currentText + (')' * (openBracket - closeBracket));
    }
    try {
      final equation = currentText
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('−', '-');
      Expression exp = Parser().parse(equation);
      var result = exp
          .simplify()
          .evaluate(EvaluationType.REAL, ContextModel())
          .toString();
      if (result.endsWith('.0')) {
        result = result.substring(0, result.length - 2);
      }
      _controller.text = result;
    } catch (e) {
      emit(InputError(error: 'Invalid input $e'));
    }
  }

  void clearLast() {
    if (_controller.text.isEmpty) return;
    final text = _controller.text.split('');
    text.removeLast();
    _controller.text = text.join();
  }

  void buttonClick(String text) {
    String currentText = _controller.text;

    if (currentText.isEmpty) {
      if (RegExp(r'[*×/=÷%)C]$').hasMatch(text)) return;
      _controller.text = text;
      return;
    }

    String lastText = currentText[currentText.length - 1];

    if (text == '=') {
      _calculate();
      return;
    }

    final operator = RegExp(r'[−+*/×÷%]$');
    final num = RegExp(r'[0-9.]$');

    if (RegExp(r'[)]$').hasMatch(text)) {
      if (RegExp(r'[−+*×/÷().]$').hasMatch(lastText)) return;

      final openBracket =
          currentText.split('').where((element) => element == '(').length;

      final closeBracket =
          currentText.split('').where((element) => element == ')').length;

      if (openBracket > closeBracket) {
        _controller.text = _controller.text + text;
        return;
      }

      return;
    }
    if (lastText == '(' && RegExp(r'[*×/÷%]$').hasMatch(text)) return;
    
    if (text == '(' && !operator.hasMatch(lastText)) {
      _controller.text = '$currentText×$text';
      return;
    }

    if (text == '.') {
      final lastNum = currentText.split(RegExp(r'[+−*×/÷()]'));
      if (lastNum.last.contains('.')) return;
      _controller.text = _controller.text + text;
      return;
    }

    if (text == 'C') {
      _controller.clear();
      return;
    }

    if (num.hasMatch(lastText) ||
        (operator.hasMatch(lastText) && (!operator.hasMatch(text))) ||
        RegExp(r'[()]$').hasMatch(lastText)) {
      _controller.text = _controller.text + text;
    } else if (operator.hasMatch(lastText) && operator.hasMatch(text)) {
      lastText == text
          ? null
          : _controller.text =
              _controller.text.substring(0, _controller.text.length - 1) + text;
    } else {
      emit(InputError(error: ''));
    }
  }
}
