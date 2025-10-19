# 🚀 Deploy Automático no Railway

Este guia explica como configurar o deploy automático no Railway usando Git.

## 📋 Pré-requisitos

1. Conta no Railway
2. Railway CLI instalado: `npm install -g @railway/cli`
3. Projeto no Git (GitHub, GitLab, etc.)

## 🔧 Configuração Inicial

### 1. Login no Railway
```bash
railway login
```

### 2. Criar/Conectar Projeto
```bash
# Se for um projeto novo
railway init

# Se for conectar a um projeto existente
railway link
```

### 3. Adicionar Banco PostgreSQL
```bash
railway add postgresql
```

### 4. Configurar Variáveis de Ambiente
No dashboard do Railway ou via CLI:

```bash
# Django Settings
railway variables set DJANGO_SETTINGS_MODULE=config.settings_production
railway variables set DJANGO_DEBUG=False
railway variables set DJANGO_SECRET_KEY=$(openssl rand -base64 32)
railway variables set ALLOWED_HOSTS="*"
railway variables set CORS_ALLOW_ALL_ORIGINS=True

# Database (Railway gerencia automaticamente)
# POSTGRES_DB, POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_HOST, POSTGRES_PORT
# são configurados automaticamente pelo Railway
```

## 🚀 Deploy Automático

### 1. Conectar Repositório Git
No dashboard do Railway:
1. Vá para seu projeto
2. Clique em "Settings" → "Source"
3. Conecte seu repositório GitHub/GitLab
4. Selecione a branch (geralmente `main` ou `master`)

### 2. Deploy com Git Push
```bash
# Fazer commit das mudanças
git add .
git commit -m "Deploy to Railway"

# Push para triggerar deploy automático
git push origin main
```

## 📁 Estrutura do Projeto

```
fiscolab3/
├── Dockerfile              # Dockerfile otimizado para Railway
├── railway.json            # Configuração do Railway
├── .railwayignore          # Arquivos ignorados no deploy
├── back/                   # Backend Django
├── front/                  # Frontend React
└── chatbot/               # Chatbot ML
```

## 🔍 Monitoramento

### Ver Status do Deploy
```bash
railway status
```

### Ver Logs
```bash
railway logs
```

### Ver URL da Aplicação
```bash
railway domain
```

## 🛠️ Configurações Importantes

### Dockerfile Otimizado
- Build multi-stage para frontend e backend
- Instalação de dependências ML em background
- Nginx como proxy reverso
- Healthcheck configurado

### Variáveis de Ambiente
- `DJANGO_SETTINGS_MODULE`: `config.settings_production`
- `DJANGO_DEBUG`: `False`
- `ALLOWED_HOSTS`: `*`
- Banco PostgreSQL gerenciado pelo Railway

## 🐛 Troubleshooting

### Build Falha
1. Verificar logs: `railway logs`
2. Verificar se todas as variáveis estão configuradas
3. Verificar se o Dockerfile está correto

### Aplicação Não Inicia
1. Verificar se o banco PostgreSQL está conectado
2. Verificar logs de erro
3. Verificar variáveis de ambiente

### Timeout no Build
- O Dockerfile está otimizado para evitar timeouts
- Dependências ML são instaladas em background
- Build usa cache quando possível

## 📊 Comandos Úteis

```bash
# Status do projeto
railway status

# Logs em tempo real
railway logs -f

# Ver variáveis
railway variables

# Conectar ao projeto
railway link

# Deploy manual (se necessário)
railway up
```

## 🎯 Fluxo de Deploy

1. **Desenvolvimento Local**: Use `docker compose up` para desenvolvimento
2. **Commit**: Faça commit das mudanças
3. **Push**: `git push` triggera deploy automático
4. **Railway**: Build e deploy automático
5. **Acesso**: Aplicação disponível na URL do Railway

## ✅ Checklist de Deploy

- [ ] Railway CLI instalado
- [ ] Login no Railway feito
- [ ] Projeto criado/conectado
- [ ] PostgreSQL adicionado
- [ ] Variáveis de ambiente configuradas
- [ ] Repositório Git conectado
- [ ] Deploy automático ativado
- [ ] Teste de deploy realizado

## 🌐 URLs Importantes

- **Railway Dashboard**: https://railway.app/dashboard
- **Documentação Railway**: https://docs.railway.app/
- **Railway CLI**: https://docs.railway.app/develop/cli
