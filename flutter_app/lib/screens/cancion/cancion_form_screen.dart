import 'package:flutter/material.dart';
import '../../models/cancion.dart';
import '../../models/album.dart';
import '../../models/artista.dart';
import '../../services/cancion_service.dart';
import '../../services/album_service.dart';
import '../../services/artista_service.dart';
import '../../widgets/success_snackbar.dart';
import '../../theme/app_theme.dart';

class CancionFormScreen extends StatefulWidget {
  final Cancion? cancion;
  const CancionFormScreen({Key? key, this.cancion}) : super(key: key);

  @override
  _CancionFormScreenState createState() => _CancionFormScreenState();
}

class _CancionFormScreenState extends State<CancionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = CancionService();
  final _albumService = AlbumService();
  final _artistaService = ArtistaService();
  
  bool _isLoading = false;
  List<Album> _albumes = [];
  List<Artista> _artistas = [];

  late TextEditingController _tituloController;
  late TextEditingController _duracionController;
  late TextEditingController _precioController;
  int? _selectedAlbum;
  int? _selectedArtista;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.cancion?.titulo ?? '');
    _duracionController = TextEditingController(text: (widget.cancion?.duracionSegundos ?? 0) > 0 ? widget.cancion!.duracionSegundos.toString() : '');
    _precioController = TextEditingController(text: widget.cancion?.precio ?? '');
    
    _selectedAlbum = widget.cancion?.album;
    if (_selectedAlbum == 0) _selectedAlbum = null;
    
    _selectedArtista = widget.cancion?.artista;
    if (_selectedArtista == 0) _selectedArtista = null;

    _loadForeignKeys();
  }

  Future<void> _loadForeignKeys() async {
    try {
      final albumes = await _albumService.getAlbums();
      final artistas = await _artistaService.getArtistas();
      if (mounted) {
        setState(() {
          _albumes = albumes;
          _artistas = artistas;
        });
      }
    } catch (e) {
      // Ignorar errores de carga
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _duracionController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedAlbum == null) {
      SnackbarHelper.showError(context, 'Debe seleccionar un álbum');
      return;
    }
    if (_selectedArtista == null) {
      SnackbarHelper.showError(context, 'Debe seleccionar un artista');
      return;
    }
    
    setState(() => _isLoading = true);
    
    final data = Cancion(
      id: widget.cancion?.id ?? 0,
      titulo: _tituloController.text.trim(),
      duracionSegundos: int.tryParse(_duracionController.text.trim()) ?? 0,
      precio: _precioController.text.trim(),
      album: _selectedAlbum!,
      artista: _selectedArtista!,
      estado: widget.cancion?.estado ?? true,
    );

    try {
      if (widget.cancion == null) {
        await _service.createCancion(data);
        if (mounted) SnackbarHelper.showSuccess(context, 'Canción creada exitosamente');
      } else {
        await _service.updateCancion(widget.cancion!.id, data);
        if (mounted) SnackbarHelper.showSuccess(context, 'Canción actualizada exitosamente');
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        SnackbarHelper.showError(context, e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.gray900,
      appBar: AppBar(
        title: Text(widget.cancion == null ? 'Crear Canción' : 'Editar Canción'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildField('Título', _tituloController, TextInputType.text),
              const SizedBox(height: 16),
              _buildField('Duración (Segundos)', _duracionController, TextInputType.number),
              const SizedBox(height: 16),
              _buildField('Precio', _precioController, const TextInputType.numberWithOptions(decimal: true)),
              const SizedBox(height: 16),
              _buildDropdown('Álbum', _selectedAlbum, _albumes, (val) => setState(() => _selectedAlbum = val)),
              const SizedBox(height: 16),
              _buildDropdownArtista('Artista', _selectedArtista, _artistas, (val) => setState(() => _selectedArtista = val)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSave,
                  child: _isLoading 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppTheme.gray900, strokeWidth: 2))
                    : const Text('GUARDAR'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, TextInputType type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: type,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Ingrese $label',
          ),
          validator: (value) => value == null || value.trim().isEmpty ? 'Este campo es obligatorio' : null,
          enabled: !_isLoading,
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, int? value, List<Album> items, Function(int?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: value,
          dropdownColor: AppTheme.gray800,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(),
          items: items.map((a) {
            return DropdownMenuItem<int>(
              value: a.id,
              child: Text(a.titulo),
            );
          }).toList(),
          onChanged: _isLoading ? null : onChanged,
          validator: (val) => val == null ? 'Seleccione una opción' : null,
        ),
      ],
    );
  }

  Widget _buildDropdownArtista(String label, int? value, List<Artista> items, Function(int?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: value,
          dropdownColor: AppTheme.gray800,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(),
          items: items.map((a) {
            return DropdownMenuItem<int>(
              value: a.id,
              child: Text(a.nombreArtistico),
            );
          }).toList(),
          onChanged: _isLoading ? null : onChanged,
          validator: (val) => val == null ? 'Seleccione una opción' : null,
        ),
      ],
    );
  }
}
