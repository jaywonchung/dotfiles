# Python & Tooling

When you need to run Python, use `uv`. When switching between project directories, always run `source .venv/bin/activate` in the target project root before running any Python/uv commands. A previously activated venv from another project will cause conflicts.

Zeus should be installed with `pip install zeus` (or `uv pip install zeus`). It was moved from `zeus-ml` to `zeus`.

NEVER use `pip install` outside of a project venv. Always verify the active environment before running any pip/python command — run `which python` and `which pip` to confirm they point to a `.venv/` path. If they point to `/usr/local/bin/` or `/usr/bin/`, you are in system Python — STOP.

# Code Changes

When you fix something in-place based on my request, do not create something new named "xxx_fixed", "xxx_correct", etc. Just in-place fix the original. Don't write comments saying it was fixed, either.
On the same note, do not confuse the code's comments with message you want to convey to me. For instance, do not write comments like `# Fixed the bug here`, `# Changed to use function xyz`, `# Now uses abc library`, etc. Just make the change, let me know through our conversation, and keep the code and comments "stateless" so to speak.

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

# GitHub

To fetch PR review comments programmatically, use:
```bash
gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /repos/{owner}/{repo}/pulls/{pr_number}/comments
```
This returns JSON with all inline review comments (diff_hunk, body, path, line, user, etc.). Prefer this over `gh pr view` for reading code review feedback.
