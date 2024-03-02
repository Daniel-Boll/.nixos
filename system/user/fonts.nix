{pkgs, ...}: with pkgs; {
  fonts.packages = [
    (nerdfonts.override { fonts = [ "Iosevka" "JetBrainsMono" "Noto" "Mononoki" ]; })
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    font-awesome
    iosevka
    source-han-sans
    source-han-sans-japanese
    source-han-serif-japanese
  ];
  fontconfig.defaultFonts = {
    serif = [ "Noto Serif" "Source Han Serif" ];
    sansSerif = [ "Noto Sans" "Source Han Sans" ];
  };
}
