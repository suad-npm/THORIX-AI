
$ErrorActionPreference = "Stop"

Write-Host "`n=== THORIX AI v0.4.0 Setup ===" -ForegroundColor Cyan

# Check project directory
if (!(Test-Path ".\src\thorix\brain\router.py")) {
    throw "THORIX project files not found. Run from project root."
}

# Check streaming function
if (!(Select-String -Path ".\src\thorix\brain\router.py" -Pattern "def stream_reply" -Quiet)) {
    throw "stream_reply function not found in router.py."
}

# Create backup
$backup = ".\backup_v04_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -ItemType Directory -Force $backup | Out-Null

Copy-Item ".\src\thorix\__init__.py" $backup
Write-Host "Backup created." -ForegroundColor Green

# Create background task manager
@'
from concurrent.futures import ThreadPoolExecutor
from queue import Queue

from thorix.brain import stream_reply


class BackgroundTaskManager:

    def __init__(self, max_workers=2):
        self.executor = ThreadPoolExecutor(
            max_workers=max_workers,
            thread_name_prefix="THORIX-Task"
        )
        self.events = Queue()
        self.tasks = {}
        self.counter = 0

    def submit(self, messages, question):
        self.counter += 1
        task_id = self.counter

        self.tasks[task_id] = {
            "status": "running",
            "question": question
        }

        def work():
            return "".join(stream_reply(messages)).strip()

        future = self.executor.submit(work)

        def completed(result):
            try:
                answer = result.result()

                if not answer:
                    raise RuntimeError("Empty AI response")

                self.events.put(
                    ("completed", task_id, answer)
                )

            except Exception as error:
                self.events.put(
                    ("failed", task_id, str(error))
                )

        future.add_done_callback(completed)

        return task_id

    def shutdown(self):
        self.executor.shutdown(
            wait=False,
            cancel_futures=False
        )
'@ | Set-Content ".\src\thorix\task_manager.py" -Encoding utf8

# Replace main assistant
@'
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
    print("             THORIX AI v0.4.0")
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

    running = True

    try:
        while running:

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

            # Wait briefly for new user input
            try:
                user_message = input_queue.get(timeout=0.2)
            except Empty:
                continue

            user_message = user_message.strip()

            if not user_message:
                continue

            if user_message.lower() in ("exit", "quit"):
                print("\nTHORIX: Goodbye Boss!")
                running = False
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

            # Prepare independent conversation snapshot
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

            print("\nTHORIX: অবশ্যই Boss! একটু সময় দিন, দেখছি।")

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
'@ | Set-Content ".\src\thorix\__init__.py" -Encoding utf8

Write-Host "`nTHORIX v0.4.0 setup completed!" -ForegroundColor Green
Write-Host "Your .env and router.py were not modified." -ForegroundColor Yellow
Write-Host "Run: uv run thorix" -ForegroundColor Cyan
