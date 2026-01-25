---
name: py-formatter
description: Python向けのフォーマット・リント設定ガイド。Black、flake8、isort、mypy、VSCode、Lefthook等の推奨設定を提供。プロジェクト固有の設定ファイルがない場合にこの設定を使用。
---

# Python Formatter & Linter Configuration

Python向けのフォーマット・リント設定のリファレンスです。

## ⚠️ 設定ファイルの優先順位

**重要原則**: プロジェクト固有の設定ファイルが存在する場合は、それを優先して使用してください。

```
1. プロジェクトルートの設定ファイル（pyproject.toml, .flake8等）
   → 既存の設定ファイルがある場合は、それに従う

2. 設定ファイルが無い場合
   → 以下のグローバル推奨設定を使用
```

## 🛠️ 開発ツール

### インストール

```bash
pip install black flake8 isort mypy
```

## 🎨 Black設定（コードフォーマット）

### 推奨設定 (pyproject.toml)

**プロジェクトに `pyproject.toml` の `[tool.black]` セクションがない場合のみ、以下の設定を使用**:

```toml
[tool.black]
line-length = 88
target-version = ['py311']
exclude = '''
/(
    \.git
  | \.venv
  | venv
  | dist
  | build
)/
'''
```

### コマンド例

```bash
# フォーマット実行
black yourfile.py

# ディレクトリ全体をフォーマット
black src/

# チェックのみ（変更なし）
black --check src/
```

## 🔍 flake8設定（リント）

### 推奨設定 (.flake8)

**プロジェクトに `.flake8` がない場合のみ、以下の設定を使用**:

```ini
[flake8]
max-line-length = 88
extend-ignore = E203, W503
exclude =
    .git,
    __pycache__,
    .venv,
    venv,
    dist,
    build
```

### コマンド例

```bash
# リント実行
flake8 yourfile.py

# ディレクトリ全体をリント
flake8 src/
```

## 📦 isort設定（インポート整理）

### 推奨設定 (pyproject.toml)

**プロジェクトに `pyproject.toml` の `[tool.isort]` セクションがない場合のみ、以下の設定を使用**:

```toml
[tool.isort]
profile = "black"
line_length = 88
```

### コマンド例

```bash
# インポート整理
isort yourfile.py

# ディレクトリ全体を整理
isort src/

# チェックのみ
isort --check-only src/
```

## 🔬 mypy設定（型チェック）

### 推奨設定 (pyproject.toml)

**プロジェクトに `pyproject.toml` の `[tool.mypy]` セクションがない場合のみ、以下の設定を使用**:

```toml
[tool.mypy]
python_version = "3.11"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
```

### コマンド例

```bash
# 型チェック実行
mypy yourfile.py

# ディレクトリ全体を型チェック
mypy src/
```

## 💻 VSCode設定

### 推奨設定 (.vscode/settings.json)

プロジェクトに `.vscode/settings.json` がない場合の推奨設定:

```json
{
  "[python]": {
    "editor.defaultFormatter": "ms-python.black-formatter",
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
      "source.organizeImports": true
    }
  },
  "python.linting.enabled": true,
  "python.linting.flake8Enabled": true,
  "python.linting.mypyEnabled": true
}
```

## 🪝 Pre-commit フック（Lefthook）

### インストール

```bash
# Lefthookをインストール（グローバル推奨）
brew install lefthook  # macOS
scoop install lefthook  # Windows

# または npm経由
npm install --save-dev @evilmartians/lefthook

# インストール後、フックを有効化
npx lefthook install
```

### 推奨設定 (lefthook.yml)

**プロジェクトに `lefthook.yml` がない場合のみ、以下の設定を使用**:

```yaml
pre-commit:
  parallel: true
  commands:
    # Pythonファイルのフォーマット
    black:
      glob: "*.py"
      run: black {staged_files}
      stage_fixed: true

    # Pythonのインポート整理
    isort:
      glob: "*.py"
      run: isort {staged_files}
      stage_fixed: true

    # Pythonのリント
    flake8:
      glob: "*.py"
      run: flake8 {staged_files}

    # 型チェック
    mypy:
      glob: "*.py"
      run: mypy {staged_files}

pre-push:
  parallel: false
  commands:
    # 全体の型チェック
    mypy-all:
      run: mypy src/

    # テスト実行
    pytest:
      run: pytest --cov --cov-report=term-missing
```

### より詳細な設定例

セキュリティチェックを含む高度な設定:

```yaml
pre-commit:
  parallel: true
  commands:
    # Pythonファイルのフォーマット
    black:
      glob: "*.py"
      run: black {staged_files}
      stage_fixed: true
      fail_text: "Blackでフォーマットしてください"

    # インポート整理
    isort:
      glob: "*.py"
      run: isort {staged_files}
      stage_fixed: true

    # リント
    flake8:
      glob: "*.py"
      run: flake8 {staged_files}
      fail_text: "flake8エラーを修正してください"

    # 型チェック
    mypy:
      glob: "*.py"
      run: mypy {staged_files}

    # セキュリティチェック
    secrets:
      glob: "*"
      run: |
        if git diff --cached --name-only | xargs grep -l "API_KEY\|SECRET\|PASSWORD" > /dev/null; then
          echo "⚠️  警告: 秘密情報が含まれている可能性があります"
          exit 1
        fi

pre-push:
  parallel: false
  commands:
    # 全体の型チェック
    mypy-all:
      run: mypy .

    # テスト実行
    pytest:
      run: pytest --cov --cov-report=term-missing
```

## 📦 完全な pyproject.toml 例

**プロジェクトに `pyproject.toml` がない場合の完全な設定例**:

```toml
[tool.black]
line-length = 88
target-version = ['py311']
exclude = '''
/(
    \.git
  | \.venv
  | venv
  | dist
  | build
)/
'''

[tool.isort]
profile = "black"
line_length = 88

[tool.mypy]
python_version = "3.11"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
```

## 📚 参考リンク

- [Black公式ドキュメント](https://black.readthedocs.io/)
- [flake8公式ドキュメント](https://flake8.pycqa.org/)
- [isort公式ドキュメント](https://pycqa.github.io/isort/)
- [mypy公式ドキュメント](https://mypy.readthedocs.io/)
- [PEP 8 スタイルガイド](https://peps.python.org/pep-0008/)
- [Lefthook](https://github.com/evilmartians/lefthook)

---

**このスキルの使い方**:
- `@code-safety-inspector` がコード検証時にこのスキルを参照します
- プロジェクト固有の設定ファイルがある場合は、それを優先的に使用してください
- 設定ファイルがない場合のみ、上記の推奨設定を適用してください
