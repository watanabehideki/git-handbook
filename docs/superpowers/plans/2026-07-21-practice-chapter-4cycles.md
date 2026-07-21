# 実践章 4サイクル構成 実装計画

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** `git-handbook.html` の3章を、コマンド単位の17節から、開発サイクルを4周する6節構成へ組み替え、掲載する出力をすべて実測値にそろえる。

**Architecture:** 3章の準備2節（`p3-1` config / `p3-2` リポジトリを用意する）は残し、その後ろの `p3-3`〜`p3-17`（1011〜1572行）を4つのサイクル節に置き換える。各サイクルは `<h3 id="p3-N">`、その中のコマンド解説は `<h4 id="p3-N-xxx">` とする。4章からは `restore` と コンフリクト を削除して実践章へ一本化する。サイドバーとTOCカードは、節を追加・削除するタスクの中で同時に更新し、各タスク終了時点で常にリンク切れがない状態を保つ。

**Tech Stack:** 単一の静的HTML（`git-handbook.html`）と textlint 15（`npm run lint`）。検証にはシェルスクリプトと、実測用の Git リポジトリ `../git-practice-repo` を使う。

## Global Constraints

仕様書 `docs/superpowers/specs/2026-07-21-practice-chapter-4cycles-design.md` の「執筆ルール」を全タスクに適用する。

- ファイル操作は必ずコマンドとして本文に書く。地の文で「編集します」とだけ述べない
- 出力はその時点の全行を載せる。省略する場合は省略と分かる形にする
- 出力は実測値を使う。各タスクの最初に `../git-practice-repo` で実際に打ち、その結果を貼る。手で書かない
- 並び順も実測に合わせる。`git branch` と `git status -s` の一覧は ASCII 順で表示される
- 定型部分を縮小する場合、省くのは出力だけとし、コマンド列は省かない
- コミットハッシュは実行のたびに変わる。掲載するハッシュはそのタスクで実測した値にする
- HTML の特殊文字は `&lt;` `&gt;` `&amp;` にエスケープする
- 既存のマークアップパターンに従う（後述の「マークアップ規約」）
- CSS の変更は Task 1 の `figure img` 1行のみとする。仕様書のスコープ外にある「CSS とレイアウトの変更」は、この1行を除き行わない
- 各タスクの最後に `npm run lint` と `scripts/check-anchors.sh` を実行し、両方が通ることを確認してからコミットする

## マークアップ規約

既存ファイルから抽出した型。新規に書く要素はこれに合わせる。

**コードブロック**（`<pre>` の中は改行がそのまま出るため、インデントを入れない）

```html
<pre><button class="copy-btn">コピー</button><span class="term-head"><span class="dot"></span><span class="dot"></span><span class="dot"></span><span class="label">ラベル</span></span><code><span class="pr">$</span> git status
<span class="out">On branch main</span>                <span class="cmt"># 今いるブランチ</span></code></pre>
```

- `<span class="pr">$</span>` … プロンプト
- `<span class="out">` … コマンドの出力
- `<span class="cmt">` … 行末の解説コメント
- `<span class="hl">` … 出力の中で目立たせたい部分

**図**（`figure::before` が「図[N]」を自動採番する）

```html
<figure>
  <img src="pr-banner.png" alt="画面の内容を日本語で説明">
  <figcaption>キャプション。</figcaption>
</figure>
```

**ワンポイント**

```html
<div class="box tip">
  <div class="box-t"><svg class="ico" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M12 2a7 7 0 0 0-4 12.7V17h8v-2.3A7 7 0 0 0 12 2Z"/><path d="M9 21h6"/></svg>タイトル</div>
  <p>本文。</p>
</div>
```

注意ボックス

```html
<div class="box stumble">
  <div class="box-t"><svg class="ico" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M12 9v4M12 17h.01"/><path d="M10.3 3.9 1.8 18a2 2 0 0 0 1.7 3h17a2 2 0 0 0 1.7-3L13.7 3.9a2 2 0 0 0-3.4 0Z"/></svg>タイトル</div>
  <p>本文。</p>
</div>
```

**表**

```html
<div class="tbl-wrap"><table>
  <thead><tr><th>見出し</th><th>見出し</th></tr></thead>
  <tbody><tr><td>値</td><td>値</td></tr></tbody>
</table></div>
```

## File Structure

| ファイル | 役割 | 変更 |
| --- | --- | --- |
| `git-handbook.html` | ハンドブック本体。単一ファイル | 変更 |
| `git-handbook.html` サイドバー 314〜331行 | 3章の節リンク | 変更 |
| `git-handbook.html` TOCカード 391行 | 3章の節リンク | 変更 |
| `git-handbook.html` CSS 190行付近 | `figure img` を追加 | 変更 |
| `git-handbook.html` 1011〜1572行 | 旧 `p3-3`〜`p3-17`。4サイクルに置換 | 置換 |
| `git-handbook.html` 1576〜1918行 | 4章。`restore`（`p4-3`）とコンフリクト（`p4-7`）を削除し再採番 | 変更 |
| `scripts/check-anchors.sh` | `href="#x"` に対応する `id="x"` があるか検証 | 新規 |
| `pr-banner.png` 他4点 | 撮影済みのスクリーンショット | 既存 |
| `../git-practice-repo` | 出力の実測に使う練習リポジトリ | 実行環境 |

3章の節境界は次のとおり。行番号は Task 1 開始時点のもので、タスクを進めるとずれる。そのため各タスクは行番号を使わず、**`id` 属性を目印に置換範囲を特定する**。

- `<section class="section" id="p3">` … 924行
- `p3-1` config … 949行
- `p3-2` リポジトリを用意する … 962行（準備はここまで残す）
- `p3-3` branch … 1011行（**ここから**置換）
- `p3-17` ブランチ削除 … 1562行
- `</section>` … 1573行（**ここまで**置換対象の直後）
- `<section class="section" id="p4">` … 1576行

## 節と id の対応（完成形）

