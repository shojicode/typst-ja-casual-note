// Battery-included Typst template for casual writing and note-taking in Japanese

#let colorscheme = (
  background: rgb("#f6fafa"),
  text: rgb("#041010"),
  // headings / general accent
  accent: rgb("#1e7474"),

  // for callouts
  warning: rgb("#c94a4a"),
  caution: rgb("#c9923a"),
  note: rgb("#3a7bd5"),
  success: rgb("#2ea66f"),
  important: rgb("#ff0000"),

  // thmboxの定理環境の色
  theorem: rgb("#f0e68c"),
  definition: rgb("#e6e6fa"),
  proposition: rgb("#ffe4e1"),
  lemma: rgb("#e0ffff"),
  corollary: rgb("#f5deb3"),
  example: rgb("#d8bfd8"),
  remark: rgb("#f5f5dc"),
  note-thmbox: rgb("#b0c4de"),
  exercise: rgb("#fafad2"),
  algorithm: rgb("#e0ffff"),
  claim: rgb("#f5deb3"),
  axiom: rgb("#d8bfd8"),
)

#let colorscheme-formal-patch = (
  background: rgb("#f6fafa"),
  text: rgb("#041010"),
  accent: rgb("#041010"),
)

#let template(
  auto-indent: true,

  // if heading level is less than or equal to this value, a line will be drawn under the heading and indexed in the toc
  major_heading_level: 3,
  thmbox_settings: (
    counter_level: 2,
    breakable: true,
  ),
  colorscheme: colorscheme,
  body
) = {
  // Whole document settings
  set text(font: "Harano Aji Mincho")

  // Headings
  show heading: it => {
    set text(fill: colorscheme.accent, weight: "bold", font: "Harano Aji Gothic")
    it
    if it.level <= major_heading_level {
      v(-0.5em)
      line(length: 100%, stroke: (paint: colorscheme.accent, thickness: 1pt))
    }
  }

  // Paragraph settings
  set par(
    leading: 0.75em,
    spacing: 0.75em,
    justify: true,
    first-line-indent: if auto-indent {
      (all: true, amount: 1em)
    }
  )

  // inline
  show strong: it => {
    set text(font: "Harano Aji Gothic")
    it
  }

  set enum(spacing: 1.2em)

  // Setup for theorem-like environments
  import "@preview/thmbox:0.3.0": *
  show: thmbox-init(counter-level: thmbox_settings.counter_level)
  if thmbox_settings.breakable {
    show figure.where(kind: "thmbox"): set block(breakable: true)
  }
  show figure.where(kind: "thmbox"): set text(font: "Harano Aji Mincho")

  show std.title: it => {
    set text(
      font: "Harano Aji Gothic",
      size: 2em,
      weight: "bold",
      fill: colorscheme.accent
    )
    it
  }

  let frame(stroke) = (x,y) => (
    if table.header == none {

    } else {
      if y == 1 {
        (top: stroke.thickness*1.5 + stroke.paint)
      } else if y > 1 {
        (top: stroke)
      }
    }
  )
  set table(
    stroke: frame(1pt+colorscheme.accent),
  )

  set table.cell(inset: (left: 1em, right: 1em))
  show table.cell: set text(font: "Harano Aji Gothic")
  show table.cell.where(y: 0): set text(font: "Harano Aji Gothic", weight: "bold", fill: colorscheme.accent)

  show raw : set text(font: (
    "FiraCode Nerd Font",

    // デフォルトではコードブロックの日本語フォントがおかしくなるので、デフォルトのDejaVu Sans MonoのフォールバックにHarano Aji Gothicを追加している。
    "DejaVu Sans Mono",
    "Harano Aji Gothic",
    )
  )

  show raw.where(block: false) : it => {
    box(
      fill: luma(230),
      radius: 0.3em,
      inset: (x: 0.33em),
      outset: (y: 0.33em),
      it
    )
  }

  import "@preview/codly:1.3.0": *
  import "@preview/codly-languages:0.1.1": *
  show: codly-init.with()
  codly(
    languages: codly-languages,
    header-cell-args: (align: center),
    header-transform: it => {
      set text(font: "Harano Aji Gothic", fill: colorscheme.accent)
      strong(it)
    },
    stroke: 1pt + colorscheme.accent,
    zebra-fill: luma(245),
    lang-radius: 0.3em,
    radius: 0.3em,
  )

  show math.equation: it => {
    show math.text: set text(font: "Harano Aji Mincho")
    it
  }

  body
}

