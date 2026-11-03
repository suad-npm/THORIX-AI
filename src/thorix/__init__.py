
import threading
from queue import Queue, Empty

from dotenv import load_dotenv
from thorix.task_manager import BackgroundTaskManager


def main():
    load_dotenv()

    history = []
    manager = BackgroundTaskManager(max_workers=2)
    input_queue = Queue()

    print("\n" + "=" * 50)
    print("             THORIX AI v0.4.1")
    print("       Human-like Background Assistant")
    print("=" * 50)
    print("\nHello Boss! THORIX is ready.")
    print("Background tasks enabled.")
    print("\nCommands: /tasks | exit")
    print("-" * 50)

    def read_input():
        while True:
            try:
                message = input("\nBoss > ")
            except EOFError:
                input_queue.put("exit")
                return

            input_queue.put(message)

            if message.strip().lower() in ("exit", "quit"):
                return

    input_thread = threading.Thread(
        target=read_input,
        daemon=True
    )
    input_thread.start()

    try:
        while True:

            # Process completed background tasks
            while not manager.events.empty():
                event = manager.events.get()
                event_type, task_id, result = event

                if event_type == "completed":
                    manager.tasks[task_id]["status"] = "completed"

                    history.append({
                        "role": "assistant",
                        "content": result
                    })

                    print(
                        f"\n\n[THORIX] Task #{task_id} completed!"
                    )
                    print(f"\nTHORIX: {result}\n")

                else:
                    manager.tasks[task_id]["status"] = "failed"
                    print(
                        f"\n\n[THORIX] Task #{task_id} failed: {result}\n"
                    )

            # Wait for user input
            try:
                user_message = input_queue.get(timeout=0.2)
            except Empty:
                continue

            user_message = user_message.strip()

            if not user_message:
                continue

            if user_message.lower() in ("exit", "quit"):
                print("\nTHORIX: Goodbye Boss!")
                break

            if user_message.lower() == "/tasks":
                print("\n=== Background Tasks ===")

                if not manager.tasks:
                    print("No tasks yet.")

                for task_id, task in manager.tasks.items():
                    print(
                        f"Task #{task_id}: "
                        f"{task['status']} - {task['question']}"
                    )

                continue

            # Prepare conversation context
            messages = history[-12:] + [
                {
                    "role": "user",
                    "content": user_message
                }
            ]

            history.append({
                "role": "user",
                "content": user_message
            })

            # Unicode-safe Bangla acknowledgement
            acknowledgement = (
                "\u0985\u09ac\u09b6\u09cd\u09af\u0987 Boss! "
                "\u098f\u0995\u099f\u09c1 "
                "\u09b8\u09ae\u09df "
                "\u09a6\u09bf\u09a8, "
                "\u09a6\u09c7\u0996\u099b\u09bf\u0964"
            )

            print(f"\nTHORIX: {acknowledgement}")

            task_id = manager.submit(
                messages,
                user_message
            )

            print(
                f"[THORIX] Background task #{task_id} started."
            )

    except KeyboardInterrupt:
        print("\nTHORIX: Shutting down.")

    finally:
        manager.shutdown()


if __name__ == "__main__":
    main()
