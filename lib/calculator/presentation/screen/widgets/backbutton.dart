

import 'package:calculator/calculator/presentation/cubit/calculate_cubit.dart';
import 'package:calculator/utils/enum/enum.dart';
import 'package:calculator/utils/shapes/cancelbutton.dart';
import 'package:calculator/utils/shapes/cancelbuttonsplash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalcBackButton extends StatelessWidget {
  const CalcBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CancelButtonClip(),
      clipBehavior: Clip.hardEdge,
      child: Material(
        child: InkWell(
          onLongPress: () => context
              .read<CalculateCubit>()
              .onEvent(CalculatorEvent.clear, ''),
          onTap: () =>
              context.read<CalculateCubit>().clearLast(),
          hoverColor:
              const Color.fromARGB(255, 246, 223, 223),
          customBorder: CancelButtonSplashClip(),
          child: Container(
            color: const Color.fromARGB(55, 138, 98, 98),
            child: const Icon(
              Icons.close_sharp,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}