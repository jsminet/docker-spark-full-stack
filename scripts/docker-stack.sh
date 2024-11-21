#!/usr/bin/env bash
# Convert classic compose file to compose swarm file
set -ex
docker compose config | sed '/published:/s/\"//g' | sed '/^name:/d' | sed -E 's/(cpus*[^:]+:)\s*([^"#\n]+)$/\1 "\2"/' > compose-swarm.yml