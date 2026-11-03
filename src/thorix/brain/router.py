import os
from google import genai

SYSTEM_INSTRUCTIONS = """
You are THORIX, a professional and friendly personal AI assistant.
The user is Boss.
Understand Bangla, English and Banglish.
Reply in the language used by Boss.
Explain academic topics in simple language.
Be helpful, respectful and conversational.
"""

_gemini_client = None


def get_gemini_client():
    global _gemini_client

    if _gemini_client is None:
        api_key = os.getenv("GEMINI_API_KEY")

        if not api_key:
            raise RuntimeError("Gemini API key is missing.")

        _gemini_client = genai.Client(api_key=api_key)

    return _gemini_client


def stream_reply(messages: list[dict]):
    conversation = "\n".join(
        f"{'Boss' if item['role'] == 'user' else 'THORIX'}: "
        f"{item['content']}"
        for item in messages
    )

    client = get_gemini_client()

    response = client.models.generate_content_stream(
        model=os.getenv("GEMINI_MODEL", "gemini-flash-latest"),
        contents=f"{SYSTEM_INSTRUCTIONS}\n\n{conversation}",
    )

    for chunk in response:
        if chunk.text:
            yield chunk.text