| id | 見出し | 中の `h4` |
| --- | --- | --- |
| `p3-1` | config — 名前とメールを設定する | なし（現状維持） |
| `p3-2` | リポジトリを用意する | 現状維持 |
| `p3-3` | サイクル1 — 1コミットを最後まで通す | `p3-3-branch` `p3-3-switch` `p3-3-status` `p3-3-add` `p3-3-commit` `p3-3-push` `p3-3-pr` `p3-3-merge` `p3-3-fetch` `p3-3-delete` |
| `p3-4` | サイクル2 — 確認と取り消し | `p3-4-diff` `p3-4-restore` `p3-4-log` `p3-4-pull` |
| `p3-5` | サイクル3 — 管理から外す | `p3-5-ignore` `p3-5-rmcached` |
| `p3-6` | サイクル4 — コンフリクト | `p3-6-branches` `p3-6-conflict` `p3-6-resolve` |

---

### Task 1: 検証の足場と画像の受け入れ

スクリーンショットを表示できるようにし、以降のタスクで使うリンク検証スクリプトを用意する。

**Files:**
- Create: `scripts/check-anchors.sh`
- Modify: `git-handbook.html`（CSS の `figure svg` 行の直後）
- 確認のみ: `pr-banner.png` `pr-compare.png` `pr-form.png` `pr-merge.png` `pr-conflict.png`

**Interfaces:**
- Produces: `scripts/check-anchors.sh`。引数なしで実行し、リンク切れがあれば該当 `href` を標準出力に出して終了コード1、なければ `OK: all N anchors resolve` を出して終了コード0
- Produces: CSS ルール `figure img{display:block; width:100%; height:auto;}`

- [ ] **Step 1: 画像5点がそろっていることを確認する**

Run:
```bash
cd /Users/hideki/development/git-handbook
for f in pr-banner pr-compare pr-form pr-merge pr-conflict; do
  printf "%-16s " "$f.png"; sips -g pixelWidth -g pixelHeight "$f.png" | tail -2 | tr -d '\n' | sed 's/  */ /g'; echo
done
```

Expected:
```
pr-banner.png    pixelWidth: 1720 pixelHeight: 112
pr-compare.png   pixelWidth: 2432 pixelHeight: 452
pr-form.png      pixelWidth: 1606 pixelHeight: 822
pr-merge.png     pixelWidth: 1548 pixelHeight: 860
pr-conflict.png  pixelWidth: 1560 pixelHeight: 492
```

1点でも欠けていたら止まる。撮影手順は仕様書の「図版（スクリーンショット）」を参照する。

- [ ] **Step 2: リンク検証スクリプトを書く**

Create `scripts/check-anchors.sh`:

```bash
#!/usr/bin/env bash
# git-handbook.html 内の href="#xxx" に対応する id="xxx" が存在するかを検証する。
set -uo pipefail

FILE="${1:-git-handbook.html}"

if [ ! -f "$FILE" ]; then
  echo "NG: $FILE が見つかりません" >&2
  exit 1
fi

ids=$(grep -o 'id="[^"]*"' "$FILE" | sed 's/id="//;s/"//' | sort -u)
hrefs=$(grep -o 'href="#[^"]*"' "$FILE" | sed 's/href="#//;s/"//' | sort -u)

missing=0
total=0
while IFS= read -r h; do
  [ -z "$h" ] && continue
  total=$((total + 1))
  if ! printf '%s\n' "$ids" | grep -qx "$h"; then
    echo "NG: href=\"#$h\" に対応する id がありません"
    missing=$((missing + 1))
  fi
done <<< "$hrefs"

if [ "$missing" -gt 0 ]; then
  echo "NG: $missing 件のリンク切れ"
  exit 1
fi

echo "OK: all $total anchors resolve"
```

- [ ] **Step 3: スクリプトを実行可能にして、今の HTML で通ることを確認する**

Run:
```bash
chmod +x scripts/check-anchors.sh && ./scripts/check-anchors.sh
```

Expected: `OK: all N anchors resolve`（N は40前後）

ここで NG が出たら、今回の変更前から存在するリンク切れとみなす。その `href` を控えて Step 4 に進み、Task 7 の最終確認で解消されているかを見る。

- [ ] **Step 4: 画像用の CSS を1行追加する**

`git-handbook.html` の

```
  figure svg{display:block; width:100%; height:auto;}
```

の直後に、次の1行を追加する。

```
  figure img{display:block; width:100%; height:auto; border:1px solid var(--line); border-radius:6px;}
```

枠線と角丸を付けるのは、スクリーンショットの白背景が図の白背景に溶けて境界が分からなくなるため。

- [ ] **Step 5: lint とリンク検証を実行する**

Run:
```bash
npm run lint && ./scripts/check-anchors.sh
```

Expected: textlint がエラーなしで終了し、続いて `OK: all N anchors resolve` が出る

- [ ] **Step 6: コミットする**

```bash
git add scripts/check-anchors.sh git-handbook.html pr-banner.png pr-compare.png pr-form.png pr-merge.png pr-conflict.png
git commit -m "実践章の再構成に向けて画像表示のCSSとリンク検証スクリプトを追加"
```

---

### Task 2: サイクル1 に置き換える

旧 `p3-3`〜`p3-17` を削除し、サイクル1の1節に置き換える。サイドバーとTOCカードも同時に更新する。このタスクを終えた時点で、3章は「準備2節＋サイクル1」として完結した状態になる。

**Files:**
- Modify: `git-handbook.html`（`id="p3-3"` の行から `id="p3-17"` の節の末尾まで）
- Modify: `git-handbook.html` サイドバー 314〜331行付近
- Modify: `git-handbook.html` TOCカード 391行

**Interfaces:**
- Consumes: Task 1 の `scripts/check-anchors.sh` と `figure img` の CSS
- Produces: `id="p3-3"` の節と、その中の `h4` 10個。
  - `p3-3-branch` `p3-3-switch` `p3-3-status` `p3-3-add` `p3-3-commit`
  - `p3-3-push` `p3-3-pr` `p3-3-merge` `p3-3-fetch` `p3-3-delete`

- [ ] **Step 1: 練習リポジトリを初期状態に戻す**

Run:
```bash
cd /Users/hideki/development
rm -rf git-practice-repo
mkdir git-practice-repo && cd git-practice-repo
git init -q
echo "# git-practice-repo" > README.md
git add README.md
git commit -q -m "最初のコミット"
git remote add origin git@github.com:watanabehideki/git-practice-repo.git
git branch -M main
git push -u --force origin main
for b in $(git ls-remote --heads origin | sed 's|.*refs/heads/||' | grep -v '^main$'); do
  git push origin --delete "$b" -q
done
git log --oneline
```

