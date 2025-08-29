#import "@preview/touying:0.6.1": *
#import "@preview/zebraw:0.5.5": *
// #import "@preview/fruitify:0.1.1": fruitify


// Code blocks customisation
#show: zebraw-init.with(
  background-color: none,
  numbering: false,
  comment-flag: "//"
)

// #set footnote(numbering: fruitify)

#let cph_rs_config_colors = config-colors(
  // Assumption: cph.rs uses a minimal light theme.
  // Neutrals chosen to match a clean white UI with dark text.
  neutral: rgb("#4b5563"),
  neutral-light: rgb("#9ca3af"),
  neutral-lighter: rgb("#d1d5db"),
  neutral-lightest: rgb("#f3f4f6"),
  neutral-dark: rgb("#374151"),
  neutral-darker: rgb("#1f2937"),
  neutral-darkest: rgb("#0a0a0a"),

  // Primary and companions derived from Rust Foundation brand palette.
  primary: rgb("1E2650"),            // Rust Dark Blue
  primary-light: rgb("3b4572"),
  primary-lighter: rgb("6570a0"),
  primary-lightest: rgb("a7aec9"),
  primary-dark: rgb("191f42"),
  primary-darker: rgb("141a36"),
  primary-darkest: rgb("0f142a"),

  secondary: rgb("D34516"),          // Rust Orange
  secondary-light: rgb("e1693f"),
  secondary-lighter: rgb("ea8d6d"),
  secondary-lightest: rgb("f3b6a0"),
  secondary-dark: rgb("b33b14"),
  secondary-darker: rgb("8f3011"),
  secondary-darkest: rgb("#6c250d"),

  tertiary: rgb("#28607F"),           // Rust Blue
  tertiary-light: rgb("#4f7f97"),
  tertiary-lighter: rgb("#7aa1b3"),
  tertiary-lightest: rgb("#aecdca"),
  tertiary-dark: rgb("#214e67"),
  tertiary-darker: rgb("#1a3e52"),
  tertiary-darkest: rgb("#142f3f"),
)

#import themes.university: *

#show: university-theme.with(
  aspect-ratio: "16-9",
  // footer-a: [Sun Wenjie / Josiah / Mossa],
  // config-common(new-section-slide-fn: none),
  // Bioconductor
  header-right: none,
  cph_rs_config_colors,
  config-info(
    // title: [Exploring R and Rust in Bioinformatics],
    title: [Rust-based R packages with extendr],
    subtitle: [
      \@ Rust meetup \#60 sponsored by Bang & Olufsen \
    ],
    // subtitle: [Online Developer Forum],
    author: [
        #align(center)[
        Mossa Merhi Reimert
        ]
    ],
    // date: datetime.today(),
    // date: [28#super[th] July 2025],
    // Thu, Aug 28 · 6:00 PM CEST
    date: [28#super[th] August, 2025],
    // institution: image("cph_rs_logo.svg"),
    logo: image("feRris.png", width: 10%)
  ),
)

#show link: set text(fill: purple)
// assume it is r when inlines
#set raw(lang: "r")
#show raw: set text(font: "Fira Code", ligatures: true)
#let raw_rust = raw.with(lang: "rust")
#let raw_r = raw.with(lang: "r")
#let raw_c = raw.with(lang: "C")
// #set heading(numbering: numbly("{1}.", default: "1.1"))

#title-slide()

// #strike[`cph.rs`] `lyngby.rs`

#focus-slide[
  #show raw: set text(size: 26pt)
  = `whoami` 
  ```
  Mossa Merhi Reimert, PhD
  Using Rust since 2019 (post NLL)
  Statistician / Veterinary Epidemiologist
  Father of two
  ```
  #pause
  Not a computer scientist!
]

#focus-slide[
  Grateful to be here at `cph.rs`!
  
  #align(horizon + center, image("cph_rs_logo.svg"))
]

#focus-slide[
  Grateful to be here at #strike()[`cph.rs`!]\
  #h(10em)`lyngby.rs`!
  #align(horizon + center, image("cph_rs_logo.svg"))
]

