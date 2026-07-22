# 実践しながら学ぶ — 実行コマンド一覧（検証済み）

`git-handbook.html` の「3 実践しながら学ぶ」を、**実際に打つ順番どおり**に並べたものです。
本文のコードブロックに書かれているコマンドだけで構成しています。本文に無い操作は含まれません。

- 検証環境: git 2.47.0 / macOS 15.5 / リモートは GitHub（SSH）
- 検証リポジトリ: `git-practice-repo`（`git@github.com:watanabehideki/git-practice-repo.git`）
- 出力は実測値。コミットハッシュ・PR 番号・日時は実行のたびに変わる
- 画面（PR の作成とマージ）は `gh` コマンドで代用した。マージ方式は `Create a merge commit`

---

## 準備

### config — 名前とメールを設定する

```bash
git config --global user.name "Taro Yamada"
git config --global user.email "taro@example.com"

git config --global --list
```

```
user.name=Taro Yamada
user.email=taro@example.com
```

> `--list` は user.name / user.email 以外の既存設定もすべて列挙する。

### リポジトリを用意する（新規作成）

リモートに**空のリポジトリ**を1つ作っておく（GitHub の画面で作成。README を初期化しない）。

```bash
cd ~/dev
mkdir git-practice-repo && cd git-practice-repo
git init
echo "# git-practice-repo" > README.md
git add README.md
git commit -m "最初のコミット"
```

```
[main (root-commit) c01ae1e] 最初のコミット
 1 file changed, 1 insertion(+)
 create mode 100644 README.md
```

```bash
git remote add origin git@github.com:watanabehideki/git-practice-repo.git
git branch -M main
git push -u origin main
```

```
branch 'main' set up to track 'origin/main'.
```

### origin を確認する

```bash
git remote -v
```

```
origin	git@github.com:watanabehideki/git-practice-repo.git (fetch)
origin	git@github.com:watanabehideki/git-practice-repo.git (push)
```

---

## サイクル1 — 1コミットを最後まで通す

### branch — 今あるブランチを確認する

```bash
git branch
git branch -a
```

```
* main

* main
  remotes/origin/main
```

### switch — 作業ブランチに切り替える

```bash
git switch -c feature/readme
git branch

git switch main
git switch feature/readme
```

```
Switched to a new branch 'feature/readme'

* feature/readme
  main

Switched to branch 'main'
Your branch is up to date with 'origin/main'.

Switched to branch 'feature/readme'
```

### status — 変更の状態を確認する

```bash
echo "# Git 練習リポジトリ" > README.md
git status
```

```
On branch feature/readme
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   README.md

no changes added to commit (use "git add" and/or "git commit -a")
```

```bash
git status -s
```

```
 M README.md
```

### add — 変更をステージングに追加する

```bash
git add README.md
git add .
git status -s
```

```
M  README.md
```

### commit — 変更を記録する

```bash
git commit -m "README の見出しを修正"
```

```
[feature/readme c4c0d77] README の見出しを修正
 1 file changed, 1 insertion(+), 1 deletion(-)
```

### push — 変更をリモートに反映する

```bash
git push -u origin feature/readme
```

```
remote:
remote: Create a pull request for 'feature/readme' on GitHub by visiting:
remote:      https://github.com/watanabehideki/git-practice-repo/pull/new/feature/readme
remote:
To github.com:watanabehideki/git-practice-repo.git
 * [new branch]      feature/readme -> feature/readme
branch 'feature/readme' set up to track 'origin/feature/readme'.
```

```bash
git branch -vv
```

```
* feature/readme c4c0d77 [origin/feature/readme] README の見出しを修正
  main           c01ae1e [origin/main] 最初のコミット
```

```bash
git push
```

```
Everything up-to-date
```

### PR を作成してマージする

画面で PR を作成し、`Create a merge commit` でマージする。CLI で代用する場合は次のとおり。

```bash
gh pr create --base main --head feature/readme --title "README の見出しを修正" --body "…"
gh pr merge <PR番号> --merge
```

### fetch と merge — 手元を最新にする

```bash
git fetch
```

```
From github.com:watanabehideki/git-practice-repo
   c01ae1e..164a6fa  main       -> origin/main
```

```bash
git log --oneline origin/main
```

```
164a6fa Merge pull request #13 from watanabehideki/feature/readme
c4c0d77 README の見出しを修正
c01ae1e 最初のコミット
```

```bash
git diff origin/main
git switch main
git merge origin/main
```

```
Switched to branch 'main'
Your branch is behind 'origin/main' by 2 commits, and can be fast-forwarded.
  (use "git pull" to update your local branch)

Updating c01ae1e..164a6fa
Fast-forward
 README.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
```

