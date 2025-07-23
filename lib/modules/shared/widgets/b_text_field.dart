import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BTextField extends HookWidget {
  const BTextField({
    super.key,
    required this.label,
    required this.ctrl,
    required this.isObscure,
    this.isRequired = false,
  });
  final bool isRequired;
  final TextEditingController ctrl;
  final bool isObscure;
  final String label;
  @override
  Widget build(BuildContext context) {
    final isObscureNotifier = useState(true);
    final theme = Theme.of(context);
     final enabledColor = const Color.fromARGB(31, 23, 23, 23);
    return TextField(
      controller: ctrl,
      obscureText: isObscure && isObscureNotifier.value,
      decoration: InputDecoration(
        suffixIcon:
            isObscure
                ? IconButton(
                  onPressed: () {
                    isObscureNotifier.value = !isObscureNotifier.value;
                  },
                  icon: Icon(
                    isObscureNotifier.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: enabledColor,
                  ),
                )
                : null,
        labelText: '$label${isRequired ? '*' : ''}',
        labelStyle: theme.textTheme.labelLarge,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color.fromARGB(31, 23, 23, 23)),
        ),
      ),
    );
  }
}