== extendR is published in JOSS

#h(1fr)

#link("https://joss.theoj.org/papers/10.21105/joss.06394",
  image("extendr_article_heading.png")
)

#align(center)[
 https://joss.theoj.org/papers/10.21105/joss.06394
]

== What is `extendr`?

extendr is a Rust extension for R.

- Official documentation for extending R (#link("https://cran.r-project.org/doc/manuals/R-exts.html", "R-exts")) with official support for  `C/C++/Fortran`.

- Community extensions: Rcpp, cpp11, rJava, reticulate (python), RJulia

  #align(center)[#image("blake_extendr_logo_trans.png", height: 5em)]

  #align(center)[
    #set text(size: 1.9em)
    Checkout #link("https://extendr.rs/", "extendr.rs")! 
  ]

== About R 

#slide[
  // #set text(size: 23pt)
  #quote([R is a _free_ software environment for _statistical_ computing and graphics.]) -- #link("https://www.r-project.org/", "r-project.org").


  - R is an interpreted language written in C.
  
  - R is the successor of S
  
  - R data format supports encoding of missing values, `NA` (like arrow)

  // R is the language of many scientists, and CRAN is its main R-package repository.
  // #image("blake_extendr_logo_trans.png")
]

== R primer

- ```r
variable <- "value"
```
- ```r
set_middle <- function(x = c(1,2,3), value = 99) {
  value -> x[length(x) %/% 2]
}
```
Using `set_middle`:
```r
> set_middle() # returns invisibly..
> set_middle() |> print()
[1] 99
```
#pause 
- Questions?

== R behavior

- R admits copy-on-write semantics. 
  ```r
  > x <- c(1,2,3)
  > .Internal(address(x))
  <pointer: 0x1226cca88>
  > x[1] <- 99
  > .Internal(address(x))
  <pointer: 0x1226ee678>
  ```
// Source: #link("https://docs.julialang.org/en/v1/manual/noteworthy-differences/#Noteworthy-differences-from-R", [Julia's Manual: Noteworthy differences from R
// ])

- There is no way to modify in-place in R...

== FFI challenges with R

- R's C-API is built around an opaque pointer type `SEXP`.

- R has a garbage collector

- Errors in R induce `C` longjmps 

#pause
#v(0.33fr)
- Comments? Questions?
#v(0.1fr)


== extendr is comprised of:


== Overview

#slide[
  // #set text(size: 22pt)
  // Suite of software packages to facilitate binding R and Rust.
  
  #align(center,
    table(
      inset: 0.4em,
      columns: (auto, auto, auto, auto),
      align: (left +horizon, horizon + center, horizon + center, horizon + center), 
      table.header[Package][CRAN compatible?][Published][Repository],
      `rextendr`, [#sym.checkmark], [CRAN], [#link("https://github.com/extendr/rextendr", "github/extendr/rextendr")],
      `extendr-api`,[#sym.checkmark],[crates.io], table.cell(rowspan:4, [#link("https://github.com/extendr/extendr", "github/extendr/extendr")]),
      `extendr-macros`,[#sym.checkmark],[crates.io], 
      `extendr-ffi`,[#sym.checkmark], [crates.io],
      `extendr-engine`,[!], [crates.io],
      `libR-sys`, [#sym.checkmark],[crates.io], [#link("https://github.com/extendr/libR-sys", "github/extendr/libR-sys")],
    )
  )

]

// -   `{rextendr}` -- usethis-like R package

// - #link("https://extendr.github.io/extendr/extendr_api", "extendr-api") -- the “core” Rust library
// - #link("https://extendr.github.io/extendr/extendr_ffi", "extendr-ffi") -- bindings to R’s C API
// - #link("https://extendr.github.io/extendr/extendr_engine", "extendr-engine") -- R engine for embedding R into Rust


== Getting Started

#slide[
  #set text(size: 24pt)
R users prefer R for everything:
- `rextendr::rust_source()` and `rextendr::rust_function()` to execute Rust code in R _now_.
*Happy path*
- Embed Rust code in an R package
  ```r
  usethis::create_package("newPkg")
  rextendr::use_extendr()
  ```
  - Update bindings with: `rextendr::document()` 
][
  #set text(size: 21pt)
  #pad(left: 3em)[
    ```sh
    newPkg
    ├── DESCRIPTION
    ├── NAMESPACE
    ├── R
    │   └── extendr-wrappers.R
    ├── newPkg.Rproj
    └── src
        ├── Makevars
        ├── Makevars.ucrt
        ├── Makevars.win
        ├── entrypoint.c
        ├── newPkg-win.def
        └── rust
            ├── Cargo.toml
            └── src
                └── lib.rs
    ```
  ]
]


== extendr packages

#slide(composer: (1fr,1fr))[
  
-   16 CRAN packages

-   Many, many more on GitHub:
][
  #image("images/paste-3.png")
]

