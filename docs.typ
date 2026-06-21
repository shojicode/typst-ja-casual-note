#import "lib.typ": *
#show: template.with()

#maketitle(
  title: [Typst-ja-casual-note],
  subtitle: [
    ノートテイキングからレポートまで
  ],
  authors: (
    ("Tama", "神戸大学生物学科B1"),
  ),
)

#abstract()[
  このパッケージはTypstで日本語の（主に大学における）ノートやレポートを作成するためのテンプレートです。Battery-includedであることを目指しており、Typstの標準機能の見た目を整えるだけでなく、サードパーティーの定理環境やBetterなコードブロックのデフォルトでのインポートや設定、`abstract`や`maketitle`のようなユーティリティの追加などを行っています。
  
  また、デフォルトのカラースキームに、提供される`colorscheme-formal-patch`を追加で指定したり、自身でTPOに応じたカラースキームを作成することで、フォーマルな文書の作成も可能です。
]


= 使用法
まず、適当な手段でこのパッケージを`import`します。例えば、`@local`（Windowsならば`%APPDATA%\Roaming\typst\packages\local\`）に`ja-casual-note\0.1.0`ディレクトリを作って、その中にこのテンプレートのファイルと`typst.toml`を配置した場合、次のようにしてインポートできます。
```typst
#import "@local/typst-ja-casual-note": *
```
続いて、テンプレートの適用を行います。
```typst
#import "@local/typst-ja-casual-note": *
#show: template.with()
```
この`with()`の引数にいろいろなオプションを指定することで、テンプレートの挙動を変更できます。指定できるオプションは次の通りです。

== `auto-indent`
#tablem()[
  | 引数 | 型 | デフォルト値 |
  | ---- | -- | ------------ |
  | `auto-indent` | `bool` | `true` |
]
本文の段落頭での自動インデントを有効化するかどうかを指定します。例えば、日本語の小説では、段落頭に`「`がくる場合、その段落の頭はインデントされないことが多いですが、`auto-indent`を`true`にしてしまうと、そういった段落もすべてインデントされてしまいます（これはLaTeXでも同様の問題があります）。このオプションを`false`にすると、段落頭のインデントがすべて無効化されるため、そういった問題を回避できます。その場合、段落頭のインデントが必要な場合は手動で全角スペースを挿入してください。

== `major-heading-level`
#tablem()[
  | 引数 | 型 | デフォルト値 |
  | ---- | -- | ------------ |
  | `major-heading-level` | `int` | `3` |
]
見出しの下線などに関する設定です。見出しのレベルがこの値以下であれば、見出しの下に線が引かれるようになります。例えば、`major-heading-level`を`2`に設定した場合、レベル1とレベル2の見出しの下には線が引かれますが、レベル3の見出しの下には線が引かれません。

== `thmbox-settings`
#tablem()[
  | 引数 | 型 | デフォルト値 |
  | ---- | -- | ------------ |
  | `thmbox-settings` | `dictionary` | `(counter-level: 2, breakable: true)` |
]
定理環境の設定を指定します。`counter-level`は定理環境のカウンターのレベルを指定するもので、例えば`2`を指定すると、定理環境の番号が「定理1.1」のようになります。`breakable`は定理環境がページを跨いで分割されることを許可するかどうかを指定するものです。定理が長くなってしまう場合などに、ページを跨いで定理環境が分割されることを許可したくない（定理環境が分割されるくらいなら改ページしてほしい）場合は、`breakable`を`false`に設定してください。

== `colorscheme`
#tablem()[
  | 引数 | 型 | デフォルト値 |
  | ---- | -- | ------------ |
  | `colorscheme` | `dictionary` | `colorscheme`（このパッケージで定義されているデフォルトのカラースキーム） |
]
文書全体のカラースキームを指定します。デフォルトでは、このパッケージで定義されているカラースキームが使用されます。次のようなフィールドを持つ`dictionary`を定義することで、自身でカラースキームを定義することもできます。

#tablem()[
| フィールド | 説明 |
| ---------- | ---- |
| `background` | 文書の背景色を指定します。 |
| `text` | 本文の文字色を指定します。 |
| `accent` | 強調などに使用されるアクセントカラーを指定します。 |
]
コールアウトの色や定理環境の色などを変えることは、今のところできません。ご自身でラップしていただく必要があります。

`colorscheme`に、`colorscheme+colorscheme-formal-patch`を指定することで、このパッケージで定義されているフォーマルな文書向けのカラースキームを使用することもできます。`colorscheme-formal-patch`の実態は`accent`を`tex-t`と同じ色にすることなので、自身でカラースキームを定義する際には`accent`を`text`と同じ色にすることで同様の効果が得られます。

= 定理環境
このパッケージでは、定理環境を使用するためのサードパーティー製のパッケージである`thmbox`がデフォルトでインポートされており、日本語向けにラッピングしています。用意されている定理環境は次の通り：

== `theorem`
#theorem()[三平方の定理][
  直角三角形の斜辺の長さの二乗は、他の二辺の長さの二乗の和に等しい。
]

== `definition`
#definition()[正方形][
  正方形とは、四つの辺の長さがすべて等しく、四つの角がすべて直角である四辺形のことである。
]

== `proposition`
#proposition()[][
  任意の自然数$n$に対して$n$が偶数であれば、$n^2$も偶数である。
]<proposition>

== `proof`
#proof()[
  $n$が偶数であると仮定する。すると、$n$は$2k$（$k$は整数）と表せる。したがって、$n^2 = (2k)^2 = 4k^2 = 2(2k^2)$となり、$n^2$も偶数である。
]

== `lemma`
#lemma()[ユークリッドの互除法][
  二つの自然数の最大公約数は、それらの差の最大公約数に等しい。
]

== `corollary`
#corollary()[4は偶数][
  @proposition が成り立つことより、4は偶数である。
]

== `example`
#example()[モノイド][
  実数全体の集合$RR$と、その上の通常の加法$+ : RR times RR -> RR$の組は、モノイドをなす。

  #proof()[
    加法の定義より、実数の加法は結合律：
    $
      forall x, y, z in RR,
      (x + y) + z = x + (y + z)
    $
    を満たす。また、単位元をもつ：
    $
      exists 0 in RR,
      forall x in RR,
      0 + x = x + 0 = x
    $
    以上より、実数全体の集合$RR$と、その上の通常の加法$+$の組は、モノイドをなす。
  ]
]

== `remark`
#remark()[解の公式][
  二次方程式$a x^2 + b x + c = 0 quad  (a != 0)$の解の公式
  $
    x = (-b ± sqrt(b^2 - 4a c)) / (2a)
  $
  は、$a=0$のときにのみ適用できる。
]

== `note-thmbox`
#note-thmbox()[より詳しい説明][
  二次方程式の解の公式は、平方完成を用いて導出される。
]

== `exercise`
#exercise()[二次方程式の解の公式の導出][
  $a x^2 + b x + c = 0 (a != 0)$ の解の公式を、平方完成を用いて導出せよ。
]

== `algorithm`
#algorithm()[ユークリッドの互除法][
  1. 二つの自然数$a$と$b$を入力とする。
  2. $a$が$b$より大きい場合、$a$を$a - b$に置き換える。そうでない場合、$b$を$b - a$に置き換える。
  3. $a$と$b$が等しくなるまで、ステップ2を繰り返す。
  4. $a$（または$b$）が最大公約数である。
]

== `claim`
#claim()[][
  任意の自然数$n$に対して、
  $n$が偶数であれば、$n^2$も偶数である。
]

== `axiom`
#axiom()[選択公理][
  任意の非空集合族に対して、各集合からちょうど一つの要素を選ぶ関数が存在する。
]

詳細は#link("https://typst.app/universe/package/thmbox/")を参照。

= コールアウト
コールアウトと言いながら、文書全体で統一されたデザインの汎用タイトル付きボックス、というべきものが提供されます。デフォルトのコールアウトは次の通り：
#callout(title: "コールアウト")[#lorem(25)]
```typst
#callout(title: "コールアウト")[#lorem(25)]
```

いくつかのコールアウトはプリセットとして用意されています。

#warning()[
  これは警告です。
]
```typst
#warning()[
  これは警告です。
]
```

#caution()[
  これは注意です。
]
```typst
#caution()[
  これは注意です。
]
```

#note()[
  これはノートです。
]

```typst
#note()[
  これはノートです。
]
```

#success()[
  これは成功した内容などを表すコールアウトです。
]
#codly(breakable: false)
```typst
#success()[
  これは成功した内容などを表すコールアウトです。
]
```

#important()[
  これは重要な内容を表すコールアウトです。
]
```typst
#important()[
  これは重要な内容を表すコールアウトです。
]
```
`important`コールアウトの`level`引数に、`1`から`3`までの整数を指定することで、重要度を表すことができます。`3`が最も重要です。
#important(level: 2)[
  これは最も重要な内容を表すコールアウトです。
]

#important(level: 3)[
  これは最も重要な内容を表すコールアウトです。
]

= コードブロック
このパッケージでは、コードブロックのために`codly`パッケージがデフォルトでインポートされており、コードブロックの見た目が整えられています。コードブロックは次のようにして使用できます。
````typst
```python
def fizzbuzz(n):
    for i in range(1, n+1):
        if i % 3 == 0 and i % 5 == 0:
            print("FizzBuzz")
        elif i % 3 == 0:
            print("Fizz")
        elif i % 5 == 0:
            print("Buzz")
        else:
            print(i)
