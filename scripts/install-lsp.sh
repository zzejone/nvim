#!/usr/bin/env bash

set -u

# ============================================================
# Neovim LSP Installer
#
# Supported:
#   macOS
#   Arch Linux
#
# Usage:
#   ./scripts/install-lsp.sh
#
# Examples:
#   1 3 5
#   1,3,5
#   all
#   q
# ============================================================

set -o pipefail

# ------------------------------------------------------------
# Colors
# ------------------------------------------------------------

if [[ -t 1 ]]; then
    RED='\033[31m'
    GREEN='\033[32m'
    YELLOW='\033[33m'
    BLUE='\033[34m'
    CYAN='\033[36m'
    RESET='\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    CYAN=''
    RESET=''
fi

# ------------------------------------------------------------
# OS
# ------------------------------------------------------------

OS="$(uname -s)"

case "$OS" in
    Darwin)
        OS_NAME="macOS"
        ;;
    Linux)
        if [[ -f /etc/arch-release ]]; then
            OS_NAME="Arch Linux"
        else
            echo -e "${RED}Unsupported Linux distribution.${RESET}"
            echo "This script currently supports Arch Linux only."
            exit 1
        fi
        ;;
    *)
        echo -e "${RED}Unsupported OS: $OS${RESET}"
        exit 1
        ;;
esac

echo
echo -e "${CYAN}Neovim LSP Installer${RESET}"
echo "OS: $OS_NAME"
echo

# ------------------------------------------------------------
# Package manager helpers
# ------------------------------------------------------------

has_command() {
    command -v "$1" >/dev/null 2>&1
}

install_brew() {
    if has_command brew; then
        return 0
    fi

    echo -e "${YELLOW}Homebrew is not installed.${RESET}"
    echo "Please install Homebrew first:"
    echo "https://brew.sh"
    return 1
}

install_pacman_package() {
    local package="$1"

    if pacman -Qi "$package" >/dev/null 2>&1; then
        echo -e "${GREEN}$package is already installed.${RESET}"
        return 0
    fi

    sudo pacman -S --needed "$package"
}

install_aur_package() {
    local package="$1"

    if has_command yay; then
        yay -S --needed "$package"
        return $?
    fi

    if has_command paru; then
        paru -S --needed "$package"
        return $?
    fi

    echo -e "${YELLOW}$package is an AUR package.${RESET}"
    echo "Please install yay or paru first."
    return 1
}

install_brew_package() {
    local package="$1"

    if brew list "$package" >/dev/null 2>&1; then
        echo -e "${GREEN}$package is already installed.${RESET}"
        return 0
    fi

    brew install "$package"
}

install_npm_package() {
    if ! has_command npm; then
        echo -e "${RED}npm is not installed.${RESET}"
        echo "Install Node.js first."
        return 1
    fi

    npm install -g "$@"
}

install_go_package() {
    local package="$1"

    if ! has_command go; then
        echo -e "${RED}Go is not installed.${RESET}"
        echo "Install Go first."
        return 1
    fi

    go install "$package"
}

install_cargo_package() {
    local package="$1"

    if ! has_command cargo; then
        echo -e "${RED}cargo is not installed.${RESET}"
        echo "Install Rust first."
        return 1
    fi

    cargo install "$package"
}

install_pipx_package() {
    local package="$1"

    if ! has_command pipx; then
        echo -e "${RED}pipx is not installed.${RESET}"
        echo "Install pipx first."
        return 1
    fi

    pipx install "$package"
}

# ------------------------------------------------------------
# LSP definitions
#
# name
# description
# macOS install method
# Arch install method
# command used to detect installation
# ------------------------------------------------------------

declare -a LSP_NAME
declare -a LSP_DESC
declare -a LSP_MAC
declare -a LSP_ARCH
declare -a LSP_CMD

add_lsp() {
    LSP_NAME+=("$1")
    LSP_DESC+=("$2")
    LSP_MAC+=("$3")
    LSP_ARCH+=("$4")
    LSP_CMD+=("$5")
}

# ------------------------------------------------------------
# LSP list
# ------------------------------------------------------------

add_lsp \
    "gopls" \
    "Go" \
    "go" \
    "go" \
    "gopls"

add_lsp \
    "lua-language-server" \
    "Lua" \
    "brew" \
    "pacman" \
    "lua-language-server"

add_lsp \
    "typescript-language-server" \
    "TypeScript / JavaScript" \
    "npm" \
    "npm" \
    "typescript-language-server"

add_lsp \
    "pyright" \
    "Python" \
    "brew" \
    "pacman" \
    "pyright"

add_lsp \
    "rust-analyzer" \
    "Rust" \
    "brew" \
    "pacman" \
    "rust-analyzer"

