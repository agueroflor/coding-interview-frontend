import 'package:flutter/material.dart';

class AppColors {
  // Colores principales
  static const Color primary = Color(0xFFFFA500);
  static const Color primaryYellow = Color(0xFFFFC107);

  // Colores de fondo
  static const Color backgroundBase = Color(0xFFD6E8E8);
  static const Color cardBackground = Colors.white;

  // Colores de texto
  static const Color textPrimary = Colors.black87;
  static final Color textSecondary = Colors.grey[600]!;
  static final Color textTertiary = Colors.grey[700]!;
  static final Color textDark = Colors.grey[800]!;
  static final Color textDarker = Colors.grey[900]!;

  // Colores de borde
  static final Color borderGrey = Colors.grey[300]!;
  static final Color borderGreyDark = Colors.grey[400]!;
  static final Color borderGreyDarker = Colors.grey[700]!;

  // Colores de hint/placeholder
  static final Color hintText = Colors.grey[300]!;

  // Colores de error
  static final Color error = Colors.red[700]!;

  // Colores de sombra
  static Color shadowLight = Colors.black.withValues(alpha: 0.1);
  static Color shadowMedium = Colors.black.withValues(alpha: 0.15);
  static Color shadowDark = Colors.black.withValues(alpha: 0.2);
  static Color shadowDarker = Colors.black.withValues(alpha: 0.25);
  static Color shadowDarkest = Colors.black.withValues(alpha: 0.3);

  // Colores de fondo con transparencia
  static Color cardBackgroundTransparent = Colors.white.withValues(alpha: 0.95);
  static Color disabledBackground = Colors.grey[300]!;

  // Colores de iconos
  static final Color iconGrey = Colors.grey[600]!;

  // Colores específicos de componentes
  static const Color circularIndicator = Color(0xFFFFC107);
  static const Color snackbarBackground = Color(0xFFFFC107);
}
