#!/bin/bash
# MCP servers setup script for Claude Code

set -e

echo "Setting up MCP servers..."

# context7 - Documentation lookup
claude mcp add context7 --scope user -- npx -y @upstash/context7-mcp@latest
echo "Added: context7"

# chrome-devtools - Browser automation
claude mcp add chrome-devtools --scope user -- npx chrome-devtools-mcp@latest --executablePath /usr/bin/google-chrome
echo "Added: chrome-devtools"

# exa - Web search
claude mcp add exa --scope user --transport http -- 'https://mcp.exa.ai/mcp?tools=web_search_exa,get_code_context_exa,crawling_exa,company_research_exa,linkedin_search_exa,deep_researcher_start,deep_researcher_check'
echo "Added: exa"

# Ref - Documentation reference
if [ -z "$REF_API_KEY" ]; then
  echo "Enter your Ref API key (from https://ref.tools):"
  read -r REF_API_KEY
fi
claude mcp add Ref --scope user --transport http --header "x-ref-api-key: $REF_API_KEY" -- 'https://api.ref.tools/mcp'
echo "Added: Ref"

echo ""
echo "MCP servers setup complete!"
echo "Run 'claude mcp list' to verify."
