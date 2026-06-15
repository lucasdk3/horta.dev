import json
import urllib.request
import urllib.error
from datetime import datetime, timezone

PROJECT_ID = "horta-495401"
DATABASE_ID = "ai-studio-ae6efca7-de42-416a-bd0c-dd80122fa556"
BASE_URL = f"https://firestore.googleapis.com/v1/projects/{PROJECT_ID}/databases/{DATABASE_ID}/documents"

import subprocess
ACCESS_TOKEN = subprocess.check_output(["gcloud", "auth", "print-access-token"]).decode().strip()

SURVEYS = [
  {
    "id": "knowledge-distribution",
    "title": {"pt": "Distribuição de Conhecimento Interno", "en": "Internal Knowledge Distribution", "es": "Distribución de Conocimiento Interno"},
    "description": {"pt": "Estudo sobre como wikis, documentação técnica e processos são compartilhados em empresas de tecnologia.", "en": "A study on how wikis, technical documentation, and processes are shared in tech companies.", "es": "Estudio sobre cómo se comparten wikis, documentación técnica y procesos en empresas de tecnología."},
    "category": "DevOps Culture",
    "tags": ["culture", "documentation", "wiki"],
    "active": True,
    "questions": [
      {"id": "q1_tool", "type": "choice", "label": {"pt": "Qual a ferramenta principal de documentação técnica?", "en": "What is the primary technical documentation tool?", "es": "¿Cuál es la principal herramienta de documentación técnica?"}, "options": [{"value": "confluence", "label": {"pt": "Confluence", "en": "Confluence", "es": "Confluence"}}, {"value": "notion", "label": {"pt": "Notion", "en": "Notion", "es": "Notion"}}, {"value": "docs_as_code", "label": {"pt": "Docs as Code (Git + Markdown)", "en": "Docs as Code (Git + Markdown)", "es": "Docs as Code (Git + Markdown)"}}, {"value": "custom", "label": {"pt": "Wiki Interna / Customizada", "en": "Internal / Custom Wiki", "es": "Wiki Interna"}}]},
      {"id": "q2_update", "type": "rating", "label": {"pt": "Quão confiável/atualizada está a documentação na sua empresa? (1 = Caos, 5 = Perfeita)", "en": "How reliable/updated is your company documentation? (1 = Chaos, 5 = Perfect)", "es": "¿Qué tan confiable está la documentación en su empresa? (1 = Caos, 5 = Perfecta)"}},
      {"id": "q3_discovery", "type": "choice", "label": {"pt": "Como você encontra informações novas?", "en": "How do you find new information?", "es": "¿Cómo encuentras información nueva?"}, "options": [{"value": "search", "label": {"pt": "Busca na Ferramenta", "en": "Tool Search", "es": "Busca en la herramienta"}}, {"value": "asking", "label": {"pt": "Perguntando no Slack/Discord", "en": "Asking on Slack/Discord", "es": "Preguntando en Slack/Discord"}}, {"value": "bookmarks", "label": {"pt": "Favoritos e Links Diretos", "en": "Bookmarks and Direct Links", "es": "Favoritos"}}]},
      {"id": "q4_pain", "type": "text", "label": {"pt": "Qual a maior dificuldade em manter o conhecimento hoje?", "en": "What is the biggest difficulty in maintaining knowledge today?", "es": "¿Cuál es la mayor dificuldade para mantener el conocimiento hoy?"}}
    ]
  },
  {
    "id": "ai-workflow",
    "title": {"pt": "IA no Fluxo de Trabalho DevOps", "en": "AI in DevOps Workflow", "es": "IA en el flujo de trabajo DevOps"},
    "description": {"pt": "Entendendo como engenheiros estão implementando IA de forma pragmática, de autocomplete a agentes autônomos.", "en": "Understanding how engineers are implementing AI pragmatically, from autocomplete to autonomous agents.", "es": "Entender cómo los ingenieros están implementando la IA de forma pragmática, desde el autocompletado hasta los agentes autónomos."},
    "category": "AI",
    "tags": ["ai", "automation", "productivity"],
    "active": True,
    "questions": [
      {"id": "q1_ai_stage", "type": "choice", "label": {"pt": "Qual o seu nível de implementação de IA?", "en": "What is your AI implementation level?", "es": "¿Cuál es tu nivel de implementação de IA?"}, "options": [{"value": "basic", "label": {"pt": "Básico (Copilot / Chat)", "en": "Basic (Copilot / Chat)", "es": "Básico"}}, {"value": "automated", "label": {"pt": "Automatizado (PR Reviews, Test Generation)", "en": "Automated (PR Reviews, Test Gen)", "es": "Automatizado"}}, {"value": "agentic", "label": {"pt": "Agentic (De tarefas no Jira ao Commit)", "en": "Agentic (From Jira to Commit)", "es": "Agentes"}}]},
      {"id": "q2_productivity", "type": "rating", "label": {"pt": "Ganhos de produtividade percebidos (1 = Nenhum, 5 = Revolucionário)", "en": "Perceived productivity gains (1 = None, 5 = Revolutionary)", "es": "Mejoras de productividad percibidas (1 = Ninguna, 5 = Revolucionaria)"}},
      {"id": "q3_main_tool", "type": "choice", "label": {"pt": "Ferramenta de IA favorita no dia a dia?", "en": "Favorite AI tool for daily tasks?", "es": "¿Herramienta de IA favorita?"}, "options": [{"value": "cursor", "label": {"pt": "Cursor", "en": "Cursor", "es": "Cursor"}}, {"value": "github_copilot", "label": {"pt": "GitHub Copilot", "en": "GitHub Copilot", "es": "GitHub Copilot"}}, {"value": "claude_dev", "label": {"pt": "Claude / Cline", "en": "Claude / Cline", "es": "Claude / Cline"}}]}
    ]
  },
  {
    "id": "games-devops",
    "title": {"pt": "Cultura DevOps na Indústria de Games", "en": "DevOps Culture in Game Industry", "es": "Cultura DevOps en la Industria de Juegos"},
    "description": {"pt": "Exploração de servidores, pipelines de assets e cultura de deploy para games multiplayer e singleplayer.", "en": "Exploration of servers, asset pipelines, and deployment culture for multiplayer and singleplayer games.", "es": "Exploración de servidores, pipelines de activos y cultura de implementación para juegos multijugador y de un solo jugador."},
    "category": "Industry Specific",
    "tags": ["games", "infrastructure", "bare-metal"],
    "active": True,
    "questions": [
      {"id": "q1_server_type", "type": "choice", "label": {"pt": "Como vocês gerenciam os servidores de jogo?", "en": "How do you manage game servers?", "es": "¿Cómo gestionan los servidores de juego?"}, "options": [{"value": "bare_metal", "label": {"pt": "Bare Metal dedicado", "en": "Dedicated Bare Metal", "es": "Bare Metal"}}, {"value": "cloud_vms", "label": {"pt": "Cloud VMs (AWS, GCE)", "en": "Cloud VMs", "es": "Cloud VMs"}}, {"value": "k8s_agones", "label": {"pt": "Kubernetes (Agones/Custom)", "en": "Kubernetes (Agones/Custom)", "es": "Kubernetes"}}]},
      {"id": "q2_asset_pipeline", "type": "choice", "label": {"pt": "Os assets (3D, Texturas) fazem parte do CI/CD?", "en": "Do assets (3D, Textures) go through CI/CD?", "es": "¿Los activos forman parte del CI/CD?"}, "options": [{"value": "integrated", "label": {"pt": "Sim, fluxo unificado", "en": "Yes, unified flow", "es": "Sí, flujo unificado"}}, {"value": "separated", "label": {"pt": "Não, pipelines separados", "en": "No, separated pipelines", "es": "No, pipelines separados"}}, {"value": "manual", "label": {"pt": "Processo Manual/Externalizado", "en": "Manual/External process", "es": "Manual"}}]},
      {"id": "q3_deploy_freq", "type": "choice", "label": {"pt": "Frequência de Deploy para Produção?", "en": "Deployment frequency to Production?", "es": "¿Frecuencia de implementación?"}, "options": [{"value": "daily", "label": {"pt": "Diário", "en": "Daily", "es": "Diario"}}, {"value": "weekly", "label": {"pt": "Semanal", "en": "Weekly", "es": "Semanal"}}, {"value": "seasonally", "label": {"pt": "Por Temporada/Patch", "en": "Seasonal/Patch", "es": "Por temporada"}}]}
    ]
  }
]


