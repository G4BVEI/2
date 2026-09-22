import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const ConvivaApp());

// ============================================================
// PALETA & TIPOGRAFIA
// ============================================================

class AppColors {
  static const roxo = Color(0xFF6C4AB6);
  static const roxoEscuro = Color(0xFF4A2F85);
  static const roxoClaro = Color(0xFFB39DDB);
  static const verde = Color(0xFF00897B);
  static const verdeEscuro = Color(0xFF00695C);
  static const laranja = Color(0xFFEF6C00);
  static const laranjaEscuro = Color(0xFFE65100);
  static const fundo = Color(0xFFF5F3FB);
  static const card = Colors.white;
  static const texto = Color(0xFF2D2A3E);
  static const textoSecundario = Color(0xFF6E6A80);
  static const sucesso = Color(0xFF2E7D32);
  static const alerta = Color(0xFFF9A825);
  static const cinza = Color(0xFF9E9E9E);
  static const facebook = Color(0xFF1877F2);
}

class AppShadows {
  static final suave = [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];
  static final media = [
    BoxShadow(
      color: Colors.black.withOpacity(0.10),
      blurRadius: 22,
      offset: const Offset(0, 10),
    ),
  ];
  static List<BoxShadow> colorida(Color c) => [
        BoxShadow(
          color: c.withOpacity(0.30),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ];
}

// ============================================================
// MODELOS DE USUÁRIO / EVENTO
// ============================================================

enum TipoUsuario { organizador, motorista, usuario }

extension TipoUsuarioInfo on TipoUsuario {
  String get label => switch (this) {
        TipoUsuario.organizador => 'Organizador',
        TipoUsuario.motorista => 'Motorista',
        TipoUsuario.usuario => 'Usuário',
      };

  String get descricao => switch (this) {
        TipoUsuario.organizador => 'Crie e gerencie eventos',
        TipoUsuario.motorista => 'Leve pessoas aos eventos',
        TipoUsuario.usuario => 'Participe de eventos sociais',
      };

  IconData get icone => switch (this) {
        TipoUsuario.organizador => Icons.event_available_rounded,
        TipoUsuario.motorista => Icons.directions_bus_rounded,
        TipoUsuario.usuario => Icons.emoji_people_rounded,
      };

  Color get cor => switch (this) {
        TipoUsuario.organizador => AppColors.roxo,
        TipoUsuario.motorista => AppColors.verde,
        TipoUsuario.usuario => AppColors.laranja,
      };

  List<Color> get gradiente => switch (this) {
        TipoUsuario.organizador => [AppColors.roxo, AppColors.roxoEscuro],
        TipoUsuario.motorista => [AppColors.verde, AppColors.verdeEscuro],
        TipoUsuario.usuario => [AppColors.laranja, AppColors.laranjaEscuro],
      };
}

class Participante {
  final String nome;
  String? facebookUrl;

  Participante({required this.nome, this.facebookUrl});
}

class Pessoa {
  String nome;
  String? documento;
  String? endereco;
  String? telefone;
  final TipoUsuario tipo;
  String? facebookUrl;

  Pessoa({
    required this.nome,
    this.documento,
    this.endereco,
    this.telefone,
    required this.tipo,
    this.facebookUrl,
  });

  bool get facebookConectado => facebookUrl != null && facebookUrl!.isNotEmpty;
}

class Evento {
  final String id;
  String titulo;
  String descricao;
  String data;
  String horario;
  String local;
  int capacidade;
  final List<Participante> participantes;
  bool realizado;

  Evento({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.data,
    required this.horario,
    required this.local,
    required this.capacidade,
    List<Participante>? participantes,
    this.realizado = false,
  }) : participantes = participantes ?? [];

  bool get lotado => participantes.length >= capacidade;
  int get vagasRestantes => capacidade - participantes.length;

  bool contemParticipante(String nome) =>
      participantes.any((p) => p.nome == nome);
}

// ============================================================
// MODELOS DE BROCHES (embutidos)
// ============================================================

class Broche {
  final String id;
  final String nome;
  final String descricao;
  final String emoji;
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

class EventoParticipado {
  final String eventoId;
  final String tipo;
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

class BrochesService {
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

// ============================================================
// ESTADO GLOBAL
// ============================================================

class AppState extends ChangeNotifier {
  AppState._();
  static final AppState instance = AppState._();

  Pessoa? usuarioLogado;

