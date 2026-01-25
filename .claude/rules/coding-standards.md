---
description: コーディング規約。コード実装時に常に適用される基本ルール。
globs: ["**/*.ts", "**/*.tsx", "**/*.js", "**/*.jsx", "**/*.py"]
---

# コーディング規約

## コメント規約

**原則**: 「何を」ではなく「なぜ」を説明

```javascript
// ❌ 悪い例: 何をしているか説明
// カウンターをインクリメント
counter++;

// ✅ 良い例: なぜそうするのか説明
// ユーザーが2回クリックした場合のみ処理を実行するため
counter++;
```

**TODOコメント**:
```javascript
// TODO: リファクタリング必要
// FIXME: パフォーマンス改善が必要
// HACK: 一時的な回避策、後で修正
```

## コード品質原則

### DRY原則（Don't Repeat Yourself）
- 重複コードを排除
- 共通ロジックは関数・モジュール化

### SOLID原則
- **S**ingle Responsibility: 単一責任の原則
- **O**pen/Closed: オープン・クローズドの原則
- **L**iskov Substitution: リスコフの置換原則
- **I**nterface Segregation: インターフェース分離の原則
- **D**ependency Inversion: 依存性逆転の原則

### その他の原則
- 関数は単一責任を持つ（1つのことだけをする）
- マジックナンバーは定数化
- 早期リターンを活用（ネストを減らす）

## 命名規則

### 一般的なルール
- 変数名・関数名は意図が明確な名前を使用
- 略語は避ける（`usr` ではなく `user`）
- ブール値は `is`、`has`、`can` などのプレフィックスを使用

### 言語別規則

**TypeScript/JavaScript**:
- 変数・関数: camelCase (`getUserById`)
- クラス・型: PascalCase (`UserService`, `UserType`)
- 定数: UPPER_SNAKE_CASE (`MAX_RETRY_COUNT`)
- ファイル: kebab-case (`user-service.ts`) または camelCase

**Python**:
- 変数・関数: snake_case (`get_user_by_id`)
- クラス: PascalCase (`UserService`)
- 定数: UPPER_SNAKE_CASE (`MAX_RETRY_COUNT`)
- プライベート: `_` プレフィックス (`_internal_method`)
