{pkgs, ...}: with pkgs; {
  fonts.packages = [
    (nerdfonts.override { fonts = [ "Iosevka" "JetBrainsMono" "Noto" "Mononoki" ]; })
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    font-awesome
    iosevka
  ];
}
