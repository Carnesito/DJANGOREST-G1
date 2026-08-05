import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/album.dart';
import '../../models/disquera.dart';
import '../../services/album_service.dart';
import '../../services/disquera_service.dart';
import '../../widgets/success_snackbar.dart';
import '../../theme/app_theme.dart';

class AlbumFormScreen extends StatefulWidget {
  final Album? album;
  const AlbumFormScreen({Key? key, this.album}) : super(key: key);

  @override
  _AlbumFormScreenState createState() => _AlbumFormScreenState();
}

class _AlbumFormScreenState extends State<AlbumFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = AlbumService();
  final _disqueraService = DisqueraService();
  
  bool _isLoading = false;
  List<Disquera> _disqueras = [];

  late TextEditingController _tituloController;
  late TextEditingController _fechaController;
  late TextEditingController _portadaController;
  int? _selectedDisquera;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.album?.titulo ?? '');
    _fechaController = TextEditingController(text: widget.album?.fechaLanzamiento ?? '');
    _portadaController = TextEditingController(text: widget.album?.portadaUrl ?? '');
    _selectedDisquera = widget.album?.disquera;
    if (_selectedDisquera == 0) _selectedDisquera = null;
    
    _loadDisqueras();
  }

  Future<void> _loadDisqueras() async {
    try {
      final disqueras = await _disqueraService.getDisqueras();
      if (mounted) {
        setState(() {
          _disqueras = disqueras;
        });
      }
    } catch (e) {
      // Ignorar error de carga de disqueras por simplicidad, se podría mostrar alerta
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _fechaController.dispose();
    _portadaController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.green500,
              onPrimary: AppTheme.gray900,
              surface: AppTheme.gray800,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _fechaController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDisquera == null) {
      SnackbarHelper.showError(context, 'Debe seleccionar una disquera');
      return;
    }
    
    setState(() => _isLoading = true);
    
    final data = Album(
      id: widget.album?.id ?? 0,
      titulo: _tituloController.text.trim(),
      fechaLanzamiento: _fechaController.text.trim(),
      portadaUrl: _portadaController.text.trim(),
      disquera: _selectedDisquera!,
      estado: widget.album?.estado ?? true,
    );

    try {
      if (widget.album == null) {
        await _service.createAlbum(data);
        if (mounted) SnackbarHelper.showSuccess(context, 'Álbum creado exitosamente');
      } else {
        await _service.updateAlbum(widget.album!.id, data);
        if (mounted) SnackbarHelper.showSuccess(context, 'Álbum actualizado exitosamente');
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
        title: Text(widget.album == null ? 'Crear Álbum' : 'Editar Álbum'),
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
              _buildDateField('Fecha de Lanzamiento', _fechaController),
              const SizedBox(height: 16),
              _buildField('URL de Portada', _portadaController, TextInputType.url, isRequired: false),
              const SizedBox(height: 16),
              _buildDropdown('Disquera', _selectedDisquera, (val) => setState(() => _selectedDisquera = val)),
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

  Widget _buildField(String label, TextEditingController controller, TextInputType type, {bool isRequired = true}) {
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
          validator: isRequired 
            ? (value) => value == null || value.trim().isEmpty ? 'Este campo es obligatorio' : null
            : null,
          enabled: !_isLoading,
        ),
      ],
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () => !_isLoading ? _selectDate() : null,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'YYYY-MM-DD',
            suffixIcon: const Icon(Icons.calendar_today, color: AppTheme.green400),
          ),
          validator: (value) => value == null || value.trim().isEmpty ? 'Este campo es obligatorio' : null,
          enabled: !_isLoading,
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, int? value, Function(int?) onChanged) {
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
          items: _disqueras.map((d) {
            return DropdownMenuItem<int>(
              value: d.id,
              child: Text(d.nombre),
            );
          }).toList(),
          onChanged: _isLoading ? null : onChanged,
          validator: (val) => val == null ? 'Seleccione una opción' : null,
        ),
      ],
    );
  }
}
