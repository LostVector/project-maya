# Local three-R9700 DeepSeek settings

This profile is for our Linux workstation with three 32 GB Radeon AI PRO
R9700s and 256 GB of system RAM. We tested DeepSeek-V4.1-Flash-1017 EXL3 3.5 bpw
with resident Engrams and DSpark. Use a HIP build with RDNA4 EXL3 kernels,
resident helper prefill, and exact peer prefill reduction. The original 8K
profile was tested on the fork based on Maya v1.1.73 (`b90e8f59`). Later
opt-ins and their measured configurations are described below.

## GPU roles

| Visible GPU | Upstream PCIe link | Role |
| --- | --- | --- |
| 0 | 5.0 ×8 | TP2 rank 0 and lead |
| 1 | 5.0 ×8 with BIOS Gen5 selected | TP2 rank 1 |
| 2 | 4.0 ×4 | Resident expert helper and DSpark |

Verify the HIP-visible IDs against the startup log. The TP pair runs all 40
target layers. GPU 2 holds a 20 GB pool of complete experts and receives
activations for its resident experts during prefill.

On this workstation GPU 1's CPU-facing link (root port `0000:00:01.3`)
previously ran at PCIe Gen4 ×8 under load despite Gen5 capability and a
32 GT/s target. Selecting Gen5 for that slot in BIOS and rebooting restored
Gen5 ×8 for the measured runs. The cause of the earlier downshift is
unconfirmed. Verify both rank links during a sustained pinned host-to-device
copy before and between benchmark arms, especially after a reboot or BIOS
change. Check for 32 GT/s ×8 and roughly 26–27 GB/s per rank on this host.
The degraded link measured about 14.3 GB/s. An idle 2.5 GT/s sample by itself
can reflect normal power management. Record the active speed with results
and compare arms with matching active link speeds.

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
  "DS4_INDEX_TC_GFX12": "1",
  "MAYA_DS4_BATCH_MARKED_TAIL": "1",
  "MAYA_DS4_WATCHDOG_S": "120"
}
```

Use `--prefill-chunk 8192` and `DS4_HIP_PEER_AR=1` for the base prefill
path. The original 4K/8K comparison below used text-only serving with
`--vision off` and disabled routing traces and custom helper placement.

`DS4_INDEX_TC_GFX12=1` enables the INT8 sparse-attention scorer for prefill
on RDNA4. Keep `DS4_INDEX_TC` unset or set it to `1` when enabling it, and
check for the indexer's WMMA startup message on both target GPUs. The local
EXL3 3.5 bpw comparison used 8K chunks, vision, and 3-bit DSpark. Fresh
32K, 64K, and 96K TTFT fell 10.8%, 8.3%, and 8.1%. Resumed decode changed
by +5.2%, +1.7%, and −0.6%, with one matched fixture per length. All 12
operator cases matched their top-512 selections and finite masks. The
floating-point score reduction order can change generated tokens.

`MAYA_DS4_BATCH_MARKED_TAIL=1` batches eligible fresh text tails within
the existing scheduler pieces and retains the replay point. This is the
local opt-in for reducing mixed-session prefill pauses. The mixed-turn
screen reduced the longest pause from 27–30 s to about 16 s. The edited
follow-up reloaded the same prefix and took longer to reach the first
token in that screen.

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

## Adaptive prefill opt-in

For the three-R9700 DeepSeek V4.1 Flash EXL3 2.9 bpw profile, keep
`--prefill-chunk 8192` in the engine arguments and add this setting to the
`env` object at startup:

```json
{
  "MAYA_DS4_ADAPTIVE_PREFILL_MAX": "12288"
}
```

Use the shared helper and exact peer reduction described above. A compatible
server can choose up to 12,288 rows for an idle text request with at least
128,000 fresh tokens after prefix reuse. Admission checks every GPU's reserve
with both HIP and driver accounting. The normal 8K cap applies when admission
fails. The server keeps its choice for the request and uses the existing
scheduler yield points.

Leave the setting unset or use `0` to use the normal prefill configuration.
`12288` is the supported nonzero value. The variable has the native
`DS4_ADAPTIVE_PREFILL_MAX` alias.

The wider workspace borrows GPU expert slots. The server restores the original
bytes before returning from each prefill call, including a yield or cancellation.
An unverified restore stops the engine. For validation, `DS4_CHECK_LEND=1`
reads the restored bytes back.

## Preferred DSpark pack for our 2.9 bpw profile

For our three-R9700 DeepSeek-V4.1-Flash-1017 EXL3 2.9 bpw profile, use 3-bit
routed DSpark experts on GPU 2. Keep this drafter for the 3.5 bpw and Q4 XL
profiles too. The Q4 XL comparison at equal helper residency found nearly
identical resumed decode with native MXFP4 and about 2 GiB more VRAM use.
Use the matching expert-major EXL3 mul1 donor
and build a separate pack that references both the base shards and the donor.
See the [EXL3 pack guide](ds4-exl3-packs.md#3-bit-dspark-routed-experts) for
the donor layout.

```sh
MODEL=/path/to/DeepSeek-V4.1-Flash-1017-EXL3-2.9bpw
DONOR=/path/to/model-exl3-mtp-experts-maya-layout.safetensors
python tools/ds4/pack.py --model "$MODEL" --drafter-experts "$DONOR" \
  --out "$MODEL/maya-ds4-dspark-3bit"