  final List<Evento> eventos = [
    Evento(
      id: '1',
      titulo: 'Baile da Terceira Idade',
      descricao:
          'Venha dançar forró, bolero e samba com outros idosos animados!',
      data: '15/12/2025',
      horario: '19:00',
      local: 'Clube Municipal — Centro',
      capacidade: 10,
      participantes: [
        Participante(nome: 'Dona Maria'),
        Participante(nome: 'Seu João'),
      ],
    ),
    Evento(
      id: '2',
      titulo: 'Tarde de Bingo',
      descricao: 'Bingo com prêmios, café e bolo. Traga sua sorte!',
      data: '20/12/2025',
      horario: '14:00',
      local: 'Salão da Igreja São José',
      capacidade: 3,
      participantes: [
        Participante(nome: 'Ana'),
        Participante(nome: 'Carlos'),
        Participante(nome: 'Beatriz'),
      ],
    ),
    Evento(
      id: '3',
      titulo: 'Caminhada no Parque',
      descricao: 'Caminhada leve seguida de piquenique no parque central.',
      data: '01/12/2025',
      horario: '08:00',
      local: 'Parque da Cidade',
      capacidade: 20,
      participantes: [
        Participante(nome: 'Pedro'),
        Participante(nome: 'Lúcia'),
        Participante(nome: 'Marcos'),
        Participante(nome: 'Rita'),
      ],
      realizado: true,
    ),
  ];

  void login(Pessoa p) {
    usuarioLogado = p;
    notifyListeners();
  }

  void logout() {
    usuarioLogado = null;
    notifyListeners();
  }

  void _aplicarMeuLinkEmTodos() {
    final user = usuarioLogado;
    final meuLink = user?.facebookUrl;
    if (meuLink == null || meuLink.isEmpty) return;

    for (final e in eventos) {
      for (final p in e.participantes) {
        p.facebookUrl = meuLink;
      }
    }
  }

  Future<bool> conectarFacebook() async {
    final user = usuarioLogado;
    if (user == null) return false;

    try {
      final result = await FacebookAuth.instance.login(
        permissions: const ['public_profile', 'email', 'user_link'],
      );

      if (result.status != LoginStatus.success) return false;

      final data = await FacebookAuth.instance.getUserData(
        fields: 'id,name,email,picture.width(200),link',
      );

      final link = data['link'] as String?;
      final nomeFb = data['name'] as String?;

      user.facebookUrl = link;
      if (nomeFb != null && nomeFb.isNotEmpty) {
        user.nome = nomeFb;
      }

      _aplicarMeuLinkEmTodos();
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  void criarEvento({
    required String titulo,
    required String descricao,
    required String data,
    required String horario,
    required String local,
    required int capacidade,
  }) {
    eventos.insert(
      0,
      Evento(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        titulo: titulo,
        descricao: descricao,
        data: data,
        horario: horario,
        local: local,
        capacidade: capacidade,
      ),
    );
    _aplicarMeuLinkEmTodos();
    notifyListeners();
  }

  bool participar(Evento e) {
    final user = usuarioLogado;
    if (user == null || e.realizado || e.lotado) return false;
    if (e.contemParticipante(user.nome)) return false;
    e.participantes.add(
      Participante(nome: user.nome, facebookUrl: user.facebookUrl),
    );
    if (user.facebookConectado) _aplicarMeuLinkEmTodos();
    notifyListeners();
    return true;
  }

  bool confirmarPresencaRealizado(Evento e) {
    final user = usuarioLogado;
    if (user == null || !e.realizado) return false;
    if (e.contemParticipante(user.nome)) return false;
    e.participantes.add(
      Participante(nome: user.nome, facebookUrl: user.facebookUrl),
    );
    if (user.facebookConectado) _aplicarMeuLinkEmTodos();
    notifyListeners();
    return true;
  }

  // --------- Helpers pra Geladeira de Broches ---------

  /// Converte os eventos em que o usuário logado participou no formato
  /// que o BrochesService espera.
  List<EventoParticipado> historicoDoUsuario() {
    final user = usuarioLogado;
    if (user == null) return [];

    return eventos
        .where((e) => e.contemParticipante(user.nome))
        .map(
          (e) => EventoParticipado(
            eventoId: e.id,
            tipo: _tipoDoEvento(e.titulo),
            titulo: e.titulo,
            data: _parseData(e.data),
            usouCaronaSolidaria: false,
          ),
        )
        .toList();
  }

  String _tipoDoEvento(String titulo) {
    final t = titulo.toLowerCase();
    if (t.contains('bingo')) return 'bingo';
    if (t.contains('baile')) return 'baile';
    if (t.contains('bazar')) return 'bazar';
    if (t.contains('caminhada')) return 'caminhada';
    if (t.contains('chá') || t.contains('cha')) return 'cha_da_tarde';
    return 'outro';
  }

  DateTime _parseData(String ddmmyyyy) {
    try {
      final p = ddmmyyyy.split('/');
      return DateTime(int.parse(p[2]), int.parse(p[1]), int.parse(p[0]));
    } catch (_) {
      return DateTime.now();
    }
  }
}

// ============================================================
// APP RAIZ
// ============================================================

class ConvivaApp extends StatelessWidget {
  const ConvivaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conviva',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.roxo,
          primary: AppColors.roxo,
        ),
        scaffoldBackgroundColor: AppColors.fundo,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF8F6FD),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          labelStyle: const TextStyle(
            fontSize: 16,
            color: AppColors.textoSecundario,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.roxoClaro.withOpacity(0.3),
              width: 1.4,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.roxo, width: 2),
          ),
        ),
      ),
      home: const _RootGate(),
    );
  }
}

