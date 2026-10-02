echo "Enable DPCD AUX backlight control on Dell XPS OLED panels"

rebuild_marker="${OMARCHY_DELL_XPS_OLED_BACKLIGHT_MARKER:-/var/lib/omarchy/migrations/1788886195}"
running_cmdline="${OMARCHY_DELL_XPS_OLED_RUNNING_CMDLINE:-/proc/cmdline}"

omarchy-hw-dell-xps-oled && omarchy-cmd-present limine-mkinitcpio || exit 0

# Booted with the parameter already, so neither rebuild nor reboot is needed.
[[ -r $running_cmdline ]] && grep -Eq '(^| )xe\.enable_dpcd_backlight=1( |$)' "$running_cmdline" && exit 0

# The rebuild is machine-wide, so a marker keeps another user's migration from
# repeating it, while a missing one still retries an interrupted rebuild.
if [[ ! -e $rebuild_marker ]]; then
  source "$OMARCHY_PATH/install/hardware/dell-xps-oled-display-backlight.sh"
  sudo limine-mkinitcpio
  sudo install -Dm644 /dev/null "$rebuild_marker"
fi

# The reboot prompt is per-user, so every user who has not rebooted since gets it.
omarchy-state set reboot-required
