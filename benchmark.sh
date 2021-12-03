#!/usr/bin/env sh

hyperfine --prepare "nim c -d:release src/main.nim" "src/main" --warmup 3 --export-markdown benchmark.md