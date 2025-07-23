import 'package:bms_app/modules/provisioning/service/provisioning_service.dart';
import 'package:bms_app/modules/provisioning/widgets/password_dialog_widget.dart';
import 'package:bms_app/modules/shared/widgets/b_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ProvisioningSettingsScreen extends HookWidget {
  const ProvisioningSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final portController = useTextEditingController(text: '49000');
  
    final service = useMemoized(() => ProvisioningService());
      final deviceWifis = useStream(service.ssidListController.stream);
    final ValueNotifier<String?> error = useState(null);
    return Scaffold(
      appBar: AppBar(title: Text('Device configuration')),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          spacing: 24,
          children: [
            BTextField(
              label: 'Port',
              ctrl: portController,
              isRequired: true,
              isObscure: false,
            ),
            FilledButton(
              onPressed: () async {
                try {
                  error.value = null;
                  final port = int.tryParse(portController.text);
                  if (port == null) {
                    error.value = 'Invalid port';
                    return;
                  }
                  await service.init(port);
                  service.sendSearchMessage();
                } catch (e) {
                  error.value = "Error: ${e.toString()}";
                }
              },
              child: Text('Connect device'),
            ),
            Expanded(
              child: Center(
                child: error.value != null ? Text(error.value!) : SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
