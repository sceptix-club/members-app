import 'package:flutter/material.dart';

import '../../globals/colors.dart';

class LoginCard extends StatelessWidget {
  final Function? onTap;
  final String imgPath;
  const LoginCard({
    required this.onTap,
    required this.imgPath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.blue,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(8),
          color: Colors.transparent,
        ),
        child: Center(child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              padding: const EdgeInsets.all(15),
              child: Image.asset(imgPath),
            );
          },
        )),
      ),
    );
  }
}
