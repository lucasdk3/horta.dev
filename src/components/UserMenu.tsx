import { useState, useEffect } from "react";
import { auth, db } from "@/src/lib/firebase";
import { doc, onSnapshot } from "firebase/firestore";
import { UserProfile } from "@/src/types";
import { useAuthState } from "react-firebase-hooks/auth";
import { 
  DropdownMenu, 
  DropdownMenuContent, 
  DropdownMenuItem, 
  DropdownMenuLabel, 
  DropdownMenuSeparator, 
  DropdownMenuTrigger 
} from "@/components/ui/dropdown-menu";
import { Button } from "@/components/ui/button";
import { Progress } from "@/components/ui/progress";
import { User, Shield, LogOut, Droplets, Sprout, TreeDeciduous } from "lucide-react";
import { motion, AnimatePresence } from "motion/react";
import { useTranslation } from "react-i18next";

export default function UserMenu() {
  const [user] = useAuthState(auth);
  const [profile, setProfile] = useState<UserProfile | null>(null);
  const { t } = useTranslation();

  useEffect(() => {
    if (!user) {
      setProfile(null);
      return;
    }

    const unsubscribe = onSnapshot(doc(db, "users", user.uid), (snap) => {
      if (snap.exists()) {
        setProfile({ uid: user.uid, ...snap.data() } as UserProfile);
      }
    });

    return () => unsubscribe();
  }, [user]);

  if (!user || !profile) return null;

  // Botanical level calculation
  const xpToNextLevel = profile.level * 100;
  const progressPercent = Math.min(100, Math.max(0, (profile.xp / xpToNextLevel) * 100));

  const getStageIcon = (level: number) => {
    if (level >= 5) return <TreeDeciduous className="w-4 h-4 text-emerald-400" />;
    if (level >= 2) return <Sprout className="w-4 h-4 text-emerald-400" />;
    return <Droplets className="w-4 h-4 text-emerald-400" />;
  };

  return (
    <DropdownMenu>
      <DropdownMenuTrigger className="relative h-12 w-12 rounded-2xl bg-emerald-950/40 border border-emerald-500/20 p-0 overflow-hidden group inline-flex items-center justify-center transition-all outline-none focus-visible:ring-2 focus-visible:ring-emerald-500">
        {user.photoURL ? (
          <img src={user.photoURL} alt={user.displayName || ""} referrerPolicy="no-referrer" className="h-full w-full object-cover transition-transform group-hover:scale-110" />
        ) : (
          <User className="h-5 w-5 text-emerald-500/50" />
        )}
        <div className="absolute -bottom-1 -right-1 bg-emerald-600 text-white text-[8px] font-black w-5 h-5 rounded-md flex items-center justify-center border-2 border-black shadow-lg">
          {profile.level}
        </div>
      </DropdownMenuTrigger>
      <DropdownMenuContent className="w-80 bg-black border-emerald-500/20 text-white p-4 rounded-[2.5rem] shadow-2xl" align="end" sideOffset={12}>
        <DropdownMenuLabel className="p-0 mb-4">
          <div className="flex flex-col gap-3">
             <div className="flex items-center gap-3">
               <div className="w-12 h-12 rounded-2xl bg-emerald-900/30 border border-emerald-500/20 flex items-center justify-center">
                 {getStageIcon(profile.level)}
               </div>
               <div>
                 <p className="text-sm font-black text-white">{user.displayName || t('nav.user')}</p>
                 <p className="text-[10px] text-emerald-400 font-black uppercase tracking-widest flex items-center gap-1">
                   {t(`garden.stage.${profile.level}` as any)} 
                   <span className="opacity-30">|</span> 
                   STG {profile.level}
                 </p>
               </div>
             </div>
             
             <div className="space-y-1.5 pt-2">
               <div className="flex justify-between text-[10px] font-black uppercase tracking-widest">
                 <span className="text-emerald-500/50 flex items-center gap-1">
                   <Droplets className="w-3 h-3" />
                   {t('garden.drops')}
                 </span>
                 <span className="text-white">{profile.xp} / {xpToNextLevel}</span>
               </div>
               <div className="h-1.5 w-full bg-emerald-950 rounded-full overflow-hidden border border-white/5">
                 <motion.div 
                    initial={{ width: 0 }}
                    animate={{ width: `${progressPercent}%` }}
                    className="h-full bg-emerald-500 shadow-[0_0_10px_rgba(16,185,129,0.5)] transition-all duration-1000" 
                 />
               </div>
             </div>
          </div>
        </DropdownMenuLabel>

        <div className="grid grid-cols-2 gap-2 mb-4">
          <div className="bg-emerald-950/20 border border-white/5 p-3 rounded-2xl">
            <p className="text-[9px] uppercase font-black text-emerald-900 tracking-wider mb-1">Impact</p>
            <p className="text-lg font-bold text-white leading-none">Healthy</p>
          </div>
          <div className="bg-emerald-950/20 border border-white/5 p-3 rounded-2xl">
            <p className="text-[9px] uppercase font-black text-emerald-900 tracking-wider mb-1">Roots</p>
            <p className="text-lg font-bold text-white leading-none">{profile.badges?.length || 0}</p>
          </div>
        </div>

        <DropdownMenuSeparator className="bg-emerald-500/10" />
        
        <div className="pt-2">
          {profile.isAdmin && (
            <DropdownMenuItem className="py-3 px-3 rounded-xl focus:bg-emerald-900/30 focus:text-emerald-400 cursor-pointer gap-3">
              <Shield className="w-4 h-4" />
              <span className="text-xs font-bold uppercase tracking-widest">Garden Management</span>
            </DropdownMenuItem>
          )}
          <DropdownMenuItem onClick={() => auth.signOut()} className="py-3 px-3 rounded-xl focus:bg-red-950/30 focus:text-red-400 cursor-pointer gap-3 mt-1">
            <LogOut className="w-4 h-4" />
            <span className="text-xs font-bold uppercase tracking-widest">{t('nav.logout')}</span>
          </DropdownMenuItem>
        </div>
      </DropdownMenuContent>
    </DropdownMenu>
  );
}
