import 'package:calculator/calculator/presentation/cubit/calculate_cubit.dart';
import 'package:calculator/calculator/presentation/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyHome());
}

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return BlocProvider(
      create: (context) => CalculateCubit(controller),
      child: MaterialApp(
        // theme: ThemeData.dark(useMaterial3: true),
        home: HomePage(controller: controller),
      ),
    );
  }
}