class _RootGate extends StatelessWidget {
  const _RootGate();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (_, __) {
        final user = AppState.instance.usuarioLogado;
        if (user == null) return const LoginFlow();

        if (!user.facebookConectado) {
          return const ConectarFacebookPage();
        }

        if (user.tipo == TipoUsuario.organizador) {
          return const OrganizadorDashboard();
        }
        if (user.tipo == TipoUsuario.motorista) {
          return const MotoristaEmBrevePage();
        }
        return const ListaEventosPage();
      },
    );
  }
}

// ============================================================
// COMPONENTES REUTILIZÁVEIS
// ============================================================

class HeaderGradiente extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icone;
  final List<Color> cores;
  final double altura;
  final VoidCallback? onVoltar;
  final Widget? trailing;

  const HeaderGradiente({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.icone,
    required this.cores,
    this.altura = 220,
    this.onVoltar,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final alturaMax = media.size.height * 0.38;
    final alturaFinal = altura.clamp(180.0, alturaMax);

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: alturaFinal),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: cores,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
        boxShadow: AppShadows.colorida(cores.first),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (onVoltar != null)
                    _IconeCircular(
                      icone: Icons.arrow_back_rounded,
                      onTap: onVoltar!,
                    )
                  else
                    const SizedBox(width: 48),
                  const Spacer(),
                  if (trailing != null) trailing!,
                ],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.22),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(icone, color: Colors.white, size: 34),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitulo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconeCircular extends StatelessWidget {
  final IconData icone;
  final VoidCallback onTap;
  const _IconeCircular({required this.icone, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icone, color: Colors.white),
        onPressed: onTap,
      ),
    );
  }
}

class BotaoGradiente extends StatelessWidget {
  final String texto;
  final IconData icone;
  final VoidCallback? onPressed;
  final List<Color> cores;
  final bool expandido;

  const BotaoGradiente({
    super.key,
    required this.texto,
    required this.icone,
    required this.onPressed,
    required this.cores,
    this.expandido = true,
  });

