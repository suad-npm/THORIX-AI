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
