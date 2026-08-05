import 'package:flutter/material.dart';
import '../../models/genero.dart';
import '../../services/genero_service.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_display.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/success_snackbar.dart';
import '../../theme/app_theme.dart';
import 'genero_form_screen.dart';

class GeneroListScreen extends StatefulWidget {
  const GeneroListScreen({Key? key}) : super(key: key);

  @override
  _GeneroListScreenState createState() => _GeneroListScreenState();
}

class _GeneroListScreenState extends State<GeneroListScreen> {
  final GeneroService _service = GeneroService();
  List<Genero> _data = [];
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
      final data = await _service.getGeneros();
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
      message: '¿Estás seguro de eliminar este registro?',
      isDestructive: true,
    );
    if (!confirmed) return;

    setState(() => _isLoading = true);
    try {
      await _service.deleteGenero(id);
      SnackbarHelper.showSuccess(context, 'Registro eliminado exitosamente');
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
      appBar: AppBar(title: const Text('Géneros')),
      drawer: const AppDrawer(currentRoute: '/generos'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.green500,
        foregroundColor: AppTheme.gray900,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const GeneroFormScreen()),
          );
          if (result == true) _fetchData();
        },
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _data.isEmpty) return const LoadingIndicator(message: 'Cargando géneros...');
    if (_errorMessage.isNotEmpty && _data.isEmpty) {
      return ErrorDisplay(message: _errorMessage, onRetry: _fetchData);
    }
    if (_data.isEmpty) return const EmptyState(message: 'No hay registros disponibles.', icon: Icons.category);

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
              title: Text(item.nombre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text(
                item.descripcion ?? 'Sin descripción',
                style: const TextStyle(color: Colors.white70),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppTheme.indigo400),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => GeneroFormScreen(genero: item)),
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
