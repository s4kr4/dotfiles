# TypeScript Patterns & Code Examples

TypeScript実装のための詳細なパターン集とコード例です。

## 📖 Table of Contents

- [関数定義](#関数定義)
- [型定義](#型定義)
- [エラーハンドリング](#エラーハンドリング)
- [モダンJavaScript機能](#モダンjavascript機能)
- [クラスとOOP](#クラスとoop)
- [非同期処理](#非同期処理)
- [ユーティリティ型](#ユーティリティ型)

---

## 関数定義

### 基本的な関数

```typescript
// ✅ 良い例: 明示的な型、明確な目的
function calculateTotal(price: number, taxRate: number): number {
  return price * (1 + taxRate);
}

// ✅ 良い例: アロー関数（短い関数向け）
const getUserName = (user: User): string => user.name;

// ❌ 悪い例: 型がない
function calculateTotal(price, taxRate) {
  return price * (1 + taxRate);
}

// ❌ 悪い例: any型
function processData(data: any): any {
  return data.value;
}
```

### 非同期関数

```typescript
// ✅ 良い例: 適切なエラーハンドリング
async function fetchUserData(userId: string): Promise<User> {
  try {
    const response = await fetch(`/api/users/${userId}`);
    if (!response.ok) {
      throw new Error(`Failed to fetch user: ${response.statusText}`);
    }
    return await response.json();
  } catch (error) {
    throw new Error(`Failed to fetch user data: ${error}`);
  }
}

// ✅ 良い例: 複数の非同期処理
async function fetchMultipleUsers(userIds: string[]): Promise<User[]> {
  const promises = userIds.map((id) => fetchUserData(id));
  return await Promise.all(promises);
}

// ✅ 良い例: リトライロジック付き
async function fetchWithRetry<T>(
  fn: () => Promise<T>,
  maxRetries: number = 3,
  delay: number = 1000
): Promise<T> {
  let lastError: Error;

  for (let i = 0; i < maxRetries; i++) {
    try {
      return await fn();
    } catch (error) {
      lastError = error as Error;
      if (i < maxRetries - 1) {
        await new Promise((resolve) => setTimeout(resolve, delay));
      }
    }
  }

  throw new Error(`Failed after ${maxRetries} retries: ${lastError!.message}`);
}
```

### オプショナルパラメータとデフォルト値

```typescript
// ✅ 良い例: オプショナルパラメータ
function greet(name: string, greeting?: string): string {
  return `${greeting ?? 'Hello'}, ${name}!`;
}

// ✅ 良い例: デフォルト値
function createUser(
  name: string,
  role: UserRole = 'user',
  isActive: boolean = true
): User {
  return { name, role, isActive };
}

// ✅ 良い例: オプショナルとデフォルトの組み合わせ
interface FetchOptions {
  timeout?: number;
  retries?: number;
  cache?: boolean;
}

function fetchData(
  url: string,
  options: FetchOptions = {}
): Promise<Response> {
  const { timeout = 5000, retries = 3, cache = true } = options;
  // 実装
}
```

---

## 型定義

### Interface vs Type

```typescript
// ✅ Interface: オブジェクトの形状を定義
interface User {
  id: string;
  name: string;
  email: string;
  role: UserRole;
  createdAt: Date;
}

// ✅ Interface: 拡張可能
interface AdminUser extends User {
  permissions: string[];
  canManageUsers: boolean;
}

// ✅ Type: Union型
type UserRole = 'admin' | 'user' | 'guest';

// ✅ Type: Intersection型
type Timestamped = {
  createdAt: Date;
  updatedAt: Date;
};

type UserWithTimestamp = User & Timestamped;

// ✅ Type: 複雑な型
type Result<T> =
  | { success: true; data: T }
  | { success: false; error: Error };

// ✅ Type: 条件型
type NonNullableFields<T> = {
  [P in keyof T]: NonNullable<T[P]>;
};
```

### ジェネリック型

```typescript
// ✅ 良い例: 汎用的なRepository
interface Repository<T> {
  findById(id: string): Promise<T | null>;
  findAll(): Promise<T[]>;
  save(entity: T): Promise<T>;
  update(id: string, entity: Partial<T>): Promise<T>;
  delete(id: string): Promise<void>;
}

// ✅ 良い例: 制約付きジェネリック
interface Identifiable {
  id: string;
}

function findById<T extends Identifiable>(
  items: T[],
  id: string
): T | undefined {
  return items.find((item) => item.id === id);
}

// ✅ 良い例: 複数のジェネリック型パラメータ
function map<T, U>(items: T[], fn: (item: T) => U): U[] {
  return items.map(fn);
}

// ✅ 良い例: デフォルト型パラメータ
interface ApiResponse<T = unknown> {
  data: T;
  status: number;
  message: string;
}
```

---

### Utility Types

```typescript
// ✅ Partial: すべてのプロパティをオプショナルに
function updateUser(id: string, updates: Partial<User>): User {
  const user = getUserById(id);
  return { ...user, ...updates };
}

// ✅ Required: すべてのプロパティを必須に
type RequiredUser = Required<Partial<User>>;

// ✅ Pick: 特定のプロパティのみ抽出
type UserCredentials = Pick<User, 'email' | 'password'>;

// ✅ Omit: 特定のプロパティを除外
type UserWithoutPassword = Omit<User, 'password'>;

// ✅ Record: キーと値の型を指定
type UserRoles = Record<string, UserRole>;
const roles: UserRoles = {
  'user-1': 'admin',
  'user-2': 'user',
};

// ✅ ReturnType: 関数の戻り値の型を取得
function createUser(): User {
  // 実装
}
type CreatedUser = ReturnType<typeof createUser>; // User型
```

---

## エラーハンドリング

### カスタムエラークラス

```typescript
// ✅ 良い例: ベースエラークラス
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

// ✅ 良い例: 具体的なエラークラス
class ValidationError extends AppError {
  constructor(message: string, public field: string) {
    super(message, 400);
    this.field = field;
  }
}

class NotFoundError extends AppError {
  constructor(resource: string, id: string) {
    super(`${resource} with id ${id} not found`, 404);
  }
}

class UnauthorizedError extends AppError {
  constructor(message: string = 'Unauthorized') {
    super(message, 401);
  }
}
```

### エラーハンドリングパターン

```typescript
// ✅ 良い例: 型ガードによるエラー処理
try {
  const result = await processData(data);
  return result;
} catch (error) {
  if (error instanceof ValidationError) {
    logger.error(`Validation failed for ${error.field}: ${error.message}`);
    return { success: false, error: error.message };
  }

  if (error instanceof NotFoundError) {
    logger.warn(error.message);
    return { success: false, error: 'Resource not found' };
  }

  logger.error('Unexpected error:', error);
  throw new AppError('Failed to process data');
}

// ✅ 良い例: Result型パターン
type Result<T, E = Error> =
  | { success: true; data: T }
  | { success: false; error: E };

async function fetchUser(id: string): Promise<Result<User>> {
  try {
    const user = await getUserById(id);
    return { success: true, data: user };
  } catch (error) {
    return { success: false, error: error as Error };
  }
}

// 使用例
const result = await fetchUser('123');
if (result.success) {
  console.log(result.data.name);
} else {
  console.error(result.error.message);
}

// ✅ 良い例: エラーバウンダリ
function withErrorHandler<T extends (...args: any[]) => any>(
  fn: T
): (...args: Parameters<T>) => Promise<ReturnType<T>> {
  return async (...args: Parameters<T>) => {
    try {
      return await fn(...args);
    } catch (error) {
      logger.error(`Error in ${fn.name}:`, error);
      throw error;
    }
  };
}
```

---

## モダンJavaScript機能

### 分割代入（Destructuring）

```typescript
// ✅ オブジェクトの分割代入
const { id, name, email } = user;

// ✅ ネストされたオブジェクト
const { profile: { name, age } } = user;

// ✅ デフォルト値
const { role = 'user', isActive = true } = user;

// ✅ リネーム
const { name: userName, email: userEmail } = user;

// ✅ 配列の分割代入
const [first, second, ...rest] = items;

// ✅ スキップ
const [first, , third] = items;

// ✅ 関数パラメータで使用
function greetUser({ name, role }: User): string {
  return `Hello, ${name} (${role})`;
}
```

### スプレッド演算子

```typescript
// ✅ オブジェクトのコピーとマージ
const newUser = { ...user, lastLogin: new Date() };
const mergedConfig = { ...defaultConfig, ...userConfig };

// ✅ 配列の結合
const allItems = [...existingItems, ...newItems];

// ✅ 配列のコピー
const itemsCopy = [...items];

// ✅ 関数の引数
function sum(...numbers: number[]): number {
  return numbers.reduce((a, b) => a + b, 0);
}

// ✅ イミュータブルな配列操作
const updatedItems = [
  ...items.slice(0, index),
  updatedItem,
  ...items.slice(index + 1),
];
```

### オプショナルチェイニング & Nullish Coalescing

```typescript
// ✅ オプショナルチェイニング（?.）
const userName = user?.profile?.name;
const firstItem = items?.[0];
const result = user?.getName?.(;

// ✅ Nullish coalescing（??）
const displayName = userName ?? 'Anonymous';
const port = config.port ?? 3000;

// ✅ 組み合わせ
const greeting = `Hello, ${user?.name ?? 'Guest'}!`;

// ❌ 悪い例: 従来の方法
const userName = user && user.profile && user.profile.name;
const displayName = userName !== null && userName !== undefined ? userName : 'Anonymous';
```

### テンプレートリテラル

```typescript
// ✅ 基本的な使用
const message = `Hello, ${name}!`;

// ✅ 複数行
const html = `
  <div class="user">
    <h2>${user.name}</h2>
    <p>${user.email}</p>
  </div>
`;

// ✅ 式の埋め込み
const summary = `You have ${items.length} item${items.length !== 1 ? 's' : ''}`;

// ✅ タグ付きテンプレートリテラル
function sql(strings: TemplateStringsArray, ...values: any[]) {
  // SQLクエリを安全に構築
}

const query = sql`SELECT * FROM users WHERE id = ${userId}`;
```

---

## クラスとOOP

### クラス定義

```typescript
// ✅ 良い例: モダンなクラス定義
class User {
  // プライベートフィールド（#記法）
  #password: string;

  constructor(
    public id: string,
    public name: string,
    public email: string,
    private role: UserRole = 'user'
  ) {
    this.#password = '';
  }

  // ゲッター
  get isAdmin(): boolean {
    return this.role === 'admin';
  }

  // セッター
  set password(value: string) {
    if (value.length < 8) {
      throw new ValidationError('Password too short', 'password');
    }
    this.#password = value;
  }

  // メソッド
  async save(): Promise<void> {
    // データベースに保存
  }
}

// ✅ 良い例: 抽象クラス
abstract class Repository<T> {
  abstract findById(id: string): Promise<T | null>;
  abstract save(entity: T): Promise<T>;

  async findByIds(ids: string[]): Promise<T[]> {
    const promises = ids.map((id) => this.findById(id));
    const results = await Promise.all(promises);
    return results.filter((r): r is T => r !== null);
  }
}

class UserRepository extends Repository<User> {
  async findById(id: string): Promise<User | null> {
    // 実装
  }

  async save(user: User): Promise<User> {
    // 実装
  }
}
```

---

## 非同期処理

### Promise

```typescript
// ✅ Promise.all: 並列実行
const [users, posts, comments] = await Promise.all([
  fetchUsers(),
  fetchPosts(),
  fetchComments(),
]);

// ✅ Promise.allSettled: 全て完了を待つ（失敗含む）
const results = await Promise.allSettled([
  fetchUsers(),
  fetchPosts(),
  fetchComments(),
]);

results.forEach((result) => {
  if (result.status === 'fulfilled') {
    console.log('Success:', result.value);
  } else {
    console.error('Failed:', result.reason);
  }
});

// ✅ Promise.race: 最初に完了したものを返す
const fastestResponse = await Promise.race([
  fetch('https://api1.example.com'),
  fetch('https://api2.example.com'),
]);
```

### async/await パターン

```typescript
// ✅ 良い例: 直列実行
async function processItemsSequentially(items: Item[]): Promise<Result[]> {
  const results: Result[] = [];

  for (const item of items) {
    const result = await processItem(item);
    results.push(result);
  }

  return results;
}

// ✅ 良い例: 並列実行
async function processItemsInParallel(items: Item[]): Promise<Result[]> {
  return await Promise.all(
    items.map((item) => processItem(item))
  );
}

// ✅ 良い例: バッチ処理
async function processInBatches<T, R>(
  items: T[],
  batchSize: number,
  processor: (item: T) => Promise<R>
): Promise<R[]> {
  const results: R[] = [];

  for (let i = 0; i < items.length; i += batchSize) {
    const batch = items.slice(i, i + batchSize);
    const batchResults = await Promise.all(
      batch.map(processor)
    );
    results.push(...batchResults);
  }

  return results;
}
```

---

## ユーティリティ型

### カスタムユーティリティ型

```typescript
// ✅ DeepPartial: ネストされたオブジェクトも含めてPartial
type DeepPartial<T> = {
  [P in keyof T]?: T[P] extends object ? DeepPartial<T[P]> : T[P];
};

// ✅ DeepReadonly: ネストされたオブジェクトも含めてReadonly
type DeepReadonly<T> = {
  readonly [P in keyof T]: T[P] extends object ? DeepReadonly<T[P]> : T[P];
};

// ✅ NonNullableFields: すべてのフィールドを非null/undefinedに
type NonNullableFields<T> = {
  [P in keyof T]: NonNullable<T[P]>;
};

// ✅ PickByType: 特定の型のプロパティのみ抽出
type PickByType<T, U> = {
  [P in keyof T as T[P] extends U ? P : never]: T[P];
};

// 使用例
interface User {
  id: string;
  name: string;
  age: number;
  isActive: boolean;
}

type StringFields = PickByType<User, string>; // { id: string; name: string }
```

---

## まとめ

これらのパターンを活用して、型安全で保守性の高いTypeScriptコードを書いてください。

**重要な原則**:
- `any`を避ける
- 明示的な型定義
- 適切なエラーハンドリング
- モダンなJavaScript機能の活用
- コードの重複を避ける
- 単一責任の原則

**参考リンク**:
- [TypeScript公式ドキュメント](https://www.typescriptlang.org/docs/)
- [TypeScript Deep Dive](https://basarat.gitbook.io/typescript/)
- [Effective TypeScript](https://effectivetypescript.com/)
