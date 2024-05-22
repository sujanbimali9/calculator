
import 'package:calculator/calculator/presentation/cubit/calculate_cubit.dart';
import 'package:calculator/calculator/presentation/screen/widgets/calculator_buttons.dart';
import 'package:calculator/calculator/presentation/screen/widgets/inputfield.dart';
import 'package:calculator/utils/buttontext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(context) {
    final FocusNode focusNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Calculator'),
      ),
      body: BlocListener<CalculateCubit, CalculateState>(
        listener: (context, state) {
          if (state is InputError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Spacer(),
              SizedBox(
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    focusNode.requestFocus();
                  },
                  child: InputField(controller: controller, focusNode: focusNode),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(),
              const SizedBox(height: 20),
              GridView.builder(
                  itemCount: buttonsText.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisExtent: 50,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10),
                  itemBuilder: ((context, index) =>
                      ClacButtons(text: buttonsText[index]))),
            ],
          ),
        ),
      ),
    );
  }
}
