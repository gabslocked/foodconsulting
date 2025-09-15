# Food Consulting App

Um aplicativo Flutter completo para gerenciamento de missões de consultoria alimentar com integração Supabase.

## 🚀 Funcionalidades

### ✅ Autenticação
- Login/logout com Supabase Auth
- Gerenciamento de perfil de usuário
- Estados de autenticação em tempo real

### ✅ Missões
- **Listagem de missões**: Visualização de todas as missões disponíveis
- **Detalhes da missão**: Informações completas sobre cada missão
- **Abas organizadas**:
  - 🌍 **Destino**: Informações sobre o local da missão
  - ✈️ **Voos**: Gerenciamento de informações de voo
  - 🏨 **Hotel**: Detalhes de acomodação
  - 📅 **Roteiro**: Itinerário detalhado das atividades
  - 🎯 **Atividades**: Lista de atividades recomendadas
  - 💡 **Dicas**: Dicas e informações úteis

### ✅ Dados em Tempo Real
- Sincronização automática com Supabase
- Cache offline para melhor performance
- Notificações em tempo real

### ✅ Interface Moderna
- Material Design 3
- Tema claro forçado com fundo branco
- Interface responsiva e intuitiva
- Hot reload ativo para desenvolvimento

## 🛠️ Tecnologias

- **Flutter**: Framework principal
- **Supabase**: Backend-as-a-Service (autenticação, banco de dados, real-time)
- **Provider**: Gerenciamento de estado
- **PostgreSQL**: Banco de dados (via Supabase)

## 📱 Plataformas Suportadas

- ✅ **Android nativo**: Funciona perfeitamente no dispositivo
- ✅ **Flutter Web**: PWA com instalação nativa-like
- ✅ **Hot reload**: Ativo em ambas as plataformas

## 🏗️ Estrutura do Banco de Dados

### Tabelas Principais
- `profiles`: Perfis de usuários
- `missions`: Missões de consultoria
- `mission_participants`: Participantes das missões
- `flights`: Informações de voos
- `accommodations`: Acomodações/hotéis
- `itineraries`: Roteiros e cronogramas
- `activities`: Atividades recomendadas
- `tips`: Dicas e informações úteis
- `notifications`: Sistema de notificações

## 🚀 Como Executar

### Pré-requisitos
- Flutter SDK instalado
- Android SDK configurado (para Android)
- Dispositivo Android conectado ou emulador

### Executar no Android
```bash
flutter run -d <device_id>
```

### Executar na Web
```bash
flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0
```

## 🔧 Configuração

### Supabase
O app está configurado para usar o Supabase como backend. As credenciais estão configuradas no código.

### Hot Reload
- **Android**: `r` para hot reload, `R` para hot restart
- **Web**: Automático no navegador

## 🐛 Debugging

### Logs Importantes
- Todos os erros são logados no console do Flutter
- Debug prints mostram o fluxo de dados do Supabase
- Logs de parsing JSON para troubleshooting

### Problemas Resolvidos
- ✅ Erros de colunas inexistentes no banco (is_read → read, name → title)
- ✅ Queries de upcoming activities corrigidas
- ✅ Build Android funcionando (Kotlin compiler issues resolvidos)
- ✅ Parsing de dados JSON com campos corretos
- ✅ Estados de loading e erro tratados

## 📋 Status do Projeto

**🎉 TOTALMENTE FUNCIONAL**

O aplicativo está rodando perfeitamente como app nativo Android com todas as funcionalidades implementadas:
- Autenticação Supabase ✅
- Carregamento de missões ✅
- Navegação entre abas ✅
- Dados em tempo real ✅
- Interface completa ✅

## 🔄 Próximos Passos

- Implementar mais funcionalidades de edição
- Adicionar upload de imagens
- Melhorar sistema de notificações
- Adicionar mais filtros e pesquisas
# foodconsulting
# foodconsulting
# foodconsulting