```
````
これは、
```python
def fizzbuzz(n):
    for i in range(1, n+1):
        if i % 3 == 0 and i % 5 == 0:
            print("FizzBuzz")
        elif i % 3 == 0:
            print("Fizz")
        elif i % 5 == 0:
            print("Buzz")
        else:
            print(i)
```
のように表示されます。

ちなみに、コードブロックの言語に`c`を指定すると、codlyのバグで言語が`vim`として表示されます。シンタックスハイライトはおそらく正常です。

`codly`パッケージの詳細は#link("https://typst.app/universe/package/codly/")を参照。

= その他
== `maketitle`
簡便に表題・サブタイトル・著者とその所属・日付をまとめて表示するためのユーティリティです。
```
#maketitle(
  title: [タイトル],
  subtitle: [サブタイトル],
  authors: (
    ("タイプスト太郎", "K戸大学"),
    ("タイプスト次郎", "K戸大学"),
  ),
  date: [2024年6月1日],
)
```
のように書くことで、
#maketitle(
  title: [タイトル],
  subtitle: [サブタイトル],
  authors: (
    ("タイプスト太郎", "K戸大学"),
    ("タイプスト次郎", "K戸大学"),
  ),
  date: [2024年6月1日],
)
と表示されます。`date`引数を省略すると、自動でその日の日付が挿入されます。日付を挿入したくない場合は、`none`を指定してください。

このほか、`serif-title`や`affiliation-footnote`というオプションがあります。`serif-title`を`true`にすると、タイトルとサブタイトルがセリフ体になります。`affiliation-footnote`を`true`にすると、著者の所属が、著者の下ではなく、脚注として表示されます。
```typst
#maketitle(
  title: [タイトル],
  subtitle: [サブタイトル],
  authors: (
    ("タイプスト太郎", "K戸大学"),
    ("タイプスト次郎", "K戸大学"),
  ),
  date: [2024年6月1日],
  serif-title: true,
  affiliation-footnote: true,
)
```
#maketitle(
  title: [タイトル],
  subtitle: [サブタイトル],
  authors: (
    ("タイプスト太郎", "K戸大学"),
    ("タイプスト次郎", "K戸大学"),
  ),
  date: [2024年6月1日],
  serif-title: true,
  affiliation-footnote: true,
)

== `today`
今日（コンパイルした日）の日付を表示するためのユーティリティです。`#today()`と書くことで、今日の日付が挿入されます。

