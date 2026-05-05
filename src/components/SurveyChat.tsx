import { useState, useRef, useEffect } from "react";
import { Survey, Response } from "@/src/types";
import { chatWithResearch } from "@/src/lib/gemini";
import { useTranslation } from "react-i18next";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Card } from "@/components/ui/card";
import { Send, Loader2, Sparkles, User, Bot, Trash2 } from "lucide-react";
import { motion, AnimatePresence } from "motion/react";
import Markdown from "react-markdown";

interface Message {
  role: "user" | "model";
  text: string;
}

interface SurveyChatProps {
  survey: Survey;
  responses: Response[];
}

export default function SurveyChat({ survey, responses }: SurveyChatProps) {
  const { t, i18n } = useTranslation();
  const [messages, setMessages] = useState<Message[]>([]);
  const [input, setInput] = useState("");
  const [loading, setLoading] = useState(false);
  const scrollRef = useRef<HTMLDivElement>(null);

  const scrollToBottom = () => {
    if (scrollRef.current) {
      const scrollContainer = scrollRef.current.querySelector('[data-slot="scroll-area-viewport"]');
      if (scrollContainer) {
        scrollContainer.scrollTop = scrollContainer.scrollHeight;
      }
    }
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages, loading]);

  const handleSend = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!input.trim() || loading) return;

    const userMessage = input.trim();
    setInput("");
    setMessages(prev => [...prev, { role: "user", text: userMessage }]);
    setLoading(true);

    try {
      const history = messages.map(m => ({
        role: m.role,
        parts: [{ text: m.text }]
      }));

      const title = survey.title[i18n.language as "pt" | "en" | "es"] || survey.title.en;
      const response = await chatWithResearch(
        title,
        survey.questions,
        responses,
        history,
        userMessage,
        i18n.language
      );

      setMessages(prev => [...prev, { role: "model", text: response || "No response." }]);
    } catch (error) {
      setMessages(prev => [...prev, { role: "model", text: "Sorry, I encountered an error. Please try again." }]);
    } finally {
      setLoading(false);
    }
  };

  const clearChat = () => {
    setMessages([]);
  };

  return (
    <Card className="flex flex-col h-[600px] bg-slate-950 border-slate-800 rounded-3xl overflow-hidden shadow-2xl relative">
      <div className="absolute top-0 right-0 p-8 select-none pointer-events-none opacity-5">
        <Sparkles className="w-32 h-32" />
      </div>

      <div className="p-6 border-b border-slate-800 bg-slate-900/50 flex justify-between items-center relative z-10">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-indigo-600 flex items-center justify-center text-white shadow-lg shadow-indigo-500/20">
            <Sparkles className="w-5 h-5" />
          </div>
          <div>
            <h3 className="text-sm font-black uppercase tracking-widest text-white">Research AI Bot</h3>
            <p className="text-[10px] text-indigo-400 font-bold uppercase tracking-tight">Ask about the data</p>
          </div>
        </div>
        <Button 
          variant="ghost" 
          size="icon" 
          onClick={clearChat} 
          className="text-slate-500 hover:text-rose-500 hover:bg-rose-500/10 rounded-xl"
        >
          <Trash2 className="w-4 h-4" />
        </Button>
      </div>

      <ScrollArea ref={scrollRef} className="flex-1 p-6 relative z-10">
        <div className="space-y-6">
          {messages.length === 0 && (
            <div className="flex flex-col items-center justify-center h-[300px] text-center space-y-4">
              <div className="w-16 h-16 rounded-full bg-slate-900 border border-slate-800 flex items-center justify-center text-slate-700">
                <Bot className="w-8 h-8" />
              </div>
              <div className="space-y-1">
                <p className="text-white font-bold">How can I help you analyze this research?</p>
                <p className="text-slate-500 text-xs">Try asking about top technologies or productivity trends.</p>
              </div>
              <div className="flex flex-wrap justify-center gap-2 max-w-sm">
                {[
                  "What are the top 3 technologies used?",
                  "Any significant trend in productivity?",
                  "Which country has the best results?",
                ].map(q => (
                  <button 
                    key={q}
                    onClick={() => { setInput(q); }}
                    className="text-[10px] uppercase font-black tracking-widest text-indigo-400 bg-indigo-500/5 border border-indigo-500/20 px-3 py-1.5 rounded-full hover:bg-indigo-500/10 transition-colors"
                  >
                    {q}
                  </button>
                ))}
              </div>
            </div>
          )}

          <AnimatePresence initial={false}>
            {messages.map((m, i) => (
              <motion.div
                key={i}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                className={`flex gap-4 ${m.role === "user" ? "flex-row-reverse" : ""}`}
              >
                <div className={`w-8 h-8 rounded-lg flex items-center justify-center shrink-0 ${
                  m.role === "user" ? "bg-slate-800 text-slate-400" : "bg-indigo-600 text-white"
                }`}>
                  {m.role === "user" ? <User className="w-4 h-4" /> : <Bot className="w-4 h-4" />}
                </div>
                <div className={`max-w-[80%] rounded-2xl p-4 text-sm leading-relaxed ${
                  m.role === "user" 
                    ? "bg-slate-800 text-white rounded-tr-none" 
                    : "bg-slate-900 border border-slate-800 text-slate-200 rounded-tl-none"
                }`}>
                  <div className="markdown-body">
                    <Markdown>{m.text}</Markdown>
                  </div>
                </div>
              </motion.div>
            ))}
          </AnimatePresence>
          
          {loading && (
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              className="flex gap-4"
            >
              <div className="w-8 h-8 rounded-lg bg-indigo-600 text-white flex items-center justify-center shadow-lg shadow-indigo-500/20">
                <Loader2 className="w-4 h-4 animate-spin" />
              </div>
              <div className="bg-slate-900 border border-slate-800 rounded-2xl rounded-tl-none p-4 w-12 flex justify-center">
                <span className="flex gap-1">
                  <span className="w-1 h-1 bg-indigo-500 rounded-full animate-bounce" style={{ animationDelay: '0ms' }} />
                  <span className="w-1 h-1 bg-indigo-500 rounded-full animate-bounce" style={{ animationDelay: '150ms' }} />
                  <span className="w-1 h-1 bg-indigo-500 rounded-full animate-bounce" style={{ animationDelay: '300ms' }} />
                </span>
              </div>
            </motion.div>
          )}
        </div>
      </ScrollArea>

      <div className="p-6 bg-slate-900/50 border-t border-slate-800 relative z-10">
        <form onSubmit={handleSend} className="relative">
          <Input
            value={input}
            onChange={(e) => setInput(e.target.value)}
            placeholder="Type your question about the data..."
            className="bg-slate-950 border-slate-800 text-white rounded-2xl h-14 pl-6 pr-16 focus:ring-2 ring-indigo-500/20"
            disabled={loading}
          />
          <Button 
            type="submit" 
            size="icon"
            disabled={!input.trim() || loading}
            className="absolute right-2 top-2 h-10 w-10 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white"
          >
            {loading ? <Loader2 className="w-4 h-4 animate-spin" /> : <Send className="w-4 h-4" />}
          </Button>
        </form>
        <p className="text-[9px] text-slate-500 mt-3 text-center uppercase tracking-[0.2em] font-bold">
          AI may provide incomplete data analysis. Verify facts when critical.
        </p>
      </div>
    </Card>
  );
}
