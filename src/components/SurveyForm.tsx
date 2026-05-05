import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import { Survey, Question } from "@/src/types";
import { useTranslation } from "react-i18next";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { auth, db, handleFirestoreError, OperationType, grantXP } from "@/src/lib/firebase";
import { doc, setDoc, serverTimestamp } from "firebase/firestore";
import { toast } from "sonner";
import { useAuthState } from "react-firebase-hooks/auth";
import { Loader2, FileText } from "lucide-react";
import confetti from "canvas-confetti";

interface SurveyFormProps {
  survey: Survey;
  onSuccess: () => void;
  alreadyResponded: boolean;
}

export default function SurveyForm({ survey, onSuccess, alreadyResponded }: SurveyFormProps) {
  const { t, i18n } = useTranslation();
  const [user] = useAuthState(auth);
  const lang = i18n.language as "pt" | "en" | "es";

  const formSchema = z.object({
    country: z.string().min(2),
    answers: z.record(z.string(), z.any())
  });

  const { register, handleSubmit, setValue, watch, formState: { errors, isSubmitting } } = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      country: "",
      answers: {}
    }
  });

  const onSubmit = async (data: z.infer<typeof formSchema>) => {
    if (!user) {
      toast.error(t('nav.login'));
      return;
    }

    try {
      const responseId = `${survey.id}_${user.uid}`;
      const payload = {
        surveyId: survey.id,
        respondentId: user.uid,
        respondentEmail: user.email,
        country: data.country,
        answers: data.answers,
        createdAt: serverTimestamp()
      };

      await setDoc(doc(db, "responses", responseId), payload);
      
      // Grant 50 XP for responding to a survey
      await grantXP(user.uid, 50);
      
      confetti({
        particleCount: 150,
        spread: 70,
        origin: { y: 0.6 },
        colors: ['#6366f1', '#4f46e5', '#ffffff']
      });

      toast.success(t('survey.submit'), {
        description: "+50 XP earned! Level up progress updated.",
      });
      onSuccess();
    } catch (error) {

      handleFirestoreError(error, OperationType.CREATE, "responses");
      toast.error(t('common.error'));
    }
  };

  const rendersQuestion = (q: Question) => {
    const label = q.label[lang] || q.label.en;
    const answers = watch("answers");

    return (
      <div key={q.id} className="space-y-4 p-6 rounded-2xl bg-slate-800/50 border border-slate-800 backdrop-blur-sm group hover:border-indigo-500/30 transition-colors">
        <Label className="text-lg font-bold text-white flex items-center gap-2">
          <span className="w-1.5 h-4 bg-indigo-500 rounded-full"></span>
          {label}
        </Label>
        {q.type === "text" && (
          <Input 
            {...register(`answers.${q.id}`)} 
            placeholder="..."
            className="bg-slate-900 border-slate-700 focus:border-indigo-500 h-12 rounded-xl"
          />
        )}
        {q.type === "choice" && (
          <RadioGroup 
            onValueChange={(val) => setValue(`answers.${q.id}`, val)}
            className="grid grid-cols-1 md:grid-cols-2 gap-3"
          >
            {q.options?.map((opt) => {
              const optLabel = opt.label[lang] || opt.label.en;
              const isSelected = answers?.[q.id] === opt.value;
              return (
                <div key={opt.value} className="flex">
                  <RadioGroupItem value={opt.value} id={`${q.id}-${opt.value}`} className="sr-only" />
                  <Label 
                    htmlFor={`${q.id}-${opt.value}`} 
                    className={`flex-1 p-4 rounded-xl border transition-all cursor-pointer ${
                      isSelected 
                        ? 'bg-indigo-500/10 border-indigo-500 text-indigo-400 ring-2 ring-indigo-500/20' 
                        : 'bg-slate-900 border-slate-800 text-slate-400 hover:border-slate-600'
                    }`}
                  >
                    <p className="font-bold">{optLabel}</p>
                    <p className="text-[10px] opacity-60 mt-1">Select this option</p>
                  </Label>
                </div>
              );
            })}
          </RadioGroup>
        )}
        {q.type === "rating" && (
          <div className="flex gap-2">
             {[1, 2, 3, 4, 5].map((val) => {
                const isSelected = answers?.[q.id] === String(val);
                return (
                  <Button 
                    key={val}
                    type="button"
                    variant={isSelected ? "default" : "outline"}
                    className={`flex-1 h-12 rounded-xl font-bold ${isSelected ? 'bg-indigo-600' : 'bg-slate-900 border-slate-800'}`}
                    onClick={() => setValue(`answers.${q.id}`, String(val))}
                  >
                    {val}
                  </Button>
                );
             })}
          </div>
        )}
      </div>
    );
  };

  if (!user) {
    return (
      <div className="flex flex-col items-center justify-center p-12 text-center border-2 border-slate-800 border-dashed rounded-3xl bg-slate-900/50">
        <div className="w-16 h-16 rounded-full bg-indigo-500/10 flex items-center justify-center mb-6">
          <Loader2 className="w-8 h-8 text-indigo-400 group-hover:animate-spin" />
        </div>
        <h3 className="text-2xl font-black mb-2 text-white">Join the Community</h3>
        <p className="text-slate-400 mb-8 max-w-xs">{t('nav.login')} to answer this survey and contribute to the DevOps research.</p>
        <Button onClick={() => import("@/src/lib/firebase").then(f => f.signInWithGoogle())} className="rounded-full px-12 h-12 bg-white text-slate-950 font-black hover:bg-slate-200">
          Sign in with Google
        </Button>
      </div>
    );
  }

  if (alreadyResponded) {
    return (
      <div className="flex flex-col items-center justify-center p-12 text-center border-2 border-slate-800 border-dashed rounded-3xl bg-slate-900/50">
        <div className="w-16 h-16 rounded-full bg-indigo-500/10 flex items-center justify-center mb-6">
          <FileText className="w-8 h-8 text-indigo-400" />
        </div>
        <h3 className="text-2xl font-black mb-2 text-white">{t('survey.already_voted')}</h3>
        <p className="text-slate-400 mb-8">{t('survey.no_responses')}</p>
        <Button variant="outline" className="rounded-full px-8 border-slate-700" onClick={() => window.location.href = '/'}>
          Explore other surveys
        </Button>
      </div>
    );
  }

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-8 animate-in fade-in slide-in-from-bottom-10 duration-700">
      <div className="space-y-6">
        <div className="space-y-3 p-6 rounded-2xl bg-slate-800/20 border border-slate-800 backdrop-blur-sm">
          <Label htmlFor="country" className="text-slate-400 uppercase text-xs font-black tracking-widest">{t('survey.country')}</Label>
          <Input 
            id="country" 
            {...register("country")} 
            placeholder="e.g. Brazil, USA, Germany" 
            className="bg-slate-900 border-slate-700 focus:border-indigo-500 h-12 rounded-xl text-white"
          />
          {errors.country && <span className="text-destructive text-sm font-medium">{errors.country.message}</span>}
        </div>

        {survey.questions.map(rendersQuestion)}
      </div>

      <div className="pt-6 flex flex-col sm:flex-row items-center justify-between border-t border-slate-800 gap-4">
        <p className="text-xs text-slate-500 italic">Logged as: {user?.email}</p>
        <div className="flex gap-4 w-full sm:w-auto">
          <Button type="submit" className="flex-1 sm:flex-none h-14 px-12 text-lg font-black bg-white text-slate-950 hover:bg-slate-200 rounded-xl shadow-xl shadow-white/5 transition-all" disabled={isSubmitting}>
            {isSubmitting ? <Loader2 className="w-5 h-5 animate-spin mr-2" /> : null}
            {t('survey.submit')}
          </Button>
        </div>
      </div>
    </form>
  );
}