Expected: 最後に `43fa880 最初のコミット` のような1行だけが出る（ハッシュは異なる）

- [ ] **Step 2: サイクル1のコマンドを通しで実行し、出力を採取する**

次を1コマンドずつ実行し、**画面に出た全行をそのまま記録する**。ここで採取した文字列を Step 3 以降で本文に貼る。

```bash
cd /Users/hideki/development/git-practice-repo
git branch
git branch -a
git switch -c feature/readme
git branch
git switch main
git switch feature/readme
echo "# Git 練習リポジトリ" > README.md
git status
git status -s
git add README.md
git status -s
git commit -m "README の見出しを修正"
git push -u origin feature/readme
git branch -vv
```

実測済みの参考値を次に示す。ハッシュと相対時刻は実行のたびに変わる。

```
$ git branch
* main

$ git branch -a
* main
  remotes/origin/main

$ git switch -c feature/readme
Switched to a new branch 'feature/readme'

$ git branch
* feature/readme
  main

$ git switch main
Switched to branch 'main'
Your branch is up to date with 'origin/main'.

$ git status -s
 M README.md

$ git add README.md
$ git status -s
M  README.md

$ git commit -m "README の見出しを修正"
[feature/readme 71ec8ac] README の見出しを修正
 1 file changed, 1 insertion(+), 1 deletion(-)

$ git push -u origin feature/readme
To github.com:watanabehideki/git-practice-repo.git
 * [new branch]      feature/readme -> feature/readme
branch 'feature/readme' set up to track 'origin/feature/readme'.

$ git branch -vv
* feature/readme 71ec8ac [origin/feature/readme] README の見出しを修正
  main            43fa880 [origin/main] 最初のコミット
```

`git branch` の並びが `feature/readme` → `main` の順であることを必ず確認する。旧版は逆に書かれていた。

- [ ] **Step 3: 画面で PR を作成してマージし、その後の出力を採取する**

GitHub の画面で `feature/readme` から `main` への PR を作り、マージ方式に「Create a merge commit」を選んでマージする。その後、手元で次を実行して出力を記録する。

```bash
cd /Users/hideki/development/git-practice-repo
git fetch
git log --oneline origin/main
git switch main
git merge origin/main
git branch -d feature/readme
git push origin --delete feature/readme
git branch -a
```

実測済みの参考値:

```
$ git fetch
From github.com:watanabehideki/git-practice-repo
   43fa880..d38429a  main       -> origin/main

$ git switch main
Switched to branch 'main'
Your branch is behind 'origin/main' by 2 commits, and can be fast-forwarded.
  (use "git pull" to update your local branch)

$ git merge origin/main
Updating 43fa880..d38429a
Fast-forward
 README.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

$ git branch -d feature/readme
Deleted branch feature/readme (was 71ec8ac).

$ git push origin --delete feature/readme
To github.com:watanabehideki/git-practice-repo.git
 - [deleted]         feature/readme

$ git branch -a
* main
  remotes/origin/main
```

- [ ] **Step 4: 旧 `p3-3`〜`p3-17` を削除してサイクル1を書く**

削除する範囲は、`<h3 id="p3-3">branch — 今あるブランチを確認する</h3>` の行から `p3-17` の節の末尾までとする。末尾の目印は「これで1周」のワンポイントを閉じる `</div>` とする。ここを次の構成で置き換える。

節の冒頭:

```html
<h3 id="p3-3">サイクル1 — 1コミットを最後まで通す</h3>
<p>ここからは、開発の1サイクルを最後まで通します。<strong>ブランチを切る → 変更する → 記録する → 共有する → main に取り込む → 片付ける</strong>。この一周を4回くり返しながら、使うコマンドを1つずつ増やしていきます。1周目の題材は <code>README.md</code> の見出しを書き換えるだけの、ごく小さな変更です。</p>
```

続けて、次の順に `h4` ブロックを置く。各ブロックは「短い導入の段落 → コードブロック → 必要なら図・表・ボックス」の形にそろえる。

| `h4` id | 見出し | コードブロックの `label` | 中身 |
| --- | --- | --- | --- |
| `p3-3-branch` | branch — 今あるブランチを確認する | `branch` / `branch -a` | Step 2 の `git branch` と `git branch -a` の実測出力 |
| `p3-3-switch` | switch — 作業ブランチに切り替える | `switch` | Step 2 の switch 一連。`git branch` の並びは実測どおり `feature/readme` が先 |
| `p3-3-status` | status — 変更の状態を確認する | `status` / `status -s` | `echo "# Git 練習リポジトリ" > README.md` を先頭に置き、続けて Step 2 の status 出力 |
| `p3-3-add` | add — 変更をステージングに追加する | `add` | `git add README.md` と直後の `git status -s`（`M  README.md`） |
| `p3-3-commit` | commit — 変更を記録する | `commit` | Step 2 の commit 出力 |
| `p3-3-push` | push — リモートへ送る | `push` | Step 2 の push 出力と `git branch -vv` |
| `p3-3-pr` | PR作成 — 変更の取り込みを提案する | なし（図3点） | `pr-banner.png` → `pr-compare.png` → `pr-form.png` |
| `p3-3-merge` | マージ — main に取り込む | なし（図1点） | `pr-merge.png` とマージ方式のコラム |
| `p3-3-fetch` | fetch と merge — 手元を最新にする | `fetch` / `取り込む(merge)` | Step 3 の fetch / merge 出力 |
| `p3-3-delete` | ブランチ削除 — 役目を終えた枝を片付ける | `ブランチ削除` | Step 3 の branch -d / push --delete / branch -a 出力 |

旧版から**そのまま移してよい説明**は次のとおり。現行ファイルの該当箇所から本文を切り取って使う。

- 「ブランチの3つの種類」の箇条書きと `branch -a` の図 → `p3-3-branch` の中
- 「HEAD — 今いるブランチを指す目印」の段落2つと図 → `p3-3-switch` の中の `h5` 相当として、`h4` を増やさず段落＋図で置く
- 「ファイルの4つの状態」の表と図、「短縮表示 `git status -s`」の説明 → `p3-3-status` の中
- 「出力はヒント」のワンポイント → `p3-3-status` の中
- 「コミットメッセージの書き方」の段落と図 → `p3-3-commit` の中
- upstream の説明と「紐づけを確認する」のワンポイント → `p3-3-push` の中
- PR を使う理由の箇条書き3点 → `p3-3-pr` の中
- Fast-forward / 3-way / Squash の図3点 → `p3-3-merge` のコラムの中
- 「マージしても、ローカルには古いブランチが残る」の注意 → `p3-3-merge` の末尾
- 「これで1周」のワンポイント → `p3-3-delete` の末尾。文面は4サイクル構成に合わせ、次のサイクル2で何を学ぶかを予告する形で締めくくる

