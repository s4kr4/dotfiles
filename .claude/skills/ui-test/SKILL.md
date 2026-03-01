---
name: ui-test
description: UIテスト作成のベストプラクティスとガイドライン。テストケースの命名規約、Hooksテスト、コンポーネントテスト、インタラクションテストの設計指針を提供。UIに関するテストを作成・レビューする時に参照。
---

# UIテストガイドライン

UIに関するテスト（カスタムフック、コンポーネント、ユーザーインタラクション）を作成する際の観点・注意点をまとめたガイドラインです。

## 1. テストケースの命名規約

### 原則: 「UI上どう動作するか」で記述する

テストケース名は**ユーザーから見た振る舞い**で書く。内部実装の詳細（ハンドラ名、状態変数名、コールバック名）を含めない。

```typescript
// ❌ 実装詳細を露出している
test('handleSubmit が呼ばれる', () => {});
test('isOpen が true になる', () => {});
test('selectedItem が更新される', () => {});
test('onClose コールバックが実行される', () => {});

// ✅ ユーザーから見た振る舞いで記述
test('送信ボタンを押すと、フォームが送信される', () => {});
test('トリガーをクリックすると、ドロップダウンが開く', () => {});
test('リスト項目をクリックすると、選択した項目がハイライトされる', () => {});
test('オーバーレイをクリックすると、モーダルが閉じる', () => {});
```

### 命名テンプレート

基本形は **「〜すると、〜になる」** または **「〜の場合、〜になる」**。

| パターン     | テンプレート                         | 例                                                               |
| ------------ | ------------------------------------ | ---------------------------------------------------------------- |
| ユーザー操作 | `〜すると、〜になる`                 | `入力欄にテキストを入力すると、候補リストが表示される`           |
| 条件付き動作 | `〜の状態で〜すると、〜になる`       | `モーダルが開いた状態で Escape キーを押すと、モーダルが閉じる`   |
| 初期状態     | `初期状態では、〜になっている`       | `初期状態では、ドロップダウンは閉じている`                       |
| 境界値       | `〜を超えて〜すると、〜に制限される` | `スライダーの右端を超えてドラッグすると、値が最大値に固定される` |
| 無操作       | `〜しても、〜は変化しない`           | `無効状態のボタンをクリックしても、フォームは送信されない`       |

### 用語の置き換え表

テスト名で使いがちな実装用語を、UI用語に置き換える。

| 実装用語 (避ける)                    | UI用語 (使う)                                     |
| ------------------------------------ | ------------------------------------------------- |
| `handleXxx が呼ばれる`               | `〜される`（送信される、選択される、閉じる etc.） |
| `isXxx が true/false になる`         | `〜状態になる / 〜が解除される`                   |
| `selectedXxx が更新される`           | `選択した〜が反映される`                          |
| `Xxx が null になる`                 | `〜が未選択になる / 〜が非表示になる`             |
| `activeXxx が null にリセットされる` | `〜がリセットされる / 〜が閉じる`                 |
| `onXxx コールバックが実行される`     | `〜になる`（具体的なUI変化で記述）                |

### describe ブロックの構造

```typescript
describe('useDropdown()', () => {
  // フック名
  describe('初期状態', () => {}); // 初期状態は独立セクション
  describe('handleToggle', () => {}); // ハンドラ名 or 機能名で分類
  describe('キーボード操作', () => {}); // 操作カテゴリで分類
  describe('項目選択', () => {}); // 機能カテゴリで分類
});
```

describe ブロックにはハンドラ名を使ってもよい（テストの場所を示すインデックス的な役割）。ただし、個々の `test()` の名前は必ずUI動作観点にする。

---

## 2. カスタムフックのテスト

### 基本構造

```typescript
import { describe, expect, test, vi, beforeEach } from 'vitest';
import { act } from 'react';
import { cleanup, renderHook } from '@testing-library/react';

describe('useDropdown()', () => {
  beforeEach(() => {
    cleanup();
  });

  test('トリガーをクリックすると、ドロップダウンが開く', () => {
    const { result } = renderHook(() => useDropdown());

    act(() => {
      result.current.toggle();
    });

    expect(result.current.isOpen).toBe(true);
  });
});
```

### テスト観点チェックリスト

フックのテストを書く際に、以下の観点を網羅的に検討する。

#### 初期状態

