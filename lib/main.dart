import 'package:calculator/cubit/calculate_cubit.dart';
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
                  child: TextField(
                    // readOnly: true,
                    controller: controller,
                    textAlign: TextAlign.end,
                    focusNode: focusNode,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 40),
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 20),
                        fillColor: Colors.grey[200],
                        suffixIcon: SizedBox(
                          height: 50,
                          width: 80,
                          child: ClipPath(
                            clipper: CancelButtonClip(),
                            clipBehavior: Clip.hardEdge,
                            child: Material(
                              child: InkWell(
                                onLongPress: () => context
                                    .read<CalculateCubit>()
                                    .buttonClick('C'),
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
                          ),
                        ),
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                        errorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none),
                  ),
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
                      ClacButtons(value: buttonsText[index]))),
            ],
          ),
        ),
      ),
    );
  }
}

final buttonsText = [
  'C',
  '(',
  ')',
  '÷',
  '1',
  '2',
  '3',
  '+',
  '4',
  '5',
  '6',
  '−',
  '7',
  '8',
  '9',
  '×',
  '.',
  '0',
  '%',
  '='
];

class ClacButtons extends StatelessWidget {
  const ClacButtons({
    super.key,
    required this.value,
  });
  final String value;

  @override
  Widget build(BuildContext context) {
    final isNo = RegExp(r'[0-9]$').hasMatch(value);
    final clear = RegExp(r'[C]$').hasMatch(value);
    final equal = RegExp(r'[=]$').hasMatch(value);
    return InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        onTap: () {
          context.read<CalculateCubit>().buttonClick(value);
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
            value,
            style: TextStyle(
                color: isNo
                    ? Colors.black
                    : clear
                        ? Colors.red
                        : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),
        ));
  }
}

class CancelButtonClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final halfHeight = size.height / 2;

    final path = Path();
    path.moveTo(20, 0);
    path.lineTo(5, halfHeight - 5);
    path.quadraticBezierTo(0, halfHeight, 5, halfHeight + 5);
    path.lineTo(20, size.height);
    path.lineTo(size.width - 5, size.height);
    path.lineTo(size.width - 5, 0);
    path.lineTo(20, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class CancelButtonSplashClip extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final halfHeight = rect.height / 2;

    final path = Path();
    path.moveTo(rect.left + 20, rect.top);
    path.lineTo(rect.left + 5, rect.top + halfHeight - 5);
    path.quadraticBezierTo(rect.left, rect.top + halfHeight, rect.left + 5,
        rect.top + halfHeight + 5);
    path.lineTo(rect.left + 20, rect.bottom);
    path.lineTo(rect.right - 5, rect.bottom);
    path.lineTo(rect.right - 5, rect.top);
    path.lineTo(rect.left + 20, rect.top);

    path.close();
    return path;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final halfHeight = rect.height / 2;

    final path = Path();
    path.moveTo(rect.left + 20, rect.top);
    path.lineTo(rect.left + 5, rect.top + halfHeight - 5);
    path.quadraticBezierTo(rect.left, rect.top + halfHeight, rect.left + 5,
        rect.top + halfHeight + 5);
    path.lineTo(rect.left + 20, rect.bottom);
    path.lineTo(rect.right - 5, rect.bottom);
    path.lineTo(rect.right - 5, rect.top);
    path.lineTo(rect.left + 20, rect.top);

    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
