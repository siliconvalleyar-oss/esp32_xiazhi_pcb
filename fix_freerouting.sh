#!/bin/bash
# Fix FreeRouting DSN export for KiCad 2-layer boards
# Removes references to non-existent internal layers (In1.Cu, In2.Cu)

DSN_FILE="freerouting.dsn"

if [ ! -f "$DSN_FILE" ]; then
    echo "Error: $DSN_FILE not found. Run KiCad 'Export Specctra DSN' first."
    exit 1
fi

echo "Fixing $DSN_FILE..."

# Backup original
cp "$DSN_FILE" "${DSN_FILE}.bak"

# Remove layer definitions for In1.Cu and In2.Cu (they don't exist in 2-layer board)
sed -i '/layer "In1.Cu"/d' "$DSN_FILE"
sed -i '/layer "In2.Cu"/d' "$DSN_FILE"

# Remove any shape/polygon references to In1.Cu and In2.Cu in GND net
sed -i '/layer "In1.Cu"/d' "$DSN_FILE"
sed -i '/layer "In2.Cu"/d' "$DSN_FILE"

# Fix: remove empty plane definitions that cause NullPointerException
# This removes problematic plane entries for layers that don't exist
awk '
/^\(plane/ { in_plane=1; plane_content=$0; next }
in_plane {
    plane_content = plane_content "\n" $0
    if (/^\)/) {
        in_plane=0
        # Check if this plane references In1.Cu or In2.Cu
        if (plane_content !~ /In1\.Cu/ && plane_content !~ /In2\.Cu/) {
            print plane_content
        }
        next
    }
    next
}
{ print }
' "$DSN_FILE" > "${DSN_FILE}.tmp" && mv "${DSN_FILE}.tmp" "$DSN_FILE"

echo "Done. Backup saved as ${DSN_FILE}.bak"
echo "Now run FreeRouting again."