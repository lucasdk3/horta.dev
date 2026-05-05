import { BrowserRouter, Routes, Route, Link, useParams } from "react-router-dom";
import { useTranslation, I18nextProvider } from "react-i18next";
import i18n from "./lib/i18n";
import Navbar from "./components/Navbar";
import { useEffect, useState } from "react";
import { db, auth, handleFirestoreError, OperationType } from "./lib/firebase";
import { collection, query, onSnapshot, doc, getDoc, setDoc, serverTimestamp, where } from "firebase/firestore";
import { Survey, Response } from "./types";
import { motion, AnimatePresence } from "motion/react";
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from "@/components/ui/card";
import { Button, buttonVariants } from "@/components/ui/button";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Toaster } from "@/components/ui/sonner";
import SurveyForm from "./components/SurveyForm";
import SurveyTable from "./components/SurveyTable";
import SurveyAI from "./components/SurveyAI";
import SurveyChat from "./components/SurveyChat";
import About from "./components/About";
import { seed } from "./lib/seed";
import { useAuthState } from "react-firebase-hooks/auth";
import { LayoutGrid, FileText, BarChart3, Presentation, MessageSquare, Plus, ArrowLeft, Shield, Sprout, Leaf, Droplets, Flower2 } from "lucide-react";
import RequestSurveyModal from "./components/RequestSurveyModal";
import AdminDashboard from "./components/AdminDashboard";
import GlobalAssistant from "./components/GlobalAssistant";

