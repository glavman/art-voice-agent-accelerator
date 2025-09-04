Developer: # 🦠 Copilot Developer Guide for Real-Time Voice Apps (Python 3.11, FastAPI, Azure)

---

## 🚀 Overview
Develop Python 3.11 code for a **low-latency, real-time voice application** utilizing the following technologies:

- **FastAPI**
- **Azure Communication Services** (Call Automation & Media Streaming)
- **Azure Speech** (Speech-to-Text/Text-to-Speech)
- **Azure OpenAI**

Begin every significant task by outlining a concise checklist (3–7 bullets) of conceptual steps before proceeding; keep these at a high level. Focus on clarity, manageable increments, and code simplicity. Avoid unnecessary abstraction or complexity. Prioritize practical, focused updates over clever or intricate changes.

---

## 📄 General Principles
- **Readability & Simplicity:** Write clear, maintainable code that is easy to understand.
- **Simplicity First:** Choose the simplest working solution. Avoid over-engineering and premature optimization.
- **Incremental Development:** Implement small, meaningful changes rather than large, complex modifications.
- **Modular Design:** Separate infrastructure, backend logic, and user experience layers.
- **Asynchronous Endpoints:** Define all HTTP and WebSocket handlers as `async` functions.
- **Schemas:** Use `pydantic.BaseModel` for all request and response definitions.
- **Dependency Injection:** Use FastAPI `Depends` for managing sessions, authentication, and Redis clients.
- **Configuration Management:** Store secrets and configuration in environment variables or a `.env` file.
- **Structured Logging:** Output logs in JSON format, including `correlation ID`, `callConnectionId`, etc.
- **Avoid Blocking I/O:** Do not use global state; manage resource lifecycles in scoped containers.

---

## 🔎 Tracing & Application Instrumentation
- **OpenTelemetry:** Instrument all code using OpenTelemetry (OTEL). Set `service.name` and `service.instance.id` on the `TracerProvider` resource.
- **Span Kinds:** Use `SERVER` for inbound HTTP/WS handlers, `CLIENT` for outbound requests, and `INTERNAL` for local processing activities.
- **Context Propagation:** Employ the W3C `traceparent` header for HTTP/WS and span links for inter-process activities.
- **Root Traces:** Create one per `callConnectionId`, including `rt.call.connection_id` and `rt.session.id` as attributes.
- **Span Volume:** Limit span creation; generate one session span for STT (with events) and, optionally, one per VAD segment. **Do not create spans per audio frame.**
- **Semantic Attributes:** Apply attributes like `peer.service`, `net.peer.name`, `http.request.method`, `server.address`, and `network.protocol.name="websocket"`.
- **Error Reporting:** If errors occur, set span status to `ERROR` and attach an event with `error.type` and `error.message`.

After each tool invocation or code edit, validate the result in 1–2 lines. If the output does not meet expectations, self-correct and retry as needed before proceeding.

---

## 🏗️ App Structure & Dependency Management
- **No Client Attachment:** Refrain from storing clients on `Request` or `WebSocket` objects.
- **Typed AppContainer:** Define protocols for Redis, Speech, and Azure OpenAI; attach these to `app.state` and provide access via FastAPI dependencies.
- **WebSocket Dependency Injection:** Inject dependencies with `container_from_ws(ws)`; do not access `ws.app.state.*` directly.

---

## 📞 Azure Communication Services (ACS) Best Practices
- **Call Connection ID:** Treat `callConnectionId` as a correlation token, not a secret; prefer passing via headers or message bodies.
- **Spans for Media Operations:** Use `SERVER` spans for WebSocket accept operations, `CLIENT` spans for ACS control commands (answer, play, stop, hangup).

---

## ✨ Code Style Guide
- **Small, Focused Functions:** Use explicit timeouts on `await` statements; avoid blocking event loops. Make code changes as minimal, reviewable increments.
- **Favor Clarity:** Regularly review solutions to eliminate unnecessary complexity. Avoid deep inheritance, extra abstraction, or unused patterns.
- **Background Tasks:** Use `asyncio.create_task` and manage background task lifecycles appropriately.
- **Docstrings:** Always include descriptions of function inputs, outputs, and latency concerns.
- **Unit Testing:** Support testability by faking/mocking Redis, Speech, and AOAI via Protocols. Ensure your code can be unit tested.

When editing code:
1. Clearly state your assumptions.
2. Create or run minimal, relevant tests when possible.
3. Produce reviewable diffs and adhere to project standards.
If tests cannot be run, note that they are speculative and provide instructions for local validation.

After code changes, always verify the edits against expected behavior and prepare to self-correct if validation fails.

---

## 🚫 Strictly Prohibited
- Creating spans per audio chunk.
- Using global singletons.
- Adding `service.name` or `span.kind` attributes to spans manually.

---

> **Tip:** Use code blocks, lists, and semantic section headers to maximize clarity and increase inferencing accuracy. Default to plain text unless markdown is requested; use code fences for code and backticks for identifiers.

---
