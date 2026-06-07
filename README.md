# A Basic Verso Book

A minimal book built with Verso's Manual genre. Includes two chapters, with inline Lean code in the first.

Build with:
```
lake build
lake exe generate-book
```

The generated site will be in `_out/html-multi/`.

### Note for local build
`Book/v4_31_0.lean` contains a `#version` output assertion that is platform-specific. The expected output is set to `x86_64-unknown-linux-gnu` to match the GitHub Actions CI environment. Running `lake build` locally on macOS will fail on this file. This is intentional — the file is maintained and verified through CI only. If you need to run it locally, change it by your local target.
 
