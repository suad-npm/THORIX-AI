\# ⚡ THORIX AI



\### Your Personal AI Assistant — Think Smarter. Work Faster. Stay Ahead.



THORIX AI is an experimental personal AI assistant designed to make everyday computer interaction more intelligent, natural, and productive.



Inspired by futuristic AI assistants, THORIX aims to combine intelligent conversations, background task execution, personal memory, internet research, voice interaction, and Windows automation in one assistant.



The long-term vision is to build an assistant that doesn't just respond to commands but understands context, remembers conversations, performs tasks, and interacts naturally with its user.



\---



\## 🚀 Project Overview



| Information | Details |

|---|---|

| Project Name | THORIX AI |

| Current Version | v0.4.1 |

| Developer | Razit Ahmed Suad |

| Platform | Windows 11 |

| Programming Language | Python |

| AI Provider | Google Gemini |

| Package Manager | uv |

| Interface | Terminal / CLI |

| Project Status | Active Development |



\## ✨ Current Features



The current development version includes:



\- \*\*AI Conversations:\*\* Communicate with THORIX using natural language.

\- \*\*Bangla \& English:\*\* Understand and respond in Bangla, English, and Banglish.

\- \*\*Background Task Execution:\*\* Run multiple AI requests without blocking the main input loop.

\- \*\*Concurrent Tasks:\*\* Execute up to two AI tasks simultaneously by default.

\- \*\*Task Tracking:\*\* Check background task status using `/tasks`.

\- \*\*Conversation Context:\*\* Maintain recent conversation history during a running session.

\- \*\*Gemini Integration:\*\* Use Google's Gemini API for AI-generated responses.

\- \*\*Unicode Support:\*\* Display Bangla text correctly in a UTF-8 terminal.



\## 🧠 How THORIX Works



THORIX uses a modular Python architecture.



When a user sends a question:



1\. THORIX receives the message.

2\. It prepares the available conversation context.

3\. A background task is created.

4\. The task sends the request to the Gemini AI model.

5\. Gemini generates a response.

6\. THORIX receives the completed result.

7\. The result is displayed in the terminal.



\### Architecture



```text

&#x20;                BOSS / USER

&#x20;                     |

&#x20;                     v

&#x20;             THORIX CLI Interface

&#x20;                     |

&#x20;                     v

&#x20;             Conversation Manager

&#x20;                     |

&#x20;                     v

&#x20;             Background Task Manager

&#x20;                     |

&#x20;             +-------+-------+

&#x20;             |               |

&#x20;             v               v

&#x20;          Task #1          Task #2

&#x20;             |               |

&#x20;             +-------+-------+

&#x20;                     |

&#x20;                     v

&#x20;               Gemini API

&#x20;                     |

&#x20;                     v

&#x20;             Response Handler

&#x20;                     |

&#x20;                     v

&#x20;             THORIX CLI Output

```



Background tasks allow THORIX to accept new questions while previous requests are still processing.



\*\*Note:\*\* The current implementation generates responses in background workers and displays the completed answers. It does not yet provide a full real-time voice conversation experience.



\---



\## 🛠️ Technology Stack



| Technology | Purpose |

|---|---|

| Python 3.12 | Main programming language |

| Google Gemini API | AI intelligence |

| Google Gen AI SDK | Gemini integration |

| ThreadPoolExecutor | Background task execution |

| Python Queue | Communication between tasks and main loop |

| python-dotenv | Environment configuration |

| uv | Python dependency and environment management |

| Git \& GitHub | Version control |



\---



\## 📁 Project Structure



```text

THORIX-AI/

│

├── src/

│   └── thorix/

│       │

│       ├── \_\_init\_\_.py

│       │

│       ├── brain/

│       │   ├── \_\_init\_\_.py

│       │   └── router.py

│       │

│       └── task\_manager.py

│

├── .env.example

├── .gitignore

├── .python-version

├── README.md

├── pyproject.toml

├── uv.lock

│

└── optimize\_thorix.ps1

```



\### Main Modules



\- `\_\_init\_\_.py` — Main application entry point and conversation interface.

\- `brain/router.py` — Gemini AI integration and response generation.

\- `brain/\_\_init\_\_.py` — Brain module exports.

\- `task\_manager.py` — Manages background AI tasks.

\- `.env.example` — Example environment configuration.

\- `pyproject.toml` — Project metadata and dependencies.

\- `uv.lock` — Locked dependency versions.



\---



\# 💻 Installation Guide



Follow these instructions to install THORIX AI on a Windows computer.



\## 1. System Requirements



Recommended environment:



\- Windows 10 or Windows 11

\- Python 3.12

\- Git

\- uv package manager

\- Internet connection

\- Google Gemini API key



A dedicated GPU is not required for the current cloud-based AI implementation.



\## 2. Install Required Software



\### Python



