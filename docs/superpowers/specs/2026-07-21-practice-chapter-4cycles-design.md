# 実践章「実践しながら学ぶ」4サイクル構成への再設計

- 作成日: 2026-07-21
- 対象: `git-handbook.html` 3章「実践しながら学ぶ」、および 4章「発展」の一部
- 関連: `practice-commands.md`（現行手順の検証結果）

## 背景

現行の3章は「1節＝1コマンド」の辞書的な並びになっており、読み物としては引きやすい構成です。一方、実際に `git-practice-repo` を作って全手順を打った検証では、手を動かす教材として次の問題が確認できました。

- ファイルの作成・編集コマンドが本文に書かれていない（`README.md` の編集、`memo.txt` の作成、`.gitignore` の作成）
- 出力例が抜粋で、実際の画面には出るはずの行が省かれている（ignore 節の「`.gitignore` だけが残る」は事実と異なる）
- `git add .` で4件ステージした直後の commit 出力が `1 file changed` になっており、通しで打つと話が繋がらない
- `git rm --cached .env` の後に現れる `D .env`（ステージ済みの削除）の説明がなく、読者がそこで止まる
- 取り消し操作（`restore`）が4章「発展」にあり、実践中に操作を誤った読者が戻る手段を持たない
- `fetch` + `merge` と `pull` を順に実行させる構成のため、後者が `Already up to date.` になり掲載出力と一致しない

これらは個別に直すこともできますが、原因は共通しています。**コマンド単位で章を割っているため、一本の作業の流れが節をまたいで分断されている**ことです。そこで章全体を、実際の開発サイクルを4周する構成に組み替えます。

## 目的

- 読者が本文のコマンドをそのまま打てば、必ず本書と同じ画面が再現される
- 1周ごとに「ブランチを切ってマージして片付ける」までを完結させ、開発サイクルを体で覚えられるようにする
- 取り消しとコンフリクトという、手を動かすと必ず遭遇する事故を実践章の中で扱う

## 全体構成

準備2節のあと、4つのサイクルで構成します。

| 節 | 内容 | 新しく学ぶコマンド |
| --- | --- | --- |
| 準備1 | config | `git config` |
| 準備2 | リポジトリを用意する / origin とは | `git init` `git clone` `git remote` |
| サイクル1 | 1コミットを最後まで通す | `branch` `switch` `status` `add` `commit` `push` `fetch` `merge` `branch -d` |
| サイクル2 | 確認と取り消し | `diff` `restore` `log` `pull` |
| サイクル3 | 管理から外す | `.gitignore` `rm --cached` |
| サイクル4 | コンフリクト | 競合マーカーの解消 |

各サイクルは同じ骨格をたどります。

```
git switch -c feature/xxx
  → 編集 → git add → git commit → git push
  → PR作成 → 画面でマージ
  → git switch main → 手元へ反映 → git branch -d → git push origin --delete
```

各サイクルは main にいて最新の状態で終わるため、次のサイクルはブランチの作成から始まります。冒頭に `git switch main` と `git pull` は置きません。1人で練習している間は main が他者によって進むことがなく、`pull` を置いても `Already up to date.` としか表示されないためです。

ただしチーム開発では他の開発メンバーが main を進めるので、ブランチを切る前の最新化は必須です。これはサイクル2で `pull` を扱う際に、習慣として本文で明示します。

## サイクル1 — 1コミットを最後まで通す

- 題材: `README.md` の見出しを書き換える
- ブランチ: `feature/readme`

全コマンドを実測出力付きで記載します。この章で唯一、定型部分を省略しない節です。

| 順 | コマンド | 扱う内容 |
| --- | --- | --- |
| 1 | `git branch` / `git branch -a` | 現在地の確認、ブランチの3種類 |
| 2 | `git switch -c feature/readme` | 作業ブランチの作成、HEAD |
| 3 | `echo "# Git 練習リポジトリ" > README.md` | 編集操作をコマンドで明示 |
| 4 | `git status` / `git status -s` | ファイルの4つの状態、短縮表示の左右列 |
| 5 | `git add README.md` | ステージング |
| 6 | `git commit -m "README の見出しを修正"` | コミットメッセージの書き方 |
| 7 | `git push -u origin feature/readme` | upstream、`git branch -vv` |
| 8 | PR作成 → 画面でマージ | マージ方式はマージコミットに固定 |
| 9 | `git fetch` → `git log --oneline origin/main` → `git switch main` → `git merge origin/main` | リモート追跡ブランチ、2手に分けた取り込み |
| 10 | `git branch -d` / `git push origin --delete` | 片付け |

