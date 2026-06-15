import { useState, useEffect } from "react";
import { db, handleFirestoreError, OperationType } from "../lib/firebase";
import { collection, query, onSnapshot, doc, updateDoc, setDoc, serverTimestamp, deleteDoc } from "firebase/firestore";
import { SurveyRequest } from "../types";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { toast } from "sonner";
import { Check, X, Trash2, Clock, Mail, Tag, FileText } from "lucide-react";
import { motion, AnimatePresence } from "motion/react";

export default function AdminDashboard() {
  const [requests, setRequests] = useState<SurveyRequest[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const q = query(collection(db, "survey_requests"));
    const unsubscribe = onSnapshot(q, (snapshot) => {
      const data = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() } as SurveyRequest));
      setRequests(data.sort((a, b) => (b.createdAt?.seconds || 0) - (a.createdAt?.seconds || 0)));
      setLoading(false);
    }, (error) => handleFirestoreError(error, OperationType.GET, "survey_requests"));

    return () => unsubscribe();
  }, []);

  const handleApprove = async (request: SurveyRequest) => {
    try {
      // 1. Create the survey
      const surveyId = request.id;
      const surveyRef = doc(db, "surveys", surveyId);
      
      await setDoc(surveyRef, {
        title: { pt: request.title, en: request.title, es: request.title },
        description: { pt: request.description, en: request.description, es: request.description },
        category: request.suggestedCategory || "Community",
        tags: ["community", "requested"],
        questions: [
          {
            id: "q1",
            type: "rating",
            label: { pt: "O que você acha deste tópico?", en: "What do you think about this topic?", es: "¿Qué opinas de este tema?" }
          }
        ],
        active: true,
        createdAt: serverTimestamp(),
        createdBy: request.requesterId
      });

      // 2. Update request status
      await updateDoc(doc(db, "survey_requests", request.id), {
        status: "approved"
      });

      toast.success("Survey approved and created!");
    } catch (error) {
      handleFirestoreError(error, OperationType.WRITE, "surveys/approval");
    }
  };

  const handleReject = async (requestId: string) => {
    try {
      await updateDoc(doc(db, "survey_requests", requestId), {
        status: "rejected"
      });
      toast.info("Request rejected");
    } catch (error) {
      handleFirestoreError(error, OperationType.WRITE, `survey_requests/${requestId}`);
    }
  };

  const handleDelete = async (requestId: string) => {
    if (!confirm("Are you sure you want to delete this request?")) return;
    try {
      await deleteDoc(doc(db, "survey_requests", requestId));
      toast.success("Request deleted");
    } catch (error) {
      handleFirestoreError(error, OperationType.DELETE, `survey_requests/${requestId}`);
    }
  };

  if (loading) return <div className="p-12 text-center text-slate-500 animate-pulse">Loading requests...</div>;

  return (
    <div className="space-y-8">
      <div>
        <h2 className="text-3xl font-black text-white mb-2">Community Requests</h2>
        <p className="text-slate-400">Review and approve survey suggestions from the community.</p>
      </div>

      <div className="grid grid-cols-1 gap-6">
        <AnimatePresence>
          {requests.map((request) => (
            <motion.div
              key={request.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, scale: 0.95 }}
              layout
            >
              <Card className="bg-slate-900/50 border-slate-800 hover:border-slate-700 transition-colors overflow-hidden">
                <CardHeader className="pb-4">
                  <div className="flex items-start justify-between">
                    <div className="space-y-1">
                      <CardTitle className="text-xl font-bold flex items-center gap-2">
                        {request.title}
                        <Badge variant={request.status === 'pending' ? 'outline' : request.status === 'approved' ? 'default' : 'destructive'} 
                               className={request.status === 'pending' ? 'border-amber-500/50 text-amber-500' : request.status === 'approved' ? 'bg-emerald-500 text-white' : ''}>
                          {request.status}
                        </Badge>
                      </CardTitle>
                      <CardDescription className="flex items-center gap-4 text-xs font-medium">
                        <span className="flex items-center gap-1.5"><Mail className="w-3 h-3" /> {request.requesterEmail}</span>
                        <span className="flex items-center gap-1.5"><Clock className="w-3 h-3" /> {request.createdAt?.toDate ? request.createdAt.toDate().toLocaleDateString() : 'Just now'}</span>
                        {request.suggestedCategory && (
                          <span className="flex items-center gap-1.5 text-indigo-400"><Tag className="w-3 h-3" /> {request.suggestedCategory}</span>
                        )}
                      </CardDescription>
                    </div>
                    <div className="flex items-center gap-2">
                      {request.status === 'pending' && (
                        <>
                          <Button size="icon" variant="outline" className="rounded-lg border-emerald-500/20 hover:bg-emerald-500 group" onClick={() => handleApprove(request)}>
                            <Check className="w-4 h-4 text-emerald-500 group-hover:text-white" />
                          </Button>
                          <Button size="icon" variant="outline" className="rounded-lg border-amber-500/20 hover:bg-amber-500 group" onClick={() => handleReject(request.id)}>
                            <X className="w-4 h-4 text-amber-500 group-hover:text-white" />
                          </Button>
                        </>
                      )}
                      <Button size="icon" variant="ghost" className="rounded-lg text-slate-500 hover:text-rose-500 hover:bg-rose-500/10" onClick={() => handleDelete(request.id)}>
                        <Trash2 className="w-4 h-4" />
                      </Button>
                    </div>
                  </div>
                </CardHeader>
                <CardContent>
                  <div className="p-4 rounded-xl bg-slate-950 border border-slate-800/50 text-sm italic text-slate-300 leading-relaxed">
                    "{request.description}"
                  </div>
                </CardContent>
              </Card>
            </motion.div>
          ))}
        </AnimatePresence>

        {requests.length === 0 && (
          <div className="p-20 text-center border-2 border-slate-800 border-dashed rounded-3xl">
            <FileText className="w-12 h-12 text-slate-700 mx-auto mb-4" />
            <p className="text-slate-500 font-bold uppercase tracking-widest text-sm">No requests found</p>
          </div>
        )}
      </div>
    </div>
  );
}
