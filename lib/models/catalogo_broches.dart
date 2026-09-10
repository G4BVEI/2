import 'package:flutter/material.dart';
import 'broche.dart';

/// Catálogo de todos os broches existentes no app.
/// Adicione novos broches aqui conforme os tipos de evento crescerem.
class CatalogoBroches {
  static const List<Broche> todos = [
    Broche(
      id: 'broche_bingo',
      nome: 'Rei do Bingo',
      descricao: 'Compareça a uma tarde de bingo da comunidade.',
      emoji: '🎱',
      tipoEventoRequerido: 'bingo',
      corPrincipal: Color(0xFFE0A72E),
    ),
    Broche(
      id: 'broche_baile',
      nome: 'Pé de Valsa',
      descricao: 'Dance em um baile comunitário.',
      emoji: '💃',
      tipoEventoRequerido: 'baile',
      corPrincipal: Color(0xFFD1477A),
    ),
    Broche(
      id: 'broche_bazar',
      nome: 'Caçador de Ofertas',
      descricao: 'Visite um bazar da comunidade.',
      emoji: '🛍️',
      tipoEventoRequerido: 'bazar',
      corPrincipal: Color(0xFF3E8E7E),
    ),
    Broche(
      id: 'broche_caminhada',
      nome: 'Passo Firme',
      descricao: 'Participe de uma caminhada em grupo.',
      emoji: '🚶',
      tipoEventoRequerido: 'caminhada',
      corPrincipal: Color(0xFF4A7FB5),
    ),
    Broche(
      id: 'broche_cha',
      nome: 'Chá das Boas Conversas',
      descricao: 'Vá a um chá da tarde da comunidade.',
      emoji: '☕',
      tipoEventoRequerido: 'cha_da_tarde',
      corPrincipal: Color(0xFF9B6B43),
    ),
    Broche(
      id: 'broche_carona',
      nome: 'Companhia de Viagem',
      descricao: 'Use uma carona solidária para chegar a um evento.',
      emoji: '🚗',
      tipoEventoRequerido: 'carona',
      corPrincipal: Color(0xFF6C63A6),
    ),
    Broche(
      id: 'broche_frequente',
      nome: 'Presença Cativa',
      descricao: 'Compareça a 5 eventos diferentes.',
      emoji: '⭐',
      corPrincipal: Color(0xFFC98A2C),
    ),
  ];
}