== `abstract`
簡便にアブストラクトを表示するためのユーティリティです。

```typst
#abstract()[
  これはアブストラクトです。
]
```
#abstract()[
  これはアブストラクトです。
]
もし、タイトルを"Abstract", "要旨"のように変更したい場合は、`title`引数を指定してください。
```typst
#abstract(title: "Abstract")[
  これはアブストラクトです。
]
```
#abstract(title: "Abstract")[
  これはアブストラクトです。
]

== `hr`
Markdownの`---`やHTMLの`<hr>`のように、区切りが欲しいけどセクションは変えたくないときなどに使用できる水平線を表示するためのユーティリティです。`#hr`と書くことで、水平線
#hr
が挿入されます。

== `tablem`
次のような、Markdown形式の表：
```
| A | B |
|---|---|
| 1 | 2 |
| 3 | 4 |
```
をそのままTypstで使用できるようにするためのパッケージをデフォルトでインポートしています。
```typst
#tablem()[
  | A | B |
  |---|---|
  | 1 | 2 |
  | 3 | 4 |
]
とすることで、
```
#tablem()[
  | A | B |
  |---|---|
  | 1 | 2 |
  | 3 | 4 |
]
のように表示されます。
詳細は#link("https://typst.app/universe/package/tablem/")を参照。

== `comb`と`perm`
Typstの標準機能では、組み合わせの記号$comb(n, k)$や順列の記号$perm(n, k)$を簡単に書くことができません。そこで、このパッケージでは、次のような簡便な関数を提供しています。
```typst
$comb(n, k)$　$perm(n, k)$
```
とすることで、
$comb(n, k)$　$perm(n, k)$

のように表示されます。