`p3-3-pr` の図3点は次のマークアップにする。

```html
<figure>
  <img src="pr-banner.png" alt="push した直後のリポジトリ画面。feature/readme had recent pushes と表示され、右に Compare &amp; pull request ボタンがある">
  <figcaption>push すると、リポジトリの画面に <code>Compare &amp; pull request</code> ボタンが出る。ここが PR 作成の入口。</figcaption>
</figure>
<figure>
  <img src="pr-compare.png" alt="Comparing changes の画面。base: main と compare: feature/readme が並び、Able to merge と表示されている">
  <figcaption><strong>base</strong> が取り込み先（<code>main</code>）、<strong>compare</strong> が取り込み元（<code>feature/readme</code>）。<code>Able to merge.</code> は競合なく取り込めるという意味。</figcaption>
</figure>
<figure>
  <img src="pr-form.png" alt="PR作成フォーム。タイトル欄にコミットメッセージが入り、説明欄と Create pull request ボタンがある">
  <figcaption>タイトルにはコミットメッセージが自動で入る。説明欄には「なぜこの変更をしたか」を書く。</figcaption>
</figure>
```

`p3-3-merge` のマージ方式コラムは、仕様書の決定どおり**2層**にする。上段に画面の3ボタン、下段に Git レベルの対応を置く。

```html
<figure>
  <img src="pr-merge.png" alt="マージボックス。Merge pull request ボタンと、Create a merge commit / Squash and merge / Rebase and merge の3つが並ぶドロップダウン">
  <figcaption>マージボタンの右の <code>▼</code> を押すと、方式を選べる。本書では <code>Create a merge commit</code> を選ぶ。</figcaption>
</figure>
<div class="tbl-wrap"><table>
  <thead><tr><th>画面の選択肢</th><th>Git が行うこと</th></tr></thead>
  <tbody>
    <tr><td>Create a merge commit</td><td>両者を親に持つ<strong>マージコミット</strong>を1つ作る。main 側が進んでいなければ、手元では <strong>Fast-forward</strong> で追いつける</td></tr>
    <tr><td>Squash and merge</td><td>feature の複数コミットを<strong>1つにまとめて</strong> main に載せる。マージコミットは作られない</td></tr>
    <tr><td>Rebase and merge</td><td>feature のコミットを main の先端に付け替える。本書では扱わない</td></tr>
  </tbody>
</table></div>
```

コラムの末尾に、次の注意を `box stumble` で置く。

```html
<div class="box stumble">
  <div class="box-t"><svg class="ico" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M12 9v4M12 17h.01"/><path d="M10.3 3.9 1.8 18a2 2 0 0 0 1.7 3h17a2 2 0 0 0 1.7-3L13.7 3.9a2 2 0 0 0-3.4 0Z"/></svg>ボタンの表示は前回選んだ方式で変わる</div>
  <p>マージボタンには、そのリポジトリで<strong>最後に選んだ方式</strong>が表示されます。<code>Squash and merge</code> と出ていても、右の <code>▼</code> から <code>Create a merge commit</code> を選び直せます。押す前に、いま何が選ばれているかを確かめてください。</p>
  <p>また <strong>Squash マージを選ぶと、あとで <code>git branch -d</code> が失敗します</strong>。main 側には別のコミットとして載るため、Git からは未マージに見えるからです。その場合は PR がマージ済みであることを確認したうえで <code>git branch -D</code> を使います。</p>
</div>
```

- [ ] **Step 5: サイドバーとTOCカードを更新する**

サイドバーの3章部分を次の3行に置き換える。置き換える範囲は `<a href="#p3-1" class="sub">config</a>` から `<a href="#p3-17" class="sub">ブランチ削除</a>` までとする。

```html
      <a href="#p3-1" class="sub">config</a>
      <a href="#p3-2" class="sub">リポジトリを用意する</a>
      <a href="#p3-3" class="sub">サイクル1 基本の一周</a>
```

TOCカード（391行）の `toc-children` を、次に置き換える。

```html
<div class="toc-children"><a href="#p3-1">config</a> <span class="sep">·</span> <a href="#p3-2">リポジトリを用意する</a> <span class="sep">·</span> <a href="#p3-3">サイクル1 基本の一周</a></div>
```

- [ ] **Step 6: lint とリンク検証を実行する**

Run:
```bash
cd /Users/hideki/development/git-handbook
npm run lint && ./scripts/check-anchors.sh
```

Expected: textlint がエラーなしで終了し、`OK: all N anchors resolve` が出る

- [ ] **Step 7: 本文どおりに打ち直して画面と一致することを確認する**

Step 1 のリセットを再実行してから、**本文に書いたコマンドだけ**を上から順に打ち、掲載した出力と実際の画面が一致することを確認する。食い違ったら本文を実測値に直す。

- [ ] **Step 8: コミットする**

```bash
git add git-handbook.html
git commit -m "実践章にサイクル1を新設し、旧コマンド別17節を置き換え"
```

---

### Task 3: サイクル2 を追加する

**Files:**
- Modify: `git-handbook.html`（`id="p3-3"` の節の直後に挿入）
- Modify: `git-handbook.html` サイドバーとTOCカード

**Interfaces:**
- Consumes: Task 2 の `p3-3` 節。サイクル2は main が最新の状態から始まる前提
- Produces: `id="p3-4"` と `h4` 群 `p3-4-diff` `p3-4-restore` `p3-4-log` `p3-4-pull`

- [ ] **Step 1: サイクル2のコマンドを実行し、出力を採取する**

Run:
```bash
cd /Users/hideki/development/git-practice-repo
git switch -c feature/memo
touch memo.txt
echo "使い方はここに書きます。" >> README.md
git status -s
git diff
git restore README.md
git status -s
git add memo.txt
git commit -m "memo.txt を追加"
git log --oneline
git push -u origin feature/memo
```

