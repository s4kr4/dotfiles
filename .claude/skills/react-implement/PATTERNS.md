# React Patterns & Code Examples

React実装のための詳細なパターン集とコード例です。

## 📖 Table of Contents

- [関数コンポーネント](#関数コンポーネント)
- [Hooks の使用](#hooks-の使用)
- [カスタムフック](#カスタムフック)
- [Props の型定義](#props-の型定義)
- [Context API](#context-api)
- [useReducer による状態管理](#usereducer-による状態管理)
- [パフォーマンス最適化](#パフォーマンス最適化)
- [エラーバウンダリ](#エラーバウンダリ)
- [フォームハンドリング](#フォームハンドリング)
- [テストパターン](#テストパターン)

---

## 関数コンポーネント

### 基本的な関数コンポーネント

```typescript
// ✅ 良い例: function形式で定義（アロー関数ではなく）
interface TodoListProps {
  items: Todo[];
  onItemClick: (id: string) => void;
}

function TodoList({ items, onItemClick }: TodoListProps) {
  return (
    <div>
      {items.map((item) => (
        <div key={item.id} onClick={() => onItemClick(item.id)}>
          {item.title}
        </div>
      ))}
    </div>
  );
}

// ❌ 悪い例: アロー関数形式（非推奨）
const TodoList = ({ items, onItemClick }: TodoListProps) => {
  // ...
};

// ❌ 悪い例: クラスコンポーネント（禁止）
class TodoList extends React.Component<TodoListProps> {
  // ...
}
```

### 名前付きエクスポート（推奨）

```typescript
// ✅ 良い例: 名前付きエクスポート
export function UserCard({ user }: { user: User }) {
  return (
    <div>
      <h2>{user.name}</h2>
      <p>{user.email}</p>
    </div>
  );
}

// ❌ 非推奨: デフォルトエクスポート
export default function UserCard({ user }: { user: User }) {
  // ...
}
```

**理由**:
- 名前付きエクスポートはリファクタリング時に安全
- インポート時の名前が統一される
- ツールのサポートが優れている

---

## Hooks の使用

### useState

```typescript
import { useState } from 'react';

function Counter() {
  // ✅ useState: 状態管理
  const [count, setCount] = useState(0);
  const [user, setUser] = useState<User | null>(null);

  // ✅ 関数形式の setState（前の値に基づく更新）
  const increment = () => {
    setCount((prev) => prev + 1);
  };

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={increment}>Increment</button>
    </div>
  );
}
```

### useEffect

```typescript
import { useEffect, useState } from 'react';

function UserProfile({ userId }: { userId: string }) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(false);

  // ✅ useEffect: 副作用処理
  useEffect(() => {
    const fetchUser = async () => {
      setLoading(true);
      try {
        const data = await getUserById(userId);
        setUser(data);
      } catch (error) {
        console.error('Failed to fetch user:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchUser();
  }, [userId]); // 依存配列を適切に指定

  // ✅ クリーンアップ関数
  useEffect(() => {
    const subscription = subscribeToUpdates(userId);

    return () => {
      subscription.unsubscribe(); // クリーンアップ
    };
  }, [userId]);

  if (loading) return <div>Loading...</div>;
  if (!user) return <div>User not found</div>;

  return (
    <div>
      <h1>{user.name}</h1>
      <p>{user.email}</p>
    </div>
  );
}
```

### useCallback と useMemo

```typescript
import { useCallback, useMemo, useState } from 'react';

function ProductList({ products }: { products: Product[] }) {
  const [sortOrder, setSortOrder] = useState<'asc' | 'desc'>('asc');

  // ✅ useCallback: 関数のメモ化
  const handleSort = useCallback(() => {
    setSortOrder((prev) => (prev === 'asc' ? 'desc' : 'asc'));
  }, []);

  // ✅ useMemo: 計算結果のメモ化
  const sortedProducts = useMemo(() => {
    return products.sort((a, b) => {
      if (sortOrder === 'asc') {
        return a.price - b.price;
      } else {
        return b.price - a.price;
      }
    });
  }, [products, sortOrder]);

  return (
    <div>
      <button onClick={handleSort}>Sort</button>
      <ul>
        {sortedProducts.map((product) => (
          <li key={product.id}>
            {product.name} - ${product.price}
          </li>
        ))}
      </ul>
    </div>
  );
}
```

---

## カスタムフック

### 共通ロジックの抽出

```typescript
// ✅ カスタムフックは use で始める
function useTodoManager() {
  const [todos, setTodos] = useState<Todo[]>([]);
  const [loading, setLoading] = useState(false);

  const addTodo = useCallback((title: string) => {
    const newTodo: Todo = {
      id: Date.now().toString(),
      title,
      completed: false,
    };
    setTodos((prev) => [...prev, newTodo]);
  }, []);

  const toggleTodo = useCallback((id: string) => {
    setTodos((prev) =>
      prev.map((todo) =>
        todo.id === id ? { ...todo, completed: !todo.completed } : todo
      )
    );
  }, []);

  const removeTodo = useCallback((id: string) => {
    setTodos((prev) => prev.filter((todo) => todo.id !== id));
  }, []);

  return {
    todos,
    loading,
    addTodo,
    toggleTodo,
    removeTodo,
  };
}

// 使用例
function TodoApp() {
  const { todos, addTodo, toggleTodo, removeTodo } = useTodoManager();

  return (
    <div>
      <button onClick={() => addTodo('New task')}>Add Todo</button>
      <ul>
        {todos.map((todo) => (
          <li key={todo.id}>
            <input
              type="checkbox"
              checked={todo.completed}
              onChange={() => toggleTodo(todo.id)}
            />
            {todo.title}
            <button onClick={() => removeTodo(todo.id)}>Delete</button>
          </li>
        ))}
      </ul>
    </div>
  );
}
```

### データフェッチングのカスタムフック

```typescript
function useFetch<T>(url: string) {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        const response = await fetch(url);
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        const result = await response.json();
        setData(result);
      } catch (err) {
        setError(err instanceof Error ? err : new Error('Unknown error'));
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [url]);

  return { data, loading, error };
}

// 使用例
function UserList() {
  const { data: users, loading, error } = useFetch<User[]>('/api/users');

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;
  if (!users) return <div>No users found</div>;

  return (
    <ul>
      {users.map((user) => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
}
```

---

## Props の型定義

### 基本的なProps型

```typescript
// ✅ interfaceで型定義（推奨）
interface ButtonProps {
  children: React.ReactNode;
  onClick: () => void;
  variant?: 'primary' | 'secondary';
  disabled?: boolean;
}

function Button({
  children,
  onClick,
  variant = 'primary',
  disabled = false,
}: ButtonProps) {
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={`btn btn-${variant}`}
    >
      {children}
    </button>
  );
}
```

### ジェネリックProps

```typescript
// ✅ ジェネリックProps
interface ListProps<T> {
  items: T[];
  renderItem: (item: T) => React.ReactNode;
  keyExtractor: (item: T) => string;
}

function List<T>({ items, renderItem, keyExtractor }: ListProps<T>) {
  return (
    <div>
      {items.map((item) => (
        <div key={keyExtractor(item)}>{renderItem(item)}</div>
      ))}
    </div>
  );
}

// 使用例
function App() {
  const users: User[] = [
    { id: '1', name: 'Alice' },
    { id: '2', name: 'Bob' },
  ];

  return (
    <List
      items={users}
      renderItem={(user) => <span>{user.name}</span>}
      keyExtractor={(user) => user.id}
    />
  );
}
```

### イベントハンドラの型

```typescript
interface FormProps {
  onSubmit: (data: FormData) => void;
}

function MyForm({ onSubmit }: FormProps) {
  // ✅ 適切なイベント型
  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    const formData = new FormData(event.currentTarget);
    onSubmit(formData);
  };

  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    console.log(event.target.value);
  };

  const handleClick = (event: React.MouseEvent<HTMLButtonElement>) => {
    console.log('Button clicked');
  };

  return (
    <form onSubmit={handleSubmit}>
      <input onChange={handleChange} />
      <button onClick={handleClick}>Submit</button>
    </form>
  );
}
```

---

## Context API

### Context の作成とProvider

```typescript
// ✅ Context でグローバル状態を管理
interface ThemeContextType {
  theme: 'light' | 'dark';
  toggleTheme: () => void;
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const [theme, setTheme] = useState<'light' | 'dark'>('light');

  const toggleTheme = useCallback(() => {
    setTheme((prev) => (prev === 'light' ? 'dark' : 'light'));
  }, []);

  const value = useMemo(
    () => ({ theme, toggleTheme }),
    [theme, toggleTheme]
  );

  return (
    <ThemeContext.Provider value={value}>{children}</ThemeContext.Provider>
  );
}

// ✅ カスタムフックでContextを利用
export function useTheme() {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useTheme must be used within ThemeProvider');
  }
  return context;
}

// 使用例
function App() {
  return (
    <ThemeProvider>
      <Header />
      <Main />
    </ThemeProvider>
  );
}

function Header() {
  const { theme, toggleTheme } = useTheme();

  return (
    <header className={theme}>
      <button onClick={toggleTheme}>Toggle Theme</button>
    </header>
  );
}
```

### 複数のContextを組み合わせる

```typescript
// ✅ 複数のProviderを組み合わせる
function App() {
  return (
    <ThemeProvider>
      <AuthProvider>
        <NotificationProvider>
          <Router />
        </NotificationProvider>
      </AuthProvider>
    </ThemeProvider>
  );
}

// ✅ または、コンポーザーパターンを使う
function AppProviders({ children }: { children: React.ReactNode }) {
  return (
    <ThemeProvider>
      <AuthProvider>
        <NotificationProvider>{children}</NotificationProvider>
      </AuthProvider>
    </ThemeProvider>
  );
}

function App() {
  return (
    <AppProviders>
      <Router />
    </AppProviders>
  );
}
```

---

## useReducer による状態管理

### 基本的な useReducer

```typescript
// ✅ 複雑な状態はuseReducerで管理
interface State {
  count: number;
  user: User | null;
  isLoading: boolean;
}

type Action =
  | { type: 'INCREMENT' }
  | { type: 'DECREMENT' }
  | { type: 'SET_USER'; payload: User }
  | { type: 'SET_LOADING'; payload: boolean }
  | { type: 'RESET' };

function reducer(state: State, action: Action): State {
  switch (action.type) {
    case 'INCREMENT':
      return { ...state, count: state.count + 1 };
    case 'DECREMENT':
      return { ...state, count: state.count - 1 };
    case 'SET_USER':
      return { ...state, user: action.payload };
    case 'SET_LOADING':
      return { ...state, isLoading: action.payload };
    case 'RESET':
      return { count: 0, user: null, isLoading: false };
    default:
      return state;
  }
}

function MyComponent() {
  const [state, dispatch] = useReducer(reducer, {
    count: 0,
    user: null,
    isLoading: false,
  });

  return (
    <div>
      <p>Count: {state.count}</p>
      <button onClick={() => dispatch({ type: 'INCREMENT' })}>+</button>
      <button onClick={() => dispatch({ type: 'DECREMENT' })}>-</button>
      <button onClick={() => dispatch({ type: 'RESET' })}>Reset</button>
    </div>
  );
}
```

### useReducer と Context の組み合わせ

```typescript
// ✅ グローバルな状態管理
interface TodoState {
  todos: Todo[];
  filter: 'all' | 'active' | 'completed';
}

type TodoAction =
  | { type: 'ADD_TODO'; payload: string }
  | { type: 'TOGGLE_TODO'; payload: string }
  | { type: 'DELETE_TODO'; payload: string }
  | { type: 'SET_FILTER'; payload: 'all' | 'active' | 'completed' };

function todoReducer(state: TodoState, action: TodoAction): TodoState {
  switch (action.type) {
    case 'ADD_TODO':
      return {
        ...state,
        todos: [
          ...state.todos,
          { id: Date.now().toString(), title: action.payload, completed: false },
        ],
      };
    case 'TOGGLE_TODO':
      return {
        ...state,
        todos: state.todos.map((todo) =>
          todo.id === action.payload
            ? { ...todo, completed: !todo.completed }
            : todo
        ),
      };
    case 'DELETE_TODO':
      return {
        ...state,
        todos: state.todos.filter((todo) => todo.id !== action.payload),
      };
    case 'SET_FILTER':
      return { ...state, filter: action.payload };
    default:
      return state;
  }
}

const TodoContext = createContext<
  | {
      state: TodoState;
      dispatch: React.Dispatch<TodoAction>;
    }
  | undefined
>(undefined);

export function TodoProvider({ children }: { children: React.ReactNode }) {
  const [state, dispatch] = useReducer(todoReducer, {
    todos: [],
    filter: 'all',
  });

  const value = useMemo(() => ({ state, dispatch }), [state]);

  return <TodoContext.Provider value={value}>{children}</TodoContext.Provider>;
}

export function useTodos() {
  const context = useContext(TodoContext);
  if (!context) {
    throw new Error('useTodos must be used within TodoProvider');
  }
  return context;
}

// 使用例
function TodoList() {
  const { state, dispatch } = useTodos();

  const filteredTodos = state.todos.filter((todo) => {
    if (state.filter === 'active') return !todo.completed;
    if (state.filter === 'completed') return todo.completed;
    return true;
  });

  return (
    <div>
      <ul>
        {filteredTodos.map((todo) => (
          <li key={todo.id}>
            <input
              type="checkbox"
              checked={todo.completed}
              onChange={() =>
                dispatch({ type: 'TOGGLE_TODO', payload: todo.id })
              }
            />
            {todo.title}
            <button
              onClick={() => dispatch({ type: 'DELETE_TODO', payload: todo.id })}
            >
              Delete
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
}
```

---

## パフォーマンス最適化

### React.memo

```typescript
// ✅ React.memo で不要な再レンダリングを防ぐ
interface ExpensiveComponentProps {
  data: string;
  count: number;
}

export const ExpensiveComponent = React.memo(function ExpensiveComponent({
  data,
  count,
}: ExpensiveComponentProps) {
  console.log('ExpensiveComponent rendered');

  return (
    <div>
      <p>Data: {data}</p>
      <p>Count: {count}</p>
    </div>
  );
});

// ✅ カスタム比較関数
export const ExpensiveComponentWithCustomCompare = React.memo(
  function ExpensiveComponent({ data, count }: ExpensiveComponentProps) {
    return (
      <div>
        <p>Data: {data}</p>
        <p>Count: {count}</p>
      </div>
    );
  },
  (prevProps, nextProps) => {
    // true を返すと再レンダリングをスキップ
    return prevProps.data === nextProps.data;
  }
);
```

### useCallback と useMemo の適切な使用

```typescript
function ParentComponent() {
  const [count, setCount] = useState(0);
  const [text, setText] = useState('');

  // ✅ useCallback でコールバック関数をメモ化
  const handleClick = useCallback(() => {
    console.log('Button clicked');
  }, []); // 依存配列が空なので関数は再生成されない

  // ✅ useMemo で高コストな計算をメモ化
  const expensiveValue = useMemo(() => {
    console.log('Expensive calculation');
    return count * 1000;
  }, [count]); // count が変わったときだけ再計算

  return (
    <div>
      <p>Count: {count}</p>
      <p>Expensive Value: {expensiveValue}</p>
      <input value={text} onChange={(e) => setText(e.target.value)} />
      <ExpensiveComponent data={text} onClick={handleClick} />
    </div>
  );
}

interface ExpensiveComponentProps {
  data: string;
  onClick: () => void;
}

const ExpensiveComponent = React.memo(function ExpensiveComponent({
  data,
  onClick,
}: ExpensiveComponentProps) {
  console.log('ExpensiveComponent rendered');

  return (
    <div>
      <p>{data}</p>
      <button onClick={onClick}>Click me</button>
    </div>
  );
});
```

### レンダリング最適化のアンチパターン

```typescript
// ❌ 悪い例: 過度なメモ化
function BadExample() {
  const [count, setCount] = useState(0);

  // ❌ 不要なuseCallback（依存配列にcountがあり毎回再生成される）
  const handleClick = useCallback(() => {
    setCount(count + 1);
  }, [count]);

  // ❌ 不要なuseMemo（計算コストが低い）
  const doubled = useMemo(() => count * 2, [count]);

  return <button onClick={handleClick}>{doubled}</button>;
}

// ✅ 良い例: シンプルに保つ
function GoodExample() {
  const [count, setCount] = useState(0);

  // ✅ 関数形式のsetStateで依存配列を不要に
  const handleClick = useCallback(() => {
    setCount((prev) => prev + 1);
  }, []);

  // ✅ 単純な計算はそのまま
  const doubled = count * 2;

  return <button onClick={handleClick}>{doubled}</button>;
}
```

---

## エラーバウンダリ

### エラーバウンダリコンポーネント

```typescript
// ✅ エラーバウンダリはクラスコンポーネントで実装
interface ErrorBoundaryProps {
  children: React.ReactNode;
  fallback?: React.ReactNode;
}

interface ErrorBoundaryState {
  hasError: boolean;
  error: Error | null;
}

export class ErrorBoundary extends React.Component<
  ErrorBoundaryProps,
  ErrorBoundaryState
> {
  constructor(props: ErrorBoundaryProps) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error: Error): ErrorBoundaryState {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    console.error('Error caught by ErrorBoundary:', error, errorInfo);
    // エラーログをサーバーに送信するなどの処理
  }

  render() {
    if (this.state.hasError) {
      if (this.props.fallback) {
        return this.props.fallback;
      }

      return (
        <div>
          <h1>Something went wrong</h1>
          <p>{this.state.error?.message}</p>
          <button onClick={() => this.setState({ hasError: false, error: null })}>
            Try again
          </button>
        </div>
      );
    }

    return this.props.children;
  }
}

// 使用例
function App() {
  return (
    <ErrorBoundary fallback={<div>Error occurred!</div>}>
      <MyComponent />
    </ErrorBoundary>
  );
}
```

### 関数コンポーネントでのエラーハンドリング

```typescript
// ✅ try-catch でエラーをキャッチ
function MyComponent() {
  const [error, setError] = useState<Error | null>(null);
  const [data, setData] = useState<Data | null>(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const result = await api.fetchData();
        setData(result);
      } catch (err) {
        setError(err instanceof Error ? err : new Error('Unknown error'));
      }
    };

    fetchData();
  }, []);

  if (error) {
    return <div>Error: {error.message}</div>;
  }

  if (!data) {
    return <div>Loading...</div>;
  }

  return <div>{data.title}</div>;
}
```

---

## フォームハンドリング

### 制御されたコンポーネント

```typescript
interface FormData {
  username: string;
  email: string;
  password: string;
}

function LoginForm() {
  const [formData, setFormData] = useState<FormData>({
    username: '',
    email: '',
    password: '',
  });
  const [errors, setErrors] = useState<Partial<FormData>>({});

  // ✅ 汎用的なchangeハンドラ
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
  };

  const validate = (): boolean => {
    const newErrors: Partial<FormData> = {};

    if (!formData.username) {
      newErrors.username = 'Username is required';
    }

    if (!formData.email) {
      newErrors.email = 'Email is required';
    } else if (!/\S+@\S+\.\S+/.test(formData.email)) {
      newErrors.email = 'Email is invalid';
    }

    if (!formData.password) {
      newErrors.password = 'Password is required';
    } else if (formData.password.length < 8) {
      newErrors.password = 'Password must be at least 8 characters';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    if (!validate()) {
      return;
    }

    // フォーム送信処理
    console.log('Form submitted:', formData);
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label htmlFor="username">Username</label>
        <input
          type="text"
          id="username"
          name="username"
          value={formData.username}
          onChange={handleChange}
        />
        {errors.username && <span className="error">{errors.username}</span>}
      </div>

      <div>
        <label htmlFor="email">Email</label>
        <input
          type="email"
          id="email"
          name="email"
          value={formData.email}
          onChange={handleChange}
        />
        {errors.email && <span className="error">{errors.email}</span>}
      </div>

      <div>
        <label htmlFor="password">Password</label>
        <input
          type="password"
          id="password"
          name="password"
          value={formData.password}
          onChange={handleChange}
        />
        {errors.password && <span className="error">{errors.password}</span>}
      </div>

      <button type="submit">Submit</button>
    </form>
  );
}
```

### カスタムフックでのフォーム管理

```typescript
// ✅ 汎用的なフォームフック
function useForm<T>(initialValues: T) {
  const [values, setValues] = useState<T>(initialValues);
  const [errors, setErrors] = useState<Partial<Record<keyof T, string>>>({});

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setValues((prev) => ({ ...prev, [name]: value }));
  };

  const resetForm = () => {
    setValues(initialValues);
    setErrors({});
  };

  return {
    values,
    errors,
    handleChange,
    setErrors,
    resetForm,
  };
}

// 使用例
function MyForm() {
  const { values, errors, handleChange, setErrors, resetForm } = useForm({
    username: '',
    email: '',
  });

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    // バリデーション
    const newErrors: Partial<Record<string, string>> = {};
    if (!values.username) {
      newErrors.username = 'Username is required';
    }
    if (!values.email) {
      newErrors.email = 'Email is required';
    }

    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }

    // 送信処理
    console.log('Submitted:', values);
    resetForm();
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        name="username"
        value={values.username}
        onChange={handleChange}
      />
      {errors.username && <span>{errors.username}</span>}

      <input
        name="email"
        value={values.email}
        onChange={handleChange}
      />
      {errors.email && <span>{errors.email}</span>}

      <button type="submit">Submit</button>
    </form>
  );
}
```

---

## テストパターン

### React Testing Library

```typescript
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { UserCard } from './UserCard';

describe('UserCard', () => {
  const mockUser = {
    id: '1',
    name: 'John Doe',
    email: 'john@example.com',
  };

  // ✅ 基本的なレンダリングテスト
  it('should render user information', () => {
    render(<UserCard user={mockUser} />);

    expect(screen.getByText('John Doe')).toBeInTheDocument();
    expect(screen.getByText('john@example.com')).toBeInTheDocument();
  });

  // ✅ イベントハンドラのテスト
  it('should call onEdit when edit button is clicked', () => {
    const handleEdit = jest.fn();
    render(<UserCard user={mockUser} onEdit={handleEdit} />);

    const editButton = screen.getByRole('button', { name: /edit/i });
    fireEvent.click(editButton);

    expect(handleEdit).toHaveBeenCalledWith(mockUser);
    expect(handleEdit).toHaveBeenCalledTimes(1);
  });

  // ✅ 非同期処理のテスト
  it('should load user data', async () => {
    render(<UserProfile userId="1" />);

    // 初期状態（ローディング）
    expect(screen.getByText(/loading/i)).toBeInTheDocument();

    // データ取得後
    await waitFor(() => {
      expect(screen.getByText('John Doe')).toBeInTheDocument();
    });
  });

  // ✅ エラー状態のテスト
  it('should display error message when fetch fails', async () => {
    // APIモック
    jest.spyOn(global, 'fetch').mockRejectedValueOnce(new Error('Fetch failed'));

    render(<UserProfile userId="1" />);

    await waitFor(() => {
      expect(screen.getByText(/error/i)).toBeInTheDocument();
    });
  });
});
```

### カスタムフックのテスト

```typescript
import { renderHook, act } from '@testing-library/react';
import { useTodoManager } from './useTodoManager';

describe('useTodoManager', () => {
  it('should add a new todo', () => {
    const { result } = renderHook(() => useTodoManager());

    act(() => {
      result.current.addTodo('New task');
    });

    expect(result.current.todos).toHaveLength(1);
    expect(result.current.todos[0].title).toBe('New task');
    expect(result.current.todos[0].completed).toBe(false);
  });

  it('should toggle todo completion', () => {
    const { result } = renderHook(() => useTodoManager());

    act(() => {
      result.current.addTodo('Task 1');
    });

    const todoId = result.current.todos[0].id;

    act(() => {
      result.current.toggleTodo(todoId);
    });

    expect(result.current.todos[0].completed).toBe(true);
  });

  it('should remove a todo', () => {
    const { result } = renderHook(() => useTodoManager());

    act(() => {
      result.current.addTodo('Task 1');
      result.current.addTodo('Task 2');
    });

    const todoId = result.current.todos[0].id;

    act(() => {
      result.current.removeTodo(todoId);
    });

    expect(result.current.todos).toHaveLength(1);
    expect(result.current.todos[0].title).toBe('Task 2');
  });
});
```

### Context のテスト

```typescript
import { render, screen, fireEvent } from '@testing-library/react';
import { ThemeProvider, useTheme } from './ThemeContext';

function TestComponent() {
  const { theme, toggleTheme } = useTheme();

  return (
    <div>
      <span>Current theme: {theme}</span>
      <button onClick={toggleTheme}>Toggle</button>
    </div>
  );
}

describe('ThemeContext', () => {
  it('should provide theme context', () => {
    render(
      <ThemeProvider>
        <TestComponent />
      </ThemeProvider>
    );

    expect(screen.getByText(/current theme: light/i)).toBeInTheDocument();
  });

  it('should toggle theme', () => {
    render(
      <ThemeProvider>
        <TestComponent />
      </ThemeProvider>
    );

    const toggleButton = screen.getByRole('button', { name: /toggle/i });

    fireEvent.click(toggleButton);
    expect(screen.getByText(/current theme: dark/i)).toBeInTheDocument();

    fireEvent.click(toggleButton);
    expect(screen.getByText(/current theme: light/i)).toBeInTheDocument();
  });

  it('should throw error when used outside provider', () => {
    // エラーログを抑制
    const spy = jest.spyOn(console, 'error').mockImplementation(() => {});

    expect(() => {
      render(<TestComponent />);
    }).toThrow('useTheme must be used within ThemeProvider');

    spy.mockRestore();
  });
});
```

---

## まとめ

このパターン集では、React実装における主要なパターンとベストプラクティスを網羅しました。

**重要なポイント**:
- 関数コンポーネントを使用し、Hooksでロジックを管理
- Props の型を明確に定義
- カスタムフックで共通ロジックを抽出
- Context API で適切にグローバル状態を管理
- useReducer で複雑な状態を管理
- React.memo、useCallback、useMemo で適切にパフォーマンス最適化
- エラーバウンダリで予期しないエラーをキャッチ
- 制御されたコンポーネントでフォームを管理
- React Testing Library でユーザー視点のテストを書く

詳細は [SKILL.md](SKILL.md) も参照してください。
