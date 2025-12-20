# Koji 🌱 (Demo Repository)
> - Started: January 2025
> - Status: Working demo / ongoing project

> **Academic Demo Build - Public Repository**

Koji is an AI-powered educational assistant designed to support students with learning, organization, and curiosity-driven exploration. This repository represents the **frontend architecture, UI/UX design, and application logic** of Koji. This repository is intended for learning and demonstration purposes.


Certain components are intentionally excluded to protect intellectual property and future development plans.

---

## ✨ What This Repository Includes

* Flutter-based UI and navigation
* Chat interface and message handling
* State management and clean architecture
* Animation systems and theming
* Demo-mode AI abstraction (non-production)
* Local data handling and UI logic

These elements demonstrate **engineering depth, design thinking, and scalability**.

---

## 🔒 What Is Intentionally Excluded

To protect users, intellectual property, and future commercialization, the following are **not** included in this public demo:

* Real AI model integrations
* API keys or credentials
* Backend services and endpoints
* Prompt engineering and fine-tuning data
* Production-level inference logic

The app may not be fully runnable without these components. This is intentional and standard practice for academic demos.

---

## 🧠 Architecture Overview

Koji is structured using a **service abstraction pattern**, allowing AI providers to be swapped without affecting UI logic.

```dart
abstract class AIService {
  Future<String> sendMessage(String message);
}
```

This repository uses a **DemoAIService** to simulate responses while preserving real-world architecture.

---

## 🎓 Purpose of This Repository

This project is shared to:

* Demonstrate software engineering skills
* Showcase UI/UX and interaction design
* Reflect security and IP-awareness
* Provide evaluators with insight into real-world application development

It is **not** intended for commercial use or redistribution.

---

## 🗓️ Koji Development Timeline
| Month/Year | Milestone / Achievement |
|------------|------------------------|
| Jan 2025   | Conceptualized Koji: an AI assistant for students; began researching Flutter and AI integration. |
| Feb 2025   | Learned Flutter basics and built the first simple chat interface. |
| Mar–Apr 2025 | Implemented state management, local data handling, and demo AI service abstraction. |
| May 2025   | Added animations, UI/UX improvements, and chat bubble design; tested demo interactions. |
| Jun 2025   | Integrated speech-to-text input; refined message handling and local storage. |
| Jul–Nov 2025 | Continued polishing UI, top bar animations, theming, and interaction flows. |
| Dec 2025   | Recorded demo video showcasing Koji’s capabilities with the real AI service and published this public demo repository. |

---

## 🎓 My Journey Behind Koji

Koji is more than just code - it represents my personal journey in learning, perseverance, and innovation. 
I started this project as a solo developer with limited resources, driven by a passion for computer science, education, and human-centered AI.

From teaching myself Flutter UI, animations, and state management, to integrating AI abstractions without exposing sensitive keys, every step was a lesson in problem-solving under constraints. 
My motivation came not only from curiosity but also from the support of my family, who encouraged me to pursue ambitious ideas even when tools and resources were limited.

Through Koji, I learned how to design software that balances usability, security, and scalability. 
This demo reflects both the technical skills I’ve developed and the persistence and creativity required to tackle complex challenges independently.

I hope this repository demonstrates not just an application, but the journey of growth, experimentation, and learning that brought it to life. 

---

## 📜 License

**Creative Commons Attribution–NonCommercial–NoDerivatives 4.0 (CC BY-NC-ND 4.0)**

You may:

* View and review this code for academic purposes

You may **not**:

* Use it commercially
* Modify or redistribute it
* Claim it as your own work

© 2025 Koji - Demo Build

---

## 👩‍💻 Author

**Wajiha Tasaduq**
Creator of Koji

This demo represents ongoing independent work under limited resources, driven by a passion for computer science, education, and human-centered AI.

---

## 🎬 Koji Demo Video

The demo video shows Koji working with the real AI service. **No API keys or sensitive data are shown**.

[Watch the demo video](https://youtu.be/qUyWtEfVv48)

---

## 🌱 Future Work (Private)

Koji is under active development. Future iterations will include:

* Advanced AI reasoning
* Personalized learning memory
* Accessibility-first features
* Scalable backend services

---