```

In the saved engine JSON's `args` list, replace the value following `--pack`
with the absolute path to `maya-ds4-dspark-3bit`. If a launcher passes the
engine arguments directly, change its `--pack` value too. Keep
`--dspark on --dspark-conf 0.65` and `DS4_DRAFT_GPU=2`. To switch back to
the bundled drafter, point `--pack` at the original `maya-ds4` directory.

In two 512-token coding turns, the 3-bit pack freed 1,620 MiB on GPU 2 and
raised median decode throughput by 3.8% and 7.8%. Each configuration had two
independent loads. The generated responses differed, and two 16-token turns
showed mixed results.

## Optional Q4 XL profile

For DeepSeek V4.1 Flash `UD-Q4_K_XL`, keep `--prefill-chunk 8192` and the
2,048 MiB reserve. The tested profile uses TP2 on GPUs 0 and 1, with the shared
helper and 3-bit EXL3 DSpark on GPU 2 and vision enabled. Omit the EXL3 target
packing flag for this profile and use:

```json
{
  "MAYA_DS4_MXFP4_PACKED_HOST": "1",
  "MAYA_DS4_MXFP4_KEEP_CPU": "16"
}
```

With the hybrid host layout, median fresh 32K TTFT went from 50.7 to 40.6 s.
Resumed 32K decode went from 27.1 to 26.8 tok/s, and warm short decode went
from 30.1 to 28.3 tok/s. Use the ordinary host layout when short decode
throughput takes priority.

For prefill-heavy Q4 XL use the separately calibrated fixed 12K profile.
It sets `--prefill-chunk 12288`, keeps the 2,048 MiB reserve, caps the shared
helper at `DS4_HELPER_GB=19.5`, and restores the saved late-allocation
calibration with at least 1,760 MiB on GPU 0. The calibrated run kept at least
2,366 MiB driver-reported free on every GPU. Its 32K TTFT was 38.83 s versus
40.63 s for the prior hybrid 8K run. Short decode went from 28.35 to
26.58 tok/s, so prefer 8K for decode-heavy use. Confirm the VRAM floor under
load before using fixed 12K with a different placement or build.

### FP8 MXFP4 prefill modes

On our R9700s, leave `MAYA_DS4_MXFP4_WMMA_FP8` unset for the tested automatic mode. To override it, set the variable in the engine's `env` before startup.

| Value | Routed expert matrix prefill |
| --- | --- |
| Unset or `2` | DeepSeek-style BF16 inputs and E4M3 activations with power-of-two E8M0 scales |
| `0` | FP16 |
| `1` | E4M3 activations with an unrounded amax/448 scale |

Both FP8 modes quantize groups of 32 activation values and keep the MXFP4
weight files and PCIe payloads. Mode 2 rounds to BF16 before quantization at
the gate/up input and after SwiGLU when both projections use MXFP4. Automatic mode routes mixed-format experts and light groups through their
existing kernels. The FP8 paths require HIP gfx1200 or gfx1201 and enabled
matrix cores.

On our three R9700s, the earlier E8M0 prototype with FP16 inputs cut fresh
32K TTFT by about 13% over FP16 matrix prefill on two Q4 XL prompts at the
same residency. With BF16 inputs, those two prompts took 29.55 and 28.61 s
versus 30.22 and 28.65 s on a repeated FP16-input E8M0 control. Resumed
decode was mixed. The coding smoke results cover the earlier FP16-input
prototype.
