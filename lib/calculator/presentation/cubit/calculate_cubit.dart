import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:calculator/utils/enum/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:math_expressions/math_expressions.dart';

part 'calculate_state.dart';

class CalculateCubit extends Cubit<CalculateState> {
  final TextEditingController _controller;

  CalculateCubit(final TextEditingController controller)
      : _controller = controller,
        super(CalculateInitial());

  void onEvent(CalculatorEvent event, String input) {
    switch (event) {
      case CalculatorEvent.number:
        _controller.text += input;
        break;
      case CalculatorEvent.operator:
        _handleOperator(input);
        break;
      case CalculatorEvent.clear:
        _controller.clear();
        emit(CalculateInitial());
        break;
      case CalculatorEvent.equals:
        try {
          _calculate();
        } catch (e) {
          emit(InputError(error: 'Invalid input $e'));
        }
        break;
      case CalculatorEvent.decimal:
        _handleDecimal();
        break;
      case CalculatorEvent.openParenthesis:
        _handleOpenParenthesis();
        break;
      case CalculatorEvent.closeParenthesis:
        _handleCloseParenthesis();
        break;
    }
    if (RegExp(r'[+\-−*/÷×%(]').hasMatch(_controller.text)) {
      try {
        _calculate(expression: _controller.text);
      } catch (e) {
        emit(CalculateInitial());
      }
    } else {
      emit(CalculateInitial());
    }
  }

  void clearLast() {
    if (_controller.text.isEmpty) return;
    final selection = _controller.selection;
    final text = _controller.text.split('');
    if (!selection.isValid) {
      log('remove last');

      text.removeLast();
      _controller.text = text.join();
    } else if (selection.start == selection.end) {
      log('cursor');
      if (selection.start != 0) {
        text.removeAt(selection.start - 1);
        _controller.value = _controller.value.copyWith(
            text: text.join(),
            selection: TextSelection(
                baseOffset: selection.start - 1,
                extentOffset: selection.start - 1));
      }
    } else {
      log('range');
      text.removeRange(selection.start, selection.end);
      _controller.value = _controller.value.copyWith(
          text: text.join(),
          selection: TextSelection(
              baseOffset: selection.start, extentOffset: selection.start));
    }
    if (RegExp(r'[+\-−*/÷×%(]').hasMatch(_controller.text)) {
      try {
        _calculate(expression: _controller.text);
      } catch (e) {
        emit(CalculateInitial());
      }
    } else {
      emit(CalculateInitial());
    }
    return;
  }

  void _calculate({String? expression}) {
    var currentText = expression ?? _controller.text;

    if (currentText.isEmpty) return;
    final openBracket =
        currentText.split('').where((element) => element == '(').length;

    final closeBracket =
        currentText.split('').where((element) => element == ')').length;

    if (openBracket > closeBracket) {
      currentText = currentText + (')' * (openBracket - closeBracket));
    }

    currentText = currentText.replaceAllMapped(RegExp(r'\)(\d)'), (match) {
      return ')*${match.group(1)}';
    });

    try {
      final equation = currentText
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('−', '-');
      Expression exp = Parser().parse(equation);
      String result = exp
          .simplify()
          .evaluate(EvaluationType.REAL, ContextModel())
          .toString();

      if (result.endsWith('.0')) {
        result = result.substring(0, result.length - 2);
      }
      expression == null
          ? emit(CalculateInitial())
          : emit(CalculateSuccess(result: result));
      if (expression == null) _controller.text = result;
      return;
    } catch (e) {
      rethrow;
    }
  }