`git diff` の出力は README.md の1行追加、`git restore README.md` の後は `?? memo.txt` だけが残る。実測した全行を記録する。

- [ ] **Step 2: PR を作ってマージし、pull の出力を採取する**

画面で PR を作成し、`Create a merge commit` でマージする。その後:

```bash
cd /Users/hideki/development/git-practice-repo
git switch main
git pull
git branch -d feature/memo
git push origin --delete feature/memo
```

`git pull` は `Updating ..` と `Fast-forward` を出す。`Already up to date.` になった場合は、PR のマージが終わっていないか、すでに取り込みが済んでいる。実測値を記録する。

- [ ] **Step 3: サイクル2の節を書く**

`p3-3` の節の直後（`p3-3-delete` の「これで1周」ワンポイントの `</div>` の次）に挿入する。

```html
<h3 id="p3-4">サイクル2 — 確認と取り消し</h3>
<p>2周目です。今度は <code>memo.txt</code> を新しく作り、あわせて <code>README.md</code> にも1行足してみます。ところが README への追記は<strong>やめることにした</strong>、という筋で進めます。記録する前に中身を確かめる方法と、いらなくなった変更を捨てる方法をここで覚えます。</p>
```

続けて `h4` を4つ置く。

| `h4` id | 見出し | コードブロックの `label` | 中身 |
| --- | --- | --- | --- |
| `p3-4-diff` | diff — 変更の中身を確認する | `diff` | Step 1 の `git diff` 実測出力。`--staged` と `main..feature/memo` も併記 |
| `p3-4-restore` | restore — 変更を元に戻す | `restore` | `git restore README.md` と直後の `git status -s` |
| `p3-4-log` | log — 履歴を確認する | `log` | Step 1 の commit 後の `git log` と `--oneline` |
| `p3-4-pull` | pull — 取得して取り込む | `pull` | Step 2 の pull 出力 |

節の冒頭で、まずファイルを作る操作を書く。

```html
<pre><button class="copy-btn">コピー</button><span class="term-head"><span class="dot"></span><span class="dot"></span><span class="dot"></span><span class="label">2周目をはじめる</span></span><code><span class="pr">$</span> git switch -c feature/memo   <span class="cmt"># 最新の main から新しい枝を切る</span>
<span class="pr">$</span> touch memo.txt                <span class="cmt"># 新しいファイルを作る</span>
<span class="pr">$</span> echo "使い方はここに書きます。" &gt;&gt; README.md   <span class="cmt"># README にも1行足してみる</span></code></pre>
```

4章の `restore` 節（`id="p4-3"`）の本文・図・「捨てた変更は戻せない」の注意を、`p3-4-restore` にそのまま移す。移したあと4章側を消すのは Task 6 で行う。

`p3-4-pull` には、次のワンポイントを置く。現行 `p3-15` 内の「fetch + merge ＝ pull」を統合したもの。

```html
<div class="box tip">
  <div class="box-t"><svg class="ico" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M12 2a7 7 0 0 0-4 12.7V17h8v-2.3A7 7 0 0 0 12 2Z"/><path d="M9 21h6"/></svg>fetch + merge ＝ pull</div>
  <p>サイクル1では <code>git fetch</code> で取ってきて <code>git merge origin/main</code> で取り込む、と2手に分けました。<strong>この2つをまとめたのが <code>git pull</code></strong> です。先に差分を確かめたいときは <code>fetch</code>、そのまま取り込むときは <code>pull</code> と使い分けます。</p>
  <p>なお本書の練習は1人で進めるため、ブランチを切る前の <code>main</code> はいつも最新です。しかし<strong>チームで開発するときは、他の開発メンバーが <code>main</code> を進めています</strong>。作業ブランチを切る前に <code>git switch main</code> → <code>git pull</code> で最新にする習慣をつけてください。</p>
</div>
```

- [ ] **Step 4: サイドバーとTOCカードに1行足す**

サイドバーの `<a href="#p3-3" class="sub">サイクル1 基本の一周</a>` の次に追加する。

```html
      <a href="#p3-4" class="sub">サイクル2 確認と取り消し</a>
```

TOCカードの `toc-children` の末尾に追加する。

```html
 <span class="sep">·</span> <a href="#p3-4">サイクル2 確認と取り消し</a>
```

- [ ] **Step 5: lint とリンク検証を実行する**

Run:
```bash
cd /Users/hideki/development/git-handbook && npm run lint && ./scripts/check-anchors.sh
```

Expected: どちらも成功

- [ ] **Step 6: コミットする**

```bash
git add git-handbook.html
git commit -m "実践章にサイクル2（diff・restore・log・pull）を追加"
```

---

### Task 4: サイクル3 を追加する

**Files:**
- Modify: `git-handbook.html`（`id="p3-4"` の節の直後に挿入）
- Modify: `git-handbook.html` サイドバーとTOCカード

**Interfaces:**
- Consumes: Task 3 の `p3-4` 節
- Produces: `id="p3-5"` と `h4` 群 `p3-5-ignore` `p3-5-rmcached`

- [ ] **Step 1: サイクル3のコマンドを実行し、出力を採取する**

Run:
```bash
cd /Users/hideki/development/git-practice-repo
git switch -c feature/ignore
echo "secret" > secret.txt
git status -s
printf 'secret.txt\n*.log\n' > .gitignore
cat .gitignore
git status -s
echo "SECRET_KEY=12345" > .env
git add .env && git commit -m "設定を追加"
echo ".env" >> .gitignore
echo "KEY=xyz" >> .env
git status -s
git rm --cached .env
git status -s
git add .
git commit -m ".gitignore を追加して .env の追跡を外す"
git status -s
git push -u origin feature/ignore
```

採取の際は、旧版が誤っていた次の3点を必ず確認する。

- `echo "secret" > secret.txt` の直後の `git status -s` には `?? secret.txt` だけでなく、その時点の他の行もすべて出る
- `.gitignore` を作った直後も同様で、「`.gitignore` だけが残る」わけではない
- `git rm --cached .env` の直後は `D  .env` が出る。これはステージされた削除で、コミットするまで確定しない

- [ ] **Step 2: PR を作ってマージし、片付けまで実行する**

画面で PR を作成し `Create a merge commit` でマージしたあと:

```bash
cd /Users/hideki/development/git-practice-repo
git switch main
git pull
git branch -d feature/ignore
git push origin --delete feature/ignore
ls -a
```