def to_firestore_value(val):
    if isinstance(val, bool):
        return {"booleanValue": val}
    if isinstance(val, int):
        return {"integerValue": str(val)}
    if isinstance(val, float):
        return {"doubleValue": val}
    if isinstance(val, str):
        return {"stringValue": val}
    if isinstance(val, list):
        return {"arrayValue": {"values": [to_firestore_value(v) for v in val]}}
    if isinstance(val, dict):
        return {"mapValue": {"fields": {k: to_firestore_value(v) for k, v in val.items()}}}
    return {"nullValue": None}


def survey_to_fields(survey):
    fields = {}
    for key, val in survey.items():
        if key == "id":
            continue
        fields[key] = to_firestore_value(val)
    fields["createdAt"] = {"timestampValue": datetime.now(timezone.utc).isoformat()}
    fields["createdBy"] = {"stringValue": "seed"}
    return fields


def upsert_survey(survey):
    doc_id = survey["id"]
    url = f"{BASE_URL}/surveys/{doc_id}"
    fields = survey_to_fields(survey)
    body = json.dumps({"fields": fields}).encode("utf-8")
    req = urllib.request.Request(
        url,
        data=body,
        method="PATCH",
        headers={
            "Authorization": f"Bearer {ACCESS_TOKEN}",
            "Content-Type": "application/json",
        },
    )
    try:
        with urllib.request.urlopen(req) as resp:
            print(f"  [{resp.status}] surveys/{doc_id}")
    except urllib.error.HTTPError as e:
        print(f"  [ERROR {e.code}] surveys/{doc_id}: {e.read().decode()}")


print(f"Seeding {len(SURVEYS)} surveys into Firestore ({DATABASE_ID})...")
for survey in SURVEYS:
    upsert_survey(survey)
print("Done.")
