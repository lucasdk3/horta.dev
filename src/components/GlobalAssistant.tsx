import { useState, useRef, useEffect } from "react";
import { Survey } from "@/src/types";
import { chatWithGlobalResearch } from "@/src/lib/gemini";
import { useTranslation } from "react-i18next";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Card } from "@/components/ui/card";
import { Send, Loader2, Sparkles, User, Bot, X, MessageCircle } from "lucide-react";
import { motion, AnimatePresence } from "motion/react";
import Markdown from "react-markdown";

interface Message {
  role: "user" | "model";
  text: string;
}

interface GlobalAssistantProps {
  surveys: Survey[];
}

export default function GlobalAssistant({ surveys }: GlobalAssistantProps) {
  const { t, i18n } = useTranslation();
  const [isOpen, setIsOpen] = useState(false);
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
    if (isOpen) {
      scrollToBottom();
    }
  }, [messages, loading, isOpen]);

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

      const lang = i18n.language as "pt" | "en" | "es";
      const metadata = surveys.map(s => ({
        title: s.title[lang] || s.title.en,
        description: s.description[lang] || s.description.en,
        category: s.category
      }));

      const response = await chatWithGlobalResearch(
        metadata,
        history,
        userMessage,
        i18n.language
      );

      setMessages(prev => [...prev, { role: "model", text: response || "No response." }]);
    } catch (error) {
      setMessages(prev => [...prev, { role: "model", text: "Sorry, I'm having trouble connecting. Try again later." }]);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fixed bottom-8 right-8 z-[100] flex flex-col items-end gap-4 pointer-events-none">
      <AnimatePresence>
        {isOpen && (
          <motion.div
            initial={{ opacity: 0, scale: 0.9, y: 20, transformOrigin: 'bottom right' }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            exit={{ opacity: 0, scale: 0.9, y: 20 }}
            className="pointer-events-auto"
          >
            <Card className="w-[380px] h-[520px] flex flex-col bg-slate-950 border-slate-800 shadow-2xl shadow-indigo-500/10 rounded-3xl overflow-hidden border-2">
              <div className="p-4 border-b border-white/5 bg-gradient-to-r from-indigo-600 to-indigo-800 flex justify-between items-center">
                <div className="flex items-center gap-3">
                  <div className="w-8 h-8 rounded-lg bg-white/20 backdrop-blur-sm flex items-center justify-center text-white">
                    <Sparkles className="w-4 h-4" />
                  </div>
                  <div>
                    <h3 className="text-xs font-black uppercase tracking-widest text-white leading-none mb-1">DevSurvey Assistant</h3>
                    <p className="text-[9px] text-white/60 font-bold uppercase tracking-tight">Active & Intelligence</p>
                  </div>
                </div>
                <Button 
                  variant="ghost" 
                  size="icon" 
                  onClick={() => setIsOpen(false)} 
                  className="text-white/60 hover:text-white hover:bg-white/10 rounded-lg h-8 w-8"
                >
                  <X className="w-4 h-4" />
                </Button>
              </div>

              <ScrollArea ref={scrollRef} className="flex-1 p-4 bg-slate-950/50">
                <div className="space-y-4">
                  {messages.length === 0 && (
                    <div className="flex flex-col items-center justify-center h-full min-h-[300px] text-center px-6">
                      <div className="w-12 h-12 rounded-2xl bg-slate-900 border border-slate-800 flex items-center justify-center text-indigo-500 mb-4">
                        <Bot className="w-6 h-6" />
                      </div>
                      <p className="text-white font-bold text-sm mb-2">Hello! I'm your Research Assistant.</p>
                      <p className="text-slate-500 text-xs mb-6">Ask me anything about our surveys, research topics, or how the platform works!</p>
                      <div className="flex flex-col gap-2 w-full">
                        {[
                          "What surveys are open now?",
                          "How can I contribute?",
                          "Productivity trends in tech"
                        ].map(q => (
                          <button 
                            key={q}
                            onClick={() => { setInput(q); }}
                            className="text-[10px] uppercase font-black tracking-widest text-indigo-400 bg-indigo-500/5 border border-indigo-500/10 p-3 rounded-xl hover:bg-indigo-500/10 transition-all text-left"
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
                        className={`flex gap-3 ${m.role === "user" ? "flex-row-reverse" : ""}`}
                      >
                        <div className={`w-6 h-6 rounded-md flex items-center justify-center shrink-0 mt-1 ${
                          m.role === "user" ? "bg-slate-800 text-slate-400" : "bg-indigo-600 text-white"
                        }`}>
                          {m.role === "user" ? <User className="w-3 h-3" /> : <Bot className="w-3 h-3" />}
                        </div>
                        <div className={`max-w-[85%] rounded-xl p-3 text-[13px] leading-relaxed ${
                          m.role === "user" 
                            ? "bg-slate-800 text-white rounded-tr-none" 
                            : "bg-slate-900 border border-slate-800/50 text-slate-200 rounded-tl-none"
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
                      className="flex gap-3"
                    >
                      <div className="w-6 h-6 rounded-md bg-indigo-600 text-white flex items-center justify-center shadow-lg shadow-indigo-500/20">
                        <Loader2 className="w-3 h-3 animate-spin" />
                      </div>
                      <div className="bg-slate-900 border border-slate-800/50 rounded-xl rounded-tl-none p-3 w-10 flex justify-center">
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

              <div className="p-4 bg-slate-950 border-t border-white/5">
                <form onSubmit={handleSend} className="relative">
                  <Input
                    value={input}
                    onChange={(e) => setInput(e.target.value)}
                    placeholder="Type your question..."
                    className="bg-slate-900 border-slate-800 text-white rounded-xl h-12 pl-4 pr-12 text-sm focus:ring-1 ring-indigo-500/50"
                    disabled={loading}
                  />
                  <Button 
                    type="submit" 
                    size="icon"
                    disabled={!input.trim() || loading}
                    className="absolute right-1.5 top-1.5 h-9 w-9 rounded-lg bg-indigo-600 hover:bg-indigo-500 text-white"
                  >
                    {loading ? <Loader2 className="w-3 h-3 animate-spin" /> : <Send className="w-3 h-3" />}
                  </Button>
                </form>
              </div>
            </Card>
          </motion.div>
        )}
      </AnimatePresence>

      <button
        onClick={() => setIsOpen(!isOpen)}
        className="pointer-events-auto w-14 h-14 rounded-2xl bg-indigo-600 text-white flex items-center justify-center shadow-2xl shadow-indigo-500/40 hover:scale-110 active:scale-95 transition-all group"
      >
        <AnimatePresence mode="wait">
          {isOpen ? (
            <motion.div
              key="close"
              initial={{ rotate: -90, opacity: 0 }}
              animate={{ rotate: 0, opacity: 1 }}
              exit={{ rotate: 90, opacity: 0 }}
            >
              <X className="w-7 h-7" />
            </motion.div>
          ) : (
            <motion.div
              key="open"
              initial={{ rotate: 90, opacity: 0 }}
              animate={{ rotate: 0, opacity: 1 }}
              exit={{ rotate: -90, opacity: 0 }}
              className="relative"
            >
              <MessageCircle className="w-7 h-7" />
              <div className="absolute -top-1 -right-1 w-3 h-3 bg-rose-500 rounded-full border-2 border-indigo-600 animate-pulse" />
            </motion.div>
          )}
        </AnimatePresence>
      </button>
    </div>
  );
}
