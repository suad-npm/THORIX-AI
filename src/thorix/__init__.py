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
                "exit", "quit", "à¦¬à¦¨à§à¦§", "à¦¬à§‡à¦° à¦¹à¦“"
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
