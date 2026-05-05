import { useState } from "react";
import { useTranslation } from "react-i18next";
import { db, auth, handleFirestoreError, OperationType } from "../lib/firebase";
import { collection, addDoc, serverTimestamp } from "firebase/firestore";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogFooter } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Label } from "@/components/ui/label";
import { toast } from "sonner";
import { Loader2, Send } from "lucide-react";

interface RequestSurveyModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export default function RequestSurveyModal({ isOpen, onClose }: RequestSurveyModalProps) {
  const { t } = useTranslation();
  const [loading, setLoading] = useState(false);
  const [formData, setFormData] = useState({
    title: "",
    description: "",
    category: ""
  });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!auth.currentUser) {
      toast.error("You must be logged in to request a survey");
      return;
    }

    setLoading(true);
    try {
      await addDoc(collection(db, "survey_requests"), {
        title: formData.title,
        description: formData.description,
        suggestedCategory: formData.category,
        requesterId: auth.currentUser.uid,
        requesterEmail: auth.currentUser.email,
        status: "pending",
        createdAt: serverTimestamp()
      });
      
      toast.success("Survey request sent successfully!");
      setFormData({ title: "", description: "", category: "" });
      onClose();
    } catch (error) {
      handleFirestoreError(error, OperationType.WRITE, "survey_requests");
    } finally {
      setLoading(false);
    }
  };

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="bg-slate-950 border-slate-800 text-white sm:max-w-md">
        <DialogHeader>
          <DialogTitle className="text-2xl font-black">Request a Survey</DialogTitle>
          <DialogDescription className="text-slate-400">
            Suggest a topic you'd like the community to research.
          </DialogDescription>
        </DialogHeader>
        <form onSubmit={handleSubmit} className="space-y-6 py-4">
          <div className="space-y-2">
            <Label htmlFor="title" className="text-sm font-bold uppercase tracking-wider text-slate-500">
              Survey Title
            </Label>
            <Input 
              id="title"
              placeholder="e.g. Kubernetes Adoption in Latin America"
              className="bg-slate-900 border-slate-800 rounded-xl h-12 focus:ring-2 ring-indigo-500/20"
              value={formData.title}
              onChange={(e) => setFormData({ ...formData, title: e.target.value })}
              required
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="category" className="text-sm font-bold uppercase tracking-wider text-slate-500">
              Suggested Category
            </Label>
            <Input 
              id="category"
              placeholder="e.g. Infrastructure, Backend, Culture"
              className="bg-slate-900 border-slate-800 rounded-xl h-12 focus:ring-2 ring-indigo-500/20"
              value={formData.category}
              onChange={(e) => setFormData({ ...formData, category: e.target.value })}
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="description" className="text-sm font-bold uppercase tracking-wider text-slate-500">
              Description / Why is this important?
            </Label>
            <Textarea 
              id="description"
              placeholder="Explain what information you'd like to gather..."
              className="bg-slate-900 border-slate-800 rounded-xl min-h-[120px] focus:ring-2 ring-indigo-500/20 p-4"
              value={formData.description}
              onChange={(e) => setFormData({ ...formData, description: e.target.value })}
              required
            />
          </div>
          <DialogFooter>
            <Button 
              type="submit" 
              disabled={loading}
              className="w-full h-12 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white font-black transition-all shadow-lg shadow-indigo-500/20 animate-in fade-in"
            >
              {loading ? <Loader2 className="w-5 h-5 animate-spin" /> : (
                <>
                  <Send className="w-4 h-4 mr-2" />
                  Send Request
                </>
              )}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
