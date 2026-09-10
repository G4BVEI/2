import 'package:flutter/material.dart';

/// Representa um broche/ímã colecionável que o usuário pode conquistar
/// ao comparecer a um evento comunitário.
class Broche {
  final String id;
  final String nome;
  final String descricao;

  /// Emoji usado como ilustração simples do broche (troque por um asset
  /// de imagem depois, se quiser algo mais bonito).
  final String emoji;

  /// Tipo de evento necessário para desbloquear este broche.
  /// Ex: 'bingo', 'baile', 'bazar', 'caminhada', 'cha_da_tarde'.
  /// Se quiser vincular a um evento específico (não um tipo genérico),
  /// use [eventoIdRequerido] em vez de [tipoEventoRequerido].
  final String? tipoEventoRequerido;
  final String? eventoIdRequerido;
  final Color corPrincipal;

  const Broche({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.emoji,
    required this.corPrincipal,
    this.tipoEventoRequerido,
    this.eventoIdRequerido,
  });
}

/// Representa o estado de um broche para um usuário específico:
/// se já foi conquistado e quando.
class BrocheConquistado {
  final Broche broche;
  final bool desbloqueado;
  final DateTime? dataConquista;
  final String? eventoConquistadoNome;

  const BrocheConquistado({
    required this.broche,
    required this.desbloqueado,
    this.dataConquista,
    this.eventoConquistadoNome,
  });
}
