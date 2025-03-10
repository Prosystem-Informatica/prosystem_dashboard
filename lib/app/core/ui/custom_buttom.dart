import 'package:flutter/material.dart';

enum CustomButtonType { outlined, filled }

class CustomButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final CustomButtonType type;
  final bool disabled;
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.type = CustomButtonType.outlined,
    this.disabled = true,
  }) : super(key: key);

  _getCollors() {
    if (disabled) {
      return const Color(0xFF17191C).withOpacity(0.38);
    } else {
      return const Color(0xFF26A69A);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = disabled
        ? const Color(0xFF0511F2).withOpacity(0.38)
        : const Color(0xFF0511F2);
    Color filledFillColor = disabled
        ? const Color(0xFF17191C).withOpacity(0.12)
        : const Color(0xFF17191C);
    Color filledTextColor =
        disabled ? const Color(0xFF17191C).withOpacity(0.38) : Colors.white;

    Color elevated = _getCollors();
    return type == CustomButtonType.outlined
        ? OutlinedButton(
            onPressed: disabled ? null : onPressed,
            style: ButtonStyle(
              side: WidgetStateProperty.resolveWith<BorderSide>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.disabled)) {
                    return BorderSide(
                      color: const Color(0xFF17191C).withOpacity(0.12),
                      width: 2.0, // Largura da borda
                    );
                  }
                  return const BorderSide(
                    color: Color(0xFF0511F2),
                    width: 1.0,
                  );
                },
              ),
            ),
            child: Text(
              text.toUpperCase(),
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        : TextButton(
            onPressed: disabled ? null : onPressed,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(elevated),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            child: Text(
              text.toUpperCase(),
            ),
          );
  }
}
