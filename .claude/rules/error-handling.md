---
description: エラーハンドリングのベストプラクティス。例外処理、エラーログ、リトライロジックの実装ガイド。
globs: ["**/*.ts", "**/*.tsx", "**/*.js", "**/*.jsx", "**/*.py"]
---

# エラーハンドリング

## 基本原則

1. **エラーは握りつぶさない** - 必ずログを記録するか、上位に伝播
2. **ユーザーフレンドリーなメッセージ** - 技術的詳細は隠す
3. **適切な粒度で捕捉** - 広すぎる catch は避ける
4. **リソースのクリーンアップ** - finally や using を活用

## TypeScript/JavaScript

### 基本パターン

```typescript
try {
  const data = await fetchUserData(userId);
  return processData(data);
} catch (error) {
  // ✅ エラーログを記録
  logger.error('Failed to fetch user data', { userId, error });

  // ✅ ユーザーフレンドリーなエラーメッセージ
  throw new UserNotFoundError(`ユーザー（ID: ${userId}）が見つかりません`);
}
```

### カスタムエラークラス

```typescript
class AppError extends Error {
  constructor(
    message: string,
    public statusCode: number = 500,
    public isOperational: boolean = true
  ) {
    super(message);
    this.name = this.constructor.name;
    Error.captureStackTrace(this, this.constructor);
  }
}

class ValidationError extends AppError {
  constructor(message: string) {
    super(message, 400);
  }
}

class NotFoundError extends AppError {
  constructor(message: string) {
    super(message, 404);
  }
}

class UnauthorizedError extends AppError {
  constructor(message: string = '認証が必要です') {
    super(message, 401);
  }
}
```

### リトライロジック

```typescript
async function withRetry<T>(
  fn: () => Promise<T>,
  options: { maxAttempts: number; delay: number }
): Promise<T> {
  let lastError: Error;

  for (let attempt = 1; attempt <= options.maxAttempts; attempt++) {
    try {
      return await fn();
    } catch (error) {
      lastError = error as Error;
      if (attempt < options.maxAttempts) {
        await new Promise(resolve => setTimeout(resolve, options.delay));
      }
    }
  }

  throw lastError!;
}

// 使用例
const data = await withRetry(
  () => fetchUserData(userId),
  { maxAttempts: 3, delay: 1000 }
);
```

### フォールバック処理

```typescript
// Nullish coalescing
const userName = user?.name ?? 'ゲストユーザー';

// Optional chaining
const city = user?.address?.city;
```

## Python

### 基本パターン

```python
try:
    data = fetch_user_data(user_id)
    return process_data(data)
except UserNotFoundError as e:
    logger.error(f"User not found: {user_id}", exc_info=True)
    raise
except DatabaseError as e:
    logger.error(f"Database error: {e}", exc_info=True)
    raise ServiceError("サービスが一時的に利用できません") from e
finally:
    cleanup_resources()
```

### カスタム例外クラス

```python
class AppError(Exception):
    """アプリケーション基底エラー"""
    def __init__(self, message: str, status_code: int = 500):
        super().__init__(message)
        self.status_code = status_code

class ValidationError(AppError):
    """バリデーションエラー"""
    def __init__(self, message: str):
        super().__init__(message, 400)

class NotFoundError(AppError):
    """リソース未検出エラー"""
    def __init__(self, message: str):
        super().__init__(message, 404)
```

### コンテキストマネージャー

```python
from contextlib import contextmanager

@contextmanager
def managed_resource():
    resource = acquire_resource()
    try:
        yield resource
    finally:
        release_resource(resource)

# 使用例
with managed_resource() as resource:
    process(resource)
```

## エラーログのベストプラクティス

### 含めるべき情報

- タイムスタンプ
- エラーメッセージ
- スタックトレース
- 関連するコンテキスト（ユーザーID、リクエストIDなど）
- エラーの重大度（ERROR, WARN, INFO）

### 含めてはいけない情報

- パスワード
- APIキー
- 個人情報（必要最小限に）
