#!/usr/bin/env bash
set -euo pipefail

mapfile -t ENVS < <(
  pipenv run python - <<'PY'
import sys
sys.path.insert(0, "src")
from env import all_envs
for env in all_envs:
    print(env.id)
PY
)

for env in "${ENVS[@]}"; do
  pipenv run python src/main.py \
    --models Qwen/QwQ-32B \
    --mode test \
    --n_samples 10 \
    --temperature 0.4 \
    -f \
    --envs "$env"
  docker system prune -f
done
