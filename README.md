# Koji 🌱 (Demo Repository)

> **Academic Demo Build — Public Repository**

Koji is an AI-powered educational assistant designed to support students with learning, organization, and curiosity-driven exploration. This repository represents the **frontend architecture, UI/UX design, and application logic** of Koji, shared publicly **for university evaluation purposes**.

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

## 📜 License

**Creative Commons Attribution–NonCommercial–NoDerivatives 4.0 (CC BY-NC-ND 4.0)**

You may:

* View and review this code for academic purposes

You may **not**:

* Use it commercially
* Modify or redistribute it
* Claim it as your own work

© 2025 Koji — Demo Build

---

## 👩‍💻 Author

**Wajiha Tasaduq**
Creator of Koji

This demo represents ongoing independent work under limited resources, driven by a passion for computer science, education, and human-centered AI.

---

## 🎬 Koji Demo Video

This video demonstrates the Koji app working in demo mode. **No API keys or sensitive data are shown**.

[Watch the demo video](demo_media/koji_demo_recording.mp4)

---

## 🌱 Future Work (Private)

Koji is under active development. Future iterations will include:

* Advanced AI reasoning
* Personalized learning memory
* Accessibility-first features
* Scalable backend services

These components are maintained in private repositories.

---

> *“Not everything valuable is visible — but everything here is intentional.”*