- [ ] デフォルト値が正しいか
- [ ] props に応じて初期状態が変わるか

#### ユーザー操作

- [ ] クリック / タップ
- [ ] ホバー（mouseenter / mouseleave）
- [ ] ドラッグ（mousedown → mousemove → mouseup）
- [ ] キーボード操作（Enter, Space, Escape, Tab, 矢印キー etc.）
- [ ] フォーカス / ブラー
- [ ] スクロール

#### 状態遷移

- [ ] 操作前後で状態が正しく変わるか
- [ ] トグル動作が正しいか（開→閉→開）
- [ ] 複数の状態が連動して正しく変わるか（例: メニューを閉じると選択中のサブメニューもリセットされる）

#### タイマー・非同期

- [ ] 遅延表示 / 自動非表示が正しいタイミングで動作するか
- [ ] タイマーリセット（連続操作時に前のタイマーがキャンセルされるか）
- [ ] 非同期初期化後の状態同期

#### 境界値・エッジケース

- [ ] 範囲外の入力値（クランプされるか）
- [ ] 0 / null / undefined / 空配列の扱い
- [ ] 依存オブジェクトが未初期化の場合

#### 複合操作

- [ ] ある UI が開いた状態で別の操作をしたとき（例: モーダル表示中に別のボタンを押す）
- [ ] ドラッグ中にマウスが領域外に出た場合

### セットアップパターン

#### デフォルト props ファクトリ

テストごとに必要な部分だけオーバーライドできるファクトリ関数を用意する。

```typescript
const createDefaultProps = () => ({
  items: [
    { id: '1', label: 'Option A' },
    { id: '2', label: 'Option B' },
    { id: '3', label: 'Option C' },
  ],
  onSelect: vi.fn(),
  onOpenChange: vi.fn(),
  disabled: false,
});

test('項目をクリックすると、選択した項目が反映される', () => {
  const onSelect = vi.fn();
  const { result } = renderHook(() =>
    useDropdown({ ...createDefaultProps(), onSelect }),
  );

  act(() => {
    result.current.toggle();
  });
  act(() => {
    result.current.selectItem('2');
  });

  expect(onSelect).toHaveBeenCalledWith({ id: '2', label: 'Option B' });
});
```

#### DOM ref モック

ref を使うフックをテストする場合、DOM 要素をモックする。

```typescript
const setupMockRef = (
  result: ReturnType<
    typeof renderHook<ReturnType<typeof useSlider>, unknown>
  >['result'],
  rect: Partial<DOMRect> = {},
) => {
  const mockElement = document.createElement('div');
  const defaultRect = { left: 0, width: 200, top: 0, height: 10, ...rect };
  Object.defineProperty(mockElement, 'getBoundingClientRect', {
    value: () => defaultRect,
  });
  Object.defineProperty(result.current.trackRef, 'current', {
    value: mockElement,
    writable: true,
  });
};
```

#### 外部ライブラリモック

```typescript
function createMockEditor(overrides = {}) {
  return {
    getText: vi.fn().mockReturnValue(''),
    insertText: vi.fn(),
    getSelection: vi.fn().mockReturnValue({ start: 0, end: 0 }),
    ...overrides,
  };
}
```

### タイマーのテスト

```typescript
import { vi, beforeEach, afterEach } from 'vitest';

beforeEach(() => {
  vi.useFakeTimers();
});

afterEach(() => {
  vi.useRealTimers();
});

test('ツールチップはホバーから 300ms 後に表示される', () => {
  const { result } = renderHook(() => useTooltip());

  act(() => {
    result.current.handleMouseEnter();
  });

  // 300ms 経過前はまだ非表示
  act(() => {
    vi.advanceTimersByTime(299);
  });
  expect(result.current.isVisible).toBe(false);

  // 300ms 経過後に表示
  act(() => {
    vi.advanceTimersByTime(1);
  });
  expect(result.current.isVisible).toBe(true);
});

test('ツールチップ表示前にマウスが離れると、表示されない', () => {
  const { result } = renderHook(() => useTooltip());

  act(() => {
    result.current.handleMouseEnter();
  });
  act(() => {
    vi.advanceTimersByTime(100);
  });
  act(() => {
    result.current.handleMouseLeave();
  });

  // タイマーが残り時間を経過してもツールチップは表示されない
  act(() => {
    vi.advanceTimersByTime(200);
  });
  expect(result.current.isVisible).toBe(false);
});
```

