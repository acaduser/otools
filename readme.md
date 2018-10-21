## AutoCADの拡張コマンドと作図環境を管理

## 設定手順

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

第1引数はファイル名。load関数のような拡張子の暗黙付加はしない。

理由は拡張子に意味をなさない。

第2引数は評価可能なリストとする。

内部的にはコマンド実行時utf8load関数を呼び出し、読み込まれたファイル内の同一のコマンド関数を再度呼び出している。

同様の関数にautoload関数があるがutf8には対応していない。

------
# 拡張コマンド



## alignmentText.lsp

* alignmentText

	文字オブジェクトの基点をプロパティパレットで変更したときと同等の振る舞いのコマンド。

	

-------

## angBlock.lsp

* angBlock

	ブロック参照の角度を2点指示で変更。

------

## angHatch.lsp

* angHatch

	ハッチングの回転角度を2点指示で変更。

-------

## angText.lsp

* angText

	文字オブジェクトの回転角度を2点指示で変更。
	

------

## bgcCtrl.lsp

* bgcCtrl

	現在の背景色を0~255のモノトーン階調に変更。

	

------

## changeLayer.lsp

* changeLayer

	選択したオブジェクトを別画層に変更する。

------

## chByLayerColor.lsp

* chByLayerColor

	選択したオブジェクトのByLayer色を変更ずる。

------

## copyText.lsp

* copyText

	文字オブジェクトの文字列内容をコピーする。

------
## easyBlock.lsp

* easyBlock

	簡易ブロック化

## easyExtend.lsp

* easyExtend

	境界オブジェクトを必要としない、任意の2点指示まで延長する。

------

## exchangeText.lsp

* exchangeText

	文字オブジェクトの文字列内容の交換。

------

## extEditor.lsp

* extEditor

	複数文字列の外部編集

------

## grip.lsp

* grip

	オブジェクトをグリップ状態にする。
	
	

------

## hatchMove.lsp

* hatchMove

	ハッチオブジェクトのパターンを2点指示で相対的に移動する。

------

## layRev.lsp

* layRev

	画層状態反転。グリップ状態は維持。

------

## layStdCtr.lsp

1. layAllOn

	画層全表示。グリップ状態は維持。

2. layAllOff

	現在の画層以外を非表示にする。グリップ状態は維持。

3. laySSOn

	選択した複数オブジェクトの画層のみを表示状態にする。

4. laySSOff

	選択した複数オブジェクトの画層を非表示にする。

5. layPickNestOn

	選択した単一オブジェクトの画層のみを表示状態にする。

6. layPickNestOff

	選択した単一オブジェクトの画層を非表示状態にする。
	

-------

## parallelogram.lsp

* parallelogram

	3点指示長方形作図。

-------

## pviewportLock.lsp

* pviewportLock

	図面内のすべてのビューポートのロック状態変更。

-------

	
## pviewportPan

* pviewportPan

	レイアウト内の複数ビューポートの表示範囲を相対移動。

-------

	
## pviewportModel

* pviewpotToModel

	レイアウト内の複数ビューポートの表示範囲をモデル空間にポリライン作図。
	

-------


## srtObj.lsp

* srtObj

	オブジェクトを境界に整列。

-------

	
## stackCopy.lsp

* stackCopy

	オブジェクトを等間隔にマウスホバーでコピー。
	

-------



	


