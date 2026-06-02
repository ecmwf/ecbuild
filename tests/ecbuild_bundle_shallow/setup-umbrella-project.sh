#!/usr/bin/env bash

set -e
set -u
set -o pipefail

# ─────────────────────────────────────────────
# Configuration
# ─────────────────────────────────────────────
BASE_DIR="${1:-$(pwd)/projects}"

PROJECTS=(alpha beta gamma)
UMBRELLA="umbrella"

echo "==> Creating workspace at: $BASE_DIR"
mkdir -p "$BASE_DIR"
cd "$BASE_DIR"

# ─────────────────────────────────────────────
# Helper: make a commit
# ─────────────────────────────────────────────
commit() {
    git add -A
    git commit -m "$1"
}

# ─────────────────────────────────────────────
# Create the 3 dummy projects
# ─────────────────────────────────────────────
for proj in "${PROJECTS[@]}"; do
    echo ""
    echo "──> Setting up project: $proj"
    mkdir -p "$proj"
    cd "$proj"
    git init -b main
    git config --local user.email "demo@example.com"
    git config --local user.name  "Demo User"

    # Initial commit with README
    cat > README.md <<EOF
# Project $proj
EOF
    commit "Initial commit: add README"

    # Second commit — add a source file
    mkdir -p src
    cat > "src/$proj.sh" <<EOF
#!/usr/bin/env bash
echo "Hello from $proj!"
EOF
    chmod +x "src/$proj.sh"
    commit "Add src/$proj.sh"

    # Third commit — update README with usage
    cat >> README.md <<EOF
## Usage

\`\`\`bash
bash src/$proj.sh
\`\`\`
EOF
    commit "docs: add usage section to README"

    # Fourth commit — add a config file
    cat > config.env <<EOF
PROJECT_NAME=$proj
VERSION=0.1.0
ENABLED=true
EOF
    commit "Add config.env"

    echo "    $proj: $(git log --oneline | wc -l | tr -d ' ') commits"
    cd ..
done

# ─────────────────────────────────────────────
# Create the umbrella project with submodules
# ─────────────────────────────────────────────
echo ""
echo "──> Setting up umbrella project: $UMBRELLA"
mkdir -p "$UMBRELLA"
cd "$UMBRELLA"
git init -b main
git config --local user.email "demo@example.com"
git config --local user.name  "Demo User"

# Initial README
cat > README.md <<EOF
# Umbrella Project
EOF

cat > CMakeLists.txt <<EOF

cmake_minimum_required(VERSION 3.18 FATAL_ERROR)

project( umbrella LANGUAGES NONE )

EOF

commit "Initial commit: add README"

# IMPORTANT: create each project as a submodule using file:// URL
# to honor shallow clones (--depth 1)
BARE_DIR="$BASE_DIR/../bare-repos"
mkdir -p "$BARE_DIR"
for proj in "${PROJECTS[@]}"; do
    git clone --bare "$BASE_DIR/$proj" "$BARE_DIR/$proj.git" >/dev/null
    git submodule add "file://$BARE_DIR/$proj.git" "$proj"
done
commit "Add submodules: alpha, beta, gamma"

# A follow-up commit that records a pinned state
cat >> README.md <<EOF

## Notes

Submodule remotes point to local sibling directories for demo purposes.
Replace the URLs in \`.gitmodules\` with real remote URLs before sharing.
EOF
commit "docs: note about submodule remote URLs"

# IMPORTANT: bare repo to ensure shallow clone behavior is honored
git clone --bare "$(pwd)" "$BARE_DIR/$UMBRELLA.git" >/dev/null
