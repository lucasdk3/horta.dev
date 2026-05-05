import i18n from "i18next";
import { initReactI18next } from "react-i18next";
import LanguageDetector from "i18next-browser-languagedetector";

const resources = {
  en: {
    translation: {
      "nav.home": "Home",
      "nav.login": "Login",
      "nav.logout": "Logout",
      "common.back": "Back to Home",
      "about.hero.title": "Cultivating Knowledge",
      "about.hero.subtitle": "Open data is the soil of a better engineering culture. Join us in growing the global DevOps community.",
      "nav.about": "Garden Info",
      "nav.contribute": "Cultivate",
      "nav.privacy": "Privacy",
      "about.mission.title": "Our Garden Mission",
      "about.mission.p1": "Horta was born from a critical observation: the industry often lacks precise, accessible, and unbiased data to nourish real engineering progress. While there are many reports, they frequently overlook regional nuances and specific niche workflows.",
      "about.mission.p2": "Our goal is to plant the seeds for a more transparent future. We want to understand the patterns, the toolsets, and the methodologies used across different cultures and borders. By watering this global knowledge, we empower individuals and organizations to grow together.",
      "about.creator.title": "The Caretaker",
      "about.creator.name": "Lucas Batista",
      "about.creator.role": "Full Stack Engineer & Growth Researcher",
      "about.creator.bio": "Passionate about data transparency and building community-driven tools that help the tech ecosystem bloom.",
      "about.creator.contact": "Contact",
      "about.creator.phone": "+55 (00) 00000-0000",
      "garden.drops": "Drops",
      "garden.stage": "Growth Stage",
      "garden.stage.1": "Seed",
      "garden.stage.2": "Sprout",
      "garden.stage.3": "Sapling",
      "garden.stage.4": "Bush",
      "garden.stage.5": "Tree",
      "garden.stage.6": "Ancient",
      "home.title": "Horta",
      "home.subtitle": "Nurturing the tech and developer ecosystem",
      "survey.respond": "Nurture",
      "survey.data": "Harvest",
      "survey.presentation": "AI Insights",
      "survey.chat": "AI Chat",
      "survey.no_responses": "No responses yet.",
      "survey.total_responses": "Total responses",
      "survey.country": "Country",
      "survey.submit": "Submit Response",
      "survey.already_voted": "You have already responded to this survey.",
      "survey.loading_ai": "Generating AI summary...",
      "create.survey": "Create Survey",
      "common.email": "Email",
      "common.loading": "Loading...",
      "common.error": "An error occurred."
    }
  },
  pt: {
    translation: {
      "nav.home": "Início",
      "nav.login": "Entrar",
      "nav.logout": "Sair",
      "common.back": "Voltar ao Início",
      "about.hero.title": "Cultivando Conhecimento",
      "about.hero.subtitle": "Dados abertos são o solo de uma melhor cultura de engenharia. Junte-se a nós no crescimento da comunidade DevOps.",
      "nav.about": "Sobre o Jardim",
      "nav.contribute": "Cultivar",
      "nav.privacy": "Privacidade",
      "about.mission.title": "Nossa Missão",
      "about.mission.p1": "O Horta nasceu de uma observação crítica: a indústria muitas vezes carece de dados precisos e acessíveis para nutrir o progresso real da engenharia. Embora existam muitos relatórios, eles frequentemente ignoram as nuances regionais.",
      "about.mission.p2": "Nosso objetivo é plantar as sementes para um futuro mais transparente. Queremos entender os padrões e metodologias mundiais. Ao regar esse conhecimento global, capacitamos indivíduos e organizações a crescerem juntos.",
      "about.creator.title": "O Cuidador",
      "about.creator.name": "Lucas Batista",
      "about.creator.role": "Engenheiro Full Stack e Pesquisador de Crescimento",
      "about.creator.bio": "Apaixonado por transparência de dados e pela construção de ferramentas comunitárias que ajudam o ecossistema tech a florescer.",
      "about.creator.contact": "Contato",
      "about.creator.phone": "+55 (00) 00000-0000",
      "garden.drops": "Gotas",
      "garden.stage": "Estágio",
      "garden.stage.1": "Semente",
      "garden.stage.2": "Broto",
      "garden.stage.3": "Planta Jovem",
      "garden.stage.4": "Arbusto",
      "garden.stage.5": "Árvore",
      "garden.stage.6": "Ancião",
      "home.title": "Horta",
      "home.subtitle": "Nutrindo o ecossistema de desenvolvedores",
      "survey.respond": "Nutrir",
      "survey.data": "Colher",
      "survey.presentation": "Insights IA",
      "survey.chat": "Chat IA",
      "survey.no_responses": "Ainda não há respostas.",
      "survey.total_responses": "Total de respostas",
      "survey.country": "País",
      "survey.submit": "Enviar Resposta",
      "survey.already_voted": "Você já respondeu a esta pesquisa.",
      "survey.loading_ai": "Gerando resumo com IA...",
      "create.survey": "Criar Pesquisa",
      "common.email": "E-mail",
      "common.loading": "Carregando...",
      "common.error": "Ocorreu um erro."
    }
  },
  es: {
    translation: {
      "nav.home": "Inicio",
      "nav.login": "Acceder",
      "nav.logout": "Cerrar sesión",
      "common.back": "Volver al Inicio",
      "about.hero.title": "Proyecto de Investigación Comunitaria",
      "about.hero.subtitle": "Datos abiertos para una mejor cultura de ingeniería. Únete a nosotros para mapear el futuro de DevOps.",
      "nav.about": "Acerca de",
      "nav.contribute": "Contribuir",
      "nav.privacy": "Privacidad",
      "about.mission.title": "Nuestra Misión",
      "about.mission.p1": "DevSurvey Hub nació de una observación crítica: la industria a menudo carece de datos precisos, accesibles e imparciales sobre las prácticas de ingeniería en el mundo real. Aunque existen muchos informes, con frecuencia pasan por alto los matices regionales y los flujos de trabajo específicos.",
      "about.mission.p2": "Nuestro objetivo es mapear cómo se desarrolla el mundo. Queremos entender los patrones, las herramientas y las metodologías utilizadas en diferentes culturas y fronteras. Al centralizar este conocimiento global, empoderamos a individuos y organizaciones para tomar decisiones basadas en datos, adoptar mejores estándares y fomentar una cultura de ingeniería más inclusiva.",
      "about.creator.title": "El Mantenedor",
      "about.creator.name": "Lucas Batista",
      "about.creator.role": "Ingeniero Full Stack e Investigador",
      "about.creator.bio": "Apasionado por la transparencia de los datos y la creación de herramientas comunitarias que ayuden a los ingenieros a crecer juntos.",
      "about.creator.contact": "Contacto",
      "about.creator.phone": "+55 (00) 00000-0000",
      "home.title": "DevSurvey Hub",
      "home.subtitle": "Investigación comunitaria para DevOps y Desarrolladores",
      "survey.respond": "Responder",
      "survey.data": "Datos",
      "survey.presentation": "Insights IA",
      "survey.chat": "Chat IA",
      "survey.no_responses": "Aún no hay respuestas.",
      "survey.total_responses": "Total de respuestas",
      "survey.country": "País",
      "survey.submit": "Enviar Respuesta",
      "survey.already_voted": "Ya has respondido a esta encuesta.",
      "survey.loading_ai": "Generando resumen con IA...",
      "create.survey": "Crear Encuesta",
      "common.email": "Email",
      "common.loading": "Cargando...",
      "common.error": "Ocurrió un error."
    }
  }
};

i18n
  .use(LanguageDetector)
  .use(initReactI18next)
  .init({
    resources,
    fallbackLng: "en",
    interpolation: {
      escapeValue: false
    }
  });

export default i18n;
