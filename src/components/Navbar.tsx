import { useTranslation } from "react-i18next";
import { auth, signInWithGoogle } from "@/src/lib/firebase";
import { useAuthState } from "react-firebase-hooks/auth";
import { Link } from "react-router-dom";
import { Button, buttonVariants } from "@/components/ui/button";
import { Search, LogIn } from "lucide-react";
import { motion } from "motion/react";
import UserMenu from "./UserMenu";
import Logo from "./Logo";

export default function Navbar() {
  const { t, i18n } = useTranslation();
  const [user] = useAuthState(auth);

  const changeLanguage = (lng: string) => {
    i18n.changeLanguage(lng);
  };

  const linkClass = buttonVariants({ 
    variant: "ghost", 
    size: "sm", 
    className: "font-bold uppercase text-[10px] tracking-widest text-emerald-100/50 hover:text-emerald-400" 
  });

  return (
    <nav className="h-20 flex items-center sticky top-0 z-50 pointer-events-none">
      <div className="container mx-auto px-6 h-full flex items-center justify-between pointer-events-auto">
        <Link to="/" className="flex items-center gap-3 font-bold text-xl cursor-pointer select-none">
          <motion.div 
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            className="flex items-center gap-3"
          >
            <div className="relative group">
              <Logo size={48} className="z-10 relative" />
              <div className="absolute -top-1 -right-1 w-5 h-5 bg-white rounded-lg flex items-center justify-center text-emerald-600 shadow-md transform rotate-12 group-hover:rotate-0 transition-transform z-20">
                <Search className="w-3 h-3" />
              </div>
            </div>
            <span className="tracking-tighter uppercase text-white font-black text-2xl">Horta<span className="text-emerald-500">.dev</span></span>
          </motion.div>
        </Link>

        <div className="hidden lg:flex items-center p-1 px-2 gap-1 bg-emerald-950/40 backdrop-blur-2xl border border-emerald-500/10 rounded-full shadow-2xl">
          <Link to="/" className={linkClass}>
            {t("nav.home")}
          </Link>
          <Link to="/about" className={linkClass}>
            {t("nav.about")}
          </Link>
          <Link to="/about#contribute" className={linkClass}>
            {t("nav.contribute")}
          </Link>
          <Link to="/about#privacy" className={linkClass}>
            {t("nav.privacy")}
          </Link>
        </div>

        <div className="flex items-center gap-4 p-1 px-4 bg-emerald-950/40 backdrop-blur-2xl border border-emerald-500/10 rounded-full shadow-2xl">
          <div className="hidden md:flex gap-1">
            <button onClick={() => changeLanguage('pt')} className={`w-8 h-8 flex items-center justify-center text-[10px] font-black rounded-full transition-all ${i18n.language.startsWith('pt') ? 'bg-emerald-600 text-white' : 'text-emerald-500/50 hover:text-white'}`}>PT</button>
            <button onClick={() => changeLanguage('en')} className={`w-8 h-8 flex items-center justify-center text-[10px] font-black rounded-full transition-all ${i18n.language.startsWith('en') ? 'bg-emerald-600 text-white' : 'text-emerald-500/50 hover:text-white'}`}>EN</button>
            <button onClick={() => changeLanguage('es')} className={`w-8 h-8 flex items-center justify-center text-[10px] font-black rounded-full transition-all ${i18n.language.startsWith('es') ? 'bg-emerald-600 text-white' : 'text-emerald-500/50 hover:text-white'}`}>ES</button>
          </div>

          <div className="w-[1px] h-4 bg-white/10 hidden md:block" />

          {user ? (
            <UserMenu />
          ) : (
            <button onClick={signInWithGoogle} className="flex items-center gap-2 text-[10px] uppercase font-black tracking-widest text-white hover:text-emerald-400 transition-colors">
              <LogIn className="w-4 h-4" />
              <span>{t('nav.login')}</span>
            </button>
          )}
        </div>
      </div>
    </nav>
  );
}
