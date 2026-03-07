import sublime
import sublime_plugin
import json
import os
import re
import threading
from urllib.request import Request, urlopen
from urllib.error import URLError

OLLAMA_URL = "http://localhost:11434/api/generate"
OLLAMA_MODEL = "gemma2:9b"
NOTES_DIR = os.path.expanduser("~/notes")

PROMPT_TEMPLATE = """Based on the following text content, suggest a short, descriptive filename (without extension).
Rules:
- Use lowercase letters, numbers, and hyphens only
- Maximum 5 words, separated by hyphens
- No extension, no path, just the name
- Reply with ONLY the filename, nothing else

Content:
{content}"""


def ask_ollama(content, callback):
    truncated = content[:1500]
    prompt = PROMPT_TEMPLATE.format(content=truncated)

    payload = json.dumps({
        "model": OLLAMA_MODEL,
        "prompt": prompt,
        "stream": False,
        "options": {"temperature": 0.3}
    }).encode("utf-8")

    req = Request(OLLAMA_URL, data=payload, headers={"Content-Type": "application/json"})

    try:
        with urlopen(req, timeout=60) as resp:
            result = json.loads(resp.read().decode("utf-8"))
            name = result.get("response", "").strip().strip('"').strip("'")
            name = re.sub(r'[^a-z0-9\-]', '-', name.lower())
            name = re.sub(r'-+', '-', name).strip('-')
            if not name:
                name = "untitled-note"
            callback(name)
    except (URLError, Exception) as e:
        sublime.set_timeout(lambda: sublime.error_message(f"Ollama Auto Name: {e}"), 0)


class SmartSaveCommand(sublime_plugin.TextCommand):
    """Cmd+S: untitled files get Ollama auto-name, saved files do normal save."""

    def run(self, edit):
        view = self.view
        if view.file_name():
            view.run_command("save")
        else:
            content = view.substr(sublime.Region(0, view.size()))
            if not content.strip():
                view.run_command("save")
                return

            sublime.status_message("Ollama Auto Name: generating name...")

            def on_name(name):
                sublime.set_timeout(lambda: self._save_with_name(view, name), 0)

            thread = threading.Thread(target=ask_ollama, args=(content, on_name))
            thread.start()

    def _save_with_name(self, view, suggested_name):
        os.makedirs(NOTES_DIR, exist_ok=True)
        ext = ".md"
        full_path = os.path.join(NOTES_DIR, suggested_name + ext)

        counter = 1
        base_path = full_path
        while os.path.exists(full_path):
            full_path = base_path.replace(ext, f"-{counter}{ext}")
            counter += 1

        view.window().show_input_panel(
            "Save as:",
            full_path,
            lambda path: self._do_save(view, path),
            None,
            None
        )

    def _do_save(self, view, path):
        os.makedirs(os.path.dirname(path), exist_ok=True)
        content = view.substr(sublime.Region(0, view.size()))
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)
        view.retarget(path)
        view.set_scratch(False)
        sublime.status_message(f"Saved: {path}")


class OllamaAutoNameCommand(sublime_plugin.TextCommand):
    """Manual trigger via command palette."""

    def run(self, edit):
        view = self.view
        content = view.substr(sublime.Region(0, view.size()))

        if not content.strip():
            sublime.status_message("Ollama Auto Name: buffer is empty")
            return

        sublime.status_message("Ollama Auto Name: generating name...")

        def on_name(name):
            sublime.set_timeout(lambda: self._save_with_name(view, name), 0)

        thread = threading.Thread(target=ask_ollama, args=(content, on_name))
        thread.start()

    def _save_with_name(self, view, suggested_name):
        os.makedirs(NOTES_DIR, exist_ok=True)
        ext = ".md"
        full_path = os.path.join(NOTES_DIR, suggested_name + ext)

        counter = 1
        base_path = full_path
        while os.path.exists(full_path):
            full_path = base_path.replace(ext, f"-{counter}{ext}")
            counter += 1

        view.window().show_input_panel(
            "Save as:",
            full_path,
            lambda path: self._do_save(view, path),
            None,
            None
        )

    def _do_save(self, view, path):
        os.makedirs(os.path.dirname(path), exist_ok=True)
        content = view.substr(sublime.Region(0, view.size()))
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)
        view.retarget(path)
        view.set_scratch(False)
        sublime.status_message(f"Saved: {path}")