function Home({ isAdmin }: { isAdmin: boolean }) {
  const { t, i18n } = useTranslation();
  const [surveys, setSurveys] = useState<Survey[]>([]);
  const [selectedTag, setSelectedTag] = useState<string | null>(null);
  const [isRequestModalOpen, setIsRequestModalOpen] = useState(false);
  const [activeTab, setActiveTab] = useState("surveys");
  const lang = i18n.language as "pt" | "en" | "es";

  useEffect(() => {
    const q = query(collection(db, "surveys"));
    return onSnapshot(q, (snapshot) => {
      const data = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() } as Survey));
      setSurveys(data);
    }, (error) => handleFirestoreError(error, OperationType.GET, "surveys"));
  }, []);

  const allTags = Array.from(new Set(surveys.flatMap(s => s.tags || [])));
  const filteredSurveys = selectedTag 
    ? surveys.filter(s => s.tags?.includes(selectedTag)) 
    : surveys;

  const getAccentColor = (index: number) => {
    const colors = ['red', 'blue', 'pink', 'orange', 'purple', 'yellow'];
    return colors[index % colors.length];
  };

  return (
    <div className="container mx-auto px-6 py-12 max-w-7xl">
      <header className="mb-20">
        <div className="flex flex-col md:flex-row justify-between items-start md:items-end gap-8">
          <div className="space-y-4">
            <motion.h1 
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              className="text-6xl md:text-8xl font-black tracking-tightest uppercase text-white leading-[0.9]"
            >
              Horta<br/>
              <span className="opacity-20 italic">Cultive Conhecimento</span>
            </motion.h1>
            <p className="text-xl text-slate-500 max-w-xl font-medium tracking-tight">
              {t('home.subtitle')}
            </p>
          </div>

          <div className="flex flex-col gap-4 w-full md:w-auto">
            <div className="flex gap-4">
              <Button 
                onClick={() => setIsRequestModalOpen(true)}
                className="rounded-full bg-emerald-600 hover:bg-white hover:text-black transition-all px-8 h-12 font-bold text-[10px] uppercase tracking-widest shadow-lg shadow-emerald-500/20"
              >
                <Plus className="w-4 h-4 mr-2" />
                Plant Idea
              </Button>
              {isAdmin && (
                <Button 
                  onClick={() => setActiveTab(activeTab === "admin" ? "surveys" : "admin")}
                  variant="outline"
                  className="rounded-full border-white/5 bg-white/5 hover:bg-white text-white hover:text-black transition-all px-8 h-12 font-bold text-[10px] uppercase tracking-widest"
                >
                  <Shield className="w-4 h-4 mr-2" />
                  Garden Care
                </Button>
              )}
            </div>
          </div>
        </div>

        <div className="mt-12 p-1.5 bg-slate-950/40 backdrop-blur-xl border border-white/5 rounded-full flex items-center md:w-fit mx-auto shadow-2xl">
          <Button 
             variant="ghost" 
             size="sm" 
             className={`rounded-full px-6 h-8 text-[10px] font-black uppercase tracking-widest transition-all ${selectedTag === null ? 'bg-white text-black shadow-lg' : 'text-slate-500 hover:text-white'}`}
             onClick={() => setSelectedTag(null)}
           >
             Entire Field
           </Button>
           <div className="h-4 w-[1px] bg-white/10 mx-2" />
           <div className="flex gap-1 overflow-x-auto noscroll">
             {allTags.map(tag => (
               <Button 
                key={tag}
                variant="ghost" 
                size="sm" 
                className={`rounded-full px-4 h-8 text-[10px] font-black uppercase tracking-widest transition-all ${selectedTag === tag ? 'bg-emerald-600 text-white shadow-lg' : 'text-slate-500 hover:text-white'}`}
                onClick={() => setSelectedTag(tag)}
               >
                 {tag}
               </Button>
             ))}
           </div>
        </div>
      </header>

      {activeTab === "admin" ? (
        <AdminDashboard />
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 auto-rows-[380px] gap-6">
          <AnimatePresence mode="popLayout">
            {filteredSurveys.map((survey, index) => {
              const accent = getAccentColor(index);
              const isFirst = index === 0;
              const isSecond = index === 1;
              
              return (
                <motion.div
                  key={survey.id}
                  layout
                  initial={{ opacity: 0, y: 30 }}
                  animate={{ opacity: 1, y: 0 }}
                  exit={{ opacity: 0, scale: 0.95 }}
                  transition={{ delay: index * 0.1 }}
                  className={`${isFirst ? 'md:col-span-2' : ''} ${isSecond && index > 3 ? 'md:row-span-2' : ''}`}
                >
                  <Link to={`/survey/${survey.id}`} className="h-full block">
                    <div className="bento-card group h-full flex flex-col justify-between">
                      <div className={`absolute -right-12 -top-12 text-[12rem] font-black opacity-[0.03] select-none pointer-events-none group-hover:opacity-[0.05] transition-opacity uppercase tracking-tighter accent-${accent}`}>
                        {survey.id.slice(0, 2)}
                      </div>

                      <div className="relative z-10">
                        <div className="flex items-center justify-between mb-6">
                          <div className={`w-14 h-14 rounded-2xl bg-white/5 border border-white/10 flex items-center justify-center transition-colors accent-${accent}`}>
                            <Sprout className="w-6 h-6" />
                          </div>
                          <span className={`text-[10px] uppercase font-black tracking-widest accent-${accent}`}>
                            {survey.category}
                          </span>
                        </div>

                        <h3 className={`text-3xl font-black tracking-tight text-white mb-3 ${isFirst ? 'md:text-5xl max-w-lg' : 'text-2xl'} leading-[1.1]`}>
                          {survey.title[lang] || survey.title.en}
                        </h3>
                        <p className="text-slate-500 font-medium leading-relaxed max-w-md">
                          {survey.description[lang] || survey.description.en}
                        </p>
                      </div>

                      <div className="relative z-10 flex items-end justify-between">
                        <div className="space-y-1">
                          <div className="flex gap-2">
                             {survey.tags?.slice(0, 3).map(tag => (
                               <span key={tag} className="text-[9px] uppercase font-bold text-emerald-800 tracking-wider">#{tag}</span>
                             ))}
                          </div>
                          <span className="text-[10px] uppercase font-black text-emerald-900 block">Nurturing Ecosystem</span>
                        </div>
                        
                        <div className={`w-14 h-14 rounded-2xl bg-white/5 border border-white/5 flex items-center justify-center group-hover:scale-110 transition-transform shadow-xl`}>
                          <Droplets className={`w-6 h-6 accent-${accent}`} />
                        </div>
                      </div>
                    </div>
                  </Link>
                </motion.div>
              );
            })}
          </AnimatePresence>
        </div>
      )}

      {surveys.length === 0 && activeTab !== "admin" && (
        <div className="text-center p-20 bento-card border-dashed border-white/10 space-y-8">
          <Flower2 className="w-20 h-20 mx-auto text-emerald-900" />
          <div className="space-y-2">
            <h2 className="text-3xl font-black tracking-tight">Garden Bed is Empty</h2>
            <p className="text-slate-500 font-medium">Initialize the default plant datasets to begin growing.</p>
          </div>
          <Button onClick={seed} size="lg" className="rounded-full bg-emerald-600 text-white hover:bg-emerald-500 px-10 h-14 font-black uppercase text-xs tracking-widest">
            <Plus className="w-5 h-5 mr-2" />
            Sow Seeds
          </Button>
        </div>
      )}

      <RequestSurveyModal isOpen={isRequestModalOpen} onClose={() => setIsRequestModalOpen(false)} />
      <GlobalAssistant surveys={surveys} />
    </div>
  );
}