### ブランチ削除 — 役目を終えたブランチを片付ける

```bash
git branch -d feature/readme
git push origin --delete feature/readme
git branch -a
```

```
Deleted branch feature/readme (was c4c0d77).

To github.com:watanabehideki/git-practice-repo.git
 - [deleted]         feature/readme

* main
  remotes/origin/main
```

---

## サイクル2 — 確認と取り消し

### 2周目をはじめる

```bash
git switch -c feature/memo
touch memo.txt
echo "使い方はここに書きます。" >> README.md
```

### diff — 変更の中身を確認する

```bash
git status -s
```

```
 M README.md
?? memo.txt
```

```bash
git diff
```

```
diff --git a/README.md b/README.md
index 8660881..370ebe4 100644
--- a/README.md
+++ b/README.md
@@ -1 +1,2 @@
 # Git 練習リポジトリ
+使い方はここに書きます。
```

### restore — 変更を元に戻す

```bash
git restore README.md
git status -s
```

```
?? memo.txt
```

### log — 履歴を確認する

```bash
git add memo.txt
git status -s
```

```
A  memo.txt
```

`git diff --staged` はこの位置（`git add` のあと）で実行したもの。

```bash
git diff --staged
```

```
diff --git a/memo.txt b/memo.txt
new file mode 100644
index 0000000..e69de29
```

```bash
git commit -m "memo.txt を追加"
```

```
[feature/memo 7fe5bd0] memo.txt を追加
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 memo.txt
```

`git diff main..feature/memo` はこの位置（`git commit` のあと）で実行したもの。

```bash
git diff main..feature/memo
```

```
diff --git a/memo.txt b/memo.txt
new file mode 100644
index 0000000..e69de29
```

```bash
git log
```

```
commit 7fe5bd0fde5efb8d8822d83e2ef56a8c38d72ce9
Author: Taro Yamada <taro@example.com>
Date:   Wed Jul 22 14:43:12 2026 +0900

    memo.txt を追加

commit 164a6fa53f5a57e9749e4eb61130595e4a9f24b8
Merge: c01ae1e c4c0d77
Author: watanabe hideki <…@users.noreply.github.com>
Date:   Wed Jul 22 14:42:31 2026 +0900

    Merge pull request #13 from watanabehideki/feature/readme

    README の見出しを修正

commit c4c0d775ea291fb5245940c08ae8b8175d913824
Author: Taro Yamada <taro@example.com>
Date:   Wed Jul 22 14:42:00 2026 +0900

    README の見出しを修正

commit c01ae1e8ebfaaef74842dd1e54198b27e8d1959f
Author: Taro Yamada <taro@example.com>
Date:   Wed Jul 22 14:41:25 2026 +0900

    最初のコミット
```

```bash
git log --oneline
```

```
7fe5bd0 memo.txt を追加
164a6fa Merge pull request #13 from watanabehideki/feature/readme
c4c0d77 README の見出しを修正
c01ae1e 最初のコミット
```

### pull — 取得して取り込む

```bash
git push -u origin feature/memo
```

画面で PR を作成し、`Create a merge commit` でマージする。

```bash
git switch main
git pull
```

```
Switched to branch 'main'
Your branch is up to date with 'origin/main'.

From github.com:watanabehideki/git-practice-repo
   164a6fa..60c99d3  main       -> origin/main
Updating 164a6fa..60c99d3
Fast-forward
 memo.txt | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 memo.txt
```

### 役目を終えたブランチを片付ける

```bash
git branch -d feature/memo
git push origin --delete feature/memo
git branch -a
```

```
Deleted branch feature/memo (was 7fe5bd0).

To github.com:watanabehideki/git-practice-repo.git
 - [deleted]         feature/memo

* main
  remotes/origin/main
```

---

## サイクル3 — 管理から外す

### 3周目をはじめる

```bash
git switch -c feature/ignore
```

### ignore — Git に含めないファイルを決める

```bash
echo "secret" > secret.txt
git status -s
```

```
?? secret.txt
```

```bash
printf 'secret.txt\n*.log\n' > .gitignore
cat .gitignore
```

```
secret.txt
*.log
```

```bash
git status -s
```

```
?? .gitignore
```

### rm --cached — 追跡だけをやめる

```bash
echo "SECRET_KEY=12345" > .env
git add .env && git commit -m "設定を追加"
```

```
[feature/ignore 2c14790] 設定を追加
 1 file changed, 1 insertion(+)
 create mode 100644 .env
```

```bash
echo ".env" >> .gitignore
echo "KEY=xyz" >> .env
git status -s
```

