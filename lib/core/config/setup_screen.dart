import 'package:flutter/material.dart';
import 'app_settings.dart';

class SetupScreen extends StatefulWidget {
  final VoidCallback onConfigured;
  const SetupScreen({super.key, required this.onConfigured});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlCtrl = TextEditingController();
  final _keyCtrl = TextEditingController();
  bool _saving = false;
  bool _obscure = true;

  @override
  void dispose() {
    _urlCtrl.dispose();
    _keyCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await AppSettings.save(
      apiKey: _keyCtrl.text,
      baseUrl: _urlCtrl.text,
    );
    setState(() => _saving = false);
    widget.onConfigured();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.wifi_tethering,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 12),
                  Text('Configurar WispHub',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    'Ingresa los datos de conexión a tu instancia de WispHub.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _urlCtrl,
                    decoration: const InputDecoration(
                      labelText: 'URL de la API',
                      hintText: 'https://tuempresa.wisphub.net/api/',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.link),
                    ),
                    keyboardType: TextInputType.url,
                    autocorrect: false,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Ingresa la URL de la API';
                      }
                      final uri = Uri.tryParse(v.trim());
                      if (uri == null || !uri.hasScheme) {
                        return 'URL inválida (debe empezar con https://)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _keyCtrl,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: 'API Key',
                      hintText: 'xxxx.xxxxxxxxxxxxxxxxxxxxxxxx',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.vpn_key),
                      suffixIcon: IconButton(
                        icon: Icon(
                            _obscure ? Icons.visibility : Icons.visibility_off),
                        onPressed: () =>
                            setState(() => _obscure = !_obscure),
                      ),
                    ),
                    autocorrect: false,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Ingresa el API Key'
                        : null,
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Conectar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