**注意**: タイマーリセットのテストでは、連続操作の間隔と合計経過時間を明確にする。

### ドラッグ操作のテスト

```typescript
test('スライダーをドラッグすると、ドラッグ位置に応じて値が変更される', () => {
  const onChange = vi.fn();
  const { result } = renderHook(() =>
    useSlider({ min: 0, max: 100, onChange }),
  );
  setupMockRef(result);

  // 1. mousedown でドラッグ開始
  act(() => {
    result.current.handleMouseDown({
      clientX: 100,
    } as React.MouseEvent<HTMLDivElement>);
  });
  expect(onChange).toHaveBeenCalledWith(50);

  // 2. mousemove でドラッグ中の値を更新（window にイベント発火）
  act(() => {
    window.dispatchEvent(new MouseEvent('mousemove', { clientX: 150 }));
  });
  expect(onChange).toHaveBeenCalledWith(75);

  // 3. mouseup でドラッグ終了
  act(() => {
    window.dispatchEvent(new MouseEvent('mouseup'));
  });
  expect(result.current.isDragging).toBe(false);
});

test('ドラッグ終了後にマウスを動かしても、値は変更されない', () => {
  const onChange = vi.fn();
  const { result } = renderHook(() =>
    useSlider({ min: 0, max: 100, onChange }),
  );
  setupMockRef(result);

  act(() => {
    result.current.handleMouseDown({
      clientX: 100,
    } as React.MouseEvent<HTMLDivElement>);
  });
  act(() => {
    window.dispatchEvent(new MouseEvent('mouseup'));
  });

  const callCount = onChange.mock.calls.length;

  act(() => {
    window.dispatchEvent(new MouseEvent('mousemove', { clientX: 150 }));
  });
  expect(onChange).toHaveBeenCalledTimes(callCount);
});
```

### 非同期初期化のテスト

```typescript
import { waitFor } from '@testing-library/react';

test('API からユーザー設定を取得すると、テーマがダークモードに設定される', async () => {
  const mockFetch = vi.fn().mockResolvedValue({ theme: 'dark' });
  const { result } = renderHook(() =>
    useUserSettings({ fetchSettings: mockFetch }),
  );

  await waitFor(() => {
    expect(result.current.theme).toBe('dark');
  });
});
```

---

## 3. コンポーネントのテスト

### 原則

- ユーザーが見る・触れるものをテストする（テキスト、ボタン、フォーム）
- `screen.getByRole`, `screen.getByText` などのクエリを優先する

### テスト観点チェックリスト

- [ ] 正しい内容がレンダリングされるか
- [ ] 条件付きレンダリング（ローディング、エラー、空状態）
- [ ] ユーザー操作でUIが正しく変化するか
- [ ] アクセシビリティ属性（role, aria-label）が正しいか
- [ ] イベントハンドラが正しい引数で呼ばれるか

### 例: モーダルコンポーネント

```typescript
describe('ConfirmDialog', () => {
  describe('初期状態', () => {
    test('isOpen が false の場合、ダイアログは表示されない', () => {
      render(<ConfirmDialog isOpen={false} onConfirm={vi.fn()} onCancel={vi.fn()} />);
      expect(screen.queryByRole('dialog')).not.toBeInTheDocument();
    });
  });

  describe('表示時の操作', () => {
    test('「確認」ボタンを押すと、ダイアログが閉じて確認アクションが実行される', () => {
      const onConfirm = vi.fn();
      render(<ConfirmDialog isOpen={true} onConfirm={onConfirm} onCancel={vi.fn()} />);

      fireEvent.click(screen.getByRole('button', { name: '確認' }));
      expect(onConfirm).toHaveBeenCalledOnce();
    });

    test('オーバーレイをクリックすると、ダイアログが閉じる', () => {
      const onCancel = vi.fn();
      render(<ConfirmDialog isOpen={true} onConfirm={vi.fn()} onCancel={onCancel} />);

      fireEvent.click(screen.getByTestId('overlay'));
      expect(onCancel).toHaveBeenCalledOnce();
    });

    test('Escape キーを押すと、ダイアログが閉じる', () => {
      const onCancel = vi.fn();
      render(<ConfirmDialog isOpen={true} onConfirm={vi.fn()} onCancel={onCancel} />);

      fireEvent.keyDown(screen.getByRole('dialog'), { key: 'Escape' });
      expect(onCancel).toHaveBeenCalledOnce();
    });
  });
});
```

