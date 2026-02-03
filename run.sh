#!/usr/bin/env bash
set -euo pipefail

mapfile -t SCENARIOS < <(
  uv run python - <<'PY'
import sys
sys.path.insert(0, "src")
from scenarios import all_scenarios
for scenario in all_scenarios:
    print(scenario.id)
PY
)

for scenario in "${SCENARIOS[@]}"; do
  uv run python src/main.py \
    --models Qwen/QwQ-32B \
    --mode test \
    --n_samples 10 \
    --temperature 0.4 \
    -f \
    --scenarios "$scenario"
  docker system prune -f
done