add_lsp \
    "clangd" \
    "C / C++" \
    "brew" \
    "pacman" \
    "clangd"

add_lsp \
    "bash-language-server" \
    "Bash" \
    "npm" \
    "npm" \
    "bash-language-server"

add_lsp \
    "yaml-language-server" \
    "YAML" \
    "npm" \
    "npm" \
    "yaml-language-server"

add_lsp \
    "vscode-langservers-extracted" \
    "HTML / CSS / JSON" \
    "npm" \
    "npm" \
    "vscode-html-language-server"

add_lsp \
    "dockerfile-language-server-nodejs" \
    "Dockerfile" \
    "npm" \
    "npm" \
    "docker-langserver"

add_lsp \
    "taplo" \
    "TOML" \
    "brew" \
    "cargo" \
    "taplo"

add_lsp \
    "marksman" \
    "Markdown" \
    "brew" \
    "pacman" \
    "marksman"

add_lsp \
    "graphql-language-service-cli" \
    "GraphQL" \
    "npm" \
    "npm" \
    "graphql-lsp"

add_lsp \
    "intelephense" \
    "PHP" \
    "npm" \
    "npm" \
    "intelephense"

add_lsp \
    "solargraph" \
    "Ruby" \
    "gem" \
    "gem" \
    "solargraph"

# ------------------------------------------------------------
# Check dependencies
# ------------------------------------------------------------

check_dependency() {
    local manager="$1"

    case "$manager" in
        brew)
            if ! has_command brew; then
                echo -e "${RED}Homebrew is required.${RESET}"
                install_brew
                return 1
            fi
            ;;

        pacman)
            if ! has_command pacman; then
                echo -e "${RED}pacman is required.${RESET}"
                return 1
            fi
            ;;

        npm)
            if ! has_command npm; then
                echo -e "${RED}npm is required.${RESET}"
                echo "Install Node.js first."
                return 1
            fi
            ;;

        go)
            if ! has_command go; then
                echo -e "${RED}Go is required.${RESET}"
                return 1
            fi
            ;;

        cargo)
            if ! has_command cargo; then
                echo -e "${RED}Rust/Cargo is required.${RESET}"
                return 1
            fi
            ;;

        gem)
            if ! has_command gem; then
                echo -e "${RED}Ruby/Gem is required.${RESET}"
                return 1
            fi
            ;;

        *)
            echo -e "${RED}Unknown package manager: $manager${RESET}"
            return 1
            ;;
    esac
}

# ------------------------------------------------------------
# Install individual LSP
# ------------------------------------------------------------

install_lsp() {
    local index="$1"

    local name="${LSP_NAME[$index]}"
    local desc="${LSP_DESC[$index]}"

    local manager

    if [[ "$OS_NAME" == "macOS" ]]; then
        manager="${LSP_MAC[$index]}"
    else
        manager="${LSP_ARCH[$index]}"
    fi

    echo
    echo -e "${BLUE}Installing ${name}${RESET}"
    echo "Language: $desc"
    echo "Manager:  $manager"
    echo

    # Already installed?
    if has_command "${LSP_CMD[$index]}"; then
        echo -e "${GREEN}${name} is already installed.${RESET}"
        return 0
    fi

    if ! check_dependency "$manager"; then
        echo -e "${RED}Skipping ${name}.${RESET}"
        return 1
    fi

    case "$name:$manager" in

        # ----------------------------------------------------
        # Go
        # ----------------------------------------------------

        gopls:go)
            install_go_package \
                "golang.org/x/tools/gopls@latest"
            ;;

        # ----------------------------------------------------
        # Lua
        # ----------------------------------------------------

        lua-language-server:brew)
            install_brew_package "lua-language-server"
            ;;

        lua-language-server:pacman)
            install_pacman_package "lua-language-server"
            ;;

        # ----------------------------------------------------
        # TypeScript / JavaScript
        # ----------------------------------------------------

        typescript-language-server:npm)
            install_npm_package \
                "typescript" \
                "typescript-language-server"
            ;;

        # ----------------------------------------------------
        # Python
        # ----------------------------------------------------

        pyright:brew)
            install_brew_package "pyright"
            ;;

        pyright:pacman)
            install_pacman_package "pyright"
            ;;

        # ----------------------------------------------------
        # Rust
        # ----------------------------------------------------

        rust-analyzer:brew)
            install_brew_package "rust-analyzer"
            ;;

        rust-analyzer:pacman)
            install_pacman_package "rust-analyzer"
            ;;

        # ----------------------------------------------------
        # C / C++
        # ----------------------------------------------------

        clangd:brew)
            install_brew_package "llvm"
            ;;

        clangd:pacman)
            install_pacman_package "clang"
            ;;

        # ----------------------------------------------------
        # Bash
        # ----------------------------------------------------

        bash-language-server:npm)
            install_npm_package "bash-language-server"
            ;;

        # ----------------------------------------------------
        # YAML
        # ----------------------------------------------------

        yaml-language-server:npm)
            install_npm_package "yaml-language-server"
            ;;

        # ----------------------------------------------------
        # HTML / CSS / JSON
        # ----------------------------------------------------

        vscode-langservers-extracted:npm)
            install_npm_package "vscode-langservers-extracted"
            ;;

        # ----------------------------------------------------
        # Docker
        # ----------------------------------------------------

        dockerfile-language-server-nodejs:npm)
            install_npm_package "dockerfile-language-server-nodejs"
            ;;

        # ----------------------------------------------------
        # TOML
        # ----------------------------------------------------

        taplo:brew)
            install_brew_package "taplo"
            ;;

        taplo:cargo)
            install_cargo_package "taplo-cli"
            ;;

        # ----------------------------------------------------
        # Markdown
        # ----------------------------------------------------

        marksman:brew)
            install_brew_package "marksman"
            ;;

        marksman:pacman)
            install_pacman_package "marksman"
            ;;

        # ----------------------------------------------------
        # GraphQL
        # ----------------------------------------------------

        graphql-language-service-cli:npm)
            install_npm_package "graphql-language-service-cli"
            ;;

        # ----------------------------------------------------
        # PHP
        # ----------------------------------------------------

        intelephense:npm)
            install_npm_package "intelephense"
            ;;

        # ----------------------------------------------------
        # Ruby
        # ----------------------------------------------------

        solargraph:gem)
            gem install solargraph
            ;;

        *)
            echo -e "${RED}No installation rule for:${RESET}"
            echo "  $name"
            echo "  manager=$manager"
            return 1
            ;;
    esac

    echo

    if has_command "${LSP_CMD[$index]}"; then
        echo -e "${GREEN}✓ ${name} installed successfully.${RESET}"
    else
        echo -e "${YELLOW}⚠ ${name} installation finished, but command was not found:${RESET}"
        echo "  ${LSP_CMD[$index]}"
        echo
        echo "Check your PATH."
    fi
}

