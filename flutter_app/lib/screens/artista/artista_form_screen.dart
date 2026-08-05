import 'package:flutter/material.dart';
import '../../models/artista.dart';
import '../../services/artista_service.dart';
import '../../widgets/success_snackbar.dart';
import '../../theme/app_theme.dart';

class ArtistaFormScreen extends StatefulWidget {
  final Artista? artista;
  const ArtistaFormScreen({Key? key, this.artista}) : super(key: key);

  @override
  _ArtistaFormScreenState createState() => _ArtistaFormScreenState();
}

class _ArtistaFormScreenState extends State<ArtistaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = ArtistaService();
  
  bool _isLoading = false;

  late TextEditingController _nombreController;
  late TextEditingController _generoController;
  late TextEditingController _anioController;
  late TextEditingController _biografiaController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.artista?.nombreArtistico ?? '');
    _generoController = TextEditingController(text: widget.artista?.generoPrincipal ?? '');
    _anioController = TextEditingController(text: (widget.artista?.anioInicio ?? 0) > 0 ? widget.artista!.anioInicio.toString() : '');
    _biografiaController = TextEditingController(text: widget.artista?.biografia ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _generoController.dispose();
    _anioController.dispose();
    _biografiaController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    final data = Artista(
      id: widget.artista?.id ?? 0,
      nombreArtistico: _nombreController.text.trim(),
      generoPrincipal: _generoController.text.trim(),
      biografia: _biografiaController.text.trim(),
      anioInicio: int.tryParse(_anioController.text.trim()) ?? 0,
      estado: widget.artista?.estado ?? true,
    );

    try {
      if (widget.artista == null) {
        await _service.createArtista(data);
        if (mounted) SnackbarHelper.showSuccess(context, 'Artista creado exitosamente');
      } else {
        await _service.updateArtista(widget.artista!.id, data);
        if (mounted) SnackbarHelper.showSuccess(context, 'Artista actualizado exitosamente');
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
        title: Text(widget.artista == null ? 'Crear Artista' : 'Editar Artista'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildField('Nombre Artístico', _nombreController, TextInputType.text),
              const SizedBox(height: 16),
              _buildField('Género Principal', _generoController, TextInputType.text),
              const SizedBox(height: 16),
              _buildField('Año de Inicio', _anioController, TextInputType.number),
              const SizedBox(height: 16),
              _buildField('Biografía', _biografiaController, TextInputType.multiline, maxLines: 3, isRequired: false),
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

  Widget _buildField(String label, TextEditingController controller, TextInputType type, {int maxLines = 1, bool isRequired = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: type,
          maxLines: maxLines,
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
}
