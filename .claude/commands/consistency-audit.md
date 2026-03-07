Perform a consistency audit across the project.

The user will specify the "gold standard" — the single source of truth that everything else must conform to. This could be the current source code, current docs, a specific design file, a README, etc.

Gold standard / source of truth: $ARGUMENTS

Your job:

1. Read and deeply understand the gold standard component specified above.
2. Identify all other project artifacts that should be consistent with it. Think broadly: README, CLAUDE.md, docstrings, documentation pages, tests, examples, CLI help text, config files, type annotations, naming conventions, etc.
3. For each artifact, check whether it accurately reflects the gold standard. Look for:
   - Outdated information (names, APIs, parameters, descriptions that no longer match)
   - Missing information (new things in the gold standard not yet reflected elsewhere)
   - Contradictions (artifacts that say something different from the gold standard)
   - Naming inconsistencies (different names for the same concept)
4. Present your findings in a table:
   | File | Issue | Status |
   |------|-------|--------|
   | ... | ... | outdated / missing / contradiction / ok |

Then STOP and ask the user which issues to fix. Do NOT start making changes until explicitly told.
