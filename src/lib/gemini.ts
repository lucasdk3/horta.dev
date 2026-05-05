import { GoogleGenAI } from "@google/genai";

const ai = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY });

export async function generateSurveySummary(surveyTitle: string, questions: any[], responses: any[], lang: string, filterCountry?: string) {
  const prompt = `
    You are a Senior DevOps Strategic Consultant.
    Analyze the survey "${surveyTitle}".
    
    Context:
    - Questions: ${JSON.stringify(questions)}
    - Total Responses: ${responses.length}
    - Filter applied: ${filterCountry || 'Global'}
    - Data: ${JSON.stringify(responses)}
    
    Request:
    Provide a high-density "Insights Report" in ${lang === 'pt' ? 'Portuguese' : lang === 'es' ? 'Spanish' : 'English'}.
    
    Structure:
    1. Statistical Snapshot: Use percentage distributions for the main questions.
    2. Regional Highlights: If global, mention 2-3 specific countries with interesting outliers.
    3. Pros & Cons: Based on the tools/methods identified in responses, list tech Pros and Cons.
    4. Strategic Decision: What should a CTO or DevOps Lead do right now based on this?
    
    Formatting:
    - Use strict Markdown.
    - Use code blocks for stats (e.g. \`[ 65% - K8s ]\`).
    - Keep it data-informed and concise.
  `;

  try {
    const response = await ai.models.generateContent({
      model: "gemini-3-flash-preview",
      contents: prompt,
    });
    return response.text;
  } catch (error) {
    console.error("Gemini Error:", error);
    return "Failed to generate AI summary.";
  }
}

export async function chatWithResearch(
  surveyTitle: string,
  questions: any[],
  responses: any[],
  history: { role: "user" | "model"; parts: { text: string }[] }[],
  message: string,
  lang: string
) {
  const systemContext = `
    You are a Research Assistant for the DevSurvey platform.
    You have access to the results of the survey: "${surveyTitle}".
    
    Data Context:
    - Questions: ${JSON.stringify(questions)}
    - Responses (${responses.length}): ${JSON.stringify(responses)}
    
    Guidelines:
    1. Answer questions based ONLY on the provided data context.
    2. If someone asks something not covered by the data, admit it and suggest what kind of data is currently available.
    3. Use a professional, data-driven tone.
    4. Respond in ${lang === 'pt' ? 'Portuguese' : lang === 'es' ? 'Spanish' : 'English'}.
    5. Formatting: Use Markdown for tables, bold text, and lists.
  `;

  try {
    const chat = ai.chats.create({
      model: "gemini-3-flash-preview",
      config: {
        systemInstruction: systemContext,
      },
      history: history.length > 0 ? history : [],
    });

    const response = await chat.sendMessage(message);
    return response.text;
  } catch (error) {
    console.error("Gemini Chat Error:", error);
    throw error;
  }
}

export async function chatWithGlobalResearch(
  allSurveysMetadata: any[],
  history: { role: "user" | "model"; parts: { text: string }[] }[],
  message: string,
  lang: string
) {
  const systemContext = `
    You are the DevSurvey Hub Platform Assistant.
    You help users navigate through the community research projects.
    
    Current Surveys Catalog:
    ${allSurveysMetadata.map(s => `- ${s.title}: ${s.description} (Category: ${s.category})`).join('\n')}
    
    Guidelines:
    1. Your goal is to guide users to the right research.
    2. If they ask about trends (e.g., "productivity in Brazil"), mention which surveys cover that topic.
    3. You can provide general insights if you know the survey titles imply them, but be careful not to make up specific data points.
    4. Encourage users to contribute to "New Requests" if they don't find what they need.
    5. Respond in ${lang === 'pt' ? 'Portuguese' : lang === 'es' ? 'Spanish' : 'English'}.
    6. Tone: Helpful, technical, and community-focused.
  `;

  try {
    const chat = ai.chats.create({
      model: "gemini-3-flash-preview",
      config: { systemInstruction: systemContext },
      history: history.length > 0 ? history : [],
    });

    const response = await chat.sendMessage(message);
    return response.text;
  } catch (error) {
    console.error("Global Gemini Chat Error:", error);
    throw error;
  }
}
