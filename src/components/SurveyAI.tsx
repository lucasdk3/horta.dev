import { useState, useEffect } from "react";
import { Survey, Response } from "@/src/types";
import { generateSurveySummary } from "@/src/lib/gemini";
import { useTranslation } from "react-i18next";
import { Skeleton } from "@/components/ui/skeleton";
import { Card } from "@/components/ui/card";
import { Sparkles, RefreshCw } from "lucide-react";
import { Button } from "@/components/ui/button";
import Markdown from "react-markdown";
import { db } from "@/src/lib/firebase";
import { doc, getDoc, setDoc, serverTimestamp } from "firebase/firestore";

interface SurveyAIProps {
  survey: Survey;
  responses: Response[];
}

export default function SurveyAI({ survey, responses }: SurveyAIProps) {
  const { t, i18n } = useTranslation();
  const [summary, setSummary] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [countryFilter, setCountryFilter] = useState<string>("Global");

  const countries = Array.from(new Set(responses.map(r => r.country)));
  const filteredResponses = countryFilter === "Global" 
    ? responses 
    : responses.filter(r => r.country === countryFilter);

  const generate = async (force: boolean = false) => {
    if (filteredResponses.length === 0) return;
    
    const analysisId = `${survey.id}_${i18n.language}_${countryFilter.toLowerCase()}`;
    const analysisRef = doc(db, "survey_analyses", analysisId);

    if (!force) {
      setLoading(true);
      try {
        const cachedDoc = await getDoc(analysisRef);
        if (cachedDoc.exists()) {
          const data = cachedDoc.data();
          // Reuse if response count is the same (or very close)
          if (data.responseCount === filteredResponses.length) {
            setSummary(data.summary);
            setLoading(false);
            return;
          }
        }
      } catch (e) {
        console.error("Cache read error:", e);
      }
    }

    setLoading(true);
    const title = survey.title[i18n.language as "pt" | "en" | "es"] || survey.title.en;
    
    try {
      const text = await generateSurveySummary(
        title, 
        survey.questions, 
        filteredResponses, 
        i18n.language, 
        countryFilter === "Global" ? undefined : countryFilter
      );

      if (text) {
        setSummary(text);
        // Cache the result
        await setDoc(analysisRef, {
          surveyId: survey.id,
          lang: i18n.language,
          countryFilter,
          summary: text,
          responseCount: filteredResponses.length,
          updatedAt: serverTimestamp()
        }, { merge: true });
      } else {
        setSummary("No insights generated.");
      }
    } catch (error) {
      setSummary("Failed to generate insights.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (responses.length > 0) {
      generate();
    }
  }, [countryFilter, responses.length, i18n.language]);

  if (responses.length === 0) {
    return (
      <div className="p-12 text-center border rounded-xl bg-muted/30">
        <p className="text-muted-foreground">{t('survey.no_responses')}</p>
      </div>
    );
  }

  return (
    <div className="space-y-6 animate-in zoom-in-95 duration-500">
      <div className="flex flex-col md:flex-row justify-between items-center bg-indigo-500/5 p-5 rounded-2xl border border-indigo-500/20 shadow-lg shadow-indigo-500/5 gap-4">
        <div className="flex items-center gap-3 text-indigo-400 font-black uppercase text-xs tracking-[0.2em]">
          <div className="w-8 h-8 rounded-lg bg-indigo-500 flex items-center justify-center text-white">
            <Sparkles className="w-4 h-4" />
          </div>
          <span>{t('survey.presentation')}</span>
        </div>
        
        <div className="flex items-center gap-3">
          <select 
            value={countryFilter}
            onChange={(e) => setCountryFilter(e.target.value)}
            className="bg-slate-900 border border-slate-700 text-white text-xs rounded-xl h-10 px-4 font-bold outline-none focus:ring-2 ring-indigo-500/50"
          >
            <option value="Global">Global Insights</option>
            {countries.map(c => <option key={c} value={c}>{c}</option>)}
          </select>

          <Button 
            variant="outline" 
            size="sm" 
            onClick={() => generate(true)} 
            disabled={loading}
            className="gap-2 rounded-xl border-slate-700 bg-slate-900 font-bold text-xs h-10 px-4"
          >
            <RefreshCw className={`w-3.5 h-3.5 ${loading ? 'animate-spin' : ''}`} />
            Recalculate
          </Button>
        </div>
      </div>

      {loading ? (
        <Card className="p-8 space-y-6 bg-slate-900 border-slate-800 rounded-3xl">
          <Skeleton className="h-10 w-3/4 bg-slate-800 rounded-lg" />
          <div className="space-y-3">
             <Skeleton className="h-4 w-full bg-slate-800 rounded-lg" />
             <Skeleton className="h-4 w-full bg-slate-800 rounded-lg" />
             <Skeleton className="h-4 w-5/6 bg-slate-800 rounded-lg" />
          </div>
          <Skeleton className="h-32 w-full bg-slate-800 rounded-xl" />
        </Card>
      ) : (
        <Card className="p-10 bg-slate-900 border border-slate-800 rounded-3xl shadow-2xl relative group overflow-hidden">
          <div className="absolute top-0 right-0 p-10 select-none pointer-events-none opacity-5 group-hover:opacity-10 transition-opacity">
             <Sparkles className="w-40 h-40" />
          </div>
          <div className="relative z-10 markdown-body">
            <Markdown>{summary || ""}</Markdown>
          </div>
        </Card>
      )}
    </div>
  );
}
