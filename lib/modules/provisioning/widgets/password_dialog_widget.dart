import 'package:bms_app/modules/shared/widgets/b_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:wifi_scan/wifi_scan.dart';

class PasswordDialogWidget extends HookWidget {
  const PasswordDialogWidget({super.key, required this.item});

  final WiFiAccessPoint item;

  @override
  Widget build(BuildContext context) {
    final ctrl = useTextEditingController();

    final theme = Theme.of(context);
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Text(item.ssid, style: theme.textTheme.bodyLarge),
            BTextField(ctrl: ctrl, isObscure: true, label: 'Password', isRequired: true,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    context.pop(ctrl.text);
                  },
                  child: Text('Connect'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
