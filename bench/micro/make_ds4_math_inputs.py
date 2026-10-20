"""Generate deterministic parity inputs; usage: TOKENIZER_JSON OUTPUT_DIRECTORY."""
import json
import pathlib
import sys
from tokenizers import Tokenizer

config = json.loads(pathlib.Path(__file__).with_name("ds4_math_cases.json").read_text())
tokenizer = Tokenizer.from_file(sys.argv[1])
output = pathlib.Path(sys.argv[2])
output.mkdir(parents=True, exist_ok=True)
for case in config["cases"]:
    seed = tokenizer.encode(config["texts"][case["text"]], add_special_tokens=False).ids
    count = case["tokens"] + case["prefix"]
    ids = (seed * ((count + len(seed) - 1) // len(seed)))[:count]
    (output / (case["name"] + "-ids.json")).write_text(json.dumps(ids))
