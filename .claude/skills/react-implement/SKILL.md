---
name: react-implement
description: React実装のベストプラクティスとコーディング規約。コンポーネント設計、Hooks、状態管理、パフォーマンス最適化のガイドライン。React実装、コンポーネントパターン、Hooksベストプラクティスが必要な時に参照。
---

# React Implementation Best Practices

React実装のベストプラクティス、コーディング規約、パターン集です。保守性が高く、パフォーマンスに優れたReactアプリケーションを構築するための知識ベースとして活用してください。

## 🎯 Core Principles（コア原則）

### 1. **Component Design**（コンポーネント設計）
- 関数コンポーネントを使用（クラスコンポーネントは非推奨）
- 単一責任の原則に従う（1つのコンポーネントは1つの役割）
- Props の型を明確に定義（TypeScript interface）
- コンポーネントは小さく、再利用可能に保つ
- プレゼンテーション層とロジック層を分離

### 2. **Hooks Best Practices**（Hooksのベストプラクティス）
- Hooks は関数コンポーネントのトップレベルでのみ呼び出す
- カスタムフックで共通ロジックを抽出
- `useEffect` の依存配列を適切に管理
- `useCallback` と `useMemo` で不要な再レンダリングを防ぐ
- 複雑な状態管理には `useReducer` を使用

### 3. **State Management**（状態管理）
- ローカル状態は `useState` で管理
- 複雑なロジックは `useReducer` で管理
- グローバル状態は Context API またはZustand/Reduxなどのライブラリ
- 状態のリフトアップは必要最小限に
- Prop drilling を避けるために Context を活用

### 4. **Performance**（パフォーマンス）
- `React.memo` で不要な再レンダリングを防ぐ
- `useCallback` でコールバック関数をメモ化
- `useMemo` で高コストな計算をメモ化
- レンダリング最適化は計測してから実施
- Virtual scrolling で大量データを効率的に表示

## 📚 React Patterns（詳細パターン集）

詳細なコード例とパターンについては、[PATTERNS.md](PATTERNS.md)を参照してください。

### Quick Reference

#### 関数コンポーネントとProps型定義
```typescript
// ✅ Props型を明確に定義
interface UserCardProps {
  user: User;
  onEdit?: (user: User) => void;
  isLoading?: boolean;
}

// ✅ 関数コンポーネント（名前付きエクスポート推奨）
export function UserCard({ user, onEdit, isLoading = false }: UserCardProps) {
  const handleEdit = () => {
    if (onEdit) {
      onEdit(user);
    }
  };

  if (isLoading) {
    return <div>Loading...</div>;
  }

  return (
    <div>
      <h2>{user.name}</h2>
      <button onClick={handleEdit}>Edit</button>
    </div>
  );
}
```

#### カスタムフック
```typescript
// ✅ カスタムフックで共通ロジックを抽出
function useFetch<T>(url: string) {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        const response = await fetch(url);
        if (!response.ok) throw new Error('Fetch failed');
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
```

#### useReducer でのステート管理
```typescript
// ✅ 複雑な状態はuseReducerで管理
interface State {
  count: number;
  user: User | null;
  isLoading: boolean;
}

type Action =
  | { type: 'INCREMENT' }
  | { type: 'SET_USER'; payload: User }
  | { type: 'SET_LOADING'; payload: boolean };

function reducer(state: State, action: Action): State {
  switch (action.type) {
    case 'INCREMENT':
      return { ...state, count: state.count + 1 };
    case 'SET_USER':
      return { ...state, user: action.payload };
    case 'SET_LOADING':
      return { ...state, isLoading: action.payload };
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
    <button onClick={() => dispatch({ type: 'INCREMENT' })}>
      Count: {state.count}
    </button>
  );
}
```

#### Context API でのグローバル状態管理
```typescript
// ✅ Context でグローバル状態を管理
interface ThemeContextType {
  theme: 'light' | 'dark';
  toggleTheme: () => void;
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const [theme, setTheme] = useState<'light' | 'dark'>('light');

  const toggleTheme = () => {
    setTheme((prev) => (prev === 'light' ? 'dark' : 'light'));
  };

  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

// カスタムフックでContextを利用
export function useTheme() {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useTheme must be used within ThemeProvider');
  }
  return context;
}
```

#### パフォーマンス最適化
```typescript
// ✅ React.memo で不要な再レンダリングを防ぐ
export const ExpensiveComponent = React.memo(function ExpensiveComponent({
  data,
}: {
  data: string;
}) {
  return <div>{data}</div>;
});

// ✅ useCallback でコールバック関数をメモ化
function ParentComponent() {
  const [count, setCount] = useState(0);

  const handleClick = useCallback(() => {
    console.log('Button clicked');
  }, []); // 依存配列が空なので関数は再生成されない

  return <ChildComponent onClick={handleClick} />;
}

// ✅ useMemo で高コストな計算をメモ化
function DataDisplay({ items }: { items: Item[] }) {
  const sortedItems = useMemo(() => {
    return items.sort((a, b) => a.name.localeCompare(b.name));
  }, [items]);

  return (
    <ul>
      {sortedItems.map((item) => (
        <li key={item.id}>{item.name}</li>
      ))}
    </ul>
  );
}
```

## ✅ Quality Standards（品質基準）

実装したReactコードは以下の基準を満たす必要があります：

- ✅ 関数コンポーネントを使用（クラスコンポーネント不使用）
- ✅ Props の型が明確に定義されている（TypeScript interface）
- ✅ Hooks の使用ルールに従っている（トップレベル、条件分岐内で使わない）
- ✅ `useEffect` の依存配列が適切
- ✅ カスタムフックで共通ロジックを抽出
- ✅ コンポーネント名が明確で説明的（PascalCase）
- ✅ 単一責任の原則に従う
- ✅ 適切なエラーハンドリング（エラーバウンダリ）
- ✅ アクセシビリティを考慮（a11y）
- ✅ パフォーマンス最適化が適切に実施されている

## 🔍 Code Review Checklist（コードレビューチェックリスト）

React コード実装後、以下を確認してください：

- [ ] 関数コンポーネントを使用している
- [ ] すべての Props に型定義がある
- [ ] Hooks のルールに従っている（順序、トップレベル）
- [ ] `useEffect` の依存配列が適切
- [ ] 不要な再レンダリングが発生していない
- [ ] `key` プロパティが適切に設定されている（リスト表示）
- [ ] イベントハンドラが適切にバインドされている
- [ ] State の初期値が適切
- [ ] Context が適切に使用されている（過度な Prop drilling を回避）
- [ ] エラーバウンダリが必要な箇所に実装されている
- [ ] アクセシビリティ（ARIA属性、セマンティックHTML）が考慮されている
- [ ] 未使用の state や props がない

## 🎓 Learning Resources

- 詳細なパターン集: [PATTERNS.md](PATTERNS.md)
- React公式ドキュメント: https://react.dev/
- React TypeScript Cheatsheet: https://react-typescript-cheatsheet.netlify.app/
- React Hooks ドキュメント: https://react.dev/reference/react

---

**このスキルの使い方**: React実装時にこのスキルを参照して、ベストプラクティスと品質基準に従ったコンポーネントを書いてください。TypeScript基本については `/ts-implement` スキルを併用してください。
