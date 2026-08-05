#!/usr/bin/env bash

# This file is part of Keycloak Operator Helm Chart <https://github.com/StevenJDH/helm-charts>.
# Copyright (C) 2026 Steven Jenkins De Haro.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Purpose: Converts a Kubernetes CRD YAML file into a Markdown table of properties.
#          Note: This will exclude containers with descriptions, which may have
#                provided additional context. However, this was done to significantly
#                reduce the size and complexity of the generated documentation.
#
# USAGE:
# chmod +x crd-to-md.sh
# ./crd-to-md.sh keycloaks.k8s.keycloak.org-v1.yml keycloaks.md

set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <crd.yaml> [output.md]"
    exit 1
fi

CRD="$1"
OUT="${2:-properties.md}"

command -v yq >/dev/null || { echo "Missing dependency: yq v4"; exit 1; }
command -v jq >/dev/null || { echo "Missing dependency: jq"; exit 1; }

cat >"$OUT" <<EOF
# [PLACEHOLDER] CRD Reference

This generated document lists the configurable properties available under \`spec\` for the \`[PLACEHOLDER]\` custom resource.

## Reference

| Property path | Type | Description |
|---------------|------|-------------|
EOF

yq -o=json '.' "$CRD" |
jq -r '

def typename:
  if ."x-kubernetes-int-or-string" == true then
    "int-or-string"

  elif .type? == "array" then
    if .items.type? then
      "array[" + .items.type + "]"
    else
      "array"
    end

  elif .additionalProperties? then
    "map<string," + (.additionalProperties.type // "any") + ">"

  elif .oneOf? then
    (.oneOf | map(.type // "object") | unique | join(" | "))

  elif .anyOf? then
    (.anyOf | map(.type // "object") | unique | join(" | "))

  elif .allOf? then
    "object"

  else
    (.type // "object")
  end;


def should_emit:

  # Everything that is not an object
  if (.type? // "") != "object" then
    true

  # Maps
  elif .additionalProperties? then
    true

  # Arrays
  elif .items? then
    true

  # Union schemas
  elif .oneOf? or .anyOf? or .allOf? then
    true

  # Objects that actually define values
  elif .enum? or .default? or .const? or .pattern? or .format? then
    true

  # Object with no children
  elif (.properties | length? // 0) == 0 then
    true

  # Pure container
  else
    false
  end;


def walk($path):

  (
    if $path != "" and should_emit then
      [
        $path,
        typename,
        ((.description // "")
            | gsub("\r";" ")
            | gsub("\n";" "))
      ]
    else
      empty
    end
  ),

  (
    (.properties // {})
    | to_entries[]
    | . as $e
    | $e.value
    | walk(
        if $path == ""
        then $e.key
        else $path + "." + $e.key
        end
      )
  ),

  (
    if .items.properties? then
      .items.properties
      | to_entries[]
      | . as $e
      | $e.value
      | walk($path + "[]." + $e.key)
    else
      empty
    end
  );

.spec.versions[]
| select(.schema != null)
| .schema.openAPIV3Schema.properties.spec
| walk("spec")
| @tsv

' |
while IFS=$'\t' read -r path type description
do
  # Replace CR/LF/TAB with spaces
  description=${description//$'\r'/ }
  description=${description//$'\n'/ }
  description=${description//$'\t'/ }

  # Collapse repeated spaces
  while [[ "$description" == *"  "* ]]; do
      description=${description//  / }
  done

  # Escape markdown table pipes
  description=${description//|/\\|}

  printf '| `%s` | %s | %s |\n' \
      "$path" \
      "$type" \
      "$description"
done >> "$OUT"

echo "Generated $OUT"