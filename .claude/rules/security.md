---
description: セキュリティガイドライン。コード実装時に常に確認すべきセキュリティルール。
globs: ["**/*.ts", "**/*.tsx", "**/*.js", "**/*.jsx", "**/*.py", "**/*.env*"]
---

# セキュリティガイドライン

## 秘密情報の管理

### 絶対にコードに含めてはいけないもの
- API Key
- パスワード
- データベース接続文字列
- 秘密鍵（*.key, *.pem）
- トークン

### 環境変数を使用

```bash
# ✅ 環境変数を使用
API_KEY=your_secret_key_here
DATABASE_URL=postgresql://localhost/mydb
```

### .gitignore で除外

```
.env
.env.local
.env.*.local
secrets/
*.key
*.pem
credentials.json
```

## セキュリティチェックリスト

コード実装時に以下を確認:

- [ ] 秘密情報（API Key、パスワード）をコードに含めていない
- [ ] 環境変数（.env）を使用している
- [ ] .gitignore で機密ファイルを除外している
- [ ] 入力値のバリデーションを実装している
- [ ] SQLインジェクション対策（パラメータ化クエリ）
- [ ] XSS対策（エスケープ処理）
- [ ] CSRF対策（トークン検証）
- [ ] 適切な認証・認可を実装している

## 脆弱性対策

### SQLインジェクション対策

```typescript
// ❌ 危険
const query = `SELECT * FROM users WHERE id = '${userId}'`;

// ✅ 安全（パラメータ化クエリ）
const query = 'SELECT * FROM users WHERE id = ?';
db.query(query, [userId]);
```

### XSS対策

```typescript
// ❌ 危険
element.innerHTML = userInput;

// ✅ 安全
element.textContent = userInput;
// または適切なエスケープ処理を行う
```

### パスワードの取り扱い

- 平文で保存しない
- bcrypt などのハッシュアルゴリズムを使用
- ソルトを使用

```typescript
import bcrypt from 'bcrypt';

// ハッシュ化
const hashedPassword = await bcrypt.hash(password, 10);

// 検証
const isValid = await bcrypt.compare(password, hashedPassword);
```

## 依存関係の脆弱性チェック

定期的に以下を実行:

```bash
# Node.js
npm audit
npm audit fix

# Python
pip-audit
```
