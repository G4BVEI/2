# Conviva — fake login demo

App em Flutter **sem backend**. Usa o SDK de verdade do Facebook Login só
pra puxar do perfil do usuário: nome, email, foto e o `link` (URL do
próprio perfil no Facebook), guarda tudo em memória durante a sessão, e
mostra na Home — inclusive com um botão pra abrir o perfil no Facebook.
Nada disso é salvo ou enviado pra nenhum servidor nosso.

## O que já vem pronto neste zip

```
pubspec.yaml                                     -> dependências (flutter_facebook_auth, url_launcher)
lib/
  main.dart                                      -> entry point do app
  models/fake_user.dart                          -> objeto local (id/name/email/picture/link)
  screens/login_screen.dart                      -> botão "Continue with Facebook"
  screens/home_screen.dart                       -> "Welcome, <nome>!" + botão abrir perfil + logout
android/app/src/main/AndroidManifest.xml         -> já com o meta-data do Facebook e as activities
android/app/src/main/res/values/strings.xml      -> já com seu app id / client token / scheme
```

Ou seja: já deixei os arquivos **exatamente nos caminhos finais** de um
projeto Flutter normal. Faltam só as partes que o próprio Flutter gera
automaticamente (gradle wrapper, ícones, `ios/`, `MainActivity`, etc.).

## Setup

1. Descompacte este zip numa pasta vazia (ex: `conviva_app/`) e entre nela:
   ```bash
   cd conviva_app
   ```

2. Rode `flutter create .` **dentro dela**. Isso preenche tudo que ainda
   falta (gradle, `ios/`, ícones, `MainActivity`, etc.) sem sobrescrever o
   `pubspec.yaml`, o `lib/` nem os dois arquivos Android que já preparei
   (o Flutter não sobrescreve arquivo existente por padrão):
   ```bash
   flutter create .
   ```
   > Se ele pedir seu `--org` ou pacote, pode aceitar o padrão
   > (`com.example.conviva_app`) — não afeta nada do que já configuramos.

3. Confirme que o `minSdkVersion` em `android/app/build.gradle` (ou
   `android/app/build.gradle.kts`) ficou **21 ou mais** — o SDK do
   Facebook exige isso. Se o `flutter create` colocar um valor menor,
   suba manualmente.

4. **Registre o key hash de debug no Facebook** (senão o login falha com
   erro vindo do próprio Facebook, não do app):
   ```bash
   keytool -exportcert -alias androiddebugkey -keystore ~/.android/debug.keystore | openssl sha1 -binary | openssl base64
   ```
   (senha padrão: `android`)
   - Cole esse hash em **Facebook Developer Console → seu app → Settings
     → Basic → Android → Key Hashes**, junto com o nome do pacote e a
     activity padrão (`<seu.pacote>.MainActivity`).
   - Confira que **Facebook Login** está adicionado como produto no app,
     e que sua conta está como tester/admin/developer se o app ainda
     estiver em modo Development.
   - Confirme lá no painel do app que o campo/permissão do `link` (que
     você já ativou) está mesmo liberado pro seu app — sem isso o
     `userData['link']` volta nulo e o botão de abrir perfil fica
     desabilitado.

5. Instale e rode:
   ```bash
   flutter pub get
   flutter run
   ```

## iOS (opcional)

Pra rodar no iOS também, falta adicionar as chaves do Facebook no
`ios/Runner/Info.plist` (`FacebookAppID`, `FacebookClientToken`,
`FacebookDisplayName`, e um `CFBundleURLSchemes` com
`fb2817279865318462`), conforme a
[documentação de setup iOS do flutter_facebook_auth](https://pub.dev/packages/flutter_facebook_auth).
Me avisa se quiser que eu já deixe isso pronto também.

## Observações

- Sem backend, sem persistência: fechar o app esquece a sessão local (o
  SDK do próprio Facebook pode manter uma sessão dele e auto-restaurar
  dependendo do comportamento deles — se quiser login automático ao
  reabrir, dá pra checar `FacebookAuth.instance.accessToken` no início do
  app).
- O `profileUrl` vem direto do campo `link` do Graph API, sem fallback —
  se a Meta não devolver esse campo por algum motivo, o botão de abrir
  perfil simplesmente fica desabilitado.
