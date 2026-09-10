import 'package:flutter/material.dart';
import '../models/broche.dart';
import '../services/broches_service.dart';

/// Aba "Minha Geladeira": mostra todos os broches, conquistados e
/// bloqueados, como se fossem ímãs colados numa porta de geladeira.
///
/// Substitua [historico] pela busca real do histórico de presenças
/// confirmadas do usuário logado assim que o app tiver um sistema de
/// Evento/Presença — por enquanto essa tela só espera receber a lista
/// pronta de [EventoParticipado].
class ParedeBrochesScreen extends StatelessWidget {
  final List<EventoParticipado> historico;

  const ParedeBrochesScreen({super.key, required this.historico});

  @override
  Widget build(BuildContext context) {
    final broches = BrochesService.calcularBroches(historico);
    final conquistados = broches.where((b) => b.desbloqueado).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F1EC), // tom "porta de geladeira"
      appBar: AppBar(
        title: const Text('Minha Geladeira'),
        backgroundColor: const Color(0xFFF2F1EC),
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Column(
        children: [
          _ProgressoHeader(conquistados: conquistados, total: broches.length),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 20,
                crossAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: broches.length,
              itemBuilder: (context, index) {
                final item = broches[index];
                return _BrocheMagnet(
                  item: item,
                  onTap: () => _mostrarDetalhe(context, item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDetalhe(BuildContext context, BrocheConquistado item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('${item.broche.emoji}  ${item.broche.nome}'),
        content: Text(
          item.desbloqueado
              ? 'Conquistado em ${_formatarData(item.dataConquista!)}'
                  '${item.eventoConquistadoNome != null ? '\nEvento: ${item.eventoConquistadoNome}' : ''}'
              : '${item.broche.descricao}\n\nVá a um evento correspondente para desbloquear este broche!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/${data.year}';
  }
}

class _ProgressoHeader extends StatelessWidget {
  final int conquistados;
  final int total;

  const _ProgressoHeader({required this.conquistados, required this.total});

  @override
  Widget build(BuildContext context) {
    final progresso = total == 0 ? 0.0 : conquistados / total;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$conquistados de $total broches conquistados',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progresso,
              minHeight: 10,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation(Color(0xFFE0A72E)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Um único broche desenhado como ímã de geladeira.
/// Quando bloqueado, aparece em tons de cinza com um cadeado.
class _BrocheMagnet extends StatelessWidget {
  final BrocheConquistado item;
  final VoidCallback? onTap;

  const _BrocheMagnet({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final broche = item.broche;
    final corFundo =
        item.desbloqueado ? broche.corPrincipal : Colors.grey.shade400;

    return GestureDetector(
      onTap: onTap,
      child: Semantics(
        label: item.desbloqueado
            ? '${broche.nome}, conquistado'
            : '${broche.nome}, bloqueado. ${broche.descricao}',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: corFundo.withOpacity(item.desbloqueado ? 1 : 0.35),
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      item.desbloqueado ? Colors.white : Colors.grey.shade500,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: item.desbloqueado
                    ? Text(broche.emoji, style: const TextStyle(fontSize: 34))
                    : Icon(Icons.lock_outline,
                        color: Colors.grey.shade700, size: 30),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 90,
              child: Text(
                broche.nome,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color:
                      item.desbloqueado ? Colors.black87 : Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
