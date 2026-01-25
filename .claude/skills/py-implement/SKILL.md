---
name: py-implement
description: Python実装のベストプラクティスとコーディング規約。型ヒント、PEP 8準拠、モダンなPython機能、品質基準を提供。Python実装、コーディング規約、型定義パターンが必要な時に参照。
---

# Python Implementation Best Practices

Python実装のベストプラクティス、コーディング規約、パターン集です。PEP 8準拠で保守性の高いコードを書くための知識ベースとして活用してください。

## 🎯 Core Principles（コア原則）

### 1. **PEP 8 Compliance**（PEP 8準拠）
- PEP 8スタイルガイドに従う
- BlackとFlake8で自動フォーマット・リント
- インデント: スペース4個
- 行の長さ: 88文字（Black標準）

### 2. **Type Hints**（型ヒント）
- 関数の引数と戻り値には型ヒントを使用
- `mypy`で型チェックを実行
- 複雑な型には`typing`モジュールを活用

### 3. **Code Quality**（コード品質）
- 明確な命名で自己文書化されたコードを書く
- 関数は小さく、単一責任を保つ
- Docstringsで関数・クラスを文書化
- 不要な複雑さを避ける

### 4. **Best Practices**（ベストプラクティス）
- f-stringsを優先して使用
- コンテキストマネージャ（with文）を活用
- List comprehension を適切に使用
- 例外処理を適切に実装

## 📚 Python Patterns（詳細パターン集）

詳細なコード例とパターンについては、[PATTERNS.md](PATTERNS.md)を参照してください。

### Quick Reference

#### 命名規則

```python
# 変数: snake_case
user_name = "John"
total_count = 100

# 定数: UPPER_SNAKE_CASE
MAX_RETRY = 3
API_BASE_URL = "https://api.example.com"

# クラス: PascalCase
class UserManager:
    pass

# 関数: snake_case
def get_user_data():
    pass

# プライベート: _prefix
class MyClass:
    def _internal_method(self):
        pass
```

#### 型ヒントの使用

```python
from typing import List, Dict, Optional, Union

def calculate_total(price: float, tax_rate: float) -> float:
    """合計金額を計算する

    Args:
        price: 商品価格
        tax_rate: 税率（0.1 = 10%）

    Returns:
        税込み価格
    """
    return price * (1 + tax_rate)

def get_user(user_id: str) -> Optional[Dict[str, str]]:
    """ユーザー情報を取得する

    Args:
        user_id: ユーザーID

    Returns:
        ユーザー情報の辞書。存在しない場合はNone
    """
    # 実装
    pass
```

#### モダンPython機能

```python
# ✅ f-strings（Python 3.6+）
name = "Alice"
age = 30
message = f"Hello, {name}! You are {age} years old."

# ✅ コンテキストマネージャ（with文）
with open('file.txt', 'r') as f:
    content = f.read()

# ✅ List comprehension
squares = [x**2 for x in range(10)]
even_squares = [x**2 for x in range(10) if x % 2 == 0]

# ✅ Dictionary comprehension
user_ages = {user['name']: user['age'] for user in users}

# ✅ Walrus operator（Python 3.8+）
if (n := len(items)) > 10:
    print(f"Large list: {n} items")

# ✅ Type hints with Union and Optional
def process_data(value: Union[str, int]) -> Optional[str]:
    if isinstance(value, int):
        return str(value)
    return value if value else None
```

## ✅ Quality Standards（品質基準）

実装したコードは以下の基準を満たす必要があります：

- ✅ PEP 8準拠（Blackでフォーマット済み）
- ✅ Flake8エラーなし
- ✅ 型ヒント使用（`mypy`チェック通過）
- ✅ Docstrings記述（関数、クラス）
- ✅ 適切な例外処理
- ✅ 明確な変数名と関数名
- ✅ エッジケースの処理
- ✅ コードの重複なし

## 🔍 Code Review Checklist（コードレビューチェックリスト）

コード実装後、以下を確認してください：

- [ ] PEP 8に準拠している
- [ ] Blackでフォーマット済み
- [ ] Flake8エラーがない
- [ ] 型ヒントが適切に使用されている
- [ ] Docstringsが記述されている
- [ ] 例外処理が実装されている
- [ ] 関数名・変数名が明確で説明的
- [ ] エッジケースが処理されている
- [ ] コードの重複がない
- [ ] インポートが整理されている（isort使用）
- [ ] 未使用の変数やインポートがない

## 🛠️ Development Tools

### フォーマットとリント

```bash
# Black - コードフォーマット
black yourfile.py

# isort - インポート整理
isort yourfile.py

# Flake8 - リント
flake8 yourfile.py

# mypy - 型チェック
mypy yourfile.py
```

### 設定ファイル

#### pyproject.toml

```toml
[tool.black]
line-length = 88
target-version = ['py311']

[tool.isort]
profile = "black"
line_length = 88

[tool.mypy]
python_version = "3.11"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
```

#### .flake8

```ini
[flake8]
max-line-length = 88
extend-ignore = E203, W503
exclude = .git,__pycache__,.venv,venv,dist,build
```

## 🎓 Learning Resources

- 詳細なパターン集: [PATTERNS.md](PATTERNS.md)
- PEP 8 Style Guide: https://peps.python.org/pep-0008/
- Python Type Hints: https://docs.python.org/3/library/typing.html
- Real Python: https://realpython.com/

---

**このスキルの使い方**: Python実装時にこのスキルを参照して、PEP 8準拠で品質基準に従ったコードを書いてください。
