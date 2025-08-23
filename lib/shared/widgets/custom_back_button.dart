import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? iconColor;
  final double size;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.iconColor,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed:
          onPressed ??
          () {
            // Check if there's a previous route to pop
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              // If no previous route, navigate to home screen
              Navigator.of(context).pushReplacementNamed('/home');
            }
          },
      icon: Image.network(
        'https://i.postimg.cc/zXw3zXnG/Group-32.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.arrow_back,
            color: iconColor ?? Colors.black,
            size: size,
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      ),
    );
  }
}
