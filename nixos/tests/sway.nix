import ./make-test-python.nix ({ pkgs, lib, ...} :

{
  name = "sway";
  meta = {
    maintainers = with lib.maintainers; [ primeos synthetica ];
  };

  machine = { config, ... }: {
    imports = [ ./common/user-account.nix ];
    services.getty.autologinUser = "alice";

    # Use a fixed SWAYSOCK path (for swaymsg):
    environment.variables."SWAYSOCK" = "/tmp/sway-ipc.sock";
    # For glinfo and wayland-info:
    environment.systemPackages = with pkgs; [ mesa-demos wayland-utils ];

    programs.sway.enable = true;

    virtualisation.memorySize = 1024;
    # Need to switch to a different VGA card / GPU driver than the default one (std) so that Sway can launch:
    virtualisation.qemu.options = [ "-vga virtio" ];
  };

  enableOCR = true;

  testScript = { nodes, ... }: ''
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.wait_until_tty_matches(1, "alice\@machine")

    # Configure and launch Sway:
    machine.succeed(
        "su - alice -c 'mkdir -p ~/.config/sway && sed s/Mod4/Mod1/ /etc/sway/config > ~/.config/sway/config'"
    )
    machine.send_chars("sway && touch exit-ok\n")
    machine.wait_for_file("/run/user/1000/wayland-1")
    machine.wait_for_file("/tmp/sway-ipc.sock")

    # Test XWayland:
    machine.succeed(
        "su - alice -c 'swaymsg exec WINIT_UNIX_BACKEND=x11 WAYLAND_DISPLAY=invalid alacritty'"
    )
    machine.wait_for_text("alice@machine")
    machine.send_chars("glinfo | head -n 3\n")
    machine.sleep(5)
    machine.screenshot("alacritty_glinfo")
    machine.succeed("pkill alacritty")

    # Start a terminal (Alacritty) on workspace 3:
    machine.send_key("alt-3")
    machine.succeed(
        "su - alice -c 'swaymsg exec WINIT_UNIX_BACKEND=wayland DISPLAY=invalid alacritty'"
    )
    machine.wait_for_text("alice@machine")
    machine.send_chars("wayland-info\n")
    machine.sleep(5)
    machine.screenshot("alacritty_wayland_info")
    machine.send_key("alt-shift-q")
    machine.wait_until_fails("pgrep alacritty")

    # Test swaynag:
    machine.send_key("alt-shift-e")
    machine.wait_for_text("You pressed the exit shortcut.")
    machine.screenshot("sway_exit")

    # Exit Sway and verify process exit status 0:
    machine.succeed("su - alice -c 'swaymsg exit || true'")
    machine.wait_for_file("/home/alice/exit-ok")
  '';
})