  void _handleOperator(String operator) {
    final selection = _controller.selection;
    var operaorReg = RegExp(r'[+\-−*/÷×%]');

    if (_controller.text.isEmpty ||
        (selection.start == 0 && !RegExp(r'[+\-−]').hasMatch(operator)) ||
        _controller.text.length == selection.end - 1) return;

    if (!_controller.selection.isValid ||
        selection.start == _controller.text.length) {
      String lastChar = _controller.text[_controller.text.length - 1];

      if ((lastChar == '(' && !RegExp(r'[+\-−]').hasMatch(operator))) return;

      if (_controller.text.length > 1 &&
          (_controller.text[_controller.text.length - 2] == '(' &&operaorReg.hasMatch(lastChar)&&
              RegExp(r'[\*/÷×%]').hasMatch(operator))) return;
      if (lastChar == '.') {
        _controller.text += '0';
        return;
      }
      var text = _controller.text;
      if (selection.start != selection.end) {
        final temp = text.split('pattern');
        temp.removeRange(selection.start, selection.end);
        text = temp.join();
      }

      if (operaorReg.hasMatch(lastChar)) {
        _controller.text =
            text.substring(0, _controller.text.length - 1) + operator;
        return;
      }

      _controller.text += operator;
      return;
    } else {
      if (selection.start == 0 &&
          !RegExp(r'[+\-−]').hasMatch(_controller.text[0])) return;

      final isNotSelected = selection.start == selection.end;
      final previousChar = _controller.text[selection.start - 1];
      final nextChar = isNotSelected
          ? _controller.text[selection.start]
          : _controller.text[selection.end];
      // print('${previousChar}${nextChar}');

      if (previousChar == '(') {
        if (RegExp(r'[\*/÷×%)]').hasMatch(operator)) return;
        print('(');
        final text = _controller.text.split('');

        if (!isNotSelected) text.removeRange(selection.start, selection.end);

        text.insert(selection.start, operator);

        _controller.value = _controller.value.copyWith(
            text: text.join(),
            selection: TextSelection(
                baseOffset: selection.start + 1,
                extentOffset: selection.start + 1));
        return;
      }
      if (selection.start > 1 &&
          (_controller.text[selection.start - 2] == '(' &&operaorReg.hasMatch(previousChar)&&
              RegExp(r'[\*/÷×%]').hasMatch(operator))) return;

      if ((RegExp(r'[0-9)]$').hasMatch(previousChar) &&
              RegExp(r'[0-9(]$').hasMatch(nextChar)) ||
          selection.start == 0 ||
          (RegExp(r'[(]').hasMatch(previousChar))) {
        final text = _controller.text.split('');
        if (!isNotSelected) text.removeRange(selection.start, selection.end);

        text.insert(selection.start, operator);

        _controller.value = _controller.value.copyWith(
            text: text.join(),
            selection: TextSelection(
                baseOffset: selection.start + 1,
                extentOffset: selection.start + 1));
        return;
      }
      if (operaorReg.hasMatch(previousChar) || operaorReg.hasMatch(nextChar)) {
        final isPrevious = operaorReg.hasMatch(previousChar);
        final text = _controller.text.split('');

        text.removeAt(isPrevious ? selection.start - 1 : selection.start);
        if (!isNotSelected) text.removeRange(selection.start, selection.end);

        text.insert(
            isPrevious ? selection.start - 1 : selection.start, operator);
        _controller.value = _controller.value.copyWith(
            text: text.join(),
            selection: TextSelection(
                baseOffset: selection.start, extentOffset: selection.start));
        return;
      }
    }
  }

  void _handleDecimal() {
    String currentText = _controller.text;
    if (currentText.isEmpty ||
        RegExp(r'[+\-−*/÷×%()]$').hasMatch(currentText)) {
      _controller.text += '0.';
      return;
    } else {
      final lastNumber = currentText.split(RegExp(r'[-−+*/÷×()]')).last;
      if (!lastNumber.contains('.')) {
        _controller.text += '.';
        return;
      }
    }
  }

  void _handleCloseParenthesis() {
    String currentText = _controller.text;
    final openBracketCount =
        currentText.split('').where((char) => char == '(').length;
    final closeBracketCount =
        currentText.split('').where((char) => char == ')').length;

    if (openBracketCount > closeBracketCount &&
        !RegExp(r'[-−+*/÷×%(.]$').hasMatch(currentText)) {
      _controller.text += ')';
      return;
    }
  }

  void _handleOpenParenthesis() {
    String currentText = _controller.text;
    if (currentText.isEmpty || RegExp(r'[-−+*/÷×%]$').hasMatch(currentText)) {
      _controller.text += '(';
      return;
    }
    final lastChar = currentText[currentText.length - 1];
    if (RegExp(r'[0-9)]$').hasMatch(lastChar)) {
      _controller.text += '×(';
      return;
    }
    if (RegExp(r'[.]$').hasMatch(lastChar)) {
      _controller.text += '0×(';
      return;
    }
  }
}