手順9をローカルで実行すると `Fast-forward` が実際に表示されます。これを直後のコラムへの入口にします。

### コラム: マージの3方式

手順8の直後に置きます。現行の Fast-forward / 3-way / Squash の図と説明をそのまま流用し、次の注意を追記します。

- Squash マージは main 側に別のコミットとして載るため、Git からは未マージに見える
- リモートブランチが削除済みの状態では `git branch -d` が `error: the branch 'xxx' is not fully merged` で失敗する
- PR がマージ済みであることを確認したうえで `git branch -D` を使う

GitHub の画面は「Create a merge commit」「Squash and merge」「Rebase and merge」の3つを提示します。本書の Fast-forward / 3-way / Squash とは分類の軸が違うため、コラムは2層で構成します。上段で画面の3ボタンを示し、下段でそれぞれが Git レベルで何をするかを対応表にします。Rebase and merge は本書では扱わない旨を明記します。

あわせて次の注意を書きます。撮影時に実機で確認した挙動です。

- マージボタンの表示は、そのリポジトリで最後に選んだ方式によって変わる
- 「Squash and merge」と表示されていても、右の `▼` から「Create a merge commit」を選び直せる
- したがって本文では「Merge pull request と書かれたボタンを押す」ではなく「方式を選んでからマージする」と書く

## サイクル2 — 確認と取り消し

- 題材: `memo.txt` を追加する。`README.md` も編集するが、失敗だったので捨てる
- ブランチ: `feature/memo`

新しく学ぶのは `diff` `restore` `log` `pull` です。

`README.md` の編集を「失敗だった」という文脈に置くことで、`restore` を使う必然性を作ります。結果としてコミットするのは `memo.txt` だけになります。

| 順 | コマンド | 扱う内容 |
| --- | --- | --- |
| 1 | `git switch -c feature/memo` | 定型、出力省略 |
| 2 | `touch memo.txt` / `echo ... >> README.md` | 2種類の変更を作る |
| 3 | `git diff` / `--staged` / `main..feature/memo` | 比較対象がオプションで変わること |
| 4 | `git restore README.md` | ワーキングツリーの変更を捨てる |
| 5 | `git restore --staged <file>` | ステージングから外す（アンステージ） |
| 6 | `git add memo.txt` → `git commit` | memo.txt だけを記録する |
| 7 | `git log` / `--oneline` / `--graph --all` | 積み上がった履歴を読む |
| 8 | push → PR → マージ | 定型、出力省略 |
| 9 | `git switch main` → `git pull` | fetch と merge をまとめた1手 |
| 10 | 定型（branch -d / push --delete） | 出力省略 |

手順9が `pull` の初出になります。サイクル1で `fetch` → `merge` と2手で行ったことが1コマンドになる、という対比をそのまま「fetch + merge = pull」の説明にします。現行の同名ワンポイントはここへ統合します。

あわせて、チーム開発では他の開発メンバーが main を進めるため、作業ブランチを切る前に `git switch main` と `git pull` で最新化する習慣が要る、という注意をここに置きます。本書の練習では1人で進めるので冒頭の `pull` を省いている、という事情も添えます。

`restore` には「捨てた変更は戻せない」という現行の注意書きを維持します。

## サイクル3 — 管理から外す

- 題材: `.gitignore`
- ブランチ: `feature/ignore`

