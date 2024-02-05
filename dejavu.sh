#!/bin/sh

dotfiles="https://github.com/me0mar/dotfiles"
neovim="https://github.com/me0mar/nvim"
dwm="https://github.com/me0mar/dwm"
st="https://github.com/me0mar/st"
dmenu="https://github.com/me0mar/dmenu"

error() {
	exit 1
}

optimizedDnf(){
  sudo cp ./dnf-config/dnf.conf /etc/dnf/dnf.conf
} 

fixScreenTearing(){
  sudo cp ./fix-screen-tearing/20-amd-gpu.conf /etc/X11/xorg.conf.d/
}

enableRpmfusion(){ 
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm
sudo dnf groupupdate core -y
}

switchFullFfmpeg(){
  sudo dnf -y swap ffmpeg-free ffmpeg --allowerasing
}

additionalCodec(){
  sudo dnf -y groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
  sudo dnf -y groupupdate sound-and-video
  sudo dnf -y install lame\* --exclude=lame-devel
}

amdDrivers(){
  sudo dnf -y swap mesa-va-drivers mesa-va-drivers-freeworld
  sudo dnf -y swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
}

fonts(){
  sudo dnf install -y fonts google-noto-kufi-arabic-fonts google-noto-naskh-arabic-fonts
  sudo dnf install -y dejavu-sans-fonts fira-code-fonts
}

xorg(){
  sudo dnf install -y xinit libX11-devel libXft-devel libXinerama-devel xorg-x11-server-Xorg
  sudo dnf install -y xorg-x11-drv-amdgpu libxcb libX11-xcb
}

utilities(){
  sudo dnf install -y rsync unrar p7zip p7zip-plugins zip unzip bat lsd keepassxc lxappearance
  sudo dnf install -y mpv vlc ncmpcpp mpc mpv docker docker-compose htop make gcc
  sudo dnf install -y vim neovim clang git dunst pcmanfm nitrogen pavucontrol wget curl
}

webBrowsers(){
  sudo dnf install -y firefox torbrowser-launcher
  sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.add-repo
  sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
  sudo dnf install -y brave-browser
}

hardeningFirefox(){
  # Find the profile directory dynamically
  PROFILE_DIR=$(find ~/.mozilla/firefox -maxdepth 1 -type d -name "*default-release*" | head -n 1)

  if [ -z "$PROFILE_DIR" ]; then
    echo "Error: Could not find default-release profile directory."
    exit 1
  fi
  # Navigate to the profile directory
  cd "$PROFILE_DIR"
  # Download user.js
  curl -o user.js https://codeberg.org/Narsil/user.js/raw/branch/main/desktop/user.js
}

buildSuckless(){
  mkdir -p "$HOME/.config/suckless" && cd "$HOME/.config/suckless/"*
  git clone $dwm  
  git clone $st  
  git clone $dmenu
}

optimizedDnf || error
fixScreenTearing || error
enableRpmfusion || error
switchFullFfmpeg || error 
additionalCodec || error
amdDrivers || error
fonts || error
xorg || error
utilities || error
webBrowsers || error
hardeningFirefox || error
