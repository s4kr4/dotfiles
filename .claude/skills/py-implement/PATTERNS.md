# Python Patterns & Code Examples

Python実装のための詳細なパターン集とコード例です。

## 📖 Table of Contents

- [関数定義](#関数定義)
- [型ヒント](#型ヒント)
- [クラスとOOP](#クラスとoop)
- [エラーハンドリング](#エラーハンドリング)
- [モダンPython機能](#モダンpython機能)
- [非同期処理](#非同期処理)
- [データクラス](#データクラス)

---

## 関数定義

### 基本的な関数

```python
# ✅ 良い例: 型ヒント付き、Docstring記述
def calculate_total(price: float, tax_rate: float) -> float:
    """合計金額を計算する

    Args:
        price: 商品価格
        tax_rate: 税率（0.1 = 10%）

    Returns:
        税込み価格
    """
    return price * (1 + tax_rate)

# ✅ 良い例: オプショナル引数
def greet(name: str, greeting: str = "Hello") -> str:
    """挨拶メッセージを生成する

    Args:
        name: 名前
        greeting: 挨拶の言葉（デフォルト: "Hello"）

    Returns:
        挨拶メッセージ
    """
    return f"{greeting}, {name}!"

# ❌ 悪い例: 型ヒントなし、Docstringなし
def calculate_total(price, tax_rate):
    return price * (1 + tax_rate)
```

### 複数の戻り値

```python
from typing import Tuple

# ✅ 良い例: Tupleで複数の値を返す
def get_user_info(user_id: str) -> Tuple[str, int, str]:
    """ユーザー情報を取得する

    Args:
        user_id: ユーザーID

    Returns:
        名前、年齢、メールアドレスのタプル
    """
    # 実装
    return ("Alice", 30, "alice@example.com")

# 使用例
name, age, email = get_user_info("123")

# ✅ より良い例: NamedTupleを使用
from typing import NamedTuple

class UserInfo(NamedTuple):
    name: str
    age: int
    email: str

def get_user_info(user_id: str) -> UserInfo:
    """ユーザー情報を取得する

    Args:
        user_id: ユーザーID

    Returns:
        ユーザー情報
    """
    return UserInfo(name="Alice", age=30, email="alice@example.com")

# 使用例
user = get_user_info("123")
print(user.name)  # 名前でアクセス可能
```

---

## 型ヒント

### 基本的な型

```python
from typing import List, Dict, Set, Tuple, Optional, Union, Any

# 基本型
name: str = "Alice"
age: int = 30
height: float = 165.5
is_active: bool = True

# コレクション型
names: List[str] = ["Alice", "Bob", "Charlie"]
user_ages: Dict[str, int] = {"Alice": 30, "Bob": 25}
unique_ids: Set[int] = {1, 2, 3}
coordinates: Tuple[float, float] = (35.6895, 139.6917)

# Optional（None許容）
def find_user(user_id: str) -> Optional[Dict[str, Any]]:
    """ユーザーを検索する

    Args:
        user_id: ユーザーID

    Returns:
        ユーザー情報。見つからない場合はNone
    """
    # 実装
    return None

# Union（複数の型）
def process_value(value: Union[str, int, float]) -> str:
    """値を文字列に変換する

    Args:
        value: 文字列、整数、または浮動小数点数

    Returns:
        文字列表現
    """
    return str(value)
```

### ジェネリック型

```python
from typing import TypeVar, Generic, List

T = TypeVar('T')

class Stack(Generic[T]):
    """ジェネリックなスタッククラス"""

    def __init__(self) -> None:
        self._items: List[T] = []

    def push(self, item: T) -> None:
        """要素をプッシュする"""
        self._items.append(item)

    def pop(self) -> T:
        """要素をポップする"""
        return self._items.pop()

    def is_empty(self) -> bool:
        """スタックが空かチェックする"""
        return len(self._items) == 0

# 使用例
int_stack: Stack[int] = Stack()
int_stack.push(1)
int_stack.push(2)

str_stack: Stack[str] = Stack()
str_stack.push("hello")
```

### Callable型

```python
from typing import Callable

def apply_operation(
    value: int,
    operation: Callable[[int], int]
) -> int:
    """値に操作を適用する

    Args:
        value: 元の値
        operation: 整数を受け取り整数を返す関数

    Returns:
        操作後の値
    """
    return operation(value)

# 使用例
result = apply_operation(5, lambda x: x * 2)  # 10
```

---

## クラスとOOP

### 基本的なクラス

```python
class User:
    """ユーザークラス"""

    def __init__(self, name: str, age: int, email: str) -> None:
        """初期化

        Args:
            name: 名前
            age: 年齢
            email: メールアドレス
        """
        self.name = name
        self.age = age
        self.email = email

    def greet(self) -> str:
        """挨拶メッセージを返す

        Returns:
            挨拶メッセージ
        """
        return f"Hello, I'm {self.name}!"

    def __str__(self) -> str:
        """文字列表現"""
        return f"User(name={self.name}, age={self.age})"

    def __repr__(self) -> str:
        """開発者向け文字列表現"""
        return f"User(name={self.name!r}, age={self.age}, email={self.email!r})"
```

### プロパティとプライベートメンバー

```python
class BankAccount:
    """銀行口座クラス"""

    def __init__(self, account_number: str, initial_balance: float = 0.0) -> None:
        """初期化

        Args:
            account_number: 口座番号
            initial_balance: 初期残高（デフォルト: 0.0）
        """
        self.account_number = account_number
        self._balance = initial_balance  # プライベート変数

    @property
    def balance(self) -> float:
        """残高を取得する（読み取り専用）

        Returns:
            現在の残高
        """
        return self._balance

    def deposit(self, amount: float) -> None:
        """入金する

        Args:
            amount: 入金額

        Raises:
            ValueError: 入金額が負の場合
        """
        if amount < 0:
            raise ValueError("入金額は正の数である必要があります")
        self._balance += amount

    def withdraw(self, amount: float) -> None:
        """出金する

        Args:
            amount: 出金額

        Raises:
            ValueError: 出金額が負の場合または残高不足の場合
        """
        if amount < 0:
            raise ValueError("出金額は正の数である必要があります")
        if amount > self._balance:
            raise ValueError("残高不足です")
        self._balance -= amount
```

### 抽象クラス

```python
from abc import ABC, abstractmethod
from typing import List

class Repository(ABC):
    """リポジトリの抽象基底クラス"""

    @abstractmethod
    def find_by_id(self, id: str) -> Optional[Dict]:
        """IDでエンティティを検索する

        Args:
            id: エンティティID

        Returns:
            エンティティ。見つからない場合はNone
        """
        pass

    @abstractmethod
    def save(self, entity: Dict) -> None:
        """エンティティを保存する

        Args:
            entity: 保存するエンティティ
        """
        pass

    def find_all(self) -> List[Dict]:
        """すべてのエンティティを取得する（デフォルト実装）

        Returns:
            エンティティのリスト
        """
        # デフォルト実装
        return []

class UserRepository(Repository):
    """ユーザーリポジトリ"""

    def find_by_id(self, id: str) -> Optional[Dict]:
        # 実装
        return {"id": id, "name": "Alice"}

    def save(self, entity: Dict) -> None:
        # 実装
        pass
```

---

## エラーハンドリング

### カスタム例外クラス

```python
class AppError(Exception):
    """アプリケーションエラーの基底クラス"""

    def __init__(self, message: str, code: int = 500) -> None:
        """初期化

        Args:
            message: エラーメッセージ
            code: エラーコード（デフォルト: 500）
        """
        super().__init__(message)
        self.message = message
        self.code = code

class ValidationError(AppError):
    """検証エラー"""

    def __init__(self, message: str, field: str) -> None:
        """初期化

        Args:
            message: エラーメッセージ
            field: エラーが発生したフィールド
        """
        super().__init__(message, code=400)
        self.field = field

class NotFoundError(AppError):
    """リソースが見つからないエラー"""

    def __init__(self, resource: str, id: str) -> None:
        """初期化

        Args:
            resource: リソース名
            id: リソースID
        """
        message = f"{resource} with id {id} not found"
        super().__init__(message, code=404)
```

### 例外処理のパターン

```python
# ✅ 良い例: 具体的な例外をキャッチ
def read_config(file_path: str) -> Dict:
    """設定ファイルを読み込む

    Args:
        file_path: ファイルパス

    Returns:
        設定の辞書

    Raises:
        FileNotFoundError: ファイルが見つからない場合
        json.JSONDecodeError: JSONパースエラーの場合
    """
    import json

    try:
        with open(file_path, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"設定ファイルが見つかりません: {file_path}")
        raise
    except json.JSONDecodeError as e:
        print(f"JSONパースエラー: {e}")
        raise

# ✅ 良い例: else節とfinally節の使用
def process_file(file_path: str) -> None:
    """ファイルを処理する

    Args:
        file_path: ファイルパス
    """
    f = None
    try:
        f = open(file_path, 'r')
        content = f.read()
    except FileNotFoundError:
        print("ファイルが見つかりません")
    except IOError as e:
        print(f"IOエラー: {e}")
    else:
        # 例外が発生しなかった場合のみ実行
        print("ファイル処理成功")
    finally:
        # 必ず実行される
        if f:
            f.close()

# ✅ より良い例: コンテキストマネージャを使用
def process_file_better(file_path: str) -> None:
    """ファイルを処理する（改良版）

    Args:
        file_path: ファイルパス
    """
    try:
        with open(file_path, 'r') as f:
            content = f.read()
        print("ファイル処理成功")
    except FileNotFoundError:
        print("ファイルが見つかりません")
    except IOError as e:
        print(f"IOエラー: {e}")
```

---

## モダンPython機能

### f-strings（フォーマット済み文字列リテラル）

```python
# ✅ f-strings（推奨）
name = "Alice"
age = 30
message = f"Hello, {name}! You are {age} years old."

# 式の埋め込み
result = f"The sum is {2 + 2}"

# フォーマット指定
price = 1234.5678
formatted = f"Price: ${price:.2f}"  # "Price: $1234.57"

# デバッグ用（Python 3.8+）
x = 10
print(f"{x=}")  # "x=10"
```

### リスト内包表記

```python
# ✅ リスト内包表記
squares = [x**2 for x in range(10)]

# 条件付き
even_squares = [x**2 for x in range(10) if x % 2 == 0]

# ネストされたループ
matrix = [(i, j) for i in range(3) for j in range(3)]

# ✅ 辞書内包表記
user_ages = {user['name']: user['age'] for user in users}

# ✅ セット内包表記
unique_lengths = {len(word) for word in words}
```

### Walrus演算子（:=）（Python 3.8+）

```python
# ✅ Walrus演算子: 代入と評価を同時に
if (n := len(items)) > 10:
    print(f"Large list: {n} items")

# リスト内包表記で使用
results = [y for x in data if (y := process(x)) is not None]

# while ループで使用
while (line := file.readline()):
    process(line)
```

### データクラス（Python 3.7+）

```python
from dataclasses import dataclass, field
from typing import List

@dataclass
class User:
    """ユーザーデータクラス"""
    name: str
    age: int
    email: str
    tags: List[str] = field(default_factory=list)

    def greet(self) -> str:
        """挨拶メッセージを返す"""
        return f"Hello, I'm {self.name}!"

# 使用例
user = User(name="Alice", age=30, email="alice@example.com")
print(user)  # User(name='Alice', age=30, email='alice@example.com', tags=[])

@dataclass(frozen=True)
class Point:
    """不変な座標クラス"""
    x: float
    y: float
```

---

## 非同期処理

### async/await

```python
import asyncio
from typing import List

async def fetch_data(url: str) -> str:
    """データを非同期で取得する

    Args:
        url: URL

    Returns:
        取得したデータ
    """
    await asyncio.sleep(1)  # 模擬的な非同期処理
    return f"Data from {url}"

async def fetch_all(urls: List[str]) -> List[str]:
    """複数のURLからデータを並列取得する

    Args:
        urls: URLのリスト

    Returns:
        取得したデータのリスト
    """
    tasks = [fetch_data(url) for url in urls]
    return await asyncio.gather(*tasks)

# 実行
async def main():
    urls = ["https://api1.example.com", "https://api2.example.com"]
    results = await fetch_all(urls)
    print(results)

# asyncio.run(main())
```

---

## まとめ

これらのパターンを活用して、PEP 8準拠で保守性の高いPythonコードを書いてください。

**重要な原則**:
- 型ヒントを使用
- Docstringsで文書化
- PEP 8に準拠
- 適切な例外処理
- モダンなPython機能の活用
- コードの重複を避ける

**参考リンク**:
- [PEP 8 - Style Guide](https://peps.python.org/pep-0008/)
- [Python Type Hints](https://docs.python.org/3/library/typing.html)
- [Real Python Tutorials](https://realpython.com/)