function SurveyDetail() {
  const { id } = useParams();
  const { t, i18n } = useTranslation();
  const [survey, setSurvey] = useState<Survey | null>(null);
  const [responses, setResponses] = useState<Response[]>([]);
  const [user] = useAuthState(auth);
  const lang = i18n.language as "pt" | "en" | "es";

  useEffect(() => {
    if (!id) return;
    const sDoc = doc(db, "surveys", id);
    getDoc(sDoc).then((snap) => {
      if (snap.exists()) setSurvey({ id: snap.id, ...snap.data() } as Survey);
    }).catch(error => handleFirestoreError(error, OperationType.GET, `surveys/${id}`));

    const q = query(collection(db, "responses"), where("surveyId", "==", id));
    return onSnapshot(q, (snapshot) => {
      const data = snapshot.docs
        .map(d => ({ id: d.id, ...d.data() } as Response));
      setResponses(data);
    }, (error) => handleFirestoreError(error, OperationType.GET, "responses"));
  }, [id]);

  const alreadyResponded = user ? responses.some(r => r.respondentId === user.uid) : false;

  useEffect(() => {
    if (user) {
      const userRef = doc(db, "users", user.uid);
      getDoc(userRef).then((snap) => {
        if (!snap.exists()) {
          setDoc(userRef, {
            email: user.email,
            displayName: user.displayName,
            photoURL: user.photoURL,
            isAdmin: false,
            createdAt: serverTimestamp()
          }).catch(error => handleFirestoreError(error, OperationType.WRITE, `users/${user.uid}`));
        }
      }).catch(error => handleFirestoreError(error, OperationType.GET, `users/${user.uid}`));
    }
  }, [user]);

  if (!survey) return <div className="p-20 text-center uppercase font-black tracking-widest animate-pulse text-emerald-500">{t('common.loading')}</div>;

  return (
    <div className="container mx-auto px-6 py-10 max-w-7xl animate-in fade-in duration-700">
      <div className="mb-8 flex items-center justify-between">
        <div>
           <Link to="/" className={buttonVariants({ variant: "link", size: "sm", className: "p-0 h-auto text-slate-500 hover:text-emerald-400 gap-1 mb-2 uppercase text-[10px] font-black tracking-widest" })}>
             <ArrowLeft className="w-3 h-3" />
             {t('nav.home')}
           </Link>
           <h1 className="text-4xl font-black tracking-tight text-white">{survey.title[lang] || survey.title.en}</h1>
           <p className="text-slate-400 mt-1 flex items-center gap-2">
             <span className="text-emerald-400 font-bold">{responses.length}</span> {t('survey.total_responses')}
           </p>
        </div>
        <div className="flex gap-2">
          <Button variant="outline" className="border-white/5 bg-white/5 hover:bg-white hover:text-black rounded-xl">
             Share Pollen
          </Button>
        </div>
      </div>

      <Tabs defaultValue="respond" className="space-y-8">
        <TabsList className="bg-slate-950 border border-white/5 p-2 rounded-2xl flex flex-wrap h-auto gap-2">
          <TabsTrigger value="respond" className="flex-1 min-w-[140px] justify-start gap-3 p-3 rounded-xl data-[state=active]:bg-emerald-600 data-[state=active]:text-white transition-all text-left group">
            <div className="w-8 h-8 rounded-lg bg-emerald-500/10 flex items-center justify-center group-data-[state=active]:bg-white/20">
              <Droplets className="w-4 h-4" />
            </div>
            <div>
              <p className="font-bold text-xs uppercase tracking-tight leading-none mb-1">1. {t('survey.respond')}</p>
              <p className="text-[9px] opacity-60 font-medium">Regue os dados</p>
            </div>
          </TabsTrigger>
          <TabsTrigger value="data" className="flex-1 min-w-[140px] justify-start gap-3 p-3 rounded-xl data-[state=active]:bg-emerald-600 data-[state=active]:text-white transition-all text-left group">
            <div className="w-8 h-8 rounded-lg bg-emerald-500/10 flex items-center justify-center group-data-[state=active]:bg-white/20">
              <Sprout className="w-4 h-4" />
            </div>
            <div>
              <p className="font-bold text-xs uppercase tracking-tight leading-none mb-1">2. {t('survey.data')}</p>
              <p className="text-[9px] opacity-60 font-medium">Colha os insights</p>
            </div>
          </TabsTrigger>
          <TabsTrigger value="presentation" className="flex-1 min-w-[140px] justify-start gap-3 p-3 rounded-xl data-[state=active]:bg-emerald-600 data-[state=active]:text-white transition-all text-left group">
            <div className="w-8 h-8 rounded-lg bg-emerald-500/10 flex items-center justify-center group-data-[state=active]:bg-white/20">
              <Flower2 className="w-4 h-4" />
            </div>
            <div>
              <p className="font-bold text-xs uppercase tracking-tight leading-none mb-1">3. {t('survey.presentation')}</p>
              <p className="text-[9px] opacity-60 font-medium">Florescer IA</p>
            </div>
          </TabsTrigger>
          <TabsTrigger value="chat" className="flex-1 min-w-[140px] justify-start gap-3 p-3 rounded-xl data-[state=active]:bg-emerald-600 data-[state=active]:text-white transition-all text-left group">
            <div className="w-8 h-8 rounded-lg bg-emerald-500/10 flex items-center justify-center group-data-[state=active]:bg-white/20">
              <MessageSquare className="w-4 h-4" />
            </div>
            <div>
              <p className="font-bold text-xs uppercase tracking-tight leading-none mb-1">4. {t('survey.chat')}</p>
              <p className="text-[9px] opacity-60 font-medium">Conversar com o Jardim</p>
            </div>
          </TabsTrigger>
        </TabsList>
        
        <div className="bg-slate-950 border border-white/5 rounded-[2.5rem] p-6 md:p-10 shadow-2xl relative overflow-hidden min-h-[600px] bento-card">
          <div className="absolute top-0 right-0 p-8 select-none pointer-events-none opacity-[0.02]">
            <Sprout className="w-96 h-96 -mr-48 -mt-48 text-emerald-500" />
          </div>
          
          <div className="relative z-10">
            <TabsContent value="respond" className="m-0 border-0 p-0 shadow-none">
              <div className="max-w-2xl mx-auto">
                <SurveyForm 
                  survey={survey} 
                  alreadyResponded={alreadyResponded} 
                  onSuccess={() => {}} 
                />
              </div>
            </TabsContent>
            <TabsContent value="data" className="m-0 border-0 p-0 shadow-none">
              <SurveyTable survey={survey} responses={responses} />
            </TabsContent>
            <TabsContent value="presentation" className="m-0 border-0 p-0 shadow-none">
              <SurveyAI survey={survey} responses={responses} />
            </TabsContent>

            <TabsContent value="chat" className="m-0 border-0 p-0 shadow-none">
              <SurveyChat survey={survey} responses={responses} />
            </TabsContent>
          </div>
        </div>
      </Tabs>
    </div>
  );
}

