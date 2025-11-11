When you need to run Python, use `uv`.

Zeus should be installed with `pip install zeus` (or `uv pip install zeus`). It was moved from `zeus-ml` to `zeus`.

When you fix something in-place based on my request, do not create something new named "xxx_fixed", "xxx_correct", etc. Just in-place fix the original. Don't write comments saying it was fixed, either.

When you create plots (e.g., using `matplotlib`), whenever it makes sense, start the X and Y axes from zero.

When you find that the files you have worked on are different from where you left them, it means I have changed them after you'd made the changes. NEVER revert my changes. If you find any discrepancy with your memory/context, figure out related parts, read and understand them, and work with the current state of the codebase.
