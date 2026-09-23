import 'package:flutter/material.dart';

class AppColors {
  // Paleta oficial Docker Drinks
  static const Color primary = Color(0xFF192A56);
  static const Color primaryDark = Color(0xFF101C3D);
  static const Color primaryLight = Color(0xFF273C75);

  // Acento / Destaque
  static const Color accent = Color(0xFFFDEB37);
  static const Color accentDark = Color(0xFFE5CE00);

  // Background e superfícies
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // Bordas e divisores
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFCBD5E1);

  // Textos
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Status de Pedidos
  static const Color statusPending = Color(0xFF8B5CF6);    // Pendente (Roxo)
  static const Color statusPreparing = Color(0xFFF59E0B);  // Preparando (Laranja)
  static const Color statusInTransit = Color(0xFF3B82F6);  // Em Trânsito (Azul)
  static const Color statusDelivered = Color(0xFF10B981);  // Entregue (Verde)
  static const Color error = Color(0xFFEF4444);            // Erro (Vermelho)
}