== 380k downloads and counting

#[
  As of today (Thursday, August 28th) we have a total of 494284 downloads
  #set align(center + horizon)
  
  #image("images/paste-1.png", height:1fr)

]

==
An example of a rust-powered R-package is `{mdl}`.

- Transforms a data-frame into a design/model matrix, that are used within `lm`/`glm`/`glmnet`/etc. 

#[
  #set text(size: 22pt)
  ```r
  > mtcars$cyl <- as.factor(mtcars$cyl)
  + head(
  +   mdl::mtrx(mpg ~ ., mtcars)
  + )
    (Intercept) cyl6 cyl8 disp  hp drat    wt  qsec vs am gear carb
  1           1    1    0  160 110 3.90 2.620 16.46  0  1    4    4
  2           1    1    0  160 110 3.90 2.875 17.02  0  1    4    4
  3           1    0    0  108  93 3.85 2.320 18.61  1  1    4    1
  4           1    1    0  258 110 3.08 3.215 19.44  1  0    3    1
  5           1    0    1  360 175 3.15 3.440 17.02  0  0    3    2
  6           1    1    0  225 105 2.76 3.460 20.22  1  0    3    1
  ```
  #pagebreak()
]
#[
  == Benchmark:
  // #set text(size: pt)
  ```r
  # A tibble: 2 × 4
    expression                    median `itr/sec` mem_alloc
    <bch:expr>                     <dbl>     <dbl>     <dbl>
  1 mdl::mtrx(mpg ~ ., mtcars)       1        10.5      1   
  2 model.matrix(mpg ~ ., mtcars)   10.8       1        4.40
  ```
  #text(size: 20pt, [scaled wrt. best performing])
]

#pause 
Overall, between 1.7#sym.times and 11#sym.times faster than R's `model.matrix`.

But there is more.. Performance is not everything.

==

- The rust core of `mdl` is app. 250 LOC

- Parallel processing of variables is implemented (via `rayon`)

- 95% safe code

#pause

#sym.arrow.r Any non-expert maintainer can tweak `mdl`, and if it compiles, it works.


== Let's dig.. 

// #v(25%)

```rs
/// @export
#[extendr]
fn hello_world() -> &'static str {
    "Hello world!"
}
```

- `#[extendr]` generates a compatible C-wrapper, and an R wrapping rust function
- `@export`-annotation exports the R wrapper to other R packages!

#pagebreak()

  // #set text(size: 20pt)
  ```r
> hello_world()
[1] "Hello world!"
> .Internal(inspect(hello_world()))
@0x000001f379d4d6b0 16 STRSXP g0c1 [] (len=1, tl=0)
  @0x000001f3747398c8 09 CHARSXP g1c2 [MARK,REF(5),gp=0x60,ATT] [ASCII] [cached] "Hello world!"
  ```
  Regular R:
  ```r
  > .Internal(inspect("Hello world!"))
@0x000001f3797b0510 16 STRSXP g0c1 [REF(2)] (len=1, tl=0)
  @0x000001f3747398c8 09 CHARSXP g1c2 [MARK,REF(6),gp=0x60,ATT] [ASCII] [cached] "Hello world!"
  ```

