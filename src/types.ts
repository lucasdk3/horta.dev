export interface LocalizedText {
  pt: string;
  en: string;
  es: string;
}

export type QuestionType = "text" | "choice" | "rating";

export interface Question {
  id: string;
  type: QuestionType;
  label: LocalizedText;
  options?: { value: string; label: LocalizedText }[];
}

export interface Survey {
  id: string;
  title: LocalizedText;
  description: LocalizedText;
  questions: Question[];
  category: string;
  tags: string[];
  createdAt: any;
  createdBy: string;
  active: boolean;
}

export interface Response {
  id: string;
  surveyId: string;
  respondentId: string;
  respondentEmail: string;
  country: string;
  answers: Record<string, any>;
  createdAt: any;
}

export interface SurveyRequest {
  id: string;
  title: string;
  description: string;
  suggestedCategory?: string;
  requesterId: string;
  requesterEmail: string;
  status: 'pending' | 'approved' | 'rejected';
  createdAt: any;
}

export interface UserProfile {
  uid: string;
  email: string;
  displayName: string;
  photoURL: string;
  country: string;
  isAdmin: boolean;
  xp: number;
  level: number;
  badges: string[];
}
