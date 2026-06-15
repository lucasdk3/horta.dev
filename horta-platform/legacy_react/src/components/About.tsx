import { useTranslation } from "react-i18next";
import { motion } from "motion/react";
import { 
  Sprout, 
  Heart, 
  Shield, 
  ArrowLeft, 
  Github, 
  Leaf, 
  MessageSquare,
  Trees,
  Linkedin,
  Mail,
  Flower
} from "lucide-react";
import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";

export default function About() {
  const { t } = useTranslation();

  const sections = [
    {
      id: "about",
      icon: <Sprout className="w-6 h-6 text-emerald-400" />,
      title: t("about.mission.title"),
      content: (
        <div className="space-y-4 text-slate-400 leading-relaxed">
          <p>
            {t("about.mission.p1")}
          </p>
          <p>
            {t("about.mission.p2")}
          </p>
        </div>
      )
    },
    {
      id: "contribute",
      icon: <Flower className="w-6 h-6 text-lime-400" />,
      title: t("nav.contribute"),
      content: (
        <div className="space-y-6">
          <p className="text-slate-400">
            Há muitas formas de apoiar o jardim e nos ajudar a crescer:
          </p>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="p-4 rounded-2xl bg-emerald-950/20 border border-white/5 hover:border-emerald-500/30 transition-colors">
              <h4 className="text-white font-bold mb-2 flex items-center gap-2">
                <Leaf className="w-4 h-4 text-emerald-400" /> Participar
              </h4>
              <p className="text-sm text-slate-400">Regue os dados respondendo às pesquisas ativas e compartilhando sua stack.</p>
            </div>
            <div className="p-4 rounded-2xl bg-emerald-950/20 border border-white/5 hover:border-emerald-500/30 transition-colors">
              <h4 className="text-white font-bold mb-2 flex items-center gap-2">
                <MessageSquare className="w-4 h-4 text-lime-400" /> Sugerir Tópicos
              </h4>
              <p className="text-sm text-slate-400">Plante novas ideias de pesquisa usando o botão "Plant Idea".</p>
            </div>
            <div className="p-4 rounded-2xl bg-emerald-950/20 border border-white/5 hover:border-emerald-500/30 transition-colors">
              <h4 className="text-white font-bold mb-2 flex items-center gap-2">
                <Github className="w-4 h-4 text-white" /> Open Source
              </h4>
              <p className="text-sm text-slate-400">Ajude a nutrir a plataforma contribuindo para o nosso código.</p>
            </div>
            <div className="p-4 rounded-2xl bg-emerald-950/20 border border-white/5 hover:border-emerald-500/30 transition-colors">
              <h4 className="text-white font-bold mb-2 flex items-center gap-2">
                <Heart className="w-4 h-4 text-emerald-400 font-bold" /> Espalhe o Pólen
              </h4>
              <p className="text-sm text-slate-400">Compartilhe as pesquisas para aumentar a diversidade do nosso ecossistema.</p>
            </div>
          </div>
        </div>
      )
    },
    {
      id: "creator",
      icon: <Sprout className="w-6 h-6 text-emerald-400" />,
      title: t("about.creator.title"),
      content: (
        <div className="flex flex-col md:flex-row gap-8 items-start">
          <div className="w-24 h-24 rounded-3xl bg-emerald-950/40 border border-white/5 shrink-0 flex items-center justify-center text-emerald-500 text-4xl shadow-2xl">
            <Trees className="w-10 h-10" />
          </div>
          <div className="flex-1 space-y-4">
            <div>
              <h3 className="text-2xl font-black text-white">{t("about.creator.name")}</h3>
              <p className="text-emerald-400 font-bold text-xs uppercase tracking-widest">{t("about.creator.role")}</p>
            </div>
            <p className="text-slate-400 leading-relaxed font-medium">
              {t("about.creator.bio")}
            </p>
            <div className="flex flex-wrap gap-6 pt-4 border-t border-white/5">
              <a 
                href="https://linkedin.com" 
                target="_blank" 
                rel="noreferrer"
                className="flex items-center gap-2 text-[10px] font-black uppercase tracking-widest text-slate-400 hover:text-white transition-all group"
              >
                <div className="w-8 h-8 rounded-lg bg-white/5 border border-white/5 flex items-center justify-center group-hover:bg-emerald-600 transition-colors">
                  <Linkedin className="w-4 h-4" />
                </div>
                LinkedIn
              </a>
              <a 
                href={`mailto:lucasbatista1996@gmail.com`}
                className="flex items-center gap-2 text-[10px] font-black uppercase tracking-widest text-slate-400 hover:text-white transition-all group"
              >
                <div className="w-8 h-8 rounded-lg bg-white/5 border border-white/5 flex items-center justify-center group-hover:bg-emerald-600 transition-colors">
                  <Mail className="w-4 h-4" />
                </div>
                Email
              </a>
            </div>
          </div>
        </div>
      )
    },
    {
      id: "privacy",
      icon: <Shield className="w-6 h-6 text-emerald-400" />,
      title: t("nav.privacy"),
      content: (
        <div className="space-y-4 text-slate-400 leading-relaxed text-sm">
          <div className="p-6 rounded-2xl bg-black border border-white/5">
            <h4 className="text-white font-bold mb-4">Privacy Roots</h4>
            <ul className="space-y-3 list-disc pl-4 marker:text-emerald-500">
              <li><strong>Dados Anonimizados:</strong> Suas respostas são processadas de forma anônima no jardim.</li>
              <li><strong>Sem Venda de Dados:</strong> Nunca vendemos suas informações. O objetivo é a nutrição do ecossistema.</li>
              <li><strong>Google Login:</strong> Acesso seguro focado no cuidado com a integridade das pesquisas.</li>
            </ul>
          </div>
        </div>
      )
    }
  ];

  return (
    <div className="max-w-7xl mx-auto px-6 py-12 md:py-20 flex flex-col gap-12">
      <motion.div
        initial={{ opacity: 0, scale: 0.95 }}
        animate={{ opacity: 1, scale: 1 }}
        className="space-y-6"
      >
        <Link to="/">
          <Button variant="outline" className="rounded-full border-white/5 bg-white/5 text-emerald-500 hover:bg-white hover:text-black transition-all h-10 px-6 font-bold text-[10px] uppercase tracking-widest">
            <ArrowLeft className="w-4 h-4 mr-2" />
            {t("common.back")}
          </Button>
        </Link>
        <h1 className="text-6xl md:text-8xl font-black text-white tracking-tightest leading-[0.85] uppercase">
          Horta<br/>
          <span className="opacity-20 italic">Ecosystem</span>
        </h1>
        <p className="text-xl text-slate-500 max-w-2xl font-medium tracking-tight">
          {t("about.hero.subtitle")}
        </p>
      </motion.div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 auto-rows-auto md:auto-rows-[440px] gap-6">
        {/* Gap Card - The Problem */}
        <motion.div 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="lg:col-span-2 bento-card flex flex-col justify-between"
        >
          <div className="absolute -right-12 -top-12 text-[12rem] font-black opacity-[0.03] select-none pointer-events-none accent-blue">01</div>
          <div className="relative z-10">
            <div className="flex items-center gap-4 mb-8">
              <div className="w-14 h-14 rounded-2xl bg-white/5 border border-white/10 flex items-center justify-center accent-blue shadow-xl">
                <Leaf className="w-6 h-6" />
              </div>
              <h2 className="text-3xl font-black text-white uppercase tracking-tight">O Gap</h2>
            </div>
            <div className="space-y-4 text-slate-400 leading-relaxed font-medium text-lg">
              <p>{t("about.mission.p1")}</p>
              <p>{t("about.mission.p2")}</p>
              <p className="hidden md:block">{t("about.mission.p3")}</p>
              <p className="font-black text-white border-l-4 border-emerald-500 pl-4 py-2 bg-emerald-500/5">{t("about.mission.p4")}</p>
            </div>
          </div>
        </motion.div>

        {/* Concept Card - The Idea */}
        <motion.div 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
          className="bento-card flex flex-col justify-between"
        >
          <div className="absolute -right-12 -top-12 text-[12rem] font-black opacity-[0.03] select-none pointer-events-none accent-emerald">02</div>
          <div className="relative z-10">
            <div className="w-14 h-14 rounded-2xl bg-white/5 border border-white/10 flex items-center justify-center accent-emerald shadow-xl mb-8">
              <Sprout className="w-6 h-6" />
            </div>
            <h2 className="text-3xl font-black text-white uppercase tracking-tight mb-6">O Conceito</h2>
            <div className="space-y-6 text-slate-400 font-medium leading-relaxed">
              <p>{t("about.mission.p5")}</p>
            </div>
          </div>
        </motion.div>

        {/* Creator Card */}
        <motion.div 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.15 }}
          className="bento-card flex flex-col justify-between"
        >
          <div className="absolute -right-12 -top-12 text-[12rem] font-black opacity-[0.03] select-none pointer-events-none accent-purple">03</div>
          <div className="relative z-10 h-full flex flex-col justify-between">
            <div>
               <div className="w-14 h-14 rounded-2xl bg-white/5 border border-white/10 flex items-center justify-center accent-purple shadow-xl mb-8">
                 <Trees className="w-6 h-6" />
               </div>
               <h3 className="text-3xl font-black text-white uppercase tracking-tight mb-1">{t("about.creator.name")}</h3>
               <p className="text-emerald-400 font-bold text-xs uppercase tracking-widest mb-4">{t("about.creator.role")}</p>
               <p className="text-slate-400 font-medium leading-relaxed">{t("about.creator.bio")}</p>
            </div>
            
            <div className="flex gap-4 pt-6 mt-6 border-t border-white/5">
              <a href="https://linkedin.com" target="_blank" rel="noreferrer" className="w-10 h-10 rounded-xl bg-white/5 border border-white/5 flex items-center justify-center hover:bg-white hover:text-black transition-all">
                <Linkedin className="w-4 h-4" />
              </a>
              <a href={`mailto:lucasbatista1996@gmail.com`} className="w-10 h-10 rounded-xl bg-white/5 border border-white/5 flex items-center justify-center hover:bg-white hover:text-black transition-all">
                <Mail className="w-4 h-4" />
              </a>
            </div>
          </div>
        </motion.div>

        {/* Impact Card - Seasoning */}
        <motion.div 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
          className="bento-card flex flex-col justify-between"
        >
          <div className="absolute -right-12 -top-12 text-[12rem] font-black opacity-[0.03] select-none pointer-events-none accent-orange">04</div>
          <div className="relative z-10">
            <div className="w-14 h-14 rounded-2xl bg-white/5 border border-white/10 flex items-center justify-center accent-orange shadow-xl mb-8">
              <MessageSquare className="w-6 h-6" />
            </div>
            <h2 className="text-3xl font-black text-white uppercase tracking-tight mb-6">Processo</h2>
            <div className="space-y-4 text-slate-400 font-medium leading-relaxed">
              <p>{t("about.mission.p6")}</p>
            </div>
          </div>
        </motion.div>

        {/* Goal Card */}
        <motion.div 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.25 }}
          className="bento-card bg-emerald-600/10 border-emerald-500/20 flex flex-col justify-between"
        >
          <div className="absolute -right-12 -top-12 text-[12rem] font-black opacity-[0.05] select-none pointer-events-none text-emerald-500">05</div>
          <div className="relative z-10">
            <div className="w-14 h-14 rounded-2xl bg-emerald-600 flex items-center justify-center text-white shadow-xl shadow-emerald-500/20 mb-8">
              <Sprout className="w-6 h-6" />
            </div>
            <h2 className="text-3xl font-black text-white uppercase tracking-tight mb-6">Nosso Objetivo</h2>
            <div className="space-y-4 text-white font-bold leading-relaxed text-lg">
              <p>{t("about.mission.p7")}</p>
            </div>
          </div>
        </motion.div>

        {/* Contribute Card */}
        <motion.div 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
          className="bento-card flex flex-col justify-between"
        >
          <div className="absolute -right-12 -top-12 text-[12rem] font-black opacity-[0.03] select-none pointer-events-none accent-red">06</div>
          <div className="relative z-10">
            <div className="w-14 h-14 rounded-2xl bg-white/5 border border-white/10 flex items-center justify-center accent-red shadow-xl mb-8">
              <Flower className="w-6 h-6" />
            </div>
            <h2 className="text-3xl font-black text-white uppercase tracking-tight mb-4">{t("nav.contribute")}</h2>
            <div className="space-y-4">
               {[
                 { icon: <Leaf className="w-3 h-3"/>, label: "Respond" },
                 { icon: <MessageSquare className="w-3 h-3"/>, label: "Suggest Seeds" },
                 { icon: <Github className="w-3 h-3"/>, label: "Garden Lab" }
               ].map(item => (
                 <div key={item.label} className="flex items-center gap-3 p-3 rounded-2xl bg-white/5 border border-white/5 hover:border-white/20 transition-all cursor-default">
                   <div className="w-6 h-6 rounded-lg bg-white/5 flex items-center justify-center text-emerald-400">
                     {item.icon}
                   </div>
                   <span className="text-[10px] font-black uppercase tracking-widest text-white">{item.label}</span>
                 </div>
               ))}
            </div>
          </div>
        </motion.div>

        {/* Privacy Card */}
        <motion.div 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.35 }}
          className="lg:col-span-3 bento-card flex flex-col justify-between"
        >
          <div className="absolute -right-12 -top-12 text-[12rem] font-black opacity-[0.03] select-none pointer-events-none accent-yellow">07</div>
          <div className="relative z-10">
            <div className="w-14 h-14 rounded-2xl bg-white/5 border border-white/10 flex items-center justify-center accent-yellow shadow-xl mb-8">
              <Shield className="w-6 h-6" />
            </div>
            <h2 className="text-3xl font-black text-white uppercase tracking-tight mb-6">{t("nav.privacy")}</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-x-12 gap-y-4">
               {[
                 "Dados anonimizados processados no jardim.",
                 "Sua privacidade é nossa maior raiz.",
                 "Autenticação segura via Google Garden.",
                 "Transparência em todos os insights gerados."
               ].map(text => (
                 <div key={text} className="flex items-start gap-3">
                   <div className="w-1.5 h-1.5 rounded-full bg-emerald-500 mt-2 shrink-0 shadow-glow shadow-emerald-500/50" />
                   <p className="text-slate-400 font-medium text-sm leading-relaxed">{text}</p>
                 </div>
               ))}
            </div>
          </div>
        </motion.div>
      </div>

      <footer className="mt-20 pt-12 border-t border-white/5 text-center">
        <p className="text-slate-600 text-[10px] font-black uppercase tracking-[0.4em]">
          Horta © {new Date().getFullYear()} • Powered by Community Ecosystem
        </p>
      </footer>
    </div>
  );
}
