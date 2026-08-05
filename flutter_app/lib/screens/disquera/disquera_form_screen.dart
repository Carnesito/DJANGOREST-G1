import 'package:flutter/material.dart';
import '../../models/disquera.dart';
import '../../services/disquera_service.dart';
import '../../widgets/success_snackbar.dart';
import '../../theme/app_theme.dart';

class DisqueraFormScreen extends StatefulWidget {
  final Disquera? disquera;
  const DisqueraFormScreen({Key? key, this.disquera}) : super(key: key);

  @override
  _DisqueraFormScreenState createState() => _DisqueraFormScreenState();
}

class _DisqueraFormScreenState extends State<DisqueraFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = DisqueraService();
  
  bool _isLoading = false;

  late TextEditingController _nombreController;
  late TextEditingController _paisController;
  late TextEditingController _anioController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.disquera?.nombre ?? '');
    _paisController = TextEditingController(text: widget.disquera?.paisOrigen ?? '');
    _anioController = TextEditingController(text: (widget.disquera?.anioFundacion ?? 0) > 0 ? widget.disquera!.anioFundacion.toString() : '');
    _emailController = TextEditingController(text: widget.disquera?.emailContacto ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _paisController.dispose();
    _anioController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    final disqueraData = Disquera(
      id: widget.disquera?.id ?? 0,
      nombre: _nombreController.text.trim(),
      paisOrigen: _paisController.text.trim(),
      anioFundacion: int.tryParse(_anioController.text.trim()) ?? 0,
      emailContacto: _emailController.text.trim(),
      estado: widget.disquera?.estado ?? true,
    );

    try {
      if (widget.disquera == null) {
        await _service.createDisquera(disqueraData);
        if (mounted) SnackbarHelper.showSuccess(context, 'Disquera creada exitosamente');
      } else {
        await _service.updateDisquera(widget.disquera!.id, disqueraData);
        if (mounted) SnackbarHelper.showSuccess(context, 'Disquera actualizada exitosamente');
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
        title: Text(widget.disquera == null ? 'Crear Disquera' : 'Editar Disquera'),
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
              _buildField('País de Origen', _paisController, TextInputType.text),
              const SizedBox(height: 16),
              _buildField('Año de Fundación', _anioController, TextInputType.number),
              const SizedBox(height: 16),
              _buildField('Email', _emailController, TextInputType.emailAddress),
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
}
