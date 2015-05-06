# はじめに
これは、私が使っているgemなどのインストール方法や設定、使い方などをまとめたものです。
一部のツールについては、設定ファイルをおいてあります。


# 色付きで標準出力する
スクリプト書いていると、よくコンソールに色つきでメッセージを出したくなったりします。
文字列を色付きで表示するには、文字列にエスケープシーケンスを付与します。
書式は以下のとおり。

```console
\033[{属性値}m{文字列}\033[m
```

これをシェルスクリプトとRubyで表示する方法を示します。


## シェルスクリプトで色をつける
echoを標準出力で色付きで表示するメソッド cecho を用意します。

```sh
black=30
red=31
green=32
yellow=33
blue=34
magenta=35
cyan=36
white=37

function cecho {
  color=$1
  shift
  echo -e "\033[${color}m$@\033[m"
}
```

そのメソッドを、シェルスクリプト内で以下のように使います。

```sh
cecho $red 'qwerty asdfgh'
```

詳しい解説は以下のブログを参照ください。

[使いやすいシェルスクリプトを書く | SOTA](http://deeeet.com/writing/2014/05/18/shell-template/)


## Rubyスクリプトで色を付ける
RubyのGemが色々とあるので、その中で好きなのを使ってください。
以下の記事が詳しいです。

[RubyでANSIカラーシーケンスを学ぼう！ - hp12c](http://melborne.github.io/2010/11/07/Ruby-ANSI/)

私は以下のGemを使っています。

[fazibear/colorize · GitHub](https://github.com/fazibear/colorize)

**初期設定**

gemをインストールするだけでOKです。

```console
$ gem install colorize
```

Railsプロジェクト内で利用する場合は、Gemfileに追記してください。

```ruby
gem 'colorize'
```

**使い方**

まず、requireで必要なgemをロードします。
次に、String#colorizeを呼び出します。
第一引数に表示したい色のシンボルを指定します。
すると、指定した文字列の前後に、色を付与するための制御文字が付与されます。
その文字列を、putsなどを用いて標準出力に表示します。

```ruby
require 'colorize'

text = '赤文字で表示'

text.colorize(:red)
# => "\e[0;31;49m赤文字で表示\e[0m"

puts text.colorize(:red)
```

基本的な使い方は以上です。
さらに詳しい使い方は、[fazibear/colorize · GitHub](https://github.com/fazibear/colorize) のReadmeを参照してください。


# git のコミット前に不要なコミットを弾くようにする
gitには、コミット時にフックを用いることができます。
この機能を使うと、例えば、コーディング規約に従っていないコードをコミットできないようにしたりすることができます。
やり方は以下の記事などを参考にしてください。

- [Git - Git フック](http://git-scm.com/book/ja/v1/Git-%E3%81%AE%E3%82%AB%E3%82%B9%E3%82%BF%E3%83%9E%E3%82%A4%E3%82%BA-Git-%E3%83%95%E3%83%83%E3%82%AF)
- [git用のpre-commit gemが便利すぎる|TakiTakeの日記](http://takitake.hatenablog.com/entry/2014/07/27/172151)

今回は、gemとして用意されているpre-commitのコミットフックを利用することにします。

[jish/pre-commit · GitHub](https://github.com/jish/pre-commit)

## 初期設定
コンソールで以下のように入力してください。
対象となるgitリポジトリが複数ある場合は、すべてのリポジトリに対して以下の操作をしてください。

```console
$ gem install pre-commit
$ cd path/to/git_repos
$ pre-commit install
```

この操作により、 git リポジトリの .git/hooks/pre-commit にカスタマイズされた pre-commit ファイルが配置されます。