== R compatible C wrapper

- Rust side ```rust
  #[no_mangle]
  pub extern "C" fn c_function_name() {
    rust_function_name()
  }
```
- C side:```C
SEXP c_function_name(void) {
    return R_NilValue;
}
```
- Generally on the R side: ```r
  .Call("c_function_name")
```

== Data conversions in `#[extendr]`-macro


```rs
#[no_mangle]
pub extern "C" fn c_function_name(arg1: SEXP, arg2: SEXP) -> SEXP {
  let arg1 = arg1.try_into();
  let arg2 = arg2.try_into();
  let rs_return_value = rust_function_name(arg1, arg2);
  let r_result: SEXP = rs_return_value.try_into();
  result
}
```

#pause 

This is a sketch, as we need to..
- Guard for panics coming from `rust_function`..
- Protect R allocations done within `rust_function`
- etc.

== Our goals with extendr

- Enable the ease of creating rust-based R packages

- Require as little knowledge of R-internals of our users

#pause 

What our time is spent on:

- Fighting CI to ensure that extendr works with all combinations of 
  ${"R versions"} times ({"OS versions"} union {"emscripten"\/"WASM"})$

- Campaigning for Rust on CRAN and BioConductor...

#pause

*Back to the technical stuff...*

== What if an R function panics?

- A call to `Rf_error("error message as c-string")` occurred
  - Converting rust panics to r errors
  - Users want to error due to bad input
  - etc.

A call to `Rf_error` causes a `longjump`!

== Options

```C
SEXP R_MakeUnwindCont(void);
```
```C
NORET void R_ContinueUnwind(SEXP cont);
```
```C
SEXP R_UnwindProtect(
    SEXP (*fun)(void *data), void *data,
    void (*cleanfun)(void *data, Rboolean jump),
    void *cleandata, SEXP cont);
```



#footnote([`NORET` means `!` in Rust])

#pagebreak()
#[
  #show raw: set text(size: 0.99em)
```C
SEXP R_UnwindProtect(
  SEXP (*fun)(void *data), void *data,
  void (*cleanfun)(void *data, Rboolean jump),
  void *cleandata, SEXP cont) {
  // ... 
  begincontext(&thiscontext, CTXT_UNWIND, R_NilValue, 
     R_GlobalEnv, R_BaseEnv, R_NilValue, R_NilValue);
  if (SETJMP(thiscontext.cjmpbuf)) {
    jump = TRUE;
    SETCAR(cont, R_ReturnedValue);
    unwind_cont_t *u = RAWDATA(CDR(cont));
    u->jumpmask = thiscontext.jumpmask;
    u->jumptarget = thiscontext.jumptarget;
    thiscontext.jumptarget = NULL;
  } else
```
]
#pagebreak()
```C 
  else {
    result = fun(data);
    SETCAR(cont, result);
    jump = FALSE;
  }
  endcontext(&thiscontext);

  cleanfun(cleandata, jump);
  if (jump)
    R_ContinueUnwind(cont);

  return result;
}
```

== This is used for C++ Exceptions

- In the R package `{cpp11}`, see #link("https://cpp11.r-lib.org/articles/FAQ.html#should-i-call-cpp11unwind_protect-manually").
- And in Rcpp too:
#[
  #show raw: set text(size: 12pt)
```cpp
struct UnwindData {
    std::jmp_buf jmpbuf;
};
// First jump back to the protected context with a C longjmp because
// `Rcpp_protected_eval()` is called from C and we can't safely throw
// exceptions across C frames.
inline void maybeJump(void* unwind_data, Rboolean jump) {
    if (jump) {
        UnwindData* data = static_cast<UnwindData*>(unwind_data);
        longjmp(data->jmpbuf, 1);
    }
}
inline SEXP unwindProtectUnwrap(void* data) {
    std::function<SEXP(void)>* callback = (std::function<SEXP(void)>*) data;
    return (*callback)();
}
}} // namespace Rcpp::internal
namespace Rcpp {
inline SEXP unwindProtect(SEXP (*callback)(void* data), void* data) {
    internal::UnwindData unwind_data;
    Shield<SEXP> token(::R_MakeUnwindCont());

    if (setjmp(unwind_data.jmpbuf)) {
        // Keep the token protected while unwinding because R code might run
        // in C++ destructors. Can't use PROTECT() for this because
        // UNPROTECT() might be called in a destructor, for instance if a
        // Shield<SEXP> is on the stack.
        ::R_PreserveObject(token);

        throw LongjumpException(token);
    }
    return ::R_UnwindProtect(callback, data,
                             internal::maybeJump, &unwind_data,
                             token);
}

inline SEXP unwindProtect(std::function<SEXP(void)> callback) {
    return unwindProtect(&internal::unwindProtectUnwrap, &callback);
}
```
]

