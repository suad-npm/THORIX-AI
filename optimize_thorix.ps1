
$ErrorActionPreference = "Stop"

Write-Host "`nTHORIX AI - Speed Optimization" -ForegroundColor Cyan

# 1. Create backup
$backup = ".\backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"

New-Item -ItemType Directory -Force $backup | Out-Null

$files = @(
    ".\src\thorix\__init__.py",
    ".\src\thorix\brain\__init__.py",
    ".\src\thorix\brain\router.py"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        $destination = Join-Path $backup (
            $file.Replace(".\src\thorix\", "")
        )
        $destinationDir = Split-Path $destination

        New-Item -ItemType Directory -Force $destinationDir |
            Out-Null

        Copy-Item $file $destination
    }
}

Write-Host "Backup created: $backup" -ForegroundColor Green

# 2. Ensure brain folder exists
New-Item -ItemType Directory -Force `
    ".\src\thorix\brain" | Out-Null

# 3. Update router.py
@'
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
'@ | Set-Content ".\src\thorix\brain\router.py" -Encoding utf8

# 4. Update brain/__init__.py
@'
from .router import stream_reply

__all__ = ["stream_reply"]
'@ | Set-Content ".\src\thorix\brain\__init__.py" -Encoding utf8

# 5. Update main __init__.py
@'
from dotenv import load_dotenv
from thorix.brain import stream_reply


def main() -> None:
    load_dotenv()

    history = []

    print("\n" + "=" * 48)
    print("             THORIX AI v0.3.0")
    print("          Your Personal AI Assistant")
    print("=" * 48)
    print("\nHello Boss! THORIX AI is ready.")
    print("Gemini streaming enabled.")
    print("\nType 'exit' to shut down THORIX.")

    while True:
        try:
            user_message = input("\nBoss > ").strip()

            if not user_message:
                continue

            if user_message.lower() in (
                "exit", "quit", "বন্ধ", "বের হও"
            ):
                print("\nTHORIX: Goodbye Boss!")
                break

            messages = history[-12:] + [
                {"role": "user", "content": user_message}
            ]

            print("\nTHORIX: ", end="", flush=True)

            try:
                answer_parts = []

                for part in stream_reply(messages):
                    print(part, end="", flush=True)
                    answer_parts.append(part)

                answer = "".join(answer_parts).strip()

                if not answer:
                    raise RuntimeError("Empty response from Gemini.")

                history.append(
                    {"role": "user", "content": user_message}
                )
                history.append(
                    {"role": "assistant", "content": answer}
                )

                print()

            except Exception as error:
                print(f"\n\nTHORIX Error: {error}")

        except KeyboardInterrupt:
            print("\n\nTHORIX: Shutting down. Goodbye Boss!")
            break


if __name__ == "__main__":
    main()
'@ | Set-Content ".\src\thorix\__init__.py" -Encoding utf8

Write-Host "`nAll three files updated successfully!" -ForegroundColor Green
Write-Host "Your .env file was not modified." -ForegroundColor Yellow
Write-Host "`nRun: uv run thorix" -ForegroundColor Cyan
