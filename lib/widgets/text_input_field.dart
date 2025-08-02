import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  final TextEditingController controller;
  final double height;
  final bool obscureText;

  const TextInputField({
    super.key,
    required this.controller,
    required this.height,
    required this.obscureText,
  });

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    // CSS-like styling using Flutter's Container and BoxDecoration
    return Container(
      height: widget.height,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
      child: TextField(
        controller: widget.controller,
        obscureText: _obscureText,
        style: const TextStyle(color: Colors.white, fontFamily: 'Inter'),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          border: InputBorder.none,
          suffixIcon:
              widget.obscureText
                  ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                  : null,
        ),
      ),
    );
  }
}
