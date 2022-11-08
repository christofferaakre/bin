vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use 'nvim-treesitter/nvim-treesitter-context'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'
    use 'gruvbox-community/gruvbox'
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'
    use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install' }
    use 'tpope/vim-surround'
    use 'airblade/vim-gitgutter'
    use 'itchyny/lightline.vim'
    use 'itchyny/vim-gitbranch'
    use 'preservim/nerdtree'
    use 'mattn/emmet-vim'
    use 'ThePrimeagen/harpoon'
    use 'ThePrimeagen/refactoring.nvim'
    use 'tpope/vim-fugitive'
    use 'mxw/vim-jsx'
    use 'pangloss/vim-javascript'
    use 'dikiaap/minimalist'
    use 'NLKNguyen/papercolor-theme'
    use 'sainnhe/gruvbox-material'
    use 'lervag/vimtex'
    use 'akinsho/toggleterm.nvim'
    use 'unblevable/quick-scope'
    use 'justinmk/vim-sneak'
    --use 'calviken/vim-gdscript3'
    -- use {'glacambre/firenvim', run = _ -> firenvim#install(0) }
    use 'rust-lang/rust.vim'
    use 'OmniSharp/omnisharp-vim'
    use 'tikhomirov/vim-glsl'
    use 'nickeb96/fish.vim'
    use {'numToStr/Comment.nvim'}
    use 'SirVer/ultisnips'
    use 'mlaursen/vim-react-snippets'
    use {'averms/black-nvim', run =  ':UpdateRemotePlugins'}
    --use 'pantharshit00/vim-prisma'
    -- use 'OmniSharp/Omnisharp-vim'
end)