```
 M .env
?? .gitignore
```

```bash
git rm --cached .env
git status -s
```

```
rm '.env'

D  .env
?? .gitignore
```

### 削除もコミットする

```bash
git add .
git status -s
```

```
D  .env
A  .gitignore
```

```bash
git commit -m ".gitignore を追加して .env の追跡を外す"
```

```
[feature/ignore c4380cd] .gitignore を追加して .env の追跡を外す
 2 files changed, 3 insertions(+), 1 deletion(-)
 delete mode 100644 .env
 create mode 100644 .gitignore
```

```bash
git status -s
```

```
（1行も表示されない）
```

### プッシュして PR を出す

```bash
git push -u origin feature/ignore
```

画面で PR を作成し、`Create a merge commit` でマージする。

```bash
git switch main
git pull
```

```
From github.com:watanabehideki/git-practice-repo
   60c99d3..aff4a1e  main       -> origin/main
Updating 60c99d3..aff4a1e
Fast-forward
 .gitignore | 3 +++
 1 file changed, 3 insertions(+)
 create mode 100644 .gitignore
```

### 役目を終えたブランチを片付ける

```bash
git branch -d feature/ignore
git push origin --delete feature/ignore
git branch -a
```

```
Deleted branch feature/ignore (was c4380cd).

To github.com:watanabehideki/git-practice-repo.git
 - [deleted]         feature/ignore

* main
  remotes/origin/main
```

```bash
ls -a
```

```
.
..
.env
.git
.gitignore
memo.txt
README.md
secret.txt
```

---

## サイクル4 — コンフリクト

### 2本のブランチで同じ行を変える

```bash
git switch -c feature/greeting-ja
printf '# Git 練習リポジトリ\n\nこんにちは\n' > README.md
git add README.md && git commit -m "日本語のあいさつを追加"
git push -u origin feature/greeting-ja

git switch main
git switch -c feature/greeting-en
printf '# Git 練習リポジトリ\n\nHello\n' > README.md
git add README.md && git commit -m "英語のあいさつを追加"
git push -u origin feature/greeting-en
```

```
[feature/greeting-ja 514de68] 日本語のあいさつを追加
 1 file changed, 2 insertions(+)

[feature/greeting-en 539990a] 英語のあいさつを追加
 1 file changed, 2 insertions(+)
```

### コンフリクトを起こす

画面で2本の PR を作り、`feature/greeting-ja` の PR だけを `Create a merge commit` でマージする。
もう片方の PR がコンフリクト表示に変わるまで、十数秒かかる（実測で約20秒）。

```bash
git switch main
git pull
git switch feature/greeting-en
git merge main
```

```
Updating aff4a1e..5e32744
Fast-forward
 README.md | 2 ++
 1 file changed, 2 insertions(+)

Switched to branch 'feature/greeting-en'
Your branch is up to date with 'origin/feature/greeting-en'.

Auto-merging README.md
CONFLICT (content): Merge conflict in README.md
Automatic merge failed; fix conflicts and then commit the result.
```

```bash
git status
```

```
On branch feature/greeting-en
Your branch is up to date with 'origin/feature/greeting-en'.

You have unmerged paths.
  (fix conflicts and run "git commit")
  (use "git merge --abort" to abort the merge)

Unmerged paths:
  (use "git add <file>..." to mark resolution)
	both modified:   README.md

no changes added to commit (use "git add" and/or "git commit -a")
```

```bash
git status -s
```

```
UU README.md
```

### コンフリクトマーカーを解消する

```bash
cat README.md
```

```
# Git 練習リポジトリ

<<<<<<< HEAD
Hello
=======
こんにちは
>>>>>>> main
```

```bash
printf '# Git 練習リポジトリ\n\nこんにちは\nHello\n' > README.md
git add README.md
git status -s
```

```
M  README.md
```

```bash
git commit -m "コンフリクトを解消"
```

```
[feature/greeting-en 53122bb] コンフリクトを解消
```

マージコミットなので `1 file changed` の行は出ない。

```bash
git push
```

```
To github.com:watanabehideki/git-practice-repo.git
   539990a..53122bb  feature/greeting-en -> feature/greeting-en
```

プッシュすると PR のコンフリクト表示が消える。画面でマージする。

```bash
git switch main
git pull
```

```
From github.com:watanabehideki/git-practice-repo
   5e32744..75037e4  main       -> origin/main
Updating 5e32744..75037e4
Fast-forward
 README.md | 1 +
 1 file changed, 1 insertion(+)
```

### 役目を終えたブランチを片付ける

