# Python & Tooling

When you need to run Python, use `uv`. When switching between project directories, always run `source .venv/bin/activate` in the target project root before running any Python/uv commands. A previously activated venv from another project will cause conflicts.

Zeus should be installed with `pip install zeus` (or `uv pip install zeus`). It was moved from `zeus-ml` to `zeus`.

NEVER use `pip install` outside of a project venv. Always verify the active environment before running any pip/python command — run `which python` and `which pip` to confirm they point to a `.venv/` path. If they point to `/usr/local/bin/` or `/usr/bin/`, you are in system Python — STOP.

Always look for existing scripts for linting, testing, type checking, etc. before coming up with new commands. A common location is `scripts/`.

# Code Changes

When you fix something in-place based on my request, do not create something new named "xxx_fixed", "xxx_correct", etc. Just in-place fix the original. Don't write comments saying it was fixed, either.
On the same note, do not confuse the code's comments with message you want to convey to me. For instance, do not write comments like `# Fixed the bug here`, `# Changed to use function xyz`, `# Now uses abc library`, etc. Just make the change, let me know through our conversation, and keep the code and comments "stateless" so to speak.
This type of comments will be referred to as slop comments.

When you find that the files you have worked on are different from where you left them, it means I have changed them after you'd made the changes. NEVER revert my changes. If you find any discrepancy with your memory/context, figure out related parts, read and understand them, and work with the current state of the codebase.

Backwards compatibility is not a requirement in every cases; when we're in the process of building something from scratch, we can make every breaking change we want. Your session may seem like a lot of code already exists and we need to prevent breaking changes, but in reality, we may be in the early stages of development where we can make breaking changes without issue. Always ask if you're unsure about the stage of development and whether backwards compatibility is a concern.

# Data Handling

When parsing and aggregating data files, NEVER set random defaults for missing values. The default should ALWAYS be raising an error, unless the user explicitly tells you that certain fields are optional.

In all cases, be explicit about your assumptions. Any number, threshold, choice you came up with that is not explicitly from me must be laid out and explained.

# Docstrings & Documentation

Assume all docstrings will be processed with mkdocstrings. No double backticks or double colons in Python docstrings. Just use single backticks and single colons. Triple backticks and language tag for code blocks within docstrings. Follow the clean Google style guide.

# Plots

When you create plots (e.g., using `matplotlib`), whenever it makes sense, start the X and Y axes from zero.

For deterministic SVG output with matplotlib, use `mpl.rcParams["svg.hashsalt"] = "42"` and `fig.savefig("plot.svg", metadata={"Date": None})`. For deterministic PDF output, use `fig.savefig("plot.pdf", metadata={"CreationDate": None})`.

# UI & Workflow

Never use `open` commands (e.g., `open file.pdf`, `open file.svg`) that steal focus from the terminal. If the user needs to view a file, just tell them the path.

After creating a markdown plan file in plan mode, additionally print out a command `md2html <plan_md_file> <output_html_file> && open <output_html_file>` that I can run if I want. I have `md2html` defined in my environment.

# Type Checking

Use `ty` for type checking, not pyright. Run `uvx ty check` on relevant directories.

# Fallback Behavior

NEVER implement silent fallbacks. If a preferred code path is unavailable or fails, raise an error instead of quietly falling back to an alternative implementation. The user will decide what the fallback should be, if any.

# Verification After Changes

After making code changes, ALWAYS run the relevant tests or scripts to verify correctness before reporting success. Do not skip verification steps. If there are known regression tests or verification commands (e.g., in project CLAUDE.md or MEMORY.md), run them.

# Moving files

ALWAYS use `git mv` when moving around files inside a git repository.

# Filesystem searches

NEVER run `find /`, `find /Users`, `find /Users/<user>`, `find ~`, or any other broad scan of the filesystem or the home directory. Searching across hundreds of GB of unrelated files is a fast way to thrash the disk and leak unrelated personal data into the conversation. The same restriction applies to `grep -r`, `rg`, `fd`, `mdfind`, and any other recursive search.

Search ONLY within paths that are explicitly part of the current task:
- The current working directory and its subdirectories.
- Any additional working directories listed in the environment block at session start.
- A specific subdirectory the user has named.
- For Python/JS package internals, the project's own `.venv/` or `node_modules/` — never the global site-packages or `~/Library`.

If you don't know where a file lives outside those scoped paths, STOP and ask the user where to look. Do not guess by walking the filesystem upward.

# GitHub

To fetch PR review comments programmatically, use:
```bash
gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /repos/{owner}/{repo}/pulls/{pr_number}/comments
```
This returns JSON with all inline review comments (diff_hunk, body, path, line, user, etc.). Prefer this over `gh pr view` for reading code review feedback.

# md2html Plan Files

When creating markdown plan files with tables (e.g., slide plans), add this style block at the top so `md2html` renders readable wide tables. Pandoc generates inline `<colgroup>` styles with equal widths and a narrow body; `!important` is needed to override.

```html
<style>
body { max-width: 120em !important; }
table { width: 100% !important; table-layout: fixed !important; }
col:nth-child(1) { width: 5% !important; }
col:nth-child(2) { width: 15% !important; }
col:nth-child(3) { width: 20% !important; }
col:nth-child(4) { width: 60% !important; }
</style>
```

Adjust column count and widths to match the table structure.

# Helping Write Papers

NEVER add a new bibtex entry to the paper's .bib file or change an existing entry in ANY case. If you need to cite a new paper, leave an empty \cite{} in the LaTeX source and tell me what you intended to cite and hand off to me to add the bibtex entry and fill in the citation. If you believe you found an error in an existing bibtex entry, do not change it yourself. Instead, flag it to the user and let them decide.

When you compile a LaTeX paper, always check if there's a Makefile for compilation. If so, use Make instead of running `pdflatex` directly.

For changes that very likely won't cause compilation failure, don't even compile, because the user likely has a `latexmk` watcher running that will auto-compile on file changes. Just make the change and let the watcher handle compilation, if it exists.