// テンプレートを適用したドキュメントでもcodlyの設定を上書きできるようにするため、モジュールを再公開する。
#import "@preview/codly:1.3.0": *

// #let icon(name, size: 1.2em) = image(
//   "assets/icons/" + name + ".svg",
//   width: size
// )
#import "@preview/iconify:0.5.3":icon as ic, provide-icons

// #provide-icons(json("assets/mdi.json"))

#let icon(..args) = {
  provide-icons(json("assets/mdi.json"))
  // iconify-typstのソースを見る限り、`y`パラメータはアイコンを入れている`box`の`inset`に`(y:y)`として渡されている。ここで、`y=-0.25em`とすると、アイコンの位置がテキストのベースラインに合うようになる。
  
  // TODO: この現象の原因究明
  // 現状この処理で問題はないため、対応優先度は低い。
  ic(y: -0.25em, ..args)
}

// wrappers for predefined thmbox variants
#import "@preview/thmbox:0.3.0": *

#let theorem = theorem.with(
  sans: false,
  variant: "定理",
  color: colorscheme.theorem,
)

#let proposition = proposition.with(
  sans: false,
  variant: "命題",
  color: colorscheme.proposition,
)

#let lemma = lemma.with(
  sans: false,
  variant: "補題",
  color: colorscheme.lemma,
)

#let corollary = corollary.with(
  sans: false,
  variant: "系",
  color: colorscheme.corollary,
)

#let definition = definition.with(
  sans: false,
  variant: "定義",
  color: colorscheme.definition,
)

#let example = example.with(
  variant: "例",
  color: colorscheme.example,
)

#let remark = remark.with(
  variant: "注意",
  color: colorscheme.remark,
)

// thmboxで提供されているnote環境のラッパ。基本的にcalloutの`note`を使うが、前者は定理・数学関係のノート、後者は一般的なノートという感じでゆるく使い分けるイメージ。
#let note-thmbox = note.with(
  variant: "ノート",
  color: colorscheme.note-thmbox,
)

#let exercise = exercise.with(
  variant: "演習",
  color: colorscheme.exercise,
)

#let algorithm = algorithm.with(
  variant: "アルゴリズム",
  color: colorscheme.algorithm,
)

#let claim = claim.with(
  variant: "主張",
  color: colorscheme.claim,
)

#let axiom = axiom.with(
  variant: "公理",
  color: colorscheme.axiom,
)

#let proof = proof.with(
  title: [#text(font: "Harano Aji Gothic", "証明")],
  color: colorscheme.proposition,
)

#let my-note = note.with(
  variant: [#icon("mdi:note-check", width: 1.1em)#h(0.5em)"注意"],
  color: colorscheme.note
)


// alternative of \today in LaTeX
#let today() = datetime.today().display("[year]年[month padding:none]月[day padding:none]日")

#let author-mgr(
  authors,
  // 所属の示し方には流派があると思うので、ユーザに任せる
  show_author_with_affiliation: (
    author
  ) => {
    author.at(0)
    footnote(author.at(1))
  }
) = {
  if type(authors) == array {
    // 著者が複数いる場合（所属を書く場合も含む）
    for author in authors {
      if type(author) == array {
        show_author_with_affiliation(author)
      }
      else {
        author
      }
      if author != authors.at(-1) {
        ", "
      }
    }
  } else if type(authors) == content {
    // 著者は単独かつ所属などを書かない場合、あるいはユーザが自由に書きたい場合
    authors
  }
}

