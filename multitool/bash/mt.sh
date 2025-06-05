#!/usr/bin/env bash

set -e

# multitool - Universal Package Manager Wrapper & more
# Usage: multitool install <package> | search <package> | install-package-manager

function detect_os() {
    unameOut="$(uname -s)"
    case "${unameOut}" in
        Linux*)     OS=Linux;;
        Darwin*)    OS=Mac;;
        *)          OS="UNKNOWN"
    esac
    echo "$OS"
}

function detect_package_manager() {
    OS="$1"
    if [[ $OS == "Mac" ]]; then
        if command -v brew &>/dev/null; then
            echo "brew"
        else
            echo "none"
        fi
    elif [[ $OS == "Linux" ]]; then
        if command -v apt &>/dev/null; then
            echo "apt"
        elif command -v dnf &>/dev/null; then
            echo "dnf"
        elif command -v yum &>/dev/null; then
            echo "yum"
        elif command -v pacman &>/dev/null; then
            echo "pacman"
        elif command -v zypper &>/dev/null; then
            echo "zypper"
        else
            echo "none"
        fi
    else
        echo "none"
    fi
}

function usage() {
    echo "Usage: $0 {install|search|install-package-manager} <package>"
    echo "  install <package>               Install a package"
    echo "  search <package>                Search for a package"
    echo "  install-package-manager         Install the default package manager (macOS only: Homebrew)"
    exit 1
}

function install_package_manager() {
    OS=$(detect_os)
    if [[ "$OS" != "Mac" ]]; then
        echo "Automatic package manager installation is only supported on macOS (Homebrew)."
        exit 2
    fi
    if command -v brew &>/dev/null; then
        echo "Homebrew is already installed."
        return 0
    fi
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Homebrew installed successfully."
}

function install_package() {
    MANAGER="$1"
    PKG="$2"
    if [[ $MANAGER == "brew" ]]; then
        brew install "$PKG"
    elif [[ $MANAGER == "apt" ]]; then
        sudo apt update
        sudo apt install -y "$PKG"
    elif [[ $MANAGER == "dnf" ]]; then
        sudo dnf install -y "$PKG"
    elif [[ $MANAGER == "yum" ]]; then
        sudo yum install -y "$PKG"
    elif [[ $MANAGER == "pacman" ]]; then
        sudo pacman -Sy --noconfirm "$PKG"
    elif [[ $MANAGER == "zypper" ]]; then
        sudo zypper install -y "$PKG"
    else
        echo "No supported package manager found."
        exit 2
    fi
}

function search_package() {
    MANAGER="$1"
    PKG="$2"
    if [[ $MANAGER == "brew" ]]; then
        brew search "$PKG"
    elif [[ $MANAGER == "apt" ]]; then
        apt search "$PKG"
    elif [[ $MANAGER == "dnf" ]]; then
        dnf search "$PKG"
    elif [[ $MANAGER == "yum" ]]; then
        yum search "$PKG"
    elif [[ $MANAGER == "pacman" ]]; then
        pacman -Ss "$PKG"
    elif [[ $MANAGER == "zypper" ]]; then
        zypper search "$PKG"
    else
        echo "No supported package manager found."
        exit 2
    fi
}

# Main
if [[ $# -lt 1 ]]; then
    usage
fi

ACTION="$1"
PKG="$2"

if [[ $ACTION == "install-package-manager" ]]; then
    install_package_manager
    exit 0
fi

if [[ $# -lt 2 ]]; then
    usage
fi

OS=$(detect_os)
MANAGER=$(detect_package_manager "$OS")

if [[ $MANAGER == "none" ]]; then
    if [[ $OS == "Mac" ]]; then
        echo "Homebrew is not installed. You can install it using:"
        echo "  $0 install-package-manager"
    else
        echo "No supported package manager found on your system."
    fi
    exit 2
fi

case "$ACTION" in
    install)
        install_package "$MANAGER" "$PKG"
        ;;
    search)
        search_package "$MANAGER" "$PKG"
        ;;
    *)
        usage
        ;;
esac
