import 'package:bloc/bloc.dart';
import 'package:calculator/utils/enum/enum.dart';
import 'package:flutter/material.dart';
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
        break;
      case CalculatorEvent.equals:
        _calculate();
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
  }

  void clearLast() {
    if (_controller.text.isEmpty) return;
    final text = _controller.text.split('');
    text.removeLast();
    _controller.text = text.join();
  }

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

    currentText = currentText.replaceAllMapped(RegExp(r'\)(\d)'), (match) {
      return ')*${match.group(1)}';
    });
    
    try {
      final equation = currentText
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('−', '-');
      Expression exp = Parser().parse(equation);
      double res = exp.simplify().evaluate(EvaluationType.REAL, ContextModel());

      res = res.roundToDouble();

      var result = res.toString();
      if (result.endsWith('.0')) {
        result = result.substring(0, result.length - 2);
      }
      _controller.text = result;
    } catch (e) {
      emit(InputError(error: 'Invalid input $e'));
    }
  }

  void _handleOperator(String operator) {
    if (_controller.text.isEmpty) return;
    String lastChar = _controller.text[_controller.text.length - 1];

    if ((lastChar == '(' && RegExp(r'[\*/÷×%]').hasMatch(operator))) return;

    if (_controller.text.length > 1 &&
        (_controller.text[_controller.text.length - 2] == '(' &&
            RegExp(r'[\*/÷×%]').hasMatch(operator))) return;
    if (lastChar == '.') {
      _controller.text += '0';
    }

    if (RegExp(r'[+\-−*/÷×%]').hasMatch(lastChar)) {
      _controller.text =
          _controller.text.substring(0, _controller.text.length - 1) + operator;
      return;
    }
    _controller.text += operator;
  }

  void _handleDecimal() {
    String currentText = _controller.text;
    if (currentText.isEmpty ||
        RegExp(r'[+\-−*/÷×%()]$').hasMatch(currentText)) {
      _controller.text += '0.';
    } else {
      final lastNumber = currentText.split(RegExp(r'[-−+*/÷×()]')).last;
      if (!lastNumber.contains('.')) {
        _controller.text += '.';
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
