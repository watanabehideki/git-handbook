# 実践しながら学ぶ — 実行コマンド一覧（検証済み）

`git-handbook.html` の「3 実践しながら学ぶ」を、**実際に打つ順番どおり**に並べたものです。
ハンドブック本文では省略されている**ファイル作成・編集の操作**も含めています。

- 検証環境: git 2.47.0 / macOS / リモートは GitHub（SSH）
- 検証リポジトリ: `git-practice-repo`（`git@github.com:watanabehideki/git-practice-repo.git`）
- 記号: 📌 = ハンドブック本文には出てこないが、実行しないと先に進めない操作
- 出力は実測値。コミットハッシュは環境ごとに変わる

---

## 0. 前提

リモートに**空のリポジトリ**を1つ作っておく（GitHub の画面で作成。README を初期化しない）。

---

## 3-1. config — 名前とメールを設定する

```bash
git config --global user.name "Taro Yamada"
git config --global user.email "taro@example.com"

git config --global --list        # 設定できたか確認
```

> `--list` は user.name / user.email 以外の既存設定もすべて列挙されます。

---

## 3-2. リポジトリを用意する（新規作成）

```bash
cd ~/development                              # 📌 作業を置きたい親フォルダへ移動
mkdir git-practice-repo && cd git-practice-repo
git init
echo "# git-practice-repo" > README.md
git add README.md
git commit -m "最初のコミット"
```

```
Initialized empty Git repository in .../git-practice-repo/.git/
[main (root-commit) f28c59d] 最初のコミット
 1 file changed, 1 insertion(+)
 create mode 100644 README.md
```

### リモートに接続

```bash
git remote add origin git@github.com:watanabehideki/git-practice-repo.git
git branch -M main
git push -u origin main
```

```
To github.com:watanabehideki/git-practice-repo.git
 * [new branch]      main -> main
branch 'main' set up to track 'origin/main'.
```

### origin の確認

```bash
git remote -v
```

```
origin	git@github.com:watanabehideki/git-practice-repo.git (fetch)
origin	git@github.com:watanabehideki/git-practice-repo.git (push)
```

---

## 3-3. branch — 今あるブランチを確認する

```bash
git branch
git branch -a
```

```
* main

* main
  remotes/origin/main
```

---

## 3-4. switch — 作業ブランチに切り替える

```bash
git switch -c feature/greeting
git branch
git switch main
git switch feature/greeting
```

```
Switched to a new branch 'feature/greeting'

* feature/greeting        ← アルファベット順。feature が先、main が後
  main

Switched to branch 'main'
Your branch is up to date with 'origin/main'.

Switched to branch 'feature/greeting'
```

---

## 3-5. status — 変更の状態を確認する

```bash
echo "# Git 練習リポジトリ" > README.md      # 📌 README.md を編集（見出しを書き換え）
touch memo.txt                               # 📌 新規ファイルを作成

git status
git status -s
```

```
On branch feature/greeting
Changes not staged for commit:
	modified:   README.md
Untracked files:
	memo.txt

 M README.md
?? memo.txt
```

---

## 3-6. ignore — Git に含めないファイルを決める

```bash
echo "secret" > secret.txt
git status -s
```

```
 M README.md          ← 前節の変更も一緒に出る
?? memo.txt
?? secret.txt
```

```bash
printf 'secret.txt\n*.log\n' > .gitignore    # 📌 .gitignore を作成
cat .gitignore
git status -s
```

```
secret.txt
*.log

 M README.md
?? .gitignore         ← secret.txt が消え、.gitignore が現れる
?? memo.txt
```

### すでに追跡中のファイルを追跡解除する

```bash
echo "SECRET_KEY=12345" > .env
git add .env && git commit -m "設定を追加"   # うっかり追跡・コミットしてしまったとする
echo ".env" >> .gitignore                    # 後から .gitignore に書いても……
echo "KEY=xyz" >> .env                       # .env を変更してみると
git status -s
```

```
 M .env                ← 追跡済みなので無視されない
 M README.md
?? .gitignore
?? memo.txt
```

```bash
git rm --cached .env
git status -s
```

```
rm '.env'

D  .env                ← 📌 「削除」がステージされた状態。コミットするまで確定しない
 M README.md
?? .gitignore
?? memo.txt
```

> 📌 この `D .env` は次の commit に含める必要があります。ファイル自体は手元に残ります。

---

## 3-7. diff — 変更の中身を確認する

```bash
git diff
git diff --staged
git diff main..feature/greeting
```

```
diff --git a/README.md b/README.md
--- a/README.md
+++ b/README.md
@@ -1 +1 @@
-# git-practice-repo
+# Git 練習リポジトリ
```

---

## 3-8. add — 変更をステージングに追加する

```bash
git add README.md
git add .
git status -s
```

```
D  .env               ← 前節の追跡解除
A  .gitignore
M  README.md
A  memo.txt
```

> 並びは ASCII 順（`.env` → `.gitignore` → `README.md` → `memo.txt`）。

---

## 3-9. commit — 変更を記録する

```bash
git commit -m "README の見出しを修正"
```

```
[feature/greeting e11f211] README の見出しを修正
 4 files changed, 4 insertions(+), 2 deletions(-)
 delete mode 100644 .env
 create mode 100644 .gitignore
 create mode 100644 memo.txt
```