== My conclusion

We need a way to unwind rust frames, that then allows me to call `R_ContinueUnwind`#footnote([
```C
NORET void R_ContinueUnwind(SEXP cont)
{
    SEXP retval = CAR(cont);
    unwind_cont_t *u = RAWDATA(CDR(cont));
    R_jumpctxt(u->jumptarget, u->jumpmask, retval);
}
```
]). But I cannot find a way to do that #emoji.face.sad


== Roadmap
===  Main priority: Developers, developers, developers
- Better support on package repositories like CRAN and Bioconductor

- Improve and complete #link("https://extendr.github.io/user-guide/", [our User Guide])
- Outreach to users via presentations and workshops

=== More Rust in R's ecosystem

- Leverage existing rust crates through binding r-packages
  
- More maintainers for extendr

== Wanted

- R users that are Rust curious? Come on in!

- Rust library that you want accessible to the R community? Please, join us.

- If you love `procmacro`s, and only want to write proc-macros, we have things!

- If you're only a `rustc`-interested, we need you too!


#focus-slide[
  
  Thanks for your attention!

  #pause 

  #quote(block: true)[So long, and thanks for all the fish!]

  ... I'm moving to #strike([Jutland]) Als
]

#show: appendix


// #pause

// #sym.arrow.r Any non-expert maintainer can tweak `mdl`, and if it compiles, it works.

// = Roadmap

// #focus-slide()[
//   #set align(center)
//   Let's discuss!\ 
//   // #line(stroke: teal)
//   // #rect(fill: rgb("#87b13f"), width: 9em,)
//   #rect(fill: rgb("#87b13f"), width: 9em,radius: 1.234em)
//   Questions?
// ]

// // #matrix-slide(rows: 1, [
// //   #set align(left + top)
// //   R side:
  
// //   - Memory safe parallel processing
  
// //   - Async support via `{mirai}`
  
// //   - Finish webR support
  
// //   - `{vctrs}` support for rust vectors
// //   // - Add `{vctrs}` style support 
  
// // ],[
// //   #set align(left + top)
// //   Rust side:
// //   - "native" arrow support
  
// //   - Add `nalgebra` support
// //   - WASM and webr support
    
// // ],)



// // On-going efforts

// // - WASM  and webr support


== Examples of `extendr-api` code
#slide[
=== Passing Rust data to R

```rs
#[derive(Debug)]
#[extendr]
struct Person {
    name: String,
    age: u32,
}
```
]

#slide()[
#set text(size: 21pt)
```rust
#[extendr]
impl Person {
    fn new() -> Self {
        Self { 
        name: "".to_string(), 
        age: 0 }
    }
    fn name(&self) -> &str {
        self.name.as_str()
    }
    fn set_name(&mut self, name: &str) {
        self.name = name.to_string();
    }
  }
```
][
  === On the R side
  ```r
  > person <- Person$new()
  > person$set_name("Jeff")
  > person
  <pointer: 0x105c04530>
  attr(,"class")
  [1] "Person" 
  ```
]

=== Passing R owned Rust types

```rs
#[extendr]
impl Person {
    fn older<'a>(&'a self, other: &'a Self) -> &'a Self {
        if self.age > other.age {
            self
        } else {
            other
        }
    }
}
```
Usage: Support for method-chaining in R