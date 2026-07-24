#!/usr/bin/env bash
#
# dotfiles のシンボリックリンクを $HOME に張るスクリプト
#
#   ./install.sh            リンクを張る（既存ファイルはバックアップ）
#   ./install.sh --dry-run  実行内容を表示するだけ
#   ./install.sh --force    既存ファイルをバックアップせず上書き
#
set -euo pipefail

# ============================================================
# Settings
# ============================================================

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d-%H%M%S)"

# リンク対象から除外するもの（リポジトリ運用用のファイル）
EXCLUDES=(
	.git
	.github
	.gitignore
	.gitmodules
	.DS_Store
)

DRY_RUN=0
FORCE=0

# ============================================================
# Helpers
# ============================================================

info()  { printf '\033[36m==>\033[0m %s\n' "$*"; }
warn()  { printf '\033[33m[warn]\033[0m %s\n' "$*" >&2; }
error() { printf '\033[31m[error]\033[0m %s\n' "$*" >&2; }

# --dry-run のときは実行せず表示だけする
run() {
	if [ "$DRY_RUN" -eq 1 ]; then
		printf '    (dry-run) %s\n' "$*"
	else
		"$@"
	fi
}

is_excluded() {
	local name="$1" e
	for e in "${EXCLUDES[@]}"; do
		[ "$name" = "$e" ] && return 0
	done
	return 1
}

usage() {
	cat <<'EOF'
Usage: ./install.sh [options]

Options:
  -n, --dry-run   実際には変更せず、実行内容だけ表示する
  -f, --force     既存ファイルをバックアップせずに削除して上書きする
  -h, --help      このヘルプを表示する
EOF
}

# ============================================================
# Arguments
# ============================================================

while [ $# -gt 0 ]; do
	case "$1" in
		-n|--dry-run) DRY_RUN=1 ;;
		-f|--force)   FORCE=1 ;;
		-h|--help)    usage; exit 0 ;;
		*)            error "不明なオプション: $1"; usage; exit 1 ;;
	esac
	shift
done

# ============================================================
# Main
# ============================================================

info "dotfiles: $DOTFILES_DIR"
info "リンク先: $HOME"
[ "$DRY_RUN" -eq 1 ] && info "dry-run モード（変更は行いません）"
echo

linked=0
skipped=0

for src in "$DOTFILES_DIR"/.[!.]*; do
	[ -e "$src" ] || continue          # マッチしなかった場合のグロブ文字列を弾く

	name="$(basename "$src")"
	is_excluded "$name" && continue

	dest="$HOME/$name"

	# すでに正しいリンクなら何もしない（何度実行しても安全）
	if [ -L "$dest" ] && [ "$(readlink -f "$dest")" = "$(readlink -f "$src")" ]; then
		printf '    skip  %-24s (already linked)\n' "$name"
		skipped=$((skipped + 1))
		continue
	fi

	# 既存の実体ファイル／別のリンクを退避 or 削除
	if [ -e "$dest" ] || [ -L "$dest" ]; then
		if [ "$FORCE" -eq 1 ]; then
			run rm -rf "$dest"
			warn "$name を削除しました（--force）"
		else
			run mkdir -p "$BACKUP_DIR"
			run mv "$dest" "$BACKUP_DIR/$name"
			warn "$name を $BACKUP_DIR/ に退避しました"
		fi
	fi

	run ln -s "$src" "$dest"
	printf '    link  %-24s -> %s\n' "$name" "$src"
	linked=$((linked + 1))
done

echo
info "完了: $linked 件リンク / $skipped 件スキップ"
if [ "$DRY_RUN" -eq 0 ] && [ -d "$BACKUP_DIR" ]; then
	info "バックアップ: $BACKUP_DIR"
fi
