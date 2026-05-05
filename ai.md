# AI Blueprints: Projeto Horta 🌿

Este documento serve como a "Fonte da Verdade" técnica e visual para qualquer IA que deseje replicar, manter ou expandir o projeto **Horta**.

## 🎯 Conceito Central
Horta é uma **Plataforma de Jardinagem Digital de Dados**. O objetivo é coletar dados de pesquisa da comunidade tech (Devs, DevOps, Designers) de forma gamificada, onde o conhecimento é "plantado" (respostas) e "colhido" (insights IA).

---

## 🎨 DNA de Design (Visual Specs)

### Paleta de Cores
- **Base:** `#020402` (Preto profundo, quase absoluto)
- **Acento Primário:** Emerald-500 (`#10b981`) - Usado para estados ativos, botões globais e ícones de "vida".
- **Acento Secundário:** Emerald-900/10 (Usado para superfícies de cards e backgrounds secundários).
- **Texto Primário:** Branco Puro (`#ffffff`)
- **Texto Secundário:** Slate-500 (`#64748b`)

### Tipografia
- **Títulos (Headings):** Fontes Sans-serif com peso **Black (900)** ou **Extra Bold (800)**. 
- **Estilo de Título:** Tracking extra-apertado (`tracking-tightest`), uppercase, às vezes com itálico decorativo para contraste.
- **Corpo:** Inter ou Space Grotesk para um ar técnico e moderno.

### Componentes & Layout
- **Bento Grid:** A Home utiliza um grid de cards de tamanhos variados (1:1, 2:1, 1:2) inspirados no design do Apple Vision Pro e sites da Stripe.
- **Bento-Card Style:** Bordas arredondadas generosas (`rounded-[2.5rem]`), bordas finas com baixa opacidade (`border-white/5`), e blur de fundo (`backdrop-blur-xl`).
- **Animações (Framer Motion):** 
  - Entradas em cascata (`staggerChildren`).
  - Transições de página em fade suave.
  - Hover states que escalam levemente o card.

---

## 🧠 Arquitetura de Software

### Stack Tech
- **React 19** + **TypeScript** (Typed props para tudo).
- **Vite:** Bundler ultra-rápido.
- **Firebase Firestore:** Banco NoSQL em tempo real.
- **Firebase Auth:** Login social via Google.
- **Gemini 1.5 Flash:** Motor de análise de dados e chatbot.

### Estrutura de Pastas Sugerida
- `/src/components`: UI Atomic (Buttons, Cards, Modals).
- `/src/lib`: Serviços (Firebase, i18n, Gemini).
- `/src/types.ts`: Definições globais de interfaces.

---

## 🗄️ Modelagem de Dados (Firestore)

### Entidade: `users`
| Campo | Tipo | Descrição |
| :--- | :--- | :--- |
| `uid` | string | ID único (PK) |
| `email` | string | Email do Google |
| `xp` | number | "Drops" acumulados |
| `level` | number | Estágio de crescimento (1-10) |
| `isAdmin` | boolean | Permissões de Admin |

### Entidade: `surveys`
| Campo | Tipo | Descrição |
| :--- | :--- | :--- |
| `title` | map | `{ en: string, pt: string, es: string }` |
| `questions` | array | Lista de objetos de pergunta |
| `active` | boolean | Visibilidade no site |

### Entidade: `survey_analyses` (Cache)
| Campo | Tipo | Descrição |
| :--- | :--- | :--- |
| `surveyId` | string | FK para survey |
| `lang` | string | Idioma da análise (pt, en, es) |
| `countryFilter` | string | Filtro geográfico aplicado |
| `summary` | string | Conteúdo Markdown gerado pela IA |
| `responseCount` | number | Quantidade de respostas no momento da geração |
| `updatedAt` | timestamp | Data da última geração |

---

## 💎 Estratégia de Economia de Tokens
Para otimizar o uso da API Gemini, implementamos um sistema de cache no Firestore. A lógica reside em `SurveyAI.tsx`, que verifica se o `responseCount` atual condiz com o cache antes de disparar uma nova requisição para a IA.

---

## 🔄 Conexões e Lógica

### Gamificação (O Ciclo da Rega)
Cada resposta (`response`) gera um gatilho de XP.
- **Fórmula de Level:** `Math.floor(Math.sqrt(XP / 100)) + 1`.
- **Efeito Visual:** O ícone do usuário no menu evolui de uma Semente para um Broto, e eventualmente para uma Árvore conforme o nível sobe.

### Brain Local (Integrando Gemini)
O assistente de IA recebe o contexto de todas as respostas coletadas em uma pesquisa via a função `onSnapshot`. Ele analisa padrões e retorna um JSON estruturado para o componente `SurveyAI.tsx`.

---

## 📝 Referências de Prompt para IA (Frontend)

Ao pedir para a IA criar uma tela nova, use:
> "Siga o estilo Horta: Background dark mode #020402, acentos em Emerald Green, tipografia brutalista extra-bold, use cards estilo Bento com bordas white/5 e arredondamento 40px. Adicione animações de entrada usando motion/react."

---
*Escrito para guiar a próxima geração de desenvolvedores e IAs na Horta.*
