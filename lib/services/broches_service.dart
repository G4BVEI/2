import '../models/broche.dart';
import '../models/catalogo_broches.dart';

/// Representa, de forma simplificada, um evento em que o usuário teve
/// presença confirmada. Ajuste este model quando o app ganhar um
/// sistema real de Evento/Presença — por enquanto ele só define o
/// formato que [BrochesService.calcularBroches] espera receber.
class EventoParticipado {
  final String eventoId;
  final String tipo; // ex: 'bingo', 'baile', 'bazar', 'caminhada'...
  final String titulo;
  final DateTime data;
  final bool usouCaronaSolidaria;

  const EventoParticipado({
    required this.eventoId,
    required this.tipo,
    required this.titulo,
    required this.data,
    this.usouCaronaSolidaria = false,
  });
}

class BrochesService {
  /// Recebe o histórico de presenças confirmadas do usuário e devolve
  /// o status (bloqueado/desbloqueado) de cada broche do catálogo.
  static List<BrocheConquistado> calcularBroches(
    List<EventoParticipado> historico,
  ) {
    final ordenado = [...historico]..sort((a, b) => a.data.compareTo(b.data));

    return CatalogoBroches.todos.map((broche) {
      if (broche.id == 'broche_frequente') {
        final eventosDistintos = ordenado.map((e) => e.eventoId).toSet();
        if (eventosDistintos.length >= 5) {
          return BrocheConquistado(
            broche: broche,
            desbloqueado: true,
            dataConquista: ordenado[4].data,
            eventoConquistadoNome: 'Marco de 5 eventos',
          );
        }
        return BrocheConquistado(broche: broche, desbloqueado: false);
      }

      if (broche.eventoIdRequerido != null) {
        final match =
            ordenado.where((e) => e.eventoId == broche.eventoIdRequerido);
        if (match.isNotEmpty) {
          return BrocheConquistado(
            broche: broche,
            desbloqueado: true,
            dataConquista: match.first.data,
            eventoConquistadoNome: match.first.titulo,
          );
        }
        return BrocheConquistado(broche: broche, desbloqueado: false);
      }

      if (broche.id == 'broche_carona') {
        final match = ordenado.where((e) => e.usouCaronaSolidaria);
        if (match.isNotEmpty) {
          return BrocheConquistado(
            broche: broche,
            desbloqueado: true,
            dataConquista: match.first.data,
            eventoConquistadoNome: match.first.titulo,
          );
        }
        return BrocheConquistado(broche: broche, desbloqueado: false);
      }

      final match = ordenado.where((e) => e.tipo == broche.tipoEventoRequerido);
      if (match.isNotEmpty) {
        return BrocheConquistado(
          broche: broche,
          desbloqueado: true,
          dataConquista: match.first.data,
          eventoConquistadoNome: match.first.titulo,
        );
      }
      return BrocheConquistado(broche: broche, desbloqueado: false);
    }).toList();
  }
}
