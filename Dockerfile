# Verwende ein Node.js-Image als Basis (z. B. mit Node 18 und Debian)
FROM node:18-bullseye

# Setze Arbeitsverzeichnis
WORKDIR /workspace

# Installiere Systemabhängigkeiten und grundlegende Tools
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    zsh \
    neovim \
    python3-pip \
    build-essential \
    libssl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Installiere oh-my-zsh für eine aufgeräumte Shell
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    chsh -s $(which zsh) && \
    echo 'ZSH_THEME="agnoster"' > ~/.zshrc

# Installiere Node Version Manager (NVM) und Node.js
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
    nvm install --lts && \
    npm install -g yarn

# Installiere Neovim-Paketmanager und Plugins
RUN mkdir -p ~/.config/nvim && \
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    echo "call plug#begin('~/.local/share/nvim/plugged')\n\
Plug 'neovim/nvim-lspconfig'\n\
Plug 'hrsh7th/nvim-cmp'\n\
Plug 'github/copilot.vim'\n\
Plug 'morhetz/gruvbox'\n\
call plug#end()" > ~/.config/nvim/init.vim && \
    nvim --headless +PlugInstall +qa

# Konfiguriere Neovim als IDE
RUN echo "set number\n\
set relativenumber\n\
set tabstop=4\n\
set shiftwidth=4\n\
set expandtab\n\
set background=dark\n\
colorscheme gruvbox\n\
filetype plugin indent on\n\
syntax on\n\
inoremap <silent><expr> <C-Space> copilot#Accept(\"\\<CR>\")" >> ~/.config/nvim/init.vim

# Installiere TailwindCSS CLI
RUN npm install -g tailwindcss postcss autoprefixer

# Installiere Python-Tools für Neovim
RUN pip3 install --upgrade pynvim

# ZSH-Plugins
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    sed -i "s/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/" ~/.zshrc

# Exponiere Port (für den Entwicklungsserver)
EXPOSE 3000

# Standard-Shell
CMD ["zsh"]