  @override
  Widget build(BuildContext context) {
    final desabilitado = onPressed == null;
    final c = desabilitado ? [AppColors.cinza, AppColors.cinza] : cores;

    return Container(
      width: expandido ? double.infinity : null,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: c),
        borderRadius: BorderRadius.circular(18),
        boxShadow: desabilitado ? [] : AppShadows.colorida(c.first),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(18),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icone, color: Colors.white, size: 22),
                const SizedBox(width: 10),
                Text(
                  texto,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChipStatus extends StatelessWidget {
  final String label;
  final Color cor;
  final IconData icone;
  const ChipStatus({
    super.key,
    required this.label,
    required this.cor,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.14),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: cor.withOpacity(0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 14, color: cor),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: cor,
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TELA OBRIGATÓRIA DE CONECTAR FACEBOOK
// ============================================================

class ConectarFacebookPage extends StatefulWidget {
  const ConectarFacebookPage({super.key});

  @override
  State<ConectarFacebookPage> createState() => _ConectarFacebookPageState();
}

class _ConectarFacebookPageState extends State<ConectarFacebookPage> {
  bool _carregando = false;

  Future<void> _conectar() async {
    setState(() => _carregando = true);
    final ok = await AppState.instance.conectarFacebook();
    if (!mounted) return;
    setState(() => _carregando = false);

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: Colors.red,
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Não foi possível conectar. Tente novamente.',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> _logout() async {
    try {
      await FacebookAuth.instance.logOut();
    } catch (_) {}
    AppState.instance.logout();
  }

  @override
  Widget build(BuildContext context) {
    final user = AppState.instance.usuarioLogado;
    final primeiroNome = user?.nome.split(' ').first ?? '';

    return Scaffold(
      body: Column(
        children: [
          HeaderGradiente(
            titulo: 'Falta só um passo',
            subtitulo: 'Conecte seu Facebook para continuar',
            icone: Icons.facebook,
            cores: const [AppColors.facebook, Color(0xFF0D47A1)],
            altura: 240,
            trailing: _IconeCircular(
              icone: Icons.logout_rounded,
              onTap: _logout,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: AppShadows.media,
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.facebook.withOpacity(0.10),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.facebook,
                            size: 56,
                            color: AppColors.facebook,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Olá, $primeiroNome! 👋',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.texto,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Para participar dos eventos, precisamos que você conecte seu Facebook. '
                          'Assim os outros participantes conseguem te encontrar e falar com você.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.textoSecundario,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: _carregando ? null : _conectar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.facebook,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 0,
                            ),
                            icon: _carregando
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.facebook, size: 22),
                            label: Text(
                              _carregando
                                  ? 'Conectando...'
                                  : 'Conectar com Facebook',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'É obrigatório para continuar.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textoSecundario,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// LOGIN EM 2 ETAPAS
// ============================================================

class LoginFlow extends StatefulWidget {
  const LoginFlow({super.key});
  @override
  State<LoginFlow> createState() => _LoginFlowState();
}

class _LoginFlowState extends State<LoginFlow> {
  TipoUsuario? _tipoEscolhido;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, anim) {
          final slide = Tween<Offset>(
            begin: const Offset(0.12, 0),
            end: Offset.zero,
          ).animate(anim);
          return FadeTransition(
            opacity: anim,
            child: SlideTransition(position: slide, child: child),
          );
        },
        child: _tipoEscolhido == null
            ? _EscolhaTipoPage(
                key: const ValueKey('escolha'),
                onEscolher: (t) => setState(() => _tipoEscolhido = t),
              )
            : _FormularioPage(
                key: ValueKey('form_${_tipoEscolhido!.name}'),
                tipo: _tipoEscolhido!,
                onVoltar: () => setState(() => _tipoEscolhido = null),
              ),
      ),
    );
  }
}

class _EscolhaTipoPage extends StatelessWidget {
  final void Function(TipoUsuario) onEscolher;
  const _EscolhaTipoPage({super.key, required this.onEscolher});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        children: [
          const HeaderGradiente(
            titulo: 'Conviva',
            subtitulo: 'Conecte-se, participe, viva!',
            icone: Icons.emoji_people_rounded,
            cores: [AppColors.roxo, AppColors.roxoEscuro],
            altura: 240,
          ),
          const SizedBox(height: 28),
          const Text(
            'Quem é você?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.texto,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Escolha uma opção para continuar',
            style: TextStyle(fontSize: 15, color: AppColors.textoSecundario),
          ),
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                for (var i = 0; i < TipoUsuario.values.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _CartaoTipoAnimado(
                      tipo: TipoUsuario.values[i],
                      delay: i * 90,
                      onTap: () => onEscolher(TipoUsuario.values[i]),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: AppColors.textoSecundario.withOpacity(0.3),
                  indent: 24,
                  endIndent: 12,
                ),
              ),
              const Text(
                'ou',
                style: TextStyle(
                  color: AppColors.textoSecundario,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              Expanded(
                child: Divider(
                  color: AppColors.textoSecundario.withOpacity(0.3),
                  indent: 12,
                  endIndent: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EntrarComFacebookPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.facebook,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.facebook, size: 22),
                label: const Text(
                  'Já tenho conta — entrar com Facebook',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EntrarComFacebookPage extends StatefulWidget {
  const EntrarComFacebookPage({super.key});

  @override
  State<EntrarComFacebookPage> createState() => _EntrarComFacebookPageState();
}

class _EntrarComFacebookPageState extends State<EntrarComFacebookPage> {
  bool _carregando = false;

  Future<void> _entrar() async {
    setState(() => _carregando = true);
    try {
      final result = await FacebookAuth.instance.login(
        permissions: const ['public_profile', 'email', 'user_link'],
      );
      if (!mounted) return;

      if (result.status != LoginStatus.success) {
        setState(() => _carregando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível entrar.')),
        );
        return;
      }

      final data = await FacebookAuth.instance.getUserData(
        fields: 'id,name,email,picture.width(200),link',
      );
      final nome = data['name'] as String? ?? 'Usuário';
      final link = data['link'] as String?;

      AppState.instance.login(
        Pessoa(
          nome: nome,
          tipo: TipoUsuario.usuario,
          facebookUrl: link,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao entrar com Facebook.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderGradiente(
            titulo: 'Bem-vindo de volta',
            subtitulo: 'Entre com sua conta do Facebook',
            icone: Icons.facebook,
            cores: const [AppColors.facebook, Color(0xFF0D47A1)],
            altura: 220,
            onVoltar: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: AppShadows.media,
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.facebook.withOpacity(0.10),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.facebook,
                            size: 48,
                            color: AppColors.facebook,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Usar conta do Facebook',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.texto,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Usamos seu nome e link do perfil para que outros '
                          'participantes possam te encontrar nos eventos.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.5,
                            color: AppColors.textoSecundario,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton.icon(
                            onPressed: _carregando ? null : _entrar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.facebook,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 0,
                            ),
                            icon: _carregando
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.facebook, size: 22),
                            label: Text(
                              _carregando
                                  ? 'Entrando...'
                                  : 'Entrar com Facebook',
                              style: const TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartaoTipoAnimado extends StatefulWidget {
  final TipoUsuario tipo;
  final VoidCallback onTap;
  final int delay;
  const _CartaoTipoAnimado({
    required this.tipo,
    required this.onTap,
    required this.delay,
  });

  @override
  State<_CartaoTipoAnimado> createState() => _CartaoTipoAnimadoState();
}

class _CartaoTipoAnimadoState extends State<_CartaoTipoAnimado>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fade = CurvedAnimation(parent: _c, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.tipo;
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          elevation: 0,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppShadows.suave,
                border: Border.all(color: t.cor.withOpacity(0.12), width: 1.4),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: t.gradiente,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: AppShadows.colorida(t.cor),
                    ),
                    child: Icon(t.icone, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.label,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.texto,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          t.descricao,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textoSecundario,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, color: t.cor, size: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormularioPage extends StatefulWidget {
  final TipoUsuario tipo;
  final VoidCallback onVoltar;
  const _FormularioPage({
    super.key,
    required this.tipo,
    required this.onVoltar,
  });

  @override
  State<_FormularioPage> createState() => _FormularioPageState();
}

class _FormularioPageState extends State<_FormularioPage> {
  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _doc = TextEditingController();
  final _end = TextEditingController();
  final _tel = TextEditingController();

  @override
  void dispose() {
    _nome.dispose();
    _doc.dispose();
    _end.dispose();
    _tel.dispose();
    super.dispose();
  }

  void _entrar() {
    if (!_formKey.currentState!.validate()) return;

    final pedeDoc = widget.tipo != TipoUsuario.usuario;

    AppState.instance.login(
      Pessoa(
        nome: _nome.text.trim(),
        documento: pedeDoc ? _doc.text.trim() : null,
        endereco: widget.tipo == TipoUsuario.usuario ? _end.text.trim() : null,
        telefone: (widget.tipo == TipoUsuario.usuario ||
                widget.tipo == TipoUsuario.motorista)
            ? _tel.text.trim()
            : null,
        tipo: widget.tipo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.tipo;
    final pedeDoc = t != TipoUsuario.usuario;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        children: [
          HeaderGradiente(
            titulo: 'Cadastro de ${t.label}',
            subtitulo: t.descricao,
            icone: t.icone,
            cores: t.gradiente,
            altura: 220,
            onVoltar: widget.onVoltar,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(26),
                boxShadow: AppShadows.media,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildField(
                      _nome,
                      t == TipoUsuario.organizador
                          ? 'Nome da instituição / responsável'
                          : 'Nome completo',
                      Icons.person_outline_rounded,
                    ),
                    if (pedeDoc) ...[
                      const SizedBox(height: 16),
                      _buildField(
                        _doc,
                        t == TipoUsuario.organizador ? 'CPF ou CNPJ' : 'CPF',
                        Icons.badge_outlined,
                      ),
                    ],
                    if (t == TipoUsuario.usuario) ...[
                      const SizedBox(height: 16),
                      _buildField(_end, 'Endereço', Icons.home_outlined),
                      const SizedBox(height: 16),
                      _buildField(
                        _tel,
                        'Telefone',
                        Icons.phone_outlined,
                        keyboard: TextInputType.phone,
                      ),
                    ],
                    const SizedBox(height: 26),
                    BotaoGradiente(
                      texto: 'Continuar',
                      icone: Icons.arrow_forward_rounded,
                      cores: t.gradiente,
                      onPressed: _entrar,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    TextEditingController c,
    String label,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: c,
      keyboardType: keyboard,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: widget.tipo.cor),
      ),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Obrigatório' : null,
    );
  }
}

// ============================================================
// MOTORISTA — EM BREVE
// ============================================================

class MotoristaEmBrevePage extends StatelessWidget {
  const MotoristaEmBrevePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderGradiente(
            titulo: 'Área do Motorista',
            subtitulo: 'Em desenvolvimento',
            icone: Icons.directions_bus_rounded,
            cores: const [AppColors.verde, AppColors.verdeEscuro],
            altura: 220,
            trailing: _IconeCircular(
              icone: Icons.logout_rounded,
              onTap: () => AppState.instance.logout(),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: AppColors.verde.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.construction_rounded,
                        size: 64,
                        color: AppColors.verde,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Em breve!',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.texto,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'A área do motorista ainda está sendo\npreparada com muito carinho. 🚌💨',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textoSecundario,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DASHBOARD DO ORGANIZADOR
// ============================================================

class OrganizadorDashboard extends StatefulWidget {
  const OrganizadorDashboard({super.key});
  @override
  State<OrganizadorDashboard> createState() => _OrganizadorDashboardState();
}

class _OrganizadorDashboardState extends State<OrganizadorDashboard> {
  final _novoEventoKey = GlobalKey<FormState>();
  final _titulo = TextEditingController();
  final _desc = TextEditingController();
  final _data = TextEditingController();
  final _hora = TextEditingController();
  final _local = TextEditingController();
  final _cap = TextEditingController(text: '10');

  void _adicionarEvento() {
    if (!_novoEventoKey.currentState!.validate()) return;
    AppState.instance.criarEvento(
      titulo: _titulo.text.trim(),
      descricao: _desc.text.trim(),
      data: _data.text.trim(),
      horario: _hora.text.trim(),
      local: _local.text.trim(),
      capacidade: int.tryParse(_cap.text.trim()) ?? 10,
    );
    _titulo.clear();
    _desc.clear();
    _data.clear();
    _hora.clear();
    _local.clear();
    _cap.text = '10';
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: AppColors.sucesso,
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Text('Evento criado com sucesso! 🎉'),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogNovoEvento() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Form(
              key: _novoEventoKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.roxo, AppColors.roxoEscuro],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Novo Evento',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.texto,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _field(_titulo, 'Título', Icons.title_rounded),
                  _field(_desc, 'Descrição', Icons.description_outlined),
                  _field(
                    _data,
                    'Data (ex: 25/12/2025)',
                    Icons.calendar_today_rounded,
                  ),
                  _field(
                    _hora,
                    'Horário (ex: 15:00)',
                    Icons.access_time_rounded,
                  ),
                  _field(_local, 'Local', Icons.location_on_outlined),
                  _field(
                    _cap,
                    'Capacidade',
                    Icons.people_outline_rounded,
                    keyboard: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: BotaoGradiente(
                          texto: 'Criar',
                          icone: Icons.check_rounded,
                          cores: const [AppColors.roxo, AppColors.roxoEscuro],
                          onPressed: _adicionarEvento,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        keyboardType: keyboard,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.roxo),
        ),
        validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'Obrigatório' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: AppState.instance,
        builder: (_, __) {
          final eventos = AppState.instance.eventos;
          return Column(
            children: [
              HeaderGradiente(
                titulo: 'Painel do Organizador',
                subtitulo: '${eventos.length} evento(s) cadastrado(s)',
                icone: Icons.event_available_rounded,
                cores: const [AppColors.roxo, AppColors.roxoEscuro],
                altura: 200,
                trailing: _IconeCircular(
                  icone: Icons.logout_rounded,
                  onTap: () => AppState.instance.logout(),
                ),
              ),
              Expanded(
                child: eventos.isEmpty
                    ? const _EstadoVazio(
                        icone: Icons.event_busy_rounded,
                        titulo: 'Nenhum evento ainda',
                        sub: 'Toque no botão abaixo para criar o primeiro!',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                        itemCount: eventos.length,
                        itemBuilder: (_, i) =>
                            _CardOrganizadorEvento(evento: eventos[i]),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _mostrarDialogNovoEvento,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Novo Evento',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        backgroundColor: AppColors.roxo,
        foregroundColor: Colors.white,
        elevation: 6,
      ),
    );
  }
}

class _CardOrganizadorEvento extends StatelessWidget {
  final Evento evento;
  const _CardOrganizadorEvento({required this.evento});

  @override
  Widget build(BuildContext context) {
    final statusCor = evento.realizado
        ? AppColors.cinza
        : (evento.lotado ? AppColors.alerta : AppColors.sucesso);
    final statusLabel = evento.realizado
        ? 'Realizado'
        : (evento.lotado ? 'Completo' : 'Aberto');

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppShadows.suave,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.roxo, AppColors.roxoEscuro],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    '${evento.participantes.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      evento.titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                        color: AppColors.texto,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${evento.data} • ${evento.horario}',
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: AppColors.textoSecundario,
                      ),
                    ),
                    Text(
                      evento.local,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: AppColors.textoSecundario,
                      ),
                    ),
                  ],
                ),
              ),
              ChipStatus(
                label: statusLabel,
                cor: statusCor,
                icone: evento.realizado
                    ? Icons.history_rounded
                    : (evento.lotado
                        ? Icons.lock_rounded
                        : Icons.check_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _infoPill(
                Icons.people_alt_rounded,
                '${evento.participantes.length}/${evento.capacidade} confirmados',
              ),
              const SizedBox(width: 10),
              if (!evento.realizado && !evento.lotado)
                _infoPill(
                  Icons.confirmation_number_rounded,
                  '${evento.vagasRestantes} vagas',
                  cor: AppColors.sucesso,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoPill(IconData icon, String text, {Color? cor}) {
    final c = cor ?? AppColors.textoSecundario;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: c),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: c,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// ESTADO VAZIO
// ============================================================

class _EstadoVazio extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String sub;
  const _EstadoVazio({
    required this.icone,
    required this.titulo,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: AppColors.roxoClaro.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: Icon(icone, size: 56, color: AppColors.roxo),
            ),
            const SizedBox(height: 20),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.texto,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              sub,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textoSecundario,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// LISTA DE EVENTOS (USUÁRIO) — com botão pra Geladeira
// ============================================================

class ListaEventosPage extends StatelessWidget {
  const ListaEventosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (_, __) {
        final user = AppState.instance.usuarioLogado;
        if (user == null) return const SizedBox.shrink();
        final eventos = AppState.instance.eventos;
        final primeiroNome = user.nome.split(' ').first;

        return Scaffold(
          body: Column(
            children: [
              HeaderGradiente(
                titulo: 'Olá, $primeiroNome!',
                subtitulo: '${eventos.length} eventos disponíveis',
                icone: Icons.celebration_rounded,
                cores: user.tipo.gradiente,
                altura: 200,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _IconeCircular(
                      icone: Icons.kitchen_rounded, // 🧊 Geladeira
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ParedeBrochesScreen(
                              historico: AppState.instance.historicoDoUsuario(),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 4),
                    _IconeCircular(
                      icone: Icons.logout_rounded,
                      onTap: () => AppState.instance.logout(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
                  itemCount: eventos.length,
                  itemBuilder: (_, i) => _CardEventoResumo(
                    evento: eventos[i],
                    index: i,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CardEventoResumo extends StatefulWidget {
  final Evento evento;
  final int index;
  const _CardEventoResumo({required this.evento, required this.index});

  @override
  State<_CardEventoResumo> createState() => _CardEventoResumoState();
}

class _CardEventoResumoState extends State<_CardEventoResumo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fade = CurvedAnimation(parent: _c, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));
    Future.delayed(Duration(milliseconds: widget.index * 80), () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  List<Color> _corStatus() {
    final e = widget.evento;
    if (e.realizado) return [AppColors.cinza, const Color(0xFF616161)];
    if (e.lotado) return [AppColors.alerta, const Color(0xFFEF6C00)];
    return [const Color(0xFF43A047), const Color(0xFF2E7D32)];
  }

  Widget _statusChip() {
    final e = widget.evento;
    if (e.realizado) {
      return const ChipStatus(
        label: 'Realizado',
        cor: AppColors.cinza,
        icone: Icons.history_rounded,
      );
    }
    if (e.lotado) {
      return const ChipStatus(
        label: 'Completo',
        cor: AppColors.alerta,
        icone: Icons.lock_rounded,
      );
    }
    return const ChipStatus(
      label: 'Aberto',
      cor: AppColors.sucesso,
      icone: Icons.check_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.evento;
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppShadows.media,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: _corStatus()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              e.titulo,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.texto,
                                height: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _statusChip(),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _infoPill(
                        Icons.calendar_today_rounded,
                        '${e.data}  •  ${e.horario}',
                      ),
                      const SizedBox(height: 6),
                      _infoPill(Icons.location_on_rounded, e.local),
                      const SizedBox(height: 6),
                      _infoPill(
                        Icons.people_alt_rounded,
                        '${e.participantes.length} de ${e.capacidade} confirmados',
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: BotaoGradiente(
                          texto: 'Entrar no evento',
                          icone: Icons.arrow_forward_rounded,
                          cores: const [
                            AppColors.roxo,
                            AppColors.roxoEscuro,
                          ],
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EventoDetalhePage(evento: e),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoPill(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.textoSecundario.withOpacity(0.10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 14, color: AppColors.textoSecundario),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.texto,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// PÁGINA DEDICADA DO EVENTO
// ============================================================

class EventoDetalhePage extends StatelessWidget {
  final Evento evento;
  const EventoDetalhePage({super.key, required this.evento});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (_, __) {
        final user = AppState.instance.usuarioLogado!;
        final jaParticipa = evento.contemParticipante(user.nome);
        final e = evento;

        return Scaffold(
          body: Column(
            children: [
              HeaderGradiente(
                titulo: e.titulo,
                subtitulo: '${e.data} • ${e.horario}',
                icone: Icons.event_rounded,
                cores: const [AppColors.roxo, AppColors.roxoEscuro],
                altura: 240,
                onVoltar: () => Navigator.pop(context),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: AppShadows.suave,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _statusChip(e),
                              const Spacer(),
                              if (!e.realizado && !e.lotado)
                                ChipStatus(
                                  label: '${e.vagasRestantes} vagas',
                                  cor: AppColors.sucesso,
                                  icone: Icons.confirmation_number_rounded,
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            e.descricao,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.texto,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 18),
                          _linhaInfo(
                            Icons.calendar_today_rounded,
                            'Data',
                            '${e.data} às ${e.horario}',
                          ),
                          const SizedBox(height: 10),
                          _linhaInfo(
                            Icons.location_on_rounded,
                            'Local',
                            e.local,
                          ),
                          const SizedBox(height: 10),
                          _linhaInfo(
                            Icons.people_alt_rounded,
                            'Confirmados',
                            '${e.participantes.length} de ${e.capacidade}',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: _buildBotaoAcao(context, e, jaParticipa),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: AppShadows.suave,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.groups_rounded,
                                size: 22,
                                color: AppColors.roxo,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                e.realizado
                                    ? 'Quem esteve presente'
                                    : 'Participantes',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 17,
                                  color: AppColors.texto,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${e.participantes.length}/${e.capacidade}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppColors.textoSecundario,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          if (e.participantes.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                'Ninguém confirmou ainda.',
                                style: TextStyle(
                                  color: AppColors.textoSecundario,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 15,
                                ),
                              ),
                            )
                          else
                            ...e.participantes.asMap().entries.map((entry) {
                              final i = entry.key;
                              final p = entry.value;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _LinhaParticipante(
                                  posicao: i + 1,
                                  participante: p,
                                ),
                              );
                            }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _linhaInfo(IconData icon, String label, String valor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.roxoClaro.withOpacity(0.25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.roxo),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textoSecundario,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              valor,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.texto,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statusChip(Evento e) {
    if (e.realizado) {
      return const ChipStatus(
        label: 'Realizado',
        cor: AppColors.cinza,
        icone: Icons.history_rounded,
      );
    }
    if (e.lotado) {
      return const ChipStatus(
        label: 'Completo',
        cor: AppColors.alerta,
        icone: Icons.lock_rounded,
      );
    }
    return const ChipStatus(
      label: 'Aberto',
      cor: AppColors.sucesso,
      icone: Icons.check_rounded,
    );
  }

  Widget _buildBotaoAcao(BuildContext context, Evento e, bool jaParticipa) {
    if (jaParticipa) {
      return Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.sucesso.withOpacity(0.12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.sucesso.withOpacity(0.4),
            width: 1.5,
          ),
        ),
        child: const Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.sucesso,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'Você já confirmou presença',
                style: TextStyle(
                  color: AppColors.sucesso,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (e.realizado) {
      return BotaoGradiente(
        texto: 'Confirmar que estive presente',
        icone: Icons.how_to_reg_rounded,
        cores: const [Color(0xFF757575), Color(0xFF424242)],
        onPressed: () => _confirmarPresencaRealizado(context, e),
      );
    }
    if (e.lotado) {
      return BotaoGradiente(
        texto: 'Evento completo',
        icone: Icons.lock_rounded,
        cores: const [AppColors.cinza, AppColors.cinza],
        onPressed: null,
      );
    }
    return BotaoGradiente(
      texto: 'Participar',
      icone: Icons.add_task_rounded,
      cores: const [AppColors.roxo, AppColors.roxoEscuro],
      onPressed: () => _participar(context, e),
    );
  }

  void _participar(BuildContext context, Evento e) {
    final ok = AppState.instance.participar(e);
    _showSnack(
      context,
      ok ? 'Presença confirmada! 🎉' : 'Não foi possível confirmar.',
      ok ? AppColors.sucesso : Colors.red,
    );
  }

  void _confirmarPresencaRealizado(BuildContext context, Evento e) {
    final ok = AppState.instance.confirmarPresencaRealizado(e);
    _showSnack(
      context,
      ok ? 'Presença confirmada no evento! ✅' : 'Você já está na lista.',
      ok ? AppColors.sucesso : Colors.orange,
    );
  }

  void _showSnack(BuildContext context, String msg, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: cor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Row(
          children: [
            const Icon(Icons.info_outline_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinhaParticipante extends StatelessWidget {
  final int posicao;
  final Participante participante;
  const _LinhaParticipante({
    required this.posicao,
    required this.participante,
  });

  Future<void> _abrirFacebook(BuildContext context) async {
    final url = participante.facebookUrl;
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: const Text(
            'Conecte seu Facebook primeiro para gerar o link.',
          ),
        ),
      );
      return;
    }

    final uri = Uri.parse(url);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não consegui abrir o Facebook.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.fundo,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.roxoClaro.withOpacity(0.35),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.roxo.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$posicao',
                style: const TextStyle(
                  color: AppColors.roxo,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.roxo,
            child: Text(
              participante.nome.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              participante.nome,
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
                color: AppColors.texto,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _abrirFacebook(context),
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.facebook,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.facebook,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PAREDE DE BROCHES ("Minha Geladeira") — tela dedicada
// ============================================================

class ParedeBrochesScreen extends StatelessWidget {
  final List<EventoParticipado> historico;

  const ParedeBrochesScreen({super.key, required this.historico});

  @override
  Widget build(BuildContext context) {
    final broches = BrochesService.calcularBroches(historico);
    final conquistados = broches.where((b) => b.desbloqueado).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F1EC),
      appBar: AppBar(
        title: const Text('Minha Geladeira'),
        backgroundColor: const Color(0xFFF2F1EC),
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Column(
        children: [
          _ProgressoHeader(
            conquistados: conquistados,
            total: broches.length,
          ),
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
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
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
