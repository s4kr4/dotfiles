---
name: ts-formatter
description: TypeScript/JavaScript向けのフォーマット・リント設定ガイド。Prettier、ESLint、VSCode、Lefthook等の推奨設定を提供。プロジェクト固有の設定ファイルがない場合にこの設定を使用。
---

# TypeScript/JavaScript Formatter & Linter Configuration

TypeScript/JavaScript向けのフォーマット・リント設定のリファレンスです。

## ⚠️ 設定ファイルの優先順位

**重要原則**: プロジェクト固有の設定ファイルが存在する場合は、それを優先して使用してください。

```
1. プロジェクトルートの設定ファイル（.prettierrc.json, .eslintrc.json等）
   → 既存の設定ファイルがある場合は、それに従う

2. 設定ファイルが無い場合
   → 以下のグローバル推奨設定を使用
```

## 🛠️ Prettier設定

### インストール

```bash
npm install --save-dev prettier
```

### 推奨設定 (.prettierrc.json)

**プロジェクトに `.prettierrc.json` がない場合のみ、以下の設定を使用**:

```json
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false,
  "endOfLine": "lf",
  "arrowParens": "always",
  "bracketSpacing": true
}
```

### 除外設定 (.prettierignore)

```
# 依存関係
node_modules/
dist/
build/
coverage/

# ビルド生成物
*.min.js
*.bundle.js

# ログとキャッシュ
*.log
.cache/
```

## 🔍 ESLint設定

### インストール

```bash
# TypeScript プロジェクト
npm install --save-dev eslint @eslint/js @typescript-eslint/parser @typescript-eslint/eslint-plugin eslint-config-prettier

# React プロジェクト
npm install --save-dev eslint-plugin-react eslint-plugin-react-hooks

# Flat Config用のグローバル設定（ESLint 9.x以降）
npm install --save-dev globals
```

### 推奨設定

**プロジェクトに ESLint設定ファイル がない場合のみ、以下の設定を使用**

#### 🆕 Flat Config 形式（推奨 - ESLint 9.x+）

**eslint.config.mjs**（モダンなプロジェクト向け、ESM使用時）:

```javascript
import js from '@eslint/js';
import tseslint from '@typescript-eslint/eslint-plugin';
import tsparser from '@typescript-eslint/parser';
import react from 'eslint-plugin-react';
import reactHooks from 'eslint-plugin-react-hooks';
import prettier from 'eslint-config-prettier';
import globals from 'globals';

export default [
  // グローバル無視設定
  {
    ignores: [
      'node_modules/**',
      'dist/**',
      'build/**',
      'coverage/**',
      '*.min.js',
      '*.bundle.js',
    ],
  },

  // すべてのファイルに適用する基本設定
  {
    files: ['**/*.{js,jsx,mjs,cjs,ts,tsx}'],
    languageOptions: {
      ecmaVersion: 'latest',
      sourceType: 'module',
      globals: {
        ...globals.browser,
        ...globals.node,
        ...globals.es2021,
      },
    },
  },

  // JavaScript/TypeScript共通設定
  {
    files: ['**/*.{js,jsx,mjs,cjs,ts,tsx}'],
    ...js.configs.recommended,
  },

  // TypeScript専用設定
  {
    files: ['**/*.{ts,tsx}'],
    languageOptions: {
      parser: tsparser,
      parserOptions: {
        ecmaFeatures: {
          jsx: true,
        },
      },
    },
    plugins: {
      '@typescript-eslint': tseslint,
    },
    rules: {
      ...tseslint.configs.recommended.rules,
      '@typescript-eslint/no-unused-vars': [
        'error',
        { argsIgnorePattern: '^_' },
      ],
      '@typescript-eslint/explicit-function-return-type': 'off',
      '@typescript-eslint/no-explicit-any': 'warn',
    },
  },

  // React専用設定
  {
    files: ['**/*.{jsx,tsx}'],
    plugins: {
      react: react,
      'react-hooks': reactHooks,
    },
    settings: {
      react: {
        version: 'detect',
      },
    },
    rules: {
      ...react.configs.recommended.rules,
      ...reactHooks.configs.recommended.rules,
      'react/react-in-jsx-scope': 'off',
      'react/prop-types': 'off',
    },
  },

  // コンソール使用制限
  {
    files: ['**/*.{js,jsx,ts,tsx}'],
    rules: {
      'no-console': ['warn', { allow: ['warn', 'error'] }],
    },
  },

  // Prettier統合（最後に配置）
  prettier,
];
```

**eslint.config.js**（CommonJS使用時）:

