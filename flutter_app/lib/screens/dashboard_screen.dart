import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.blueGray100, // Matching the React Admin layout bg
      appBar: AppBar(
        title: const Text('Panel Principal'),
      ),
      drawer: const AppDrawer(currentRoute: '/dashboard'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.tv, size: 80, color: AppTheme.gray700),
            SizedBox(height: 16),
            Text(
              'Bienvenido a Gestión Musical',
              style: TextStyle(fontSize: 24, color: AppTheme.gray800, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Selecciona un módulo en el menú lateral',
              style: TextStyle(color: AppTheme.gray700),
            ),
          ],
        ),
      ),
    );
  }
}
