echo "Enable DPCD AUX backlight control on Dell XPS OLED panels"

# The kernel command line only changes in the boot image, so rebuild it here
# and ask for a reboot. A machine-wide marker keeps another user's migration
# from repeating both, while a missing one still retries an interrupted rebuild.

rebuild_marker="${OMARCHY_DELL_XPS_OLED_BACKLIGHT_MARKER:-/var/lib/omarchy/migrations/1788886195}"

if omarchy-hw-dell-xps-oled && omarchy-cmd-present limine-mkinitcpio && [[ ! -e $rebuild_marker ]]; then
  source "$OMARCHY_PATH/install/hardware/dell-xps-oled-display-backlight.sh"
  sudo limine-mkinitcpio
  omarchy-state set reboot-required
  sudo install -Dm644 /dev/null "$rebuild_marker"
fi
