import VersoManual

open Verso.Genre Manual
open Verso.Genre.Manual.InlineLean
open Lean.MessageSeverity

#doc (Manual) "v4.31.0" =>
%%%
tag := "release-v4.31.0"
file := "v4.31.0"
%%%

New functionalities coming in Lean 4.31.0

# Improvements in the new `do` elaborator

A `do`-block may be thought as some syntactic sugar for a quite involved expression with nested functions.
To elaborate it, the elaborator may simply transform the `do`-block into that expression and proceed with its elaboration.
However, during the process, much of the semantics may be lost: if there are elaboration errors, the error messages become confusing and obscure;
if the initial `do`-notation can be simplified, perhaps that's not obvious in the generated expression.

The Lean team has been working on a *new `do` elaborator*: an elaborator for `do`-blocks that (roughly speaking!) tries to understand the `do`-notation
as an intermediate language instead of eagerly unfold it as a macro. It can be accessed with `set_option backward.do.legacy false`;
right now this option is set to `true` by default, but that will change as the new `do` elaborator becomes standard.

The new elaborator is able to provide finer feedback than the old one. For instance,

```lean (name := newDo)
set_option backward.do.legacy false in
example : IO Nat := do
  return 5
  IO.println "never runs"
```
```leanOutput newDo (severity := warning)
This `do` element and its control-flow region are dead code. Consider removing it.
```

while the legacy elaborator instead rejects the same program with a coarser, purely structural error:

```lean +error (name := oldDo)
example : IO Nat := do
  return 5
  IO.println "never runs"
```
```leanOutput oldDo (severity := error)
must be last element in a `do` sequence
```

Another example of a finer error message:

\[ [13542](https://github.com/leanprover/lean4/pull/13542) \]

```lean
inductive A where | a
inductive AA where | a
open A
open AA
```

```lean +error (name := do_elab_3)
set_option backward.do.legacy true

def f1 (x : Option Nat) : Id Nat := Id.run do
  if let some a := x then
    22
  else
    33
```
```leanOutput do_elab_3
unsupported pattern in syntax match
  some a
```

```lean +error (name := do_elab_4)
set_option backward.do.legacy false

def f2 (x : Option Nat) : Id Nat := Id.run do
  if let some a := x then
    22
  else
    33
```
```leanOutput do_elab_4
ambiguous pattern, use fully qualified name, possible interpretations [AA.a, A.a]
```

Both elaborators are gaining new features, e.g. `while let` syntax

\[ [13534](https://github.com/leanprover/lean4/pull/13534) \]

```lean
def testWhileLet : IO Unit := do
  let mut xs := [0, 1, 2, 3]
  while let x :: rest := xs do
    println! "{x}"
    xs := rest
  println! "done {xs.length}"
```
Check more in these PRs:

[13250](https://github.com/leanprover/lean4/pull/13250) /
[13255](https://github.com/leanprover/lean4/pull/13255) /
[13332](https://github.com/leanprover/lean4/pull/13332) /
[13396](https://github.com/leanprover/lean4/pull/13396) /
[13397](https://github.com/leanprover/lean4/pull/13397) /
[13399](https://github.com/leanprover/lean4/pull/13399) /
[13404](https://github.com/leanprover/lean4/pull/13404) /
[13413](https://github.com/leanprover/lean4/pull/13413) /
[13434](https://github.com/leanprover/lean4/pull/13434) /
[13437](https://github.com/leanprover/lean4/pull/13437) /
[13442](https://github.com/leanprover/lean4/pull/13442) /
[13447](https://github.com/leanprover/lean4/pull/13447) /
[13491](https://github.com/leanprover/lean4/pull/13491) /
[13507](https://github.com/leanprover/lean4/pull/13507) /
[13534](https://github.com/leanprover/lean4/pull/13534) /
[13542](https://github.com/leanprover/lean4/pull/13542)