---

## 4. アンチパターン

### テスト名に実装詳細を含める

```typescript
// ❌ ハンドラ名・状態変数名がテスト名に露出
test('onClose コールバックが呼ばれる', () => {});
test('isModalOpen が true になる', () => {});

// ✅ UI動作で記述
test('閉じるボタンを押すと、モーダルが閉じる', () => {});
test('トリガーをクリックすると、モーダルが開く', () => {});
```

### 1つのテストで複数の独立した振る舞いを検証

```typescript
// ❌ 1つのテストに詰め込みすぎ
test('ドロップダウンの全機能', () => {
  // 開閉のテスト
  // 選択のテスト
  // キーボード操作のテスト
  // フィルタリングのテスト
});

// ✅ 振る舞いごとに分離
test('トリガーをクリックすると、ドロップダウンが開く', () => {});
test('項目を選択すると、選択した項目がトリガーに表示される', () => {});
test('開いた状態で Escape キーを押すと、ドロップダウンが閉じる', () => {});
test('テキストを入力すると、一致する項目のみ表示される', () => {});
```

### テスト間の暗黙の依存

```typescript
// ❌ テスト間で状態を共有（実行順序に依存）
let sharedResult;
test('初期化', () => { sharedResult = renderHook(...); });
test('操作', () => { act(() => sharedResult.current.handler()); });

// ✅ 各テストは独立して完結
test('操作Aの結果', () => {
  const { result } = renderHook(() => useXxx());
  act(() => { result.current.handlerA(); });
  expect(result.current.value).toBe(expected);
});
```

### assert の不足

```typescript
// ❌ 「呼ばれた」ことだけ確認し、引数を検証しない
expect(onSelect).toHaveBeenCalled();

// ✅ 引数と呼び出し回数も含めて検証
expect(onSelect).toHaveBeenCalledWith({ id: '2', label: 'Option B' });
expect(onSelect).toHaveBeenCalledOnce();
```

---

## 5. テスト設計の進め方

### ステップ 1: テスト対象の UI 動作を洗い出す

実装コードを読む前に、UI仕様（あるいはコンポーネントの責務）から動作一覧を作成する。

```markdown
## useDropdown の動作一覧

- 初期状態ではドロップダウンが閉じている
- トリガーをクリックするとドロップダウンが開く
- 開いた状態でトリガーをクリックすると閉じる
- 項目を選択するとドロップダウンが閉じ、選択が反映される
- 開いた状態で Escape キーを押すと閉じる
- ドロップダウン外をクリックすると閉じる
- disabled の場合、トリガーをクリックしても開かない
```

### ステップ 2: describe / test 構造に変換する

動作一覧をテストファイルの骨組みに変換する。

```typescript
describe('useDropdown()', () => {
  describe('初期状態', () => {
    test('初期状態では、ドロップダウンは閉じている', () => {});
  });
  describe('handleToggle', () => {
    test('トリガーをクリックすると、ドロップダウンが開く', () => {});
    test('開いた状態でトリガーをクリックすると、ドロップダウンが閉じる', () => {});
    test('disabled の場合、トリガーをクリックしてもドロップダウンは開かない', () => {});
  });
  describe('handleSelect', () => {
    test('項目を選択すると、ドロップダウンが閉じて選択が反映される', () => {});
  });
  describe('キーボード操作', () => {
    test('開いた状態で Escape キーを押すと、ドロップダウンが閉じる', () => {});
    test('矢印キーでフォーカスが移動する', () => {});
    test('Enter キーでフォーカス中の項目が選択される', () => {});
  });
});
```

### ステップ 3: 各テストを実装する

AAA パターン（Arrange → Act → Assert）で各テストを実装する。

---

## 6. 関連スキル

| スキル             | 用途                                             |
| ------------------ | ------------------------------------------------ |
| `/tdd`             | テスト駆動開発の基本サイクルとフレームワーク設定 |
| `/react-implement` | React コンポーネント・Hooks の実装パターン       |
| `/ts-implement`    | TypeScript の型安全なコーディング規約            |

---

**このスキルの使い方**: UIテストを作成・レビューする際にこのスキルを参照してください。テストケース名の命名や、テスト観点の網羅性チェックに活用できます。
