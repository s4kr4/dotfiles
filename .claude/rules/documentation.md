# ドキュメントガイドライン

## README.md

すべてのプロジェクトには以下を含むREADME.mdを配置：

```markdown
# プロジェクト名

## 概要
プロジェクトの簡潔な説明

## 機能
- 主要機能のリスト

## セットアップ
### 必要要件
- Node.js 24+
- PostgreSQL 14+

### インストール
\`\`\`bash
npm install
cp .env.example .env
npm run dev
\`\`\`

## 開発
### コードフォーマット
\`\`\`bash
npm run format        # Prettierで自動フォーマット
npm run lint          # ESLintでチェック
npm run lint:fix      # ESLintで自動修正
\`\`\`

## 使用方法
基本的な使い方の説明

## テスト
\`\`\`bash
npm test
\`\`\`

## ライセンス
MIT
```

## コード内ドキュメント

### TypeScript / JavaScript

```typescript
/**
 * ユーザー情報を取得する
 *
 * @param userId - ユーザーID
 * @returns ユーザー情報、存在しない場合はnull
 * @throws {DatabaseError} データベース接続エラー
 */
async function getUser(userId: string): Promise<User | null> {
  // 実装
}
```

### Python

```python
def get_user(user_id: str) -> User | None:
    """
    ユーザー情報を取得する

    Args:
        user_id: ユーザーID

    Returns:
        ユーザー情報、存在しない場合はNone

    Raises:
        DatabaseError: データベース接続エラー
    """
    pass
```

## ドキュメント作成の原則

- **必要最小限**: 過剰なドキュメントは保守負担になる
- **コードで語る**: 自明なコードにコメントは不要
- **Why重視**: 「何を」より「なぜ」を説明
- **更新を忘れずに**: 古いドキュメントは害悪
