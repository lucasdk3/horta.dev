import { Response, Survey } from "@/src/types";
import { useTranslation } from "react-i18next";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Button } from "@/components/ui/button";
import { format } from "date-fns";

interface SurveyTableProps {
  survey: Survey;
  responses: Response[];
}

export default function SurveyTable({ survey, responses }: SurveyTableProps) {
  const { t, i18n } = useTranslation();
  const lang = i18n.language as "pt" | "en" | "es";

  if (responses.length === 0) {
    return (
      <div className="p-12 text-center border rounded-xl bg-muted/30">
        <p className="text-muted-foreground">{t('survey.no_responses')}</p>
      </div>
    );
  }

  return (
    <div className="space-y-4 animate-in fade-in slide-in-from-bottom-5 duration-500">
      <div className="flex justify-between items-center">
        <p className="text-xs font-black uppercase tracking-widest text-slate-500">
          {t('survey.total_responses')}: <span className="text-indigo-400">{responses.length}</span>
        </p>
        <Button variant="outline" size="sm" className="h-8 text-[10px] rounded-lg border-slate-800 bg-slate-900 font-black tracking-widest uppercase">
          Export CSV
        </Button>
      </div>
      
      <div className="rounded-2xl border border-slate-800 bg-slate-950/50 overflow-hidden group">
        <ScrollArea className="h-[500px]">
          <Table>
            <TableHeader className="sticky top-0 bg-slate-900 border-b border-slate-800 z-10 backdrop-blur-md">
              <TableRow className="hover:bg-transparent border-slate-800">
                <TableHead className="w-[120px] text-slate-500 font-bold uppercase text-[10px] tracking-widest">{t('survey.country')}</TableHead>
                {survey.questions.map((q) => (
                  <TableHead key={q.id} className="text-slate-200 font-bold text-xs">{q.label[lang] || q.label.en}</TableHead>
                ))}
                <TableHead className="text-right text-slate-500 font-bold uppercase text-[10px] tracking-widest">Date</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {responses.map((res) => (
                <TableRow key={res.id} className="border-slate-800/50 hover:bg-white/5 transition-colors">
                  <TableCell className="font-bold text-slate-300 text-sm">{res.country}</TableCell>
                  {survey.questions.map((q) => {
                    const ans = res.answers[q.id];
                    return (
                      <TableCell key={q.id} className="text-slate-400 text-sm">
                        {typeof ans === 'string' ? (
                          <span className="bg-slate-800 px-2 py-1 rounded text-[11px] font-medium text-slate-300">{ans}</span>
                        ) : String(ans || "-")}
                      </TableCell>
                    );
                  })}
                  <TableCell className="text-right text-[10px] text-slate-600 font-mono">
                    {res.createdAt ? format(res.createdAt.toDate(), "yyyy.MM.dd HH:mm") : "-"}
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </ScrollArea>
      </div>
    </div>
  );
}
