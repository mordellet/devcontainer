# Verwende ein Node.js-Image als Basis (z. B. mit Node 18 und Debian)
FROM node:18-bullseye

# Setze Arbeitsverzeichnis
WORKDIR /workspace

# Installiere grundlegende Systemabhängigkeiten
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    zsh \
    neovim \
    python3-pip \
    build-essential \
    libssl-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

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

# Installiere Python-Tools für Neovim
RUN pip3 install --upgrade pynvim

# Exponiere Port (für den Entwicklungsserver)
EXPOSE 3000

# Standard-Shell
CMD ["zsh"]