```bash
git branch -d feature/greeting-en
git branch -d feature/greeting-ja
git push origin --delete feature/greeting-en
git push origin --delete feature/greeting-ja
git branch -a
```

```
Deleted branch feature/greeting-en (was 53122bb).
Deleted branch feature/greeting-ja (was 514de68).

To github.com:watanabehideki/git-practice-repo.git
 - [deleted]         feature/greeting-en
To github.com:watanabehideki/git-practice-repo.git
 - [deleted]         feature/greeting-ja

* main
  remotes/origin/main
```

### 4周を終えた時点の履歴

```bash
git log --oneline
```

```
75037e4 Merge pull request #17 from watanabehideki/feature/greeting-en
53122bb コンフリクトを解消
5e32744 Merge pull request #16 from watanabehideki/feature/greeting-ja
539990a 英語のあいさつを追加
514de68 日本語のあいさつを追加
aff4a1e Merge pull request #15 from watanabehideki/feature/ignore
c4380cd .gitignore を追加して .env の追跡を外す
2c14790 設定を追加
60c99d3 Merge pull request #14 from watanabehideki/feature/memo
7fe5bd0 memo.txt を追加
164a6fa Merge pull request #13 from watanabehideki/feature/readme
c4c0d77 README の見出しを修正
c01ae1e 最初のコミット
```

---

## 通しで実行する場合（コピペ用）

PR の作成とマージは画面で行う。ここでは `gh` コマンドで代用している。

```bash
# --- 準備 ---
cd ~/dev
mkdir git-practice-repo && cd git-practice-repo
git init
echo "# git-practice-repo" > README.md
git add README.md
git commit -m "最初のコミット"
git remote add origin git@github.com:watanabehideki/git-practice-repo.git
git branch -M main
git push -u origin main

# --- サイクル1 ---
git branch
git branch -a
git switch -c feature/readme
git switch main
git switch feature/readme
echo "# Git 練習リポジトリ" > README.md
git status -s
git add .
git commit -m "README の見出しを修正"
git push -u origin feature/readme
gh pr create --base main --head feature/readme --title "README の見出しを修正" --body "…"
gh pr merge <PR番号> --merge
git fetch
git log --oneline origin/main
git switch main
git merge origin/main
git branch -d feature/readme
git push origin --delete feature/readme

# --- サイクル2 ---
git switch -c feature/memo
touch memo.txt
echo "使い方はここに書きます。" >> README.md
git status -s
git diff
git restore README.md
git add memo.txt
git commit -m "memo.txt を追加"
git log --oneline
git push -u origin feature/memo
gh pr create --base main --head feature/memo --title "memo.txt を追加" --body "…"
gh pr merge <PR番号> --merge
git switch main
git pull
git branch -d feature/memo
git push origin --delete feature/memo

# --- サイクル3 ---
git switch -c feature/ignore
echo "secret" > secret.txt
printf 'secret.txt\n*.log\n' > .gitignore
git status -s
echo "SECRET_KEY=12345" > .env
git add .env && git commit -m "設定を追加"
echo ".env" >> .gitignore
echo "KEY=xyz" >> .env
git rm --cached .env
git add .
git commit -m ".gitignore を追加して .env の追跡を外す"
git push -u origin feature/ignore
gh pr create --base main --head feature/ignore --title ".gitignore を追加して .env の追跡を外す" --body "…"
gh pr merge <PR番号> --merge
git switch main
git pull
git branch -d feature/ignore
git push origin --delete feature/ignore
ls -a

# --- サイクル4 ---
git switch -c feature/greeting-ja
printf '# Git 練習リポジトリ\n\nこんにちは\n' > README.md
git add README.md && git commit -m "日本語のあいさつを追加"
git push -u origin feature/greeting-ja
git switch main
git switch -c feature/greeting-en
printf '# Git 練習リポジトリ\n\nHello\n' > README.md
git add README.md && git commit -m "英語のあいさつを追加"
git push -u origin feature/greeting-en
gh pr create --base main --head feature/greeting-ja --title "日本語のあいさつを追加" --body "…"
gh pr create --base main --head feature/greeting-en --title "英語のあいさつを追加" --body "…"
gh pr merge <ja の PR番号> --merge
git switch main
git pull
git switch feature/greeting-en
git merge main
cat README.md
printf '# Git 練習リポジトリ\n\nこんにちは\nHello\n' > README.md
git add README.md
git commit -m "コンフリクトを解消"
git push
gh pr merge <en の PR番号> --merge
git switch main
git pull
git branch -d feature/greeting-en
git branch -d feature/greeting-ja
git push origin --delete feature/greeting-en
git push origin --delete feature/greeting-ja
git branch -a
```
