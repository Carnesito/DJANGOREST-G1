import 'package:flutter/material.dart';
import '../../models/genero.dart';
import '../../services/genero_service.dart';
import '../../widgets/success_snackbar.dart';
import '../../theme/app_theme.dart';

class GeneroFormScreen extends StatefulWidget {
  final Genero? genero;
  const GeneroFormScreen({Key? key, this.genero}) : super(key: key);

  @override
  _GeneroFormScreenState createState() => _GeneroFormScreenState();
}

class _GeneroFormScreenState extends State<GeneroFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = GeneroService();
  
  bool _isLoading = false;

  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.genero?.nombre ?? '');
    _descripcionController = TextEditingController(text: widget.genero?.descripcion ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    final data = Genero(
      id: widget.genero?.id ?? 0,
      nombre: _nombreController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      estado: widget.genero?.estado ?? true,
    );

    try {
      if (widget.genero == null) {
        await _service.createGenero(data);
        if (mounted) SnackbarHelper.showSuccess(context, 'Género creado exitosamente');
      } else {
        await _service.updateGenero(widget.genero!.id, data);
        if (mounted) SnackbarHelper.showSuccess(context, 'Género actualizado exitosamente');
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
        title: Text(widget.genero == null ? 'Crear Género' : 'Editar Género'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildField('Nombre', _nombreController, TextInputType.text),
              const SizedBox(height: 16),
              _buildField('Descripción', _descripcionController, TextInputType.multiline, maxLines: 3, isRequired: false),
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