export default function App() {
  const [user] = useAuthState(auth);
  const [isAdmin, setIsAdmin] = useState(false);

  useEffect(() => {
    if (user) {
      const userRef = doc(db, "users", user.uid);
      getDoc(userRef).then((snap) => {
        if (snap.exists()) {
          setIsAdmin(snap.data()?.isAdmin || user.email === 'lucasbatista1996@gmail.com');
        }
      }).catch(error => handleFirestoreError(error, OperationType.GET, `users/${user.uid}`));
    } else {
      setIsAdmin(false);
    }
  }, [user]);

  return (
    <I18nextProvider i18n={i18n}>
      <BrowserRouter>
        <div className="min-h-screen bg-[#020402] font-sans selection:bg-emerald-500/30 flex flex-col">
          <Navbar />
          <main className="flex-1">
            <Routes>
              <Route path="/" element={<Home isAdmin={isAdmin} />} />
              <Route path="/about" element={<About />} />
              <Route path="/survey/:id" element={<SurveyDetail />} />
            </Routes>
          </main>
          
          <footer className="h-10 bg-emerald-600 px-6 flex items-center justify-between text-[10px] font-bold uppercase tracking-[0.2em] text-white">
            <div className="flex gap-8">
              <span>Ecosystem: Blooming</span>
              <span>Horta v2.0</span>
            </div>
            <div className="flex items-center gap-4">
               <button onClick={() => seed()} className="hover:underline opacity-80 cursor-pointer">Sow Initial Data</button>
               <span>Nurtured by Lucas Batista</span>
            </div>
          </footer>
          <Toaster position="top-center" richColors theme="dark" />
        </div>
      </BrowserRouter>
    </I18nextProvider>
  );
}
