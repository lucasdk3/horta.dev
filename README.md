# Horta — Cultive Conhecimento 🌿

Horta é uma plataforma comunitária de pesquisa e coleta de dados voltada para o ecossistema tecnológico. O projeto utiliza uma metáfora de "jardinagem digital" para engajar usuários em pesquisas de mercado, tendências de engenharia e práticas de desenvolvimento, transformando a coleta de dados em uma experiência de cultivo e crescimento coletivo.

## 🚀 Tecnologias Utilizadas

- **Frontend:** React 19 + Vite + TypeScript
- **Estilização:** Tailwind CSS + Framer Motion (para animações fluidas)
- **Backend/Database:** Firebase (Firestore + Authentication)
- **IA Generativa:** Google Gemini API (para análise de dados e assistente virtual)
- **Internacionalização:** i18next (Suporte a múltiplos idiomas)
- **Componentes:** Base UI + Lucide React

## 📂 Estrutura do Banco de Dados (Firestore)

A plataforma utiliza o Firebase Firestore com as seguintes coleções principais:

### 1. `surveys` (Pesquisas)
Contém os formulários de pesquisa ativos na plataforma.
- `title` (map): Títulos localizados.
- `description` (map): Descrições localizadas.
- `questions` (array): Lista de objetos contendo as perguntas, tipos e opções.
- `category` (string): Categoria da pesquisa (ex: Frontend, DevOps).
- `active` (boolean): Status de visibilidade.
- `createdAt` (timestamp): Data de criação.

### 2. `responses` (Respostas)
Armazena as contribuições dos usuários.
- `surveyId` (string): Referência à pesquisa correspondente.
- `respondentId` (string): UID do usuário no Firebase Auth.
- `respondentEmail` (string): Email do respondente.
- `answers` (map): Respostas fornecidas para cada pergunta.
- `country` (string): País do respondente (detectado/escolhido).

### 3. `users` (Perfis e Gamificação)
Gerencia o progresso dos usuários na plataforma.
- `email` (string): Email único do usuário.
- `xp` (integer): Conhecido como "Drops" (Gotas), acumulado ao responder pesquisas.
- `level` (integer): Estágio de crescimento (Semente, Broto, Arbusto, Árvore, etc).
- `badges` (array): Medalhas conquistadas por marcos específicos.
- `isAdmin` (boolean): Permite acesso ao painel de criação de pesquisas.

### 4. `survey_analyses` (Cache de IA)
Otimiza custos e performance armazenando relatórios gerados pelo Gemini.
- `surveyId` (string): Vínculo com a pesquisa.
- `lang` (string): Idioma da análise.
- `summary` (string): Markdown gerado.
- `responseCount` (integer): Volume de dados no momento da geração para controle de cache.

### 5. `survey_requests` (Sugestões da Comunidade)
Onde usuários sugerem novos tópicos de pesquisa.
- `title` / `description` (string): Detalhes da sugestão.
- `status` (enum): `pending`, `approved` ou `rejected`.

## 🤖 Integração com Gemini AI

A Horta utiliza o modelo `gemini-1.5-flash` para:
- **Insights IA:** Analisar o volume de respostas de uma pesquisa e gerar resumos executivos.
- **Cache Inteligente:** As análises são salvas no banco e só regeneradas se houver novos dados, economizando tokens e tempo.
- **Global Assistant:** Um chat lateral que ajuda o usuário a navegar pela plataforma e entender os dados coletados.
- **Geração de Relatórios:** Transforma dados brutos em insights compreensíveis sobre o estado da tecnologia.

## 🏗️ Como o Projeto é Construído

### Preparação do Ambiente
O projeto exige as seguintes chaves de ambiente (configuradas no Firebase e Google AI Studio):
- Configurações do Firebase (API Key, Project ID, etc).
- `VITE_GEMINI_API_KEY`: Para conexão com o SDK do Google Generative AI.

### Fluxo de Build
1. **Instalação:** `npm install`
2. **Desenvolvimento:** `npm run dev` (Roda na porta 3000)
3. **Build de Produção:** `npm run build`
4. **Linting:** `npm run lint` (TypeScript verification)

## 🌐 Conexões e Endpoints

Como a arquitetura é baseada em Firebase, não há endpoints REST tradicionais para o banco de dados. As conexões são feitas via SDK cliente:

- **Auth:** Login via Google Popup (`signInWithPopup`).
- **Data Sync:** listeners `onSnapshot` para atualizações em tempo real de estatísticas e progresso do usuário.
- **Rules:** O acesso é protegido por `firestore.rules`, garantindo que usuários só possam ler pesquisas públicas e editar seus próprios dados de progresso e respostas.

---
*Mantido por Lucas Batista — Cultivando transparência nos dados de tecnologia.*