`ls -a` で `.env` と `secret.txt` が手元に残っていることを確認し、その結果を本文の根拠にする。

- [ ] **Step 3: サイクル3の節を書く**

`p3-4` の節の直後に挿入する。

```html
<h3 id="p3-5">サイクル3 — 管理から外す</h3>
<p>3周目の題材は <code>.gitignore</code> です。プロジェクトには、Git で管理したくないファイルがあります。パスワードや API キーを書いた秘密の設定ファイル、自動で作られるログやビルド結果などです。これらを Git の目から外す方法と、<strong>うっかりコミットしてしまったあとの外し方</strong>を扱います。</p>
```

`h4` は2つ。

| `h4` id | 見出し | コードブロックの `label` | 中身 |
| --- | --- | --- | --- |
| `p3-5-ignore` | ignore — Git に含めないファイルを決める | `ignore` | Step 1 前半。`.gitignore` の**作成コマンドを必ず書く** |
| `p3-5-rmcached` | rm --cached — 追跡だけをやめる | `追跡を解除する` | Step 1 後半。`D  .env` とその後の commit まで |

`p3-5-ignore` のコードブロックは次の形にする。`printf` で `.gitignore` を作る行を省かないこと。

```html
<pre><button class="copy-btn">コピー</button><span class="term-head"><span class="dot"></span><span class="dot"></span><span class="dot"></span><span class="label">ignore</span></span><code><span class="pr">$</span> echo "secret" &gt; secret.txt      <span class="cmt"># 秘密情報のつもりのファイルを作る</span>
<span class="pr">$</span> git status -s
<span class="out"><span class="hl">??</span> secret.txt</span>                     <span class="cmt"># untracked として現れる</span>

<span class="pr">$</span> printf 'secret.txt\n*.log\n' &gt; .gitignore   <span class="cmt"># 無視したいパターンを書く</span>
<span class="pr">$</span> cat .gitignore
<span class="out">secret.txt</span>
<span class="out">*.log</span>

<span class="pr">$</span> git status -s
<span class="out"><span class="hl">??</span> .gitignore</span>                     <span class="cmt"># secret.txt が消えた</span></code></pre>
```

`p3-5-rmcached` には、`D  .env` の意味を説明する段落を必ず入れる。

```html
<p><code>git rm --cached</code> を実行すると、<code>git status -s</code> に <code>D  .env</code> が現れます。<strong>これは「削除がステージされた」状態</strong>です。ファイルそのものは手元に残っていますが、Git の記録から外す準備ができた、という意味です。<strong>この削除もコミットして、はじめて追跡解除が確定します</strong>。</p>
```

「すでに追跡中のファイルは無視されない」の注意（現行 `p3-6` 内）はそのまま移す。

- [ ] **Step 4: サイドバーとTOCカードに1行足す**

サイドバー:

```html
      <a href="#p3-5" class="sub">サイクル3 管理から外す</a>
```

TOCカードの `toc-children` 末尾:

```html
 <span class="sep">·</span> <a href="#p3-5">サイクル3 管理から外す</a>
```

- [ ] **Step 5: lint とリンク検証を実行する**

Run:
```bash
cd /Users/hideki/development/git-handbook && npm run lint && ./scripts/check-anchors.sh
```

Expected: どちらも成功

- [ ] **Step 6: コミットする**

```bash
git add git-handbook.html
git commit -m "実践章にサイクル3（.gitignore と rm --cached）を追加"
```

---

### Task 5: サイクル4 を追加する

**Files:**
- Modify: `git-handbook.html`（`id="p3-5"` の節の直後に挿入）
- Modify: `git-handbook.html` サイドバーとTOCカード

**Interfaces:**
- Consumes: Task 4 の `p3-5` 節
- Produces: `id="p3-6"` と `h4` 群 `p3-6-branches` `p3-6-conflict` `p3-6-resolve`

- [ ] **Step 1: コンフリクトを発生させ、出力を採取する**

Run:
```bash
cd /Users/hideki/development/git-practice-repo
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

両方の PR を画面で作成し、**`feature/greeting-ja` の PR だけ**をマージする。`feature/greeting-en` の PR 画面がコンフリクト表示に変わることを確認する（反映に十数秒かかる）。その後:

```bash
cd /Users/hideki/development/git-practice-repo
git switch main
git pull
git switch feature/greeting-en
git merge main
git status
git status -s
cat README.md
```

実測済みの参考値:

```
$ git merge main
Auto-merging README.md
CONFLICT (content): Merge conflict in README.md
Automatic merge failed; fix conflicts and then commit the result.

$ git status
On branch feature/greeting-en
You have unmerged paths.
  (fix conflicts and run "git commit")
  (use "git merge --abort" to abort the merge)

Unmerged paths:
  (use "git add <file>..." to mark resolution)
	both modified:   README.md

$ git status -s
UU README.md

$ cat README.md
# Git 練習リポジトリ

<<<<<<< HEAD
Hello
=======
こんにちは
>>>>>>> main
```

**`HEAD` 側が自分のブランチ（`Hello`）、下が取り込む側（`こんにちは`）**であることを確認する。現行4章の図は上下が逆になっているため、そのまま流用してはいけない。

- [ ] **Step 2: 解消して出力を採取する**

Run:
```bash
cd /Users/hideki/development/git-practice-repo
printf '# Git 練習リポジトリ\n\nこんにちは\nHello\n' > README.md
git add README.md
git status -s
git commit -m "コンフリクトを解消"
git push
```

実測済みの参考値:

```
$ git add README.md
$ git status -s
M  README.md

