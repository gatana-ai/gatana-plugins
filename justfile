# Release tooling for the Gatana plugins.
#
#   just release            bump the patch version, tag, push and publish a GitHub release
#   just release minor      same, but bump the minor version
#   just release 2.0.0      same, but set an explicit version
#   just bump [level]       only write the new version to the manifests
#   just zip                only build the zip files in dist/

set shell := ["bash", "-euo", "pipefail", "-c"]

repo    := "gatana-ai/gatana-plugins"
dist    := "dist"
claude  := "plugins/claude"
chatgpt := "plugins/chatgpt"

# Files that carry the version number.
manifests := claude + "/.claude-plugin/plugin.json " + chatgpt + "/plugin.json .claude-plugin/marketplace.json"

default:
    @just --list

# Print the current version.
version:
    @jq -r .version {{claude}}/.claude-plugin/plugin.json

# Write a new version to all manifests. LEVEL is patch, minor, major or an explicit version.
bump level="patch":
    #!/usr/bin/env bash
    set -euo pipefail
    current="$(jq -r .version {{claude}}/.claude-plugin/plugin.json)"
    IFS=. read -r major minor patch <<< "$current"
    case "{{level}}" in
        major) new="$((major + 1)).0.0" ;;
        minor) new="$major.$((minor + 1)).0" ;;
        patch) new="$major.$minor.$((patch + 1))" ;;
        [0-9]*.[0-9]*.[0-9]*) new="{{level}}" ;;
        *) echo "bump: expected patch, minor, major or X.Y.Z, got '{{level}}'" >&2; exit 1 ;;
    esac
    for file in {{claude}}/.claude-plugin/plugin.json {{chatgpt}}/plugin.json; do
        jq --arg v "$new" '.version = $v' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
    done
    file=.claude-plugin/marketplace.json
    jq --arg v "$new" '.plugins |= map(.version = $v)' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
    echo "$current -> $new"

# Build dist/gatana-claude-plugin-vX.Y.Z.zip and dist/gatana-chatgpt-plugin-vX.Y.Z.zip.
zip:
    #!/usr/bin/env bash
    set -euo pipefail
    v="$(just version)"
    rm -rf {{dist}} && mkdir -p {{dist}}
    (cd {{claude}}  && zip -qr "../../{{dist}}/gatana-claude-plugin-v$v.zip"  . -x '.DS_Store' '*/.DS_Store')
    (cd {{chatgpt}} && zip -qr "../../{{dist}}/gatana-chatgpt-plugin-v$v.zip" . -x '.DS_Store' '*/.DS_Store')
    ls -l {{dist}}

# Bump the version, commit, tag, push and publish a GitHub release with both zip files.
release level="patch":
    #!/usr/bin/env bash
    set -euo pipefail
    branch="$(git rev-parse --abbrev-ref HEAD)"
    if [ "$branch" != "main" ]; then
        echo "release: you are on '$branch', switch to main first" >&2; exit 1
    fi
    if [ -n "$(git status --porcelain)" ]; then
        echo "release: the working tree is not clean, commit or stash your changes first" >&2; exit 1
    fi
    gh auth status >/dev/null
    git pull --ff-only
    just bump {{level}}
    v="$(just version)"
    if git rev-parse -q --verify "refs/tags/v$v" >/dev/null; then
        echo "release: tag v$v already exists" >&2; git checkout -- {{manifests}}; exit 1
    fi
    git add {{manifests}}
    git commit -m "Release v$v"
    git tag -a "v$v" -m "v$v"
    git push origin main "v$v"
    just zip
    gh release create "v$v" \
        --repo {{repo}} \
        --title "v$v" \
        --generate-notes \
        {{dist}}/gatana-claude-plugin-v$v.zip \
        {{dist}}/gatana-chatgpt-plugin-v$v.zip
