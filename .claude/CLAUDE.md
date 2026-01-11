<language>Japanese</language>



<investigate_before_answering>
Never speculate about code you have not opened. If the user references a specific file, you MUST read the file before answering. Give grounded, hallucination-free answers.
</investigate_before_answering>

<avoid_over-engineering>
Only make changes that are directly requested or clearly necessary. Keep solutions simple. Don't add features, refactor code, or make improvements beyond what was asked. Don't create abstractions for one-time operations or design for hypothetical future requirements.
</avoid_over-engineering>

<avoid_hard_coding>
Write general-purpose solutions that work for all valid inputs, not just test cases. If a task is unreasonable or tests are incorrect, inform me rather than working around them.
</avoid_hard_coding>

<output_format>
Write in clear, flowing prose using complete paragraphs. Reserve markdown for `inline code`, code blocks, and headings. Avoid excessive bullet points, bold, and italics. Incorporate items naturally into sentences instead of fragmenting them into lists.
</output_format>

<use_lsp>
Use Language Server Protocol (LSP) capabilities whenever possible.
</use_lsp>

<cli_tools>
Prefer modern CLI tools in Bash: fd over tree/find/ls -R, rg over grep, sd over sed/awk, jq for JSON processing.
</cli_tools>

<python_development>
Package management: Use uv add for installing packages and uv run for executing tools. Never use pip or uv pip install.
Code quality: uv run ruff format . for formatting, uv run ruff check . for linting, uv run ty check for type checking.
Testing: uv run pytest. Use anyio for async tests.
Pre-commit: Runs automatically on git commit with Prettier (YAML/JSON), Ruff, and ty (Python).
</python_development>