```javascript
const js = require('@eslint/js');
const tseslint = require('@typescript-eslint/eslint-plugin');
const tsparser = require('@typescript-eslint/parser');
const react = require('eslint-plugin-react');
const reactHooks = require('eslint-plugin-react-hooks');
const prettier = require('eslint-config-prettier');
const globals = require('globals');

module.exports = [
  // グローバル無視設定
  {
    ignores: [
      'node_modules/**',
      'dist/**',
      'build/**',
      'coverage/**',
      '*.min.js',
      '*.bundle.js',
    ],
  },

  // すべてのファイルに適用する基本設定
  {
    files: ['**/*.{js,jsx,mjs,cjs,ts,tsx}'],
    languageOptions: {
      ecmaVersion: 'latest',
      sourceType: 'module',
      globals: {
        ...globals.browser,
        ...globals.node,
        ...globals.es2021,
      },
    },
  },

  // JavaScript/TypeScript共通設定
  {
    files: ['**/*.{js,jsx,mjs,cjs,ts,tsx}'],
    ...js.configs.recommended,
  },

  // TypeScript専用設定
  {
    files: ['**/*.{ts,tsx}'],
    languageOptions: {
      parser: tsparser,
      parserOptions: {
        ecmaFeatures: {
          jsx: true,
        },
      },
    },
    plugins: {
      '@typescript-eslint': tseslint,
    },
    rules: {
      ...tseslint.configs.recommended.rules,
      '@typescript-eslint/no-unused-vars': [
        'error',
        { argsIgnorePattern: '^_' },
      ],
      '@typescript-eslint/explicit-function-return-type': 'off',
      '@typescript-eslint/no-explicit-any': 'warn',
    },
  },

  // React専用設定
  {
    files: ['**/*.{jsx,tsx}'],
    plugins: {
      react: react,
      'react-hooks': reactHooks,
    },
    settings: {
      react: {
        version: 'detect',
      },
    },
    rules: {
      ...react.configs.recommended.rules,
      ...reactHooks.configs.recommended.rules,
      'react/react-in-jsx-scope': 'off',
      'react/prop-types': 'off',
    },
  },

  // コンソール使用制限
  {
    files: ['**/*.{js,jsx,ts,tsx}'],
    rules: {
      'no-console': ['warn', { allow: ['warn', 'error'] }],
    },
  },

  // Prettier統合（最後に配置）
  prettier,
];
```

#### 従来形式（.eslintrc.json）

**ESLint 8.x以前、または既存プロジェクトで使用**:

```json
{
  "env": {
    "browser": true,
    "es2021": true,
    "node": true
  },
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:react/recommended",
    "plugin:react-hooks/recommended",
    "prettier"
  ],
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "ecmaFeatures": {
      "jsx": true
    },
    "ecmaVersion": "latest",
    "sourceType": "module"
  },
  "plugins": ["@typescript-eslint", "react", "react-hooks"],
  "rules": {
    "@typescript-eslint/no-unused-vars": [
      "error",
      { "argsIgnorePattern": "^_" }
    ],
    "@typescript-eslint/explicit-function-return-type": "off",
    "@typescript-eslint/no-explicit-any": "warn",
    "react/react-in-jsx-scope": "off",
    "react/prop-types": "off",
    "no-console": ["warn", { "allow": ["warn", "error"] }]
  },
  "settings": {
    "react": {
      "version": "detect"
    }
  }
}
```

### 除外設定 (.eslintignore)

**従来形式（.eslintrc.json）使用時のみ必要**（Flat Configでは `ignores` キーで設定）:

```
node_modules/
dist/
build/
coverage/
*.min.js
*.bundle.js
.cache/
```

## 💻 VSCode設定

### 推奨設定 (.vscode/settings.json)

プロジェクトに `.vscode/settings.json` がない場合の推奨設定:

```json
{
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "eslint.validate": [
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact"
  ]
}
```

## 📦 npm scripts

### 推奨スクリプト (package.json)

プロジェクトの `package.json` に以下のスクリプトを追加することを推奨:

#### Flat Config (eslint.config.mjs/js) 使用時

```json
{
  "scripts": {
    "lint": "eslint .",
    "lint:fix": "eslint . --fix",
    "format": "prettier --write \"src/**/*.{js,jsx,ts,tsx,json,css,md}\"",
    "format:check": "prettier --check \"src/**/*.{js,jsx,ts,tsx,json,css,md}\"",
    "type-check": "tsc --noEmit",
    "prepare": "lefthook install"
  }
}
```

**Note**: Flat Config形式では `--ext` オプションは不要です。`files` パターンで拡張子を指定します。

#### 従来形式 (.eslintrc.json) 使用時

```json
{
  "scripts": {
    "lint": "eslint . --ext .js,.jsx,.ts,.tsx",
    "lint:fix": "eslint . --ext .js,.jsx,.ts,.tsx --fix",
    "format": "prettier --write \"src/**/*.{js,jsx,ts,tsx,json,css,md}\"",
    "format:check": "prettier --check \"src/**/*.{js,jsx,ts,tsx,json,css,md}\"",
    "type-check": "tsc --noEmit",
    "prepare": "lefthook install"
  }
}
```

## 🪝 Pre-commit フック（Lefthook）

### インストール

