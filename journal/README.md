# Journal Workflow

生の記入 → AI自動ふり返り → 承認済みベースの3段階ジャーナル。

## ステージ

| stage | 意味 | 操作 |
|---|---|---|
| `inbox` | 生の記入 | `scripts/jot.sh <slug>` |
| `reflected` | AIふり返り済み | GitHub Action が自動処理 |
| `approved` | 承認済みベース | `scripts/approve.sh <file>` |

## 使い方

```bash
# 新規エントリ作成
scripts/jot.sh my-topic

# ステージ別一覧
scripts/list.sh inbox
scripts/list.sh approved

# 承認
scripts/approve.sh 2026-04-19-my-topic.md
```

## フロー

```
jot.sh → entries/ (stage:inbox) → git push
  → GitHub Action → stage:reflected + ふり返り追記 → PR作成
  → PRレビュー・マージ
  → approve.sh → stage:approved（行動の参考ベース）
```