| 順 | コマンド | 扱う内容 |
| --- | --- | --- |
| 1 | `git switch -c feature/ignore` | 定型、出力省略 |
| 2 | `echo "secret" > secret.txt` → `git status -s` | untracked として現れることを確認 |
| 3 | `printf 'secret.txt\n*.log\n' > .gitignore` → `git status -s` | secret.txt が消えることを確認 |
| 4 | `.env` を作成してコミット | すでに追跡中のファイルを用意する |
| 5 | `echo ".env" >> .gitignore` → `git status -s` | 追跡済みファイルは無視されない |
| 6 | `git rm --cached .env` → `git status -s` | `D .env` がステージされる |
| 7 | `git commit` | 追跡解除を確定させる |
| 8 | push → PR → マージ → pull → 片付け | 定型、出力省略 |

手順3と手順6が、現行章で読者が止まる2箇所です。手順3では作成コマンドを明示し、手順6では `D .env` が「ステージされた削除」であり、コミットするまで追跡解除が確定しないことを本文で説明します。ファイル自体は手元に残るという現行の記述は維持します。

手順2と手順3の `git status -s` の出力は、その時点で実際に表示される全行を掲載します。

## サイクル4 — コンフリクト

- 題材: `README.md` の同じ行を2つのブランチで別々に編集する
- ブランチ: `feature/greeting-ja` と `feature/greeting-en`

| 順 | コマンド | 扱う内容 |
| --- | --- | --- |
| 1 | main から2本のブランチを作る | 分岐の作り方 |
| 2 | 両ブランチで `README.md` の同じ行を編集し、それぞれコミットする | 競合の下地を作る |
| 3 | `feature/greeting-ja` を push → PR → マージ | 片方を先に main へ入れる |
| 4 | `git switch main` → `git pull` | main を最新化する |
| 5 | `git switch feature/greeting-en` → `git merge main` | ここで CONFLICT が発生する |
| 6 | `git status` | 競合中のファイルを確認する |
| 7 | 競合マーカーを手で編集する | `<<<<<<<` `=======` `>>>>>>>` の読み方 |
| 8 | `git add README.md` → `git commit` | 解決したことを Git に伝える |
| 9 | push → PR → マージ | 3-way マージが実際に起きる |
| 10 | 片付け | 定型、出力省略 |

手順2で `feature/greeting-en` 側もコミットまで進めることが必須です。未コミットの変更があると Git は merge を拒否するため、本文でその理由を明示します。

現行4章のコンフリクト節にある競合マーカーの図と解説は、ここへ移します。

### 実測した出力

この流れは `git-practice-repo` で実際に通してあります。本文にはこの実測値を掲載します。

手順5の `git merge main` は次を出力し、終了コード1で止まります。

```
Auto-merging README.md
CONFLICT (content): Merge conflict in README.md
Automatic merge failed; fix conflicts and then commit the result.
```

手順6の `git status` は `Unmerged paths:` と `both modified: README.md` を示します。`git status -s` では `UU README.md` の2文字が出ます。`U` は unmerged を表し、左右両列が `U` なのは両側で変更されたことを意味します。ファイルの4つの状態の表に `UU` を追記します。

手順7で `README.md` に入るマーカーは次のとおりです。

```
<<<<<<< HEAD
Hello
=======
こんにちは
>>>>>>> main
```

`HEAD` 側が今いる `feature/greeting-en` の内容、`main` 側が取り込もうとしている内容です。**現行4章の図は上下が逆**（HEAD 側が「こんにちは」）になっているため、サイクル4の設定に合わせて描き直す必要があります。解決例は両方を残す形にします。

手順8で `git add` を実行すると `git status -s` の表示は `M  README.md` へ変わります。続く `git commit` は次を出力します。マージコミットのため `N file changed` の行は出ません。

```
[feature/greeting-en 88ee7a3] コンフリクトを解消
```

手順9の push 後、PR は `MERGEABLE` に戻ることを確認済みです。

## 図版（スクリーンショット）

PR の作成とマージは画面操作のため、実機のスクリーンショットを掲載します。`git-practice-repo` の実画面を撮影したもので、ブランチ名とタイトルが本文と一致しています。ユーザー名とアバターは写らない範囲で切り出してあります。GitHub 公式ドキュメントの画像は使わないため、CC BY 4.0 の帰属表示は不要です。

| ファイル | 解像度 | 内容 | 掲載位置 |
| --- | --- | --- | --- |
| `pr-banner.png` | 1720×112 | `feature/readme had recent pushes` と Compare & pull request ボタン | サイクル1 手順8の冒頭 |
| `pr-compare.png` | 2432×452 | Comparing changes、`base: main` ← `compare: feature/readme`、Able to merge | サイクル1 手順8（base と compare の説明） |
| `pr-form.png` | 1606×822 | Add a title / Add a description / Create pull request | サイクル1 手順8（PR作成） |
| `pr-merge.png` | 1548×860 | No conflicts、Merge pull request、方式ドロップダウン展開 | マージ3方式コラムの上段 |
| `pr-conflict.png` | 1560×492 | This branch has conflicts、競合ファイル `README.md`、無効化された Merge ボタン | サイクル4 手順3の後 |

画像はいずれも2倍解像度なので、HTML では `max-width: 100%` で幅を制御し、`alt` に画面の内容を日本語で記述します。

## 既存コンテンツの移動と削除

| 対象 | 現在の位置 | 変更後 |
| --- | --- | --- |
| `restore` 節 | 4章 `p4-3`（1620行付近） | サイクル2へ移動。4章からは削除 |
| コンフリクト節 | 4章 `p4-7`（1763行付近） | サイクル4へ移動。4章からは削除 |
| 「もう一度、変更からコミットまで」節 | 3章 `p3-11`（1323行付近） | 削除。サイクル2以降が役割を担う |
| マージ3方式 | 3章 `p3-14`（1414行付近） | サイクル1直後のコラムへ移動 |
| 「fetch + merge = pull」ワンポイント | 3章 `p3-15` 内 | サイクル2の `pull` 説明へ統合 |
| 巻末のコマンド一覧表 | 付録（1937行付近） | 変更なし。`restore` の行は維持し、リンク先を新しい id に更新 |

## HTML 構造の変更

現行は `<h3 id="p3-1">` から `p3-17` までのフラットな採番で、サイドバー（314行付近）とTOCカード（391行）の2箇所から参照されています。

新しい採番は次のとおりです。

| id | 見出し |
| --- | --- |
| `p3-1` | config |
| `p3-2` | リポジトリを用意する |
| `p3-3` | サイクル1 — 1コミットを最後まで通す |
| `p3-4` | サイクル2 — 確認と取り消し |
| `p3-5` | サイクル3 — 管理から外す |
| `p3-6` | サイクル4 — コンフリクト |

サイクル内の各コマンドは `<h4>` とし、`p3-3-status` のようにサイクル id とコマンド名を繋げた id を振ります。これによりコマンド単位で直接リンクできる現行の利点を残します。

参照箇所の更新は次の3つです。

- サイドバー（314行付近）は6項目に置き換える
- TOCカード（391行）は `toc-title` にサイクル名、`toc-children` にコマンド名を並べる形にし、コマンド名から `h4` の id へリンクする
- 4章の `p4-3` と `p4-7` を削除するため、`p4-4` 以降を繰り上げ、サイドバーとTOCカードの4章側も更新する

## 執筆ルール

この再設計の目的は本文と実際の画面を一致させることなので、次を守ります。

1. **ファイル操作は必ずコマンドで書く。** 地の文で「編集します」と述べるだけにしない
2. **出力はその時点の全行を載せる。** 抜粋する場合は、省略していることが分かる形にする
3. **出力は実測値を使う。** 実装時に `git-practice-repo` で実際に打ち、その結果を貼る。手で書かない
4. **並び順も実測に合わせる。** `git branch` と `git status -s` の一覧は ASCII 順で表示される
5. **定型部分の縮小は、コマンド列を省かない。** 省くのは出力だけとする

## スコープ外

- 1章「Git とは」、2章「基本概念」、付録の構成変更
- 4章のうち `restore` とコンフリクト以外の節（`amend` `revert` `reset` `stash` `タグ` `worktree` など）
- `git-handbook.md` の同期（HTML を正とし、必要なら別作業で追従させる）
- CSS とレイアウトの変更

## 完了条件

- `git-practice-repo` を空の状態から作り直し、準備からサイクル4までを本文どおりに打ち切れる
- 各コマンドの実際の出力が、本文の掲載内容と一致する
- サイドバーとTOCカードのリンクがすべて実在する id を指している
