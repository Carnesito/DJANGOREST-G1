import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../screens/dashboard_screen.dart';
import '../screens/disquera/disquera_list_screen.dart';
import '../screens/artista/artista_list_screen.dart';
import '../screens/album/album_list_screen.dart';
import '../screens/cancion/cancion_list_screen.dart';
import '../screens/genero/genero_list_screen.dart';
import '../screens/usuario/usuario_list_screen.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;
  const AppDrawer({Key? key, required this.currentRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.gray900,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.gray800)),
            ),
            child: const Text(
              'GESTIÓN MUSICAL',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _buildNavItem(context, 'Panel Principal', Icons.tv, '/dashboard', const DashboardScreen()),
                _buildNavItem(context, 'Disqueras', Icons.album, '/disqueras', const DisqueraListScreen()),
                _buildNavItem(context, 'Artistas', Icons.mic, '/artistas', const ArtistaListScreen()),
                _buildNavItem(context, 'Álbumes', Icons.library_music, '/albumes', const AlbumListScreen()),
                _buildNavItem(context, 'Canciones', Icons.music_note, '/canciones', const CancionListScreen()),
                _buildNavItem(context, 'Géneros', Icons.category, '/generos', const GeneroListScreen()),
                _buildNavItem(context, 'Usuarios', Icons.security, '/usuarios', const UsuarioListScreen()),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppTheme.gray800)),
            ),
            child: ListTile(
              leading: const Icon(Icons.logout, color: AppTheme.red400),
              title: const Text('Cerrar sesión', style: TextStyle(color: AppTheme.red400)),
              onTap: () {
                Provider.of<AuthProvider>(context, listen: false).logout();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, IconData icon, String route, Widget screen) {
    final bool isSelected = currentRoute.startsWith(route);
    return ListTile(
      leading: Icon(icon, color: isSelected ? AppTheme.green400 : Colors.grey),
      title: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: isSelected ? AppTheme.green400 : Colors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
      ),
      onTap: () {
        if (!isSelected) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => screen),
          );
        } else {
          Navigator.pop(context);
        }
      },
    );
  }
}