$ git commit -m "コンフリクトを解消"
[feature/greeting-en 88ee7a3] コンフリクトを解消
```

マージコミットのため `N file changed` の行は出ない。

- [ ] **Step 3: サイクル4の節を書く**

`p3-5` の節の直後に挿入する。

```html
<h3 id="p3-6">サイクル4 — コンフリクト</h3>
<p>最後は、チーム開発で必ず出会う<strong>コンフリクト（競合）</strong>です。2人が同じファイルの同じ行を別々に書き換えると、Git はどちらが正しいか判断できず、手で決めてほしいと言って止まります。ここでは、わざと競合を起こして、自分の手で解消するところまでやります。</p>
```

`h4` は3つ。

| `h4` id | 見出し | コードブロックの `label` | 中身 |
| --- | --- | --- | --- |
| `p3-6-branches` | 2本のブランチで同じ行を変える | `2本の枝を作る` | Step 1 前半。両方コミットまで進める |
| `p3-6-conflict` | コンフリクトを起こす | `merge` / `status` | Step 1 後半の merge と status。`pr-conflict.png` をここに置く |
| `p3-6-resolve` | 競合マーカーを解消する | `README.md の中身` / `解消してコミット` | Step 1 の `cat README.md` と Step 2 |

`p3-6-branches` には、両方をコミットしておく理由を書く。

```html
<p>ここで大事なのは、<strong>両方のブランチでコミットまで済ませておく</strong>ことです。変更をコミットしていないまま <code>git merge</code> を実行すると、Git は作業中の変更が失われるのを避けるため、マージそのものを拒否します。</p>
```

`p3-6-conflict` の図:

```html
<figure>
  <img src="pr-conflict.png" alt="PR画面のコンフリクト表示。This branch has conflicts that must be resolved と競合ファイル README.md が示され、Merge pull request ボタンが押せなくなっている">
  <figcaption>先に片方がマージされると、もう片方の PR は競合状態になる。<code>Merge pull request</code> ボタンは<strong>押せなくなる</strong>。競合ファイル名（<code>README.md</code>）もここに出る。</figcaption>
</figure>
```

`p3-6-resolve` には、マーカーの読み方を実測どおりに書く。

```html
<p>競合したファイルを開くと、次の3行の<strong>競合マーカー</strong>が入っています。<code>&lt;&lt;&lt;&lt;&lt;&lt;&lt; HEAD</code> から <code>=======</code> までが<strong>今いる自分のブランチ</strong>の内容、<code>=======</code> から <code>&gt;&gt;&gt;&gt;&gt;&gt;&gt; main</code> までが<strong>取り込もうとしている相手</strong>の内容です。</p>
<p>最終的に残したい形に手で書き直し、<strong>マーカーの3行は必ず消します</strong>。今回は両方のあいさつを残すことにします。</p>
```

現行4章のコンフリクト節にある「同じ行を両側で変えると Git は止まる」の図は、上下の対応を実測に合わせて描き直したうえで `p3-6-conflict` に置く。図の HEAD 側を `Hello`（`feature/greeting-en`）、相手側を `こんにちは`（`main`）にする。

節の末尾に、章全体を締めるワンポイントを置く。

```html
<div class="box tip">
  <div class="box-t"><svg class="ico" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M12 2a7 7 0 0 0-4 12.7V17h8v-2.3A7 7 0 0 0 12 2Z"/><path d="M9 21h6"/></svg>4周おつかれさまでした</div>
  <p>ここまでで、<strong>ブランチを切る → 変更する → 確認する → 記録する → 共有する → PR を出す → マージする → 手元を最新にする → 片付ける</strong>という開発の一周を、4回くり返しました。日々の開発は、このくり返しです。迷ったら、まず <code>git status</code> で今の状態を確かめてください。</p>
</div>
```

- [ ] **Step 4: サイドバーとTOCカードに1行足す**

サイドバー:

```html
      <a href="#p3-6" class="sub">サイクル4 コンフリクト</a>
```

TOCカードの `toc-children` 末尾:

```html
 <span class="sep">·</span> <a href="#p3-6">サイクル4 コンフリクト</a>
```

- [ ] **Step 5: lint とリンク検証を実行する**

Run:
```bash
cd /Users/hideki/development/git-handbook && npm run lint && ./scripts/check-anchors.sh
```

Expected: どちらも成功

- [ ] **Step 6: コミットする**

```bash
git add git-handbook.html
git commit -m "実践章にサイクル4（コンフリクトの発生と解消）を追加"
```

---

### Task 6: 4章から restore とコンフリクトを削除して再採番する

**Files:**
- Modify: `git-handbook.html`（`id="p4-3"` の節、`id="p4-7"` の節、および `p4-4` 以降の id）
- Modify: `git-handbook.html` サイドバーとTOCカードの4章部分

**Interfaces:**
- Consumes: Task 3 の `p3-4-restore` と Task 5 の `p3-6-*`。両方が実践章に存在していることが前提
- Produces: 4章の id が `p4-1`〜`p4-9` の連番になる

- [ ] **Step 1: 実践章に移設済みであることを確認する**

Run:
```bash
cd /Users/hideki/development/git-handbook
grep -c 'id="p3-4-restore"' git-handbook.html
grep -c 'id="p3-6-resolve"' git-handbook.html
```

Expected: どちらも `1`。`0` の場合は Task 3 か Task 5 が未完了なので、そちらを先に終わらせる

- [ ] **Step 2: 4章の restore 節を削除する**

`<h3 id="p4-3">restore — 変更を元に戻す</h3>` の行から、次の `<h3 id="p4-4">` の直前までを削除する。

- [ ] **Step 3: 4章のコンフリクト節を削除する**

`<h3 id="p4-7">コンフリクト — 競合が起きる仕組みと対処</h3>` の行から、次の `<h3 id="p4-8">` の直前までを削除する。

- [ ] **Step 4: 4章の id を繰り上げる**

削除後の並びに合わせて、`h3` の id を上から順に連番へ振り直す。対応は次のとおり。

| 見出し | 旧 id | 新 id |
| --- | --- | --- |
| HEAD — 今いる位置を知る | `p4-1` | `p4-1` |
| 直前のコミットをやり直す `git commit --amend` | `p4-2` | `p4-2` |
| revert — 履歴を残して打ち消す | `p4-4` | `p4-3` |
| reset — HEAD を巻き戻す | `p4-5` | `p4-4` |
| stash — 作業を一時退避する | `p4-6` | `p4-5` |
| タグ | `p4-8` | `p4-6` |
| `git clone --shared` | `p4-9` | `p4-7` |
| `git worktree` — 複数ブランチを同時に開く | `p4-10` | `p4-8` |
| エイリアスを設定する | `p4-11` | `p4-9` |

- [ ] **Step 5: 4章の導入文を直す**

4章冒頭の段落から `restore` と コンフリクト への言及を外す。現行は「さらに<strong>コンフリクトの解決</strong>、リリースの<strong>タグ</strong>、<strong>worktree</strong> なども取り上げます。」となっているので、次に置き換える。

```html
<p>ここからは一歩進んだ内容です。<strong>HEAD</strong> の仕組み、<strong>やり直しと取り消し(amend / revert / reset)</strong>、作業の<strong>一時退避(stash)</strong>を扱います。さらにリリースの<strong>タグ</strong>や <strong>worktree</strong> なども取り上げます。これらは実務でいずれ必要になる操作です。実践章の内容に慣れてから読むのがおすすめです。</p>
```

- [ ] **Step 6: サイドバーとTOCカードの4章部分を更新する**

サイドバーから `restore` と `コンフリクト` の行を削除し、残る9項目の `href` を新しい id に合わせる。TOCカードの4章の `toc-children` も同様に、`restore` と `コンフリクト` を除いた9項目にする。

- [ ] **Step 7: 巻末のコマンド一覧表のリンクを直す**

Run:
```bash
grep -n 'href="#p4-' git-handbook.html
```

出力された `href` のうち、Step 4 で番号が変わったものを新しい id に書き換える。`restore` の行は表に残したまま、リンク先を `#p3-4-restore` に向ける。

