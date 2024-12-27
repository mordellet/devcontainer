FROM ubuntu

# Setze Arbeitsverzeichnis
WORKDIR /workspace

# Installiere grundlegende Systemabhängigkeiten
RUN apt-get install software-properties-common
RUN add-apt-repository ppa:neovim-ppa/stable

RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    zsh \
    fzf \
    fd-find \
    nodejs \
    npm \
    gcc \
    ripgrep \
    lazygit \
    neovim \
    python3-pip \
    python3-pynvim \
    build-essential \
    libssl-dev \
    openssh-server \
    sudo \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Konfiguriere OpenSSH-Server
RUN mkdir /var/run/sshd && \
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && \
    echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config && \
    echo 'AllowTcpForwarding yes' >> /etc/ssh/sshd_config

# Erstelle einen Benutzer für den SSH-Zugriff und füge ihn zur sudo-Gruppe hinzu
RUN useradd -m -s /bin/bash devuser && echo "devuser:devpassword" | chpasswd && \
    usermod -aG sudo devuser && \
    mkdir -p /home/devuser/.ssh && chmod 700 /home/devuser/.ssh && \
    chown -R devuser:devuser /home/devuser

# Konfiguriere sudo, um keine Passwortabfrage für devuser zu verlangen (optional)
RUN echo "devuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Installiere oh-my-zsh für den Benutzer
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    chsh -s $(which zsh) devuser && \
    echo 'ZSH_THEME="agnoster"' > /home/devuser/.zshrc && \
    chown devuser:devuser /home/devuser/.zshrc

# Installiere Node Version Manager (NVM) und Node.js
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
    nvm install --lts && \
    npm install -g yarn

# Installiere LazyVim und richte Plugins für Webentwicklung ein
RUN mkdir -p ~/.config/nvim && \
    git clone https://github.com/LazyVim/starter ~/.config/nvim && \
    echo 'return {\n\
      defaults = { lazy = true },\n\
      install = { colorscheme = { "gruvbox", "tokyonight" } },\n\
      plugins = {\n\
        { "neovim/nvim-lspconfig" },\n\
        { "hrsh7th/nvim-cmp" },\n\
        { "L3MON4D3/LuaSnip" },\n\
        { "saadparwaiz1/cmp_luasnip" },\n\
        { "hrsh7th/cmp-nvim-lsp" },\n\
        { "zbirenbaum/copilot.lua", config = function() require("copilot").setup({}) end },\n\
        { "zbirenbaum/copilot-cmp", config = function() require("copilot_cmp").setup() end },\n\
        { "onsails/lspkind-nvim" },\n\
        { "jose-elias-alvarez/null-ls.nvim" },\n\
        { "windwp/nvim-ts-autotag" },\n\
        { "jose-elias-alvarez/typescript.nvim" },\n\
        { "windwp/nvim-autopairs" },\n\
        { "norcalli/nvim-colorizer.lua" },\n\
        { "folke/tokyonight.nvim" },\n\
        { "tailwindlabs/tailwindcss-intellisense.nvim" },\n\
      },\n\
    }' > ~/.config/nvim/lua/config.lua && \
    nvim --headless +Lazy! +qa

# Installiere TailwindCSS CLI
RUN npm install -g tailwindcss postcss autoprefixer

# Exponiere Ports (SSH und Entwicklungsserver)
EXPOSE 22 3000

# Starte den SSH-Dienst und eine interaktive Shell
CMD ["/usr/sbin/sshd", "-D"]
