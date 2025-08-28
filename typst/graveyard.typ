
== Maintainer burden

- New version of Rust (`rustc`/`cargo`) is released every 6 weeks

This is not an issue as
- `rustup` ensures that multiple compilers can be installed on the same machine, without conflict

- How does rust handle system dependencies?

Rust packages are called crates, and not _libraries_.

- `cargo` bundles all dependencies, thus no conflict can occur

#pagebreak(weak: true)

- Rust's package repository is #link("https://crates.io/","crates.io"). Maintained by #link("https://www.rust-lang.org/governance/teams/dev-tools#team-crates-io", [crates.io team]) and the Rust Foundation#footnote[
  Separate, legal entity, that funds the infrastructure work
].
Previously, `cargo`/`crates.io` relied on an index registry hosted by GitHub. As of release 1.70.0, that is no longer the case.

- Rust guarantees *forward compatibility* of the different versions, however..
  - There are *Editions* which are opt-in breaking changes
  - There are new lints and warnings

Fear not, add Rust to your stack!

#show: appendix

== #raw("cargo geiger mdl", lang: "zsh")
#[
  #set align(horizon)
  #show raw: set text(size: 14pt)
  ```
  Metric output format: x/y
      x = unsafe code used by the build
      y = total unsafe code found in the crate
  
  Symbols:
      🔒  = No `unsafe` usage found, declares #![forbid(unsafe_code)]
      ❓  = No `unsafe` usage found, missing #![forbid(unsafe_code)]
      ☢️   = `unsafe` usage found
  
  Functions  Expressions  Impls  Traits  Methods  Dependency
  ```
  #pagebreak()
  #set align(horizon)
  ```
  0/0        0/0          2/2    0/0     0/0      ☢️  mdl 0.1.0
  55/84      1990/3033    1/1    0/0     12/12    ☢️  └── extendr-api 0.8.0
  8/8        33/33        0/0    0/0     0/0      ☢️      ├── extendr-ffi 0.8.0
  0/0        0/0          0/1    0/0     0/0      ☢️      ├── extendr-macros 0.8.0
  0/0        15/15        0/0    0/0     3/3      ☢️      │   ├── proc-macro2 1.0.86
  0/0        4/4          0/0    0/0     0/0      ☢️      │   │   └── unicode-ident 1.0.12
  0/0        0/0          0/0    0/0     0/0      ❓      │   ├── quote 1.0.37
  0/0        15/15        0/0    0/0     3/3      ☢️      │   │   └── proc-macro2 1.0.86
  0/0        88/88        3/3    0/0     2/2      ☢️      │   └── syn 2.0.77
  0/0        15/15        0/0    0/0     3/3      ☢️      │       ├── proc-macro2 1.0.86
  0/0        0/0          0/0    0/0     0/0      ❓      │       ├── quote 1.0.37
  0/0        4/4          0/0    0/0     0/0      ☢️      │       └── unicode-ident 1.0.12
  0/0        81/124       5/9    0/0     3/5      ☢️      ├── once_cell 1.21.3
  0/0        0/0          0/0    0/0     0/0      ❓      └── paste 1.0.15
  
  63/92      2211/3297    11/16  0/0     20/22
  ```
]