import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ConfirmDialog {
  static Future<bool> show(
    BuildContext context, {
    String title = 'Confirmar',
    String message = '¿Estás seguro de realizar esta acción?',
    String confirmText = 'Sí, continuar',
    String cancelText = 'Cancelar',
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.gray800,
          title: Text(title, style: const TextStyle(color: Colors.white)),
          content: Text(message, style: const TextStyle(color: Colors.white70)),
          actions: <Widget>[
            TextButton(
              child: Text(cancelText, style: const TextStyle(color: Colors.white70)),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDestructive ? AppTheme.red500 : AppTheme.green500,
                foregroundColor: isDestructive ? Colors.white : AppTheme.gray900,
              ),
              child: Text(confirmText),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}
