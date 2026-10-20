# Packed-host model integration fixture

For the DeepSeek-V4.1-Flash-1017 EXL3-3.5bpw pack and the documented three-card TP2/split36,4 configuration. The fixtures contain 2069 varied-code token IDs, 2048 database token IDs and the original expert profile used to freeze placement. Keep this directory immutable: copy it to a writable output directory before running, because the model writes its profile and raw logits.

On Linux/POSIX, build `ds4_packed_host_test` explicitly. It is excluded from normal builds and CTest because it requires the full model, roughly180GB RAM, three GPUs and over3GB output space. Stop the serving engine before loading the test model. In the copied output directory create `engram-files.txt` with the absolute paths of the native model's model-00047-of-00048.safetensors and model-00048-of-00048.safetensors, one per line. Then run:

```sh
ds4_packed_host_test /path/to/model/maya-ds4 /path/to/copied-fixture
```

The test fixes FMA16, TP2, split36/4, 2K chunks, context262144, explicit expert RAM and2048MiB reserve. It checks actual CPU expert outputs, round-trips every host expert during each layout change, writes full logits for control/candidate/repeat, runs balanced cold/warm screens, compares80 greedy tokens and requires zero expert moves. The final verifier rejects nonfinite logits, any changed bit, incomplete output shapes or unequal greedy output.

`--selftest` tests the verifier without a model. `--check-existing /path/to/output` independently checks saved logits and token files. Performance acceptance and original-engine comparison require the external controls documented in docs/EXL3_PACKED_HOST.md.
