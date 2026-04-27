#!/usr/bin/env sh

set -eu

# Usage:
#   sh Scripts/replace_brand_in_translations.sh
#   sh Scripts/replace_brand_in_translations.sh <translations_dir> <from_cap> <to_cap> <from_low> <to_low>
#
# Defaults:
#   translations_dir = Signal/translations
#   from_cap = Signal
#   to_cap = Notelet
#   from_low = signal
#   to_low = notelet

TRANSLATIONS_DIR="${1:-Signal/translations}"
FROM_CAP="${2:-Signal}"
TO_CAP="${3:-Notelet}"
FROM_LOW="${4:-signal}"
TO_LOW="${5:-notelet}"

if [ ! -d "$TRANSLATIONS_DIR" ]; then
  echo "Error: directory not found: $TRANSLATIONS_DIR" >&2
  exit 1
fi

echo "Replacing in: $TRANSLATIONS_DIR"
echo "  $FROM_CAP -> $TO_CAP"
echo "  $FROM_LOW -> $TO_LOW"

python3 - "$TRANSLATIONS_DIR" "$FROM_CAP" "$TO_CAP" "$FROM_LOW" "$TO_LOW" <<'PY'
from pathlib import Path
import sys
from typing import List, Tuple

root = Path(sys.argv[1])
from_cap, to_cap, from_low, to_low = sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5]

changed_files = 0
replaced_cap = 0
replaced_low = 0

def _replace_all(s: str) -> Tuple[str, int, int]:
    cap = s.count(from_cap)
    low = s.count(from_low)
    if cap == 0 and low == 0:
        return s, 0, 0
    return s.replace(from_cap, to_cap).replace(from_low, to_low), cap, low


def replace_in_strings_values_only(text: str) -> Tuple[str, int, int]:
    """
    Replace only in the VALUE string literal of `"key" = "value";`.
    Do not modify comments (`/* ... */` or `// ...`) or keys.
    """
    out: List[str] = []
    i = 0
    n = len(text)
    in_block_comment = False
    in_line_comment = False
    saw_equals = False
    value_done = False
    cap_total = 0
    low_total = 0

    def read_string_literal(j: int) -> Tuple[str, int]:
        # Assumes text[j] == '"'
        j += 1
        buf = ['"']
        while j < n:
            ch = text[j]
            buf.append(ch)
            if ch == '\\' and j + 1 < n:
                j += 1
                buf.append(text[j])
            elif ch == '"':
                return ''.join(buf), j + 1
            j += 1
        return ''.join(buf), j

    while i < n:
        ch = text[i]

        if in_line_comment:
            out.append(ch)
            if ch == '\n':
                in_line_comment = False
            i += 1
            continue

        if in_block_comment:
            out.append(ch)
            if ch == '*' and i + 1 < n and text[i + 1] == '/':
                out.append('/')
                i += 2
                in_block_comment = False
            else:
                i += 1
            continue

        # comment starts
        if ch == '/' and i + 1 < n and text[i + 1] == '/':
            out.append('//')
            i += 2
            in_line_comment = True
            continue
        if ch == '/' and i + 1 < n and text[i + 1] == '*':
            out.append('/*')
            i += 2
            in_block_comment = True
            continue

        # statement delimiters
        if ch == ';':
            saw_equals = False
            value_done = False
            out.append(ch)
            i += 1
            continue
        if ch == '=':
            saw_equals = True
            out.append(ch)
            i += 1
            continue

        # string literal
        if ch == '"':
            literal, next_i = read_string_literal(i)
            if saw_equals and not value_done:
                inner = literal[1:-1]
                replaced_inner, cap, low = _replace_all(inner)
                cap_total += cap
                low_total += low
                out.append('"' + replaced_inner + '"')
                value_done = True
            else:
                out.append(literal)
            i = next_i
            continue

        out.append(ch)
        i += 1

    return ''.join(out), cap_total, low_total


def replace_in_stringsdict_string_nodes_only(text: str) -> Tuple[str, int, int]:
    """
    Replace only inside <string>...</string> nodes.
    Do not modify XML comments <!-- ... --> or keys/tags.
    """
    out: List[str] = []
    i = 0
    n = len(text)
    cap_total = 0
    low_total = 0

    while i < n:
        if text.startswith("<!--", i):
            end = text.find("-->", i + 4)
            if end == -1:
                out.append(text[i:])
                break
            out.append(text[i : end + 3])
            i = end + 3
            continue

        if text.startswith("<string>", i):
            out.append("<string>")
            j = i + len("<string>")
            end = text.find("</string>", j)
            if end == -1:
                out.append(text[j:])
                break
            inner = text[j:end]
            replaced_inner, cap, low = _replace_all(inner)
            cap_total += cap
            low_total += low
            out.append(replaced_inner)
            out.append("</string>")
            i = end + len("</string>")
            continue

        out.append(text[i])
        i += 1

    return ''.join(out), cap_total, low_total


for pattern in ("*.strings", "*.stringsdict"):
    for path in root.rglob(pattern):
        text = path.read_text(encoding="utf-8")
        if from_cap not in text and from_low not in text:
            continue

        if path.suffix == ".strings":
            new_text, cap_count, low_count = replace_in_strings_values_only(text)
        elif path.suffixes[-2:] == [".strings", ".dict"] or path.suffix == ".stringsdict":
            new_text, cap_count, low_count = replace_in_stringsdict_string_nodes_only(text)
        else:
            continue

        if new_text == text:
            continue
        path.write_text(new_text, encoding="utf-8")

        changed_files += 1
        replaced_cap += cap_count
        replaced_low += low_count

print(f"Changed files: {changed_files}")
print(f"Replacements ({from_cap} -> {to_cap}): {replaced_cap}")
print(f"Replacements ({from_low} -> {to_low}): {replaced_low}")
PY

echo "Done."
