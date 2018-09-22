## AutoCADの拡張コマンドと作図環境を管理
自分の本流となる作図環境をGitHubで管理する。
# 設定手順

1. 圧縮ファイルをダウンロードする。

2. サポートファイルの検索パスの設定
	optionコマンド実行

	📂otools-master

	📂otools-master\command

	以上を追加する。

3. acaddoc.txt の拡張子の txt を変更して acaddoc.lsp とする。



	既にacaddoc.lspを活用しているのであれば、acaddoc.lsp内に次の一文を追記する。

		(load "otools.lsp" nil)

	コマンド名はotools.lsp内参照

	必要に応じて次の一文を追記する

		(load "settings.lsp" nil)

3. dwgファイルをを開くか新規ファイルを開く。
***

# 内容
## 拡張Autolispコマンドの追加



汎用的な拡張コマンドの追加

コマンドの登録用ファイル


otools.lsp

コマンドの定義ファイル

.\command フォルダ内

***
## システム変数の設定

作図する際の一般的な設定

settings.lsp

ハードウェアに余分な負荷をかけないよう調整するための設定

***
## 短縮コマンドの追加

settings.lsp

既定のコマンドの短縮コマンド名の定義

拡張したコマンドの短縮コマンド名の定義
***
## UTF-8読み込み関数

このリポジトリに含まれるAutolispファイルは文字コードUTF-8で保存されている為UTF-8専用の関数でロードする必要がある。

UTF-8はASCIIと互換があるため1Byteコードのみで書かれたものは load関数で問題なく読み込まれる。

日本語や記号等UTF-8の2Byte以上のコードが含まれたファイルは正しく読み込まれない。

UTF-8の2~4Byte文字をUnicode符号位置に変換しロードする。

## utf8loader.lsp

### utf8load 関数
UTF-8を想定しファイルをデコードしロードする。

	(utf8load "example.lsp")

もしUTF-8エンコーディングが不正だと判断したら、load関数でロードを試みる。

### utf8demandload 関数
コマンドが実行されたとき随時ファイルを読み込む関数を定義する。

	(utf8demandload "example.lsp" '(c:example))

内部的にはコマンド実行時utf8load関数を呼び出し、読み込まれたファイル内の同一のコマンド関数を再度呼び出している。
同様の関数にautoload関数があるがutf8には対応していない。



