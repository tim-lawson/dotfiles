# Ricoh GR IIIx card import: `ricoh`, or `ricoh -n` to dry-run.
#
# JPGs go to the Mac and the Media HDD, DNGs to the HDD only. --ignore-existing
# makes it additive: anything already at a destination is skipped unread, so
# reimporting a full card is cheap and local edits survive. The card is only
# ever read from.

: ${RICOH_CARD:=/Volumes/RICOH GR}
: ${RICOH_JPG:=$HOME/Pictures/JPG}
: ${RICOH_ARCHIVE:=/Volumes/Media/MEGA/Photos}

ricoh() {
    emulate -L zsh
    local -a flags=(-rth --ignore-existing --progress)
    # A dry run's progress meter is just a 0% line per file.
    [[ ${1-} == (-n|--dry-run) ]] && flags=(${flags:#--progress} -ni)

    # Trailing slash on each roll (100RICOH, 101RICOH, ...) merges them all
    # into one flat destination.
    local -a rolls=("$RICOH_CARD"/DCIM/*RICOH(N/))
    (( $#rolls )) || { print -ru2 "ricoh: no rolls in $RICOH_CARD/DCIM - card not inserted?"; return 1 }
    rolls=("${rolls[@]/%//}")

    local job pattern dest
    local -i rc=0
    for job in "*.JPG:$RICOH_JPG" "*.JPG:$RICOH_ARCHIVE/JPG" "*.DNG:$RICOH_ARCHIVE/RAW"; do
        pattern=${job%%:*} dest=${job#*:}
        # Without this, an unmounted HDD means mkdir writes 5 GB to the boot disk.
        [[ -d ${dest:h} ]] || { print -ru2 "ricoh: ${dest:h} not mounted, skipping"; rc=1; continue }
        print -r -- $'\n'"$pattern -> $dest"
        # Rules match in order: sidecars dropped, the pattern kept, rest dropped.
        mkdir -p -- $dest &&
            rsync $flags --exclude='._*' --include=$pattern --exclude='*' -- $rolls $dest/ || rc=1
    done
    return rc
}