```bash
# npm経由
npm install --save-dev @evilmartians/lefthook

# または直接インストール（推奨）
brew install lefthook  # macOS
scoop install lefthook  # Windows

# インストール後、フックを有効化
npx lefthook install
```

### 推奨設定 (lefthook.yml)

**プロジェクトに `lefthook.yml` がない場合のみ、以下の設定を使用**:

#### Flat Config 対応版（ESLint 9.x+）

```yaml
pre-commit:
  parallel: true
  commands:
    # TypeScript/JavaScriptファイルのリント
    eslint:
      glob: "*.{js,jsx,ts,tsx}"
      run: npx eslint {staged_files} --fix --max-warnings=0
      stage_fixed: true
      fail_text: "ESLintエラーを修正してください"

    # フォーマット
    prettier:
      glob: "*.{js,jsx,ts,tsx,json,css,scss,md,yml,yaml}"
      run: npx prettier --write --ignore-unknown {staged_files}
      stage_fixed: true

pre-push:
  parallel: false
  commands:
    # 型チェック
    typescript:
      run: npx tsc --noEmit

    # ユニットテスト
    jest:
      run: npm test -- --coverage --passWithNoTests
```

**Note**: Flat Config形式では `eslint` コマンドに `--ext` オプションは不要です。

#### 従来形式 (.eslintrc.json) 使用時

```yaml
pre-commit:
  parallel: true
  commands:
    # TypeScript/JavaScriptファイルのリント
    eslint:
      glob: "*.{js,jsx,ts,tsx}"
      run: npx eslint {staged_files} --ext .js,.jsx,.ts,.tsx --fix --max-warnings=0
      stage_fixed: true
      fail_text: "ESLintエラーを修正してください"

    # フォーマット
    prettier:
      glob: "*.{js,jsx,ts,tsx,json,css,scss,md,yml,yaml}"
      run: npx prettier --write --ignore-unknown {staged_files}
      stage_fixed: true

pre-push:
  parallel: false
  commands:
    # 型チェック
    typescript:
      run: npx tsc --noEmit

    # ユニットテスト
    jest:
      run: npm test -- --coverage --passWithNoTests
```

### より詳細な設定例

セキュリティチェックやコミットメッセージ検証を含む高度な設定:

#### Flat Config 対応版

```yaml
pre-commit:
  parallel: true
  commands:
    # フロントエンド
    eslint:
      glob: "*.{js,jsx,ts,tsx}"
      run: npx eslint {staged_files} --fix --max-warnings=0
      stage_fixed: true
      fail_text: "ESLintエラーを修正してください"

    prettier:
      glob: "*.{js,jsx,ts,tsx,json,css,scss,md,yml,yaml}"
      run: npx prettier --write --ignore-unknown {staged_files}
      stage_fixed: true

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
    # 型チェック
    typescript:
      run: npx tsc --noEmit

    # ユニットテスト
    jest:
      run: npm test -- --coverage --passWithNoTests
```

#### 従来形式 (.eslintrc.json) 使用時

```yaml
pre-commit:
  parallel: true
  commands:
    # フロントエンド
    eslint:
      glob: "*.{js,jsx,ts,tsx}"
      run: npx eslint {staged_files} --ext .js,.jsx,.ts,.tsx --fix --max-warnings=0
      stage_fixed: true
      fail_text: "ESLintエラーを修正してください"

    prettier:
      glob: "*.{js,jsx,ts,tsx,json,css,scss,md,yml,yaml}"
      run: npx prettier --write --ignore-unknown {staged_files}
      stage_fixed: true

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
    # 型チェック
    typescript:
      run: npx tsc --noEmit

    # ユニットテスト
    jest:
      run: npm test -- --coverage --passWithNoTests
```

**Note**: `commit-msg` フックは基本的には不要です。ユーザーが明示的に要求した場合のみ設定を追加してください。

## 📚 参考リンク

- [Prettier公式ドキュメント](https://prettier.io/)
- [ESLint公式ドキュメント](https://eslint.org/)
- [ESLint Flat Config](https://eslint.org/docs/latest/use/configure/configuration-files) - ESLint 9.x 新形式
- [TypeScript ESLint](https://typescript-eslint.io/)
- [TypeScript ESLint - Flat Config](https://typescript-eslint.io/getting-started#flat-config)
- [Lefthook](https://github.com/evilmartians/lefthook)

---

**このスキルの使い方**:
- `@code-safety-inspector` がコード検証時にこのスキルを参照します
- プロジェクト固有の設定ファイルがある場合は、それを優先的に使用してください
- 設定ファイルがない場合のみ、上記の推奨設定を適用してください
- **Flat Config形式を推奨**: 新規プロジェクトではFlat Config（`eslint.config.mjs/js`）を使用することを推奨します
- **従来形式のサポート**: 既存プロジェクトでは `.eslintrc.json` も引き続きサポートされます（ESLint 8.x互換）
