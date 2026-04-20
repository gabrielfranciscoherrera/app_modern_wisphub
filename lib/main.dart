import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_settings.dart';
import 'core/config/setup_screen.dart';
import 'core/network/api_client.dart';
import 'features/clientes/screens/clientes_screen.dart';
import 'features/facturas/screens/facturas_screen.dart';
import 'features/tickets/screens/tickets_screen.dart';
import 'features/sistema/screens/sistema_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WispHubApp());
}

class WispHubApp extends StatelessWidget {
  const WispHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ISP WispHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
      ),
      home: const _Loader(),
    );
  }
}

class _Loader extends StatefulWidget {
  const _Loader();

  @override
  State<_Loader> createState() => _LoaderState();
}

class _LoaderState extends State<_Loader> {
  bool _checking = true;
  bool _configured = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final ok = await AppSettings.isConfigured();
    setState(() {
      _configured = ok;
      _checking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (!_configured) {
      return SetupScreen(onConfigured: _onConfigured);
    }
    return _buildApp();
  }

  Future<void> _onConfigured() async {
    final dio = await buildApiClient();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ProviderScope(
          overrides: [apiClientProvider.overrideWithValue(dio)],
          child: const _HomeNav(),
        ),
      ),
    );
  }

  Widget _buildApp() {
    return FutureBuilder(
      future: buildApiClient(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return ProviderScope(
          overrides: [apiClientProvider.overrideWithValue(snap.data!)],
          child: const _HomeNav(),
        );
      },
    );
  }
}

class _HomeNav extends StatefulWidget {
  const _HomeNav();

  @override
  State<_HomeNav> createState() => _HomeNavState();
}

class _HomeNavState extends State<_HomeNav> {
  int _index = 0;

  static const _screens = [
    ClientesScreen(),
    FacturasScreen(),
    TicketsScreen(),
    SistemaScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Clientes',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Facturas',
          ),
          NavigationDestination(
            icon: Icon(Icons.support_agent_outlined),
            selectedIcon: Icon(Icons.support_agent),
            label: 'Tickets',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Sistema',
          ),
        ],
      ),
    );
  }
}
