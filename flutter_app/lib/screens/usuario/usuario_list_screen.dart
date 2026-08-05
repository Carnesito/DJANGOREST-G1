import 'package:flutter/material.dart';
import '../../models/usuario.dart';
import '../../services/usuario_service.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_display.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/success_snackbar.dart';
import '../../theme/app_theme.dart';
import 'usuario_form_screen.dart';

class UsuarioListScreen extends StatefulWidget {
  const UsuarioListScreen({Key? key}) : super(key: key);

  @override
  _UsuarioListScreenState createState() => _UsuarioListScreenState();
}

class _UsuarioListScreenState extends State<UsuarioListScreen> {
  final UsuarioService _service = UsuarioService();
  List<Usuario> _data = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final data = await _service.getUsuarios();
      setState(() {
        _data = data;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleDelete(int id) async {
    final confirmed = await ConfirmDialog.show(
      context,
      message: '¿Estás seguro de eliminar este usuario?',
      isDestructive: true,
    );
    if (!confirmed) return;

    setState(() => _isLoading = true);
    try {
      await _service.deleteUsuario(id);
      SnackbarHelper.showSuccess(context, 'Usuario eliminado exitosamente');
      _fetchData();
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        SnackbarHelper.showError(context, e.toString().replaceAll('Exception: ', ''));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.blueGray100,
      appBar: AppBar(title: const Text('Usuarios')),
      drawer: const AppDrawer(currentRoute: '/usuarios'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.green500,
        foregroundColor: AppTheme.gray900,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UsuarioFormScreen()),
          );
          if (result == true) _fetchData();
        },
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _data.isEmpty) return const LoadingIndicator(message: 'Cargando usuarios...');
    if (_errorMessage.isNotEmpty && _data.isEmpty) {
      return ErrorDisplay(message: _errorMessage, onRetry: _fetchData);
    }
    if (_data.isEmpty) return const EmptyState(message: 'No hay usuarios disponibles.', icon: Icons.security);

    return RefreshIndicator(
      onRefresh: _fetchData,
      color: AppTheme.green500,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _data.length,
        itemBuilder: (context, index) {
          final item = _data[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(item.username, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text(
                '${item.firstName} ${item.lastName} | ${item.email}',
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppTheme.indigo400),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => UsuarioFormScreen(usuario: item)),
                      );
                      if (result == true) _fetchData();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: AppTheme.red400),
                    onPressed: () => _handleDelete(item.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