# ------------------------------------------------------------
# Print menu
# ------------------------------------------------------------

print_menu() {
    echo
    echo -e "${CYAN}Available LSPs:${RESET}"
    echo

    local i

    for i in "${!LSP_NAME[@]}"; do
        local status

        if has_command "${LSP_CMD[$i]}"; then
            status="${GREEN}[installed]${RESET}"
        else
            status="${YELLOW}[not installed]${RESET}"
        fi

        printf "  %2d) %-38s %-22s %b\n" \
            "$((i + 1))" \
            "${LSP_NAME[$i]}" \
            "${LSP_DESC[$i]}" \
            "$status"
    done

    echo
    echo "  all) Install all"
    echo "  q)   Quit"
    echo
}

# ------------------------------------------------------------
# Parse selection
# ------------------------------------------------------------

parse_selection() {
    local input="$1"

    if [[ "$input" == "all" ]]; then
        SELECTED=()

        local i
        for i in "${!LSP_NAME[@]}"; do
            SELECTED+=("$i")
        done

        return 0
    fi

    SELECTED=()

    input="${input//,/ }"

    local item

    for item in $input; do
        if [[ "$item" =~ ^[0-9]+$ ]]; then

            local number="$item"

            if (( number >= 1 && number <= ${#LSP_NAME[@]} )); then
                SELECTED+=("$((number - 1))")
            else
                echo -e "${RED}Invalid selection: $number${RESET}"
                return 1
            fi

        else
            echo -e "${RED}Invalid selection: $item${RESET}"
            return 1
        fi
    done

    return 0
}

# ------------------------------------------------------------
# Main
# ------------------------------------------------------------

SELECTED=()

while true; do

    print_menu

    read -r -p "Select LSPs: " INPUT

    case "$INPUT" in
        q|Q|quit|exit)
            echo "Bye."
            exit 0
            ;;
    esac

    if ! parse_selection "$INPUT"; then
        continue
    fi

    if [[ "${#SELECTED[@]}" -eq 0 ]]; then
        echo -e "${YELLOW}Nothing selected.${RESET}"
        continue
    fi

    echo
    echo -e "${CYAN}Selected:${RESET}"

    for index in "${SELECTED[@]}"; do
        echo "  - ${LSP_NAME[$index]}"
    done

    echo

    read -r -p "Continue? [Y/n] " CONFIRM

    case "$CONFIRM" in
        n|N)
            echo "Cancelled."
            continue
            ;;
    esac

    for index in "${SELECTED[@]}"; do
        install_lsp "$index"
    done

    echo
    echo -e "${GREEN}Done.${RESET}"
    echo

    read -r -p "Press Enter to return to menu..." _
done