> `git add .` で4件まとめてステージしたので `4 files changed`。
> README.md だけを記録したいなら `git add README.md` だけにして `git add .` は打たない。

---

## 3-10. log — 履歴を確認する

```bash
git log
git log --oneline
git log --oneline --graph --all
git log -p
git log --author="Taro" --since="2 weeks ago"
```

```
commit e11f211... (HEAD -> feature/greeting)
Author: Taro Yamada <taro@example.com>
Date:   Tue Jul 21 21:11:30 2026 +0900

    README の見出しを修正
```

> `(HEAD -> feature/greeting)` はターミナルで直接実行したときに表示されます（パイプ経由では出ません）。

---

## 3-11. もう一度、変更からコミットまで

```bash
echo "使い方はここに書きます。" >> README.md   # 📌 README.md に1行追記
git status -s
git diff
git add README.md
git commit -m "使い方の説明を追記"
```

```
 M README.md

[feature/greeting 2ef3178] 使い方の説明を追記
 1 file changed, 1 insertion(+)
```

---

## 3-12. push — リモートへ送る

```bash
git push -u origin feature/greeting
git branch -vv                 # 紐づけ（upstream）の確認
```

```
To github.com:watanabehideki/git-practice-repo.git
 * [new branch]      feature/greeting -> feature/greeting
branch 'feature/greeting' set up to track 'origin/feature/greeting'.

* feature/greeting 2ef3178 [origin/feature/greeting] 使い方の説明を追記
  main             f28c59d [origin/main] 最初のコミット
```

2回目以降は送り先を省略できる。

```bash
git push
```

---

## 3-13. PR作成 / 3-14. マージ

ホスティングサービスの画面で PR を作成し、承認後にマージする。

参考: GitHub CLI を使う場合。

```bash
gh pr create --base main --head feature/greeting --title "greeting を追加" --body "練習用の変更"
gh pr merge <PR番号> --merge          # マージコミット方式
```

---

## 3-15. fetch — リモートの最新を取得する

```bash
git fetch
git log --oneline origin/main
git diff origin/main
```

```
From github.com:watanabehideki/git-practice-repo
   f28c59d..c026edd  main       -> origin/main

c026edd Merge pull request #1 from watanabehideki/feature/greeting
2ef3178 使い方の説明を追記
...
```

### 取り込む（merge）

```bash
git switch main
git merge origin/main
```

```
Switched to branch 'main'
Your branch is behind 'origin/main' by 4 commits, and can be fast-forwarded.

Updating f28c59d..c026edd
Fast-forward
 .gitignore | 3 +++
 README.md  | 3 ++-
 memo.txt   | 0
 3 files changed, 5 insertions(+), 1 deletion(-)
```

---

## 3-16. pull — 取得して取り込む

```bash
git switch main
git pull
```

```
Updating c3d4e5f..c026edd
Fast-forward
```

> 📌 前節の `fetch` → `merge` をすでに実行している場合、ここは `Already up to date.` になります。
> `fetch + merge` と `pull` は**どちらか一方**を実行すれば十分です。

---

## 3-17. ブランチ削除 — 役目を終えた枝を片付ける

```bash
git switch main
git pull
git branch -d feature/greeting
git push origin --delete feature/greeting
git branch -a                                # 📌 片付いたか確認
```

```
Deleted branch feature/greeting (was 2ef3178).

To github.com:watanabehideki/git-practice-repo.git
 - [deleted]         feature/greeting

* main
  remotes/origin/main
```

> **Squash マージした場合の注意**
> Squash マージは main 側に別コミットとして載るため、Git からは未マージに見えます。
> リモートブランチが削除済みだと `git branch -d` は失敗します。
>
> ```
> error: the branch 'feature/xxx' is not fully merged
> hint: If you are sure you want to delete it, run 'git branch -D feature/xxx'
> ```
>
> PR がマージ済みであることを確認したうえで `git branch -D` で削除します。

---

## 通しで実行する場合（コピペ用）

```bash
# --- リポジトリ作成 ---
mkdir git-practice-repo && cd git-practice-repo
git init
echo "# git-practice-repo" > README.md
git add README.md
git commit -m "最初のコミット"
git remote add origin git@github.com:watanabehideki/git-practice-repo.git
git branch -M main
git push -u origin main

# --- ブランチを切る ---
git switch -c feature/greeting

# --- 変更する ---
echo "# Git 練習リポジトリ" > README.md
touch memo.txt
git status -s

# --- ignore ---
echo "secret" > secret.txt
printf 'secret.txt\n*.log\n' > .gitignore
git status -s

# --- 追跡解除の体験 ---
echo "SECRET_KEY=12345" > .env
git add .env && git commit -m "設定を追加"
echo ".env" >> .gitignore
echo "KEY=xyz" >> .env
git rm --cached .env
git status -s

# --- 確認して記録 ---
git diff
git add .
git commit -m "README の見出しを修正"
git log --oneline

# --- もう一度 ---
echo "使い方はここに書きます。" >> README.md
git add README.md
git commit -m "使い方の説明を追記"

# --- 共有 ---
git push -u origin feature/greeting

# --- （画面で PR 作成 → マージ）---

# --- 最新化して片付け ---
git switch main
git pull
git branch -d feature/greeting
git push origin --delete feature/greeting
git branch -a
```
