When you need to run Python, use `uv`.

Zeus should be installed with `pip install zeus` (or `uv pip install zeus`). It was moved from `zeus-ml` to `zeus`.

When you fix something in-place based on my request, do not create something new named "xxx_fixed", "xxx_correct", etc. Just in-place fix the original. Don't write comments saying it was fixed, either.
On the same note, do not confuse the code's comments with message you want to convey to me. For instance, do not write comments like `# Fixed the bug here`, `# Changed to use function xyz`, `# Now uses abc library`, etc. Just make the change, let me know through our conversation, and keep the code and comments "stateless" so to speak.

When you create plots (e.g., using `matplotlib`), whenever it makes sense, start the X and Y axes from zero.

When you find that the files you have worked on are different from where you left them, it means I have changed them after you'd made the changes. NEVER revert my changes. If you find any discrepancy with your memory/context, figure out related parts, read and understand them, and work with the current state of the codebase.

In all cases, be explicit about your assumptions. Any number, threshold, choice you came up with that is not explicitly from me must be laid out and explained.

When parsing and aggregating data files, NEVER set random defaults for missing values. The default should ALWAYS be raising an error, unless the user explicitly tells you that certain fields are optional.

After creating a markdown plan file in plan mode, additionally print out a command `md2html <plan_md_file> <output_html_file> && open <output_html_file>` that I can run if I want. I have `md2html` defined in my environment.

Never use `open` commands (e.g., `open file.pdf`, `open file.svg`) that steal focus from the terminal. If the user needs to view a file, just tell them the path.
