# { project_name }

{ プロジェクトの概要 }

## 技術スタック

- Python 3.13+
- uv (パッケージ管理)
- ruff
- ty (型チェッカー)
- bun (TypeScript/JavaScript)
- oxc (oxlint, oxfmt)

## クイックスタート

```bash
python main.py
```

## 開発環境
- ローカル: `mise.local.toml` に設定（gitignore済み）

## CLIツール

Bash使用時はモダンCLIを優先:
- `fd` > `tree`, `find`, `ls -R`
- `rg` > `grep`, `cat | grep`
- `sd` > `sed`, `awk`
- `jq` でJSON処理

## Python開発

**パッケージ管理 (uv):**
- `uv add package` - インストール
- `uv run tool` - ツール実行
- `pip`, `uv pip install` は使用禁止

**コード品質:**
- `uv run ruff format .` - フォーマット
- `uv run ruff check .` - リント
- `uv run ty check` - 型チェック

**テスト:**
- `uv run pytest`
- 非同期: `anyio` を使用

**pre-commit:**
- git commit時に自動実行
- Prettier (YAML/JSON), Ruff, ty (Python)

## TypeScript開発

**パッケージ管理 (bun):**
- `bun add package` - インストール
- `bun add -d package` - dev依存として追加
- `bun run <script>` - `package.json` の scripts 実行
- `bunx <cmd>` - 一時実行
- `npm`, `yarn`, `pnpm` は使用禁止

**コード品質 (oxc):**
- `bunx oxfmt --write .` - フォーマット
- `bunx oxlint --tsconfig ./tsconfig.json --type-aware .` - リント（型考慮）
- Prettier/ESLint/Biome は使用せず oxc に統一
- 設定: `.oxlintrc.json` でルールをカスタマイズ

**型チェック:**
- `bunx tsc --noEmit` - 型チェック

**テスト:**
- `bun test`

**pre-commit:**
- git commit時に自動実行
- Prettier (YAML/JSON), oxc, tsc（TS/JS）
