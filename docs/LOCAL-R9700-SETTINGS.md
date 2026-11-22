# Local three-R9700 DeepSeek settings

This profile is for our Linux workstation with three 32 GB Radeon AI PRO
R9700s and 256 GB of system RAM. We tested DeepSeek-V4.1-Flash-1017 EXL3 3.5 bpw
with resident Engrams and DSpark on the fork based on Maya v1.1.73
(`b90e8f59`). Use a HIP build with RDNA4 EXL3 kernels, resident helper prefill,
and exact peer prefill reduction.

## GPU roles

| Visible GPU | Upstream PCIe link | Role |
| --- | --- | --- |
| 0 | 5.0 ×8 | TP2 rank 0 and lead |
| 1 | 4.0 ×8 | TP2 rank 1 |
| 2 | 4.0 ×4 | Resident expert helper and DSpark |

Verify the HIP-visible IDs against the startup log. The TP pair runs all 40
target layers. GPU 2 holds a 20 GB pool of complete experts and receives
activations for its resident experts during prefill.

## Long-context profile

Start with a working [EXL3 helper configuration](EXL3-HELPER.md). In its
`args` list, use these values and keep the paths to the local model pack and
saved expert profile. The profile affects expert placement.

```text
--gpus 0,1,2 --tp 2 --dspark on --dspark-conf 0.65
--max-context 262144 --parallel 2 --prefill-chunk 8192 --reserve-mib 2048
--mmap-experts off --cpu-threads 8 --threads on
--expert-profile /path/to/profile.bin --profile-readonly
```

Merge these entries into the engine config's `env` object. The 200 GB warm
budget is a tuning input. Actual resident host memory can differ when
`--mmap-experts off` copies the RAM-tier weights.

```json
{
  "HSA_USE_SVM": "0",
  "DS4_SPLIT": "40,0",
  "DS4_DRAFT_GPU": "2",
  "DS4_HELPER": "2",
  "DS4_HELPER_GB": "20",
  "DS4_HELPER_EXL3": "1",
  "DS4_HELPER_SHARED": "1",
  "DS4_HELPER_CHECK": "1",
  "MAYA_DS4_HELPER_PREFILL": "1",
  "DS4_WARM_CAP_GB": "200",
  "DS4_RECENT": "0",
  "DS4_AHEAD": "0",
  "DS4_SKIP_UNPICKED": "1",
  "DS4_EXL3_PACKED_HOST": "1",
  "DS4_EXL3_DIRECT_SWAPS": "1",
  "DS4_ENGRAM_THREADS": "32",
  "DS4_CACHE_SUB_RATIO": "0",
  "EXL3_WMMA": "1",
  "EXL3_WMMA_GFX12": "1",
  "EXL3_WMMA_ROWS": "16",
  "DS4_HIP_PEER_AR": "1",
  "MAYA_DS4_WATCHDOG_S": "120"
}
```

For an existing config with these GPU roles, the two prefill changes are
`--prefill-chunk 8192` and `DS4_HIP_PEER_AR=1`. Both settings already exist in
the fork. The benchmark disabled the experimental routing trace and custom
helper placement. It used text-only serving with `--vision off`.

Check for `helper prefill enabled` with up to 8,192 rows and
`exact peer prefill all-reduce enabled on GPU0/GPU1` in the startup log.
The effective chunk size appears in the prefill stats with
`DS4_PREFILL_STATS=1`. If peer transport hangs, set `DS4_HIP_PEER_AR=0` to
use host transport. For more VRAM headroom or shorter shared prefill turns,
start with `--prefill-chunk 4096`. See [peer prefill](HIP_PEER_PREFILL.md)
and [engine settings](SETTINGS.md).

## Measured tradeoffs

On a fresh 131K screening prompt, 8K chunks plus exact peer reduction went
from **732 to 1,149 prefill tok/s (+57%)** and **180 to 115 seconds** to the
first token. Scheduled expert-weight payload fell **43%**.

| Held-out coding prompt | Prefill tok/s, 4K host → 8K peer | TTFT | Decode tok/s |
| --- | ---: | ---: | ---: |
| Fresh 131K | 736 → 1,035 (+41%) | 178 → 127 s | 27.3 → 26.4 |
| Fresh 260K | 681 → 1,057 (+55%) | 382 → 246 s | 39.6 → 40.4 |

Each held-out measurement generated 512 tokens. The responses differed, so
decode rates include different generation trajectories. The settings keep
the same router and expert weights.

With a fresh 131K prefill overlapping a short coding answer, prefill went
from **717 to 1,187 tok/s** and the short answer went from **2.7 to 4.2
tok/s**. Its longest client-visible pause grew from **18.8 to 21.7 seconds**.
Alone, the same short answer ran at **42.0 vs 41.1 tok/s**. These are single
runs. For interactive use where the longest pause matters more, the 4K
host-transport control had the shorter measured pause.

The fresh-prompt screen favored `DS4_RECENT=0`. Setting it to `32`
increased streamed weight traffic by 14% and reduced throughput by 5% on
that screen.