Download Python:



https://www.python.org/downloads/



Verify installation:



```powershell

python --version

```



\### Git



Download Git:



https://git-scm.com/downloads



Verify:



```powershell

git --version

```



\### uv Package Manager



Install uv using PowerShell:



```powershell

powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"

```



Open a new terminal and verify:



```powershell

uv --version

```



\## 3. Clone the Repository



Open PowerShell and run:



```powershell

git clone https://github.com/suad-npm/THORIX-AI.git

```



Navigate to the project directory:



```powershell

cd THORIX-AI

```



\## 4. Install Dependencies



Run:



```powershell

uv sync

```



This installs the project dependencies and prepares the Python environment.



\## 5. Configure Environment Variables



Create your local environment file:



```powershell

Copy-Item .env.example .env

```



Open the file:



```powershell

notepad .env

```



Add your Gemini API key:



```env

GEMINI\_API\_KEY=your\_gemini\_api\_key



THORIX\_AI\_PROVIDER=gemini



GEMINI\_MODEL=gemini-flash-latest

```



Get a Gemini API key:



https://aistudio.google.com/apikey



\*\*Important:\*\* Replace the placeholder with your own API key. Never share your API key or upload your `.env` file to GitHub.



\## 6. Run THORIX AI



Start the assistant:



```powershell

uv run thorix

```



If everything is configured correctly, THORIX will start in your terminal.



\---



\# 🎮 Available Commands



| Command | Description |

|---|---|

| `/tasks` | Display background task information |

| `exit` | Shut down THORIX |

| `quit` | Shut down THORIX |



\### Example Conversation



```text

THORIX AI v0.4.1



Hello Boss! THORIX is ready.

Background tasks enabled.



Boss > Explain PN Junction in simple Bangla.



THORIX: অবশ্যই Boss! একটু সময় দিন, দেখছি।



\[THORIX] Background task #1 started.



\[THORIX] Task #1 completed!



THORIX: PN Junction is...

```



You can submit another question while the previous task is running.



\---



\# 🔒 Security



THORIX uses environment variables to manage API credentials.



Security recommendations:



\- Never commit `.env` to GitHub.

\- Never expose API keys in screenshots or logs.

\- Keep `.venv` and local configuration files out of version control.

\- Use your own API credentials.

\- Review any computer automation action before allowing it to execute.



The current version does not implement voice-based authentication or a complete security system.



\---



\# 🗺️ Development Roadmap



THORIX is actively evolving. The following features represent the development vision and are not all implemented yet.



| Version | Planned Development |

|---|---|

| v0.1 | Initial Python assistant |

| v0.2 | Gemini and OpenAI integration |

| v0.3 | Streaming AI response |

| v0.4 | Background task manager |

| v0.4.1 | Bangla encoding improvements |

| v0.4.x | Conversation memory and task synchronization |

| v0.5 | Internet research and source verification |

| v0.6 | Persistent long-term memory |

| v0.7 | Voice interaction and speech recognition |

| v0.8 | Wake word and voice authentication |

| v0.9 | Windows automation |

| v1.0 | Full personal AI assistant |



\### Future Vision



\- Natural voice conversations.

\- Wake-word activation: "Hey THORIX".

\- Speaker recognition and secure session locking.

\- Intelligent personal memory.

\- Internet research with source citations.

\- Smart scheduling and reminders.

\- Windows application control.

\- File and folder management.

\- Desktop notifications.

\- Futuristic desktop interface.



\---



\# ⚠️ Current Limitations



THORIX is an experimental project under active development.



The current version:



\- Requires an internet connection for Gemini responses.

\- Uses a configured Gemini API key.

\- Does not yet have integrated internet search.

\- Does not yet have persistent long-term memory.

\- Does not yet support voice commands.

\- Does not yet provide full Windows automation.

\- Maintains conversation history only during the current session.

\- May experience delays or temporary API service errors.



Some features described in the roadmap are future development goals, not currently available functionality.



\---



\# 🤝 Contributing



Contributions, suggestions, and ideas are welcome.



If you want to contribute:



1\. Fork the repository.

2\. Create a new feature branch.

3\. Implement your changes.

4\. Test your changes.

5\. Submit a Pull Request.



\---



\# 👨‍💻 Developer



\*\*Razit Ahmed Suad\*\*



B.Sc. in ICT | Full Stack Developer | AI Enthusiast



GitHub: https://github.com/suad-npm



\---



\# 📜 License



No open-source license has been added yet. Until a license is included, the repository should not be assumed to grant permission to redistribute or reuse its code.



\---



<div align="center">



\### ⚡ THORIX AI



\*\*Your Intelligence. Your Assistant. Your Control.\*\*



\*Think Smarter. Work Faster. Stay Ahead.\*



Built with curiosity, intelligence, and a vision for the future.



</div>

