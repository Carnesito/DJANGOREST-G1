import 'package:flutter/material.dart';
import '../../models/usuario.dart';
import '../../services/usuario_service.dart';
import '../../widgets/success_snackbar.dart';
import '../../theme/app_theme.dart';

class UsuarioFormScreen extends StatefulWidget {
  final Usuario? usuario;
  const UsuarioFormScreen({Key? key, this.usuario}) : super(key: key);

  @override
  _UsuarioFormScreenState createState() => _UsuarioFormScreenState();
}

class _UsuarioFormScreenState extends State<UsuarioFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = UsuarioService();
  
  bool _isLoading = false;

  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _passwordController; // Opcional al crear

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.usuario?.username ?? '');
    _emailController = TextEditingController(text: widget.usuario?.email ?? '');
    _firstNameController = TextEditingController(text: widget.usuario?.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.usuario?.lastName ?? '');
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    // Para simplificar, estamos usando el mismo modelo
    final data = Usuario(
      id: widget.usuario?.id ?? 0,
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
    );

    // En un caso real, la API de Django maneja la contraseña de forma especial
    // Aquí mandamos la contraseña si se digitó
    final Map<String, dynamic> requestData = data.toJson();
    if (_passwordController.text.isNotEmpty) {
      requestData['password'] = _passwordController.text;
    }

    try {
      if (widget.usuario == null) {
        if (_passwordController.text.isEmpty) {
           throw Exception('La contraseña es requerida para nuevos usuarios');
        }
        await _service.createUsuario(Usuario.fromJson(requestData));
        if (mounted) SnackbarHelper.showSuccess(context, 'Usuario creado exitosamente');
      } else {
        await _service.updateUsuario(widget.usuario!.id, Usuario.fromJson(requestData));
        if (mounted) SnackbarHelper.showSuccess(context, 'Usuario actualizado exitosamente');
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
        title: Text(widget.usuario == null ? 'Crear Usuario' : 'Editar Usuario'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildField('Username', _usernameController, TextInputType.text),
              const SizedBox(height: 16),
              _buildField('Email', _emailController, TextInputType.emailAddress),
              const SizedBox(height: 16),
              _buildField('Nombre', _firstNameController, TextInputType.text),
              const SizedBox(height: 16),
              _buildField('Apellido', _lastNameController, TextInputType.text),
              const SizedBox(height: 16),
              _buildField('Contraseña', _passwordController, TextInputType.visiblePassword, isRequired: widget.usuario == null, obscureText: true),
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

  Widget _buildField(String label, TextEditingController controller, TextInputType type, {bool isRequired = true, bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: type,
          obscureText: obscureText,
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