- [ ] **Step 8: lint とリンク検証を実行する**

Run:
```bash
cd /Users/hideki/development/git-handbook && npm run lint && ./scripts/check-anchors.sh
```

Expected: どちらも成功。ここで NG が出るのは Step 4 の再採番漏れなので、指摘された `href` を修正する

- [ ] **Step 9: コミットする**

```bash
git add git-handbook.html
git commit -m "発展章から restore とコンフリクトを削除し実践章へ一本化"
```

---

### Task 7: 通し検証と仕上げ

**Files:**
- Modify: `git-handbook.html`（不一致が見つかった場合のみ）
- Modify: `practice-commands.md`（4サイクル構成に合わせて更新）

**Interfaces:**
- Consumes: Task 1〜6 のすべて

- [ ] **Step 1: 練習リポジトリを空の状態から作り直す**

Run:
```bash
cd /Users/hideki/development
rm -rf git-practice-repo
mkdir git-practice-repo && cd git-practice-repo
git init -q
echo "# git-practice-repo" > README.md
git add README.md && git commit -q -m "最初のコミット"
git remote add origin git@github.com:watanabehideki/git-practice-repo.git
git branch -M main
git push -u --force origin main
for b in $(git ls-remote --heads origin | sed 's|.*refs/heads/||' | grep -v '^main$'); do
  git push origin --delete "$b" -q
done
```

- [ ] **Step 2: 準備からサイクル4まで、本文だけを見て打ち切る**

`git-handbook.html` をブラウザで開き、3章の頭から順に、**本文に書かれているコマンドだけ**を打つ。途中で「本文に書かれていない操作が必要になった」場合、それが Global Constraints の1つ目に違反している箇所なので、その操作をコマンドとして本文に追記する。

各コマンドの出力が掲載内容と一致するかを1つずつ照合し、違っていたら本文を実測値に直す。

- [ ] **Step 3: リンクと lint を最終確認する**

Run:
```bash
cd /Users/hideki/development/git-handbook
npm run lint && ./scripts/check-anchors.sh
```

Expected: どちらも成功

- [ ] **Step 4: 画像が表示されることを確認する**

Run:
```bash
cd /Users/hideki/development/git-handbook
grep -o 'src="[^"]*\.png"' git-handbook.html | sed 's/src="//;s/"//' | sort -u | while read -r f; do
  [ -f "$f" ] && echo "OK  $f" || echo "NG  $f が見つかりません"
done
```

Expected: 5行すべて `OK`

そのうえでブラウザで3章を開き、5枚の画像が枠線付きで表示され、図番号が連番になっていることを目視で確認する。

- [ ] **Step 5: `practice-commands.md` を4サイクル構成に更新する**

`practice-commands.md` は旧17節構成のコマンド順に並んでいる。Task 2〜5 で実測した順に並べ替え、各サイクルの見出しを付ける。本文と重複する説明は削り、コマンドと実測出力だけを残す。

- [ ] **Step 6: コミットする**

```bash
git add git-handbook.html practice-commands.md
git commit -m "実践章の4サイクル構成を通しで検証し、出力を実測値にそろえる"
```

---

## Self-Review

**1. Spec coverage**

| 仕様書の項目 | 対応タスク |
| --- | --- |
| 準備2節を残す | Task 2（置換範囲を `p3-3` 以降に限定） |
| サイクル1 | Task 2 |
| マージ3方式コラムを2層に | Task 2 Step 4 |
| マージボタンの表示は前回の方式で変わる | Task 2 Step 4 の `box stumble` |
| サイクル2 | Task 3 |
| 冒頭に `pull` を置かない／習慣は `p3-4-pull` で明示 | Task 3 Step 3 のワンポイント |
| サイクル3 | Task 4 |
| `D .env` の説明 | Task 4 Step 3 |
| サイクル4 | Task 5 |
| 競合マーカーの上下を実測に合わせる | Task 5 Step 1 と Step 3 |
| `restore` を実践章へ一本化 | Task 3 Step 3（移設）＋ Task 6 Step 2（削除） |
| コンフリクトを実践章へ一本化 | Task 5 Step 3（移設）＋ Task 6 Step 3（削除） |
| 「もう一度、変更からコミットまで」を削除 | Task 2 Step 4（置換範囲に含まれる） |
| id 再採番とナビ更新 | Task 2〜6 の各 Step、Task 6 Step 4・6・7 |
| 図版5点 | Task 1 Step 1、Task 2 Step 4、Task 5 Step 3 |
| `figure img` の CSS | Task 1 Step 4 |
| 執筆ルール5項目 | Global Constraints と Task 7 Step 2 |
| 完了条件 | Task 7 Step 2〜4 |

**2. Placeholder scan**

「後で書く」「適宜」「同様に」で済ませた箇所はない。旧版から移す本文は、移設元を id で特定できる形で指定した。

**3. Type consistency**

id の命名は `p3-<節番号>-<コマンド名>` に統一した。Task 2 で作る `p3-3-*`、Task 3 の `p3-4-*`、Task 4 の `p3-5-*`、Task 5 の `p3-6-*` は互いに衝突しない。Task 6 の 4章再採番後に `p4-10` `p4-11` は存在しなくなるため、Task 6 Step 7 で巻末表のリンクを直す手順を入れてある。