/// maketitle
#let maketitle(
  title: none,
  subtitle: none,
  serif-title: false,
  authors: none,
  affiliation-footnote: false,
  date: today(),
) = {
  block(
    breakable: false,
    width: 100%,
  )[
  #align(center,
    {
      if serif-title {
        std.title[
          #text(font: "Harano Aji Mincho", title)
        ]
      } else {
        std.title(title)
      }
      v(0.5em)

      if subtitle != none {
        text(subtitle, font: "Harano Aji Gothic", size: 1.25em)
        v(0.5em)
      }
      
      // 以下、著者名をいい感じに表示するロジック。関数に切り出してもいいかもしれない。
      if authors != none {
        if type(authors) == content {
          authors
        } else if type(authors) == array {
          if affiliation-footnote {
            for author in authors {
              if type(author) == array {
                author.at(0)
                footnote(author.at(1))
              } else {
                author
              }

              if author != authors.at(-1) {
                ", "
              }
            }
          } else {
            for author in authors {
              // 著者名の下に小さく所属を書く場合
              box(
                {
                  show table.cell: set text(font: "Harano Aji Mincho", fill: colorscheme.text, weight: "regular")

                  show table.cell.where(y: 1): set text(size: 0.85em)

                  if type(author) == array {
                    table(
                      columns: 1,
                      stroke: 0pt,
                      ..author
                    )
                  } else {
                    table(
                      columns: 1,
                      stroke: 0pt,
                      author, ""
                    )
                  }
                }
              )
            }
          }
        } else {
          error("Invalid type for authors")
        }
        v(0.5em)
      }

      if date != none {
        text(date, font: "Harano Aji Mincho", fill: colorscheme.text, weight: "regular")
      }

      v(1.5em)
    }
  )]
}

#let author-sample(authors) = {
  set footnote(numbering: (..args) => {
    args.pos().at(0) * "†" // 脚注は一回層のみなので、取り出してリピート
  })
  authors.at(0).at(0)
  footnote(authors.at(0).at(1))

  authors.at(1).at(0)
  footnote(authors.at(1).at(1))
}

// Markdown形式の表をレンダリングするモジュール
#import "@preview/tablem:0.3.0": tablem

// 以下、コールアウトの設定
#import "@preview/showybox:2.0.4": showybox
#let callout(title: none, color: colorscheme.accent, frame: (:), ..args) = {
  showybox(
    // タイトルが指定されていればタイトルを表示、そうでなく、positional argumentが2つ以上あれば最初のものをタイトルとして表示
    title: if title != none {
      text(font: "Harano Aji Gothic", [*#title*])
    } else if args.pos().len() >= 2 {
      text(font: "Harano Aji Gothic", [*#args.pos().at(0)*])
    },

    // frameの部分的上書きのため、引数として受けた辞書とデフォルト設定をマージする。
    frame: (
      border-color: color.darken(20%),
      title-color: color.lighten(20%),
      body-color: color.lighten(95%),
      radius: 0em,
      thickness: (left: 2.5pt)
    ) + frame,
    
    .. if args.pos().len() >= 2 and title == none {
      args.pos().slice(1)
    } else {
      args
    },
  )
}

#let warning(..args) = callout(
  title: [#icon("mdi:warning", width: 1.1em) #h(0.5em) 警告],
  color: colorscheme.warning,
  ..args
)

#let caution(..args) = callout(
  title: [#icon("mdi:alert-circle", width: 1.1em) #h(0.5em) 注意],
  color: colorscheme.caution,
  ..args
)

#let note(..args) = callout(
  title: [#icon("mdi:note-check", width: 1.1em) #h(0.5em) ノート],
  color: colorscheme.note,
  ..args
)

#let success(..args) = callout(
  title: [#icon("mdi:check-circle", width: 1.1em) #h(0.5em) 成功],
  color: colorscheme.success,
  ..args
)

#let important(level: 1, strong: true, ..args) = {
  let internal_level = ()

  if level < 1 {
    error("Invalid level for important callout")
  } else if level == 1 {
    internal_level = (1, "")
  } else if level == 2 {
    internal_level = (2, "高")
  } else {
    internal_level = (3, "最高")
  }

  let bangs = for i in range(1, internal_level.at(0) + 1) {
    text("!", weight: "bold")
  }

  let title = bangs + h(0.5em) + {
    if internal_level.at(1) != "" {
      text("重要度: " + internal_level.at(1))
    } else {
      text("重要")
    }
  } + h(0.5em) + bangs

  callout(
    title: [
      #set text(fill: colorscheme.important)
      #title
    ],
    color: colorscheme.important,
    frame: (
      border-color: colorscheme.important,
      title-color: colorscheme.important.lighten(95%),
      body-color: colorscheme.background,
      thickness: (1.5pt)
    ),
    ..args
  )
}