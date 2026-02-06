#!/usr/bin/env bash
set -euo pipefail

HOST_HOME="${HOST_HOME:-$HOME}"
JUNEST_HOME="${JUNEST_HOME:-$HOST_HOME/.junest}"
JUNEST_REPO_DIR="${JUNEST_REPO_DIR:-$HOST_HOME/.local/share/junest}"

if [ ! -d "$JUNEST_REPO_DIR" ]; then
  git clone https://github.com/fsquillace/junest.git "$JUNEST_REPO_DIR"
else
  echo "junest repo already exists: $JUNEST_REPO_DIR"
fi

export PATH="$JUNEST_REPO_DIR/bin:$PATH"
junest setup

# DNS
cp /etc/resolv.conf "$JUNEST_HOME/etc/resolv.conf"
chmod 644 "$JUNEST_HOME/etc/resolv.conf"

# mirrors (ceux qui marchent chez toi)
cat > "$JUNEST_HOME/etc/pacman.d/mirrorlist" <<'EOF'
Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch
Server = https://mirrors.kernel.org/archlinux/$repo/os/$arch
Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch
EOF

# ---- pacman.conf TEMPORAIRE (désactive signatures) ----
cat > "$JUNEST_HOME/etc/pacman.conf" <<'EOF'
[options]
SigLevel = Never
LocalFileSigLevel = Never
Architecture = auto

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist
EOF

# sync + install keyring sans vérif PGP
junest -n sudo pacman -Sy --noconfirm
junest -n sudo pacman -S --noconfirm archlinux-keyring

# ---- pacman.conf NORMAL ----
cat > "$JUNEST_HOME/etc/pacman.conf" <<'EOF'
[options]
SigLevel = Required DatabaseOptional
LocalFileSigLevel = Optional
Architecture = auto

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist
EOF

# rebuild keyring proprement
junest -n sudo rm -rf /etc/pacman.d/gnupg
junest -n sudo pacman-key --init
junest -n sudo pacman-key --populate archlinux

# nettoyage cache pour éviter prompts
junest -n sudo rm -f /var/cache/pacman/pkg/*.pkg.tar.*

# upgrade final
junest -n sudo pacman -Syu --noconfirm

echo "done"
echo ""
