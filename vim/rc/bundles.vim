let s:neobundle_git_path='!git clone %s://github.com/Shougo/neobundle.vim.git'

if has('vim_starting')
    " add NeoBundle to rtp
    execute 'set rtp ^='. fnameescape(g:config.bundlesPath . 'neobundle.vim/')
    " install NeoBundle if doesn't exist and we have git. TODO - create curl alternative
    if !isdirectory(expand(g:config.bundlesPath . 'neobundle.vim')) && executable('git')
        execute printf(s:neobundle_git_path,
                    \ (exists('$http_proxy') ? 'https' : 'git'))
                    \ g:config.bundlesPath . 'neobundle.vim'
    endif
endif

call neobundle#begin(expand(g:config.bundlesPath))

" Let NeoBundle handle bundles
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/vimproc', {
            \ 'build' : {
            \  'windows' : 'make -f make_mingw32.mak',
            \  'cygwin' : 'make -f make_cygwin.mak',
            \  'mac' : 'make -f make_mac.mak',
            \  'unix' : 'make -f make_unix.mak',
            \  },
            \ }
NeoBundle 'L9'
NeoBundle 'editorconfig/editorconfig-vim'

if has('lua') && v:version >= 703
    NeoBundle 'Shougo/neocomplete'
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    " Use neocomplete.
    let g:neocomplete#enable_at_startup = 1
    " Use smartcase.
    let g:neocomplete#enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    " Set auto completion length.
    let g:neocomplete#auto_completion_start_length = 2
    " Set manual completion length.
    let g:neocomplete#manual_completion_start_length = 0
    " Set minimum keyword length.
    let g:neocomplete#min_keyword_length = 3
    let g:neocomplete#enable_auto_delimiter = 1
    let g:neocomplete#max_list = 30
endif

NeoBundle 'kien/ctrlp.vim'

let ctrlp_ignore = ['public', 'build', 'dist', 'node_modules', '.idea', '.git']
let g:ctrlp_custom_ignore = join(ctrlp_ignore, '\|')

let g:ctrlp_by_filename = 0
let g:ctrlp_clear_cache_on_exit = 1 " speed up by not removing clearing cache every time
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_lazy_update = 0
let g:ctrlp_max_depth = 50
let g:ctrlp_max_files = 5000
let g:ctrlp_max_height = 20         " maximum height of match window
let g:ctrlp_max_history = 50
let g:ctrlp_mruf_max = 50           " number of recently opened files
let g:ctrlp_open_new_file = 'r'
let g:ctrlp_root_markers = ['.git']
let g:ctrlp_show_hidden = 1
let g:ctrlp_switch_buffer = 'et'    " jump to a file if it's open already
let g:ctrlp_working_path_mode = 'ra'
nnoremap <c-p> :CtrlP<cr>

if executable('git')
    let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others']
    let g:ctrlp_use_caching = 0
endif

NeoBundle 'evanmiller/nginx-vim-syntax'
NeoBundleLazy 'Glench/Vim-Jinja2-Syntax', {
\   'on_ft': ['jinja2', 'j2', 'jinja']
\ }

NeoBundle 'pgilad/vim-skeletons'
let skeletons#autoRegister = 1
let skeletons#skeletonsDir = ['~/.dotfiles/vim/skeletons']

NeoBundleLazy 'Shougo/unite.vim', {
            \   'on_cmd' : [{ 'name' : 'Unite',
            \  'complete' : 'customlist,unite#complete_source'},
            \  'UniteWithCursorWord', 'UniteWithInput']
            \ }
NeoBundleLazy 'osyo-manga/unite-filetype', {
            \'depends': ['Shougu/unite.vim'],
            \ 'unite_sources': ['filetype']
            \ }
NeoBundleLazy 'Shougo/unite-outline', {
            \ 'depends': ['Shougu/unite.vim'],
            \ 'unite_sources': ['outline']
            \ }
NeoBundle 'Shougo/unite-mru', {
            \'depends': ['Shougu/unite.vim']
            \ }
NeoBundleLazy 'ujihisa/unite-colorscheme', {
            \'depends': ['Shougu/unite.vim'],
            \ 'unite_sources': ['colorscheme']
            \ }

let g:unite_enable_start_insert = 1
let g:unite_split_rule = "botright"
let g:unite_force_overwrite_statusline = 0
let g:unite_winheight = 10
let g:unite_source_history_yank_enable = 1
let g:unite_source_history_yank_save_clipboard = 1
let g:unite_update_time = 200
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '--nocolor --nogroup --column --line-numbers --smart-case'
let g:unite_source_grep_recursive_opt = ''
let g:unite_source_grep_max_candidates = 15

function! neobundle#hooks.on_source(bundle)
    call unite#custom#source(
                \ 'buffer, file_rec, file_rec/async, file_rec/git',
                \ 'matchers',
                \ ['converter_relative_word', 'matcher_fuzzy'])
    call unite#custom#source(
                \ 'file_mru',
                \ 'matchers',
                \ ['matcher_project_files', 'matcher_fuzzy'])
    call unite#filters#sorter_default#use(['sorter_rank'])
endfunction

" map bindings... use [Space] but release it for plugins
nmap <space> [unite]
xmap <space> [unite]
nnoremap [unite] <nop>
xnoremap [unite] <nop>

nnoremap <silent> [unite]b :<C-u>Unite -buffer-name=buffers buffer<CR>
nnoremap <silent> [unite]f :<C-u>Unite -buffer-name=files -start-insert file<CR>
" start unite with recursive file search for filename under cursor
nnoremap <silent> [unite]F :<C-u>execute 'Unite -buffer-name=find_files -start-insert file_rec/async -input=' . expand('<cfile>:t')<CR>
nnoremap <silent> [unite]m :<C-u>Unite -buffer-name=mappings -start-insert mapping<CR>
nnoremap <silent> [unite]o :<C-u>Unite -buffer-name=outline -start-insert outline<CR>
nnoremap <silent> [unite]p :<C-u>Unite -buffer-name=files -start-insert file_rec<CR>
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=mru -start-insert file_mru<CR>
nnoremap <silent> [unite]t :<C-u>Unite -buffer-name=filetypes -start-insert filetype<CR>
nnoremap <silent> [unite]y :<C-u>Unite -buffer-name=yank history/yank<CR>
nnoremap <silent> [unite]s :<C-u>UniteWithCursorWord -buffer-name=search -no-empty grep:.:<cr>
" search word in current buffer
nnoremap <silent><expr> [unite]*  ":<C-u>UniteWithCursorWord -buffer-name=search%".bufnr('%')." line:all:wrap<CR>"

NeoBundleLazy 'scrooloose/nerdtree', {
            \  'on_path' : '.*',
            \  'on_cmd': ['NERDTree', 'NERDTreeToggle', 'NERDTreeFind',
            \  'NERDTreeClose', 'NERDTreeCWD', 'NERDTreeFromBookmark', 'NERDTreeMirror']
            \ }

let NERDTreeShowBookmarks=1
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=0
let NERDTreeShowLineNumbers=0
let NERDTreeWinSize=30
let NERDTreeDirArrows=1
let NERDChristmasTree=1
let NERDTreeAutoDeleteBuffer=1 "auto delete buffers on NERDTree delete
let NERDTreeIgnore=['\~$', '^\.\.$', '\.swp$', '\.hg$', '\.svn$', '\.bzr', '\.git$']
let NERDSpaceDelims=1
let NERDCreateDefaultMappings = 1
let NERDMenuMode=0
let NERDTreeBookmarksFile=expand('~/vimfiles/vim-bookmarks.txt')

NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'nathanaelkane/vim-indent-guides'

let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'qf', 'vimshell', 'markdown']
let g:indent_guides_auto_colors = 0
let g:indent_guides_color_change_percent = 5
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 1
let g:indent_guides_guide_size = 0

hi IndentGuidesOdd  ctermbg=black
hi IndentGuidesEven ctermbg=darkgrey

NeoBundleLazy 'cespare/vim-toml', { 'on_ft': ['toml'] }
NeoBundleLazy 'StanAngeloff/php.vim', { 'on_ft': ['php'] }
NeoBundleLazy 'Shougo/junkfile.vim', {
            \  'on_cmd': 'JunkfileOpen',
            \  'unite_sources': ['junkfile', 'junkfile/new']
            \ }
NeoBundleLazy 'kchmck/vim-coffee-script', { 'on_ft' : ['coffee'] }
NeoBundleLazy 'ap/vim-css-color', { 'on_ft':['css','scss','sass','less','styl'] }
NeoBundleLazy 'hail2u/vim-css3-syntax', { 'on_ft':['css', 'less'] }
NeoBundleLazy 'ingydotnet/yaml-vim', { 'on_ft': ['yml', 'yaml'] }

NeoBundleLazy 'cakebaker/scss-syntax.vim', { 'on_ft': ['sass', 'scss'] }
NeoBundleLazy 'wavded/vim-stylus', { 'on_ft': ['stylus'] }
NeoBundleLazy 'groenewege/vim-less', { 'on_ft': ['less', 'css'] }
NeoBundleLazy 'csscomb/vim-csscomb', { 'on_ft': ['css', 'less', 'sass'] }
NeoBundleLazy 'othree/html5.vim', { 'on_ft': ['html'] }
NeoBundleLazy 'hokaccha/vim-html5validator', { 'on_ft' : ['html'] }
NeoBundleLazy 'digitaltoad/vim-pug', { 'on_ft': ['jade', 'pug'] }
NeoBundleLazy 'gregsexton/MatchTag', { 'on_ft': ['html','xml'] }
NeoBundleLazy 'othree/xml.vim', { 'on_ft': ['xml'] }
NeoBundleLazy 'samuelsimoes/vim-jsx-utils', { 'on_ft': ['javascript'] }
NeoBundleLazy 'othree/yajs.vim', { 'on_ft': ['javascript'] }
NeoBundleLazy 'pangloss/vim-javascript', { 'on_ft': ['javascript'] }

NeoBundleLazy 'mxw/vim-jsx', { 'on_ft': ['javascript'] }
let g:jsx_ext_required = 0

" Defined as non-lazy because there is a loading problem
" NeoBundle 'moll/vim-node'
NeoBundle 'pgilad/vim-node', {'rev': 'patch-2'}

NeoBundleLazy 'itspriddle/vim-jquery.git', {'on_ft': ['javascript']}
NeoBundleLazy 'heavenshell/vim-jsdoc', {'on_ft': ['javascript']}
NeoBundleLazy 'othree/javascript-libraries-syntax.vim', {
            \   'on_ft': ['javascript','coffee']
            \ }
let g:used_javascript_libs = 'underscore,angularjs,jquery,backbone,react'

NeoBundle 'vim-scripts/logstash.vim'

NeoBundleLazy 'beautify-web/js-beautify', {
            \   'on_ft' : ['html', 'css', 'js']
            \ }
nnoremap <leader>fj :!js-beautify % -r -X<cr>

NeoBundleLazy 'maksimr/vim-jsbeautify', {
            \ 'on_ft':['javascript', 'json', 'html', 'js', 'jsx', 'css'],
            \ 'depends': ['beautify-web/js-beautify', 'editorconfig-vim']
            \ }
NeoBundleLazy 'wting/rust.vim', {
            \ 'on_ft': ['rust']
            \ }
NeoBundleLazy 'elzr/vim-json', {'on_ft': ['json']}
NeoBundle 'evidens/vim-twig'
NeoBundleLazy 'leafgarland/typescript-vim', {
            \   'on_ft': ['typescript']
            \ }
NeoBundleLazy 'tpope/vim-markdown', {'on_ft':['markdown']}
NeoBundleLazy 'waylan/vim-markdown-extra-preview', {'on_ft':['markdown']}
NeoBundleLazy 'jtratner/vim-flavored-markdown.git', {'on_ft':['markdown']}
NeoBundleLazy 'kannokanno/previm', {
            \ 'depends' : ['open-browser.vim'],
            \ 'on_ft' : ['markdown']
            \ }
NeoBundle 'tpope/vim-unimpaired'

NeoBundle 'tpope/vim-fugitive', {
            \ 'augroup' : 'fugitive'
            \ }

nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gw :Gwrite<cr>
nnoremap <leader>gp :Git push<cr>

NeoBundleLazy 'vim-ruby/vim-ruby', {
            \ 'on_map' : '<Plug>',
            \ 'on_ft' : 'ruby'
            \ }

NeoBundle 'airblade/vim-gitgutter'
let g:gitgutter_enabled = 1
let g:gitgutter_map_keys = 0
let g:gitgutter_escape_grep = 1
let g:gitgutter_eager = 0
let g:gitgutter_realtime = 0

NeoBundle 'tpope/vim-surround'
" NeoBundle 'tpope/vim-abolish.git'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'thinca/vim-visualstar'

NeoBundleLazy 'tyru/open-browser.vim', {
            \   'on_cmd' : ['OpenBrowserSearch', 'OpenBrowser'],
            \   'on_func' : 'openbrowser#open',
            \   'on_map': '<Plug>(openbrowser-'
            \ }

NeoBundleLazy 'AndrewRadev/inline_edit.vim', {
            \   'on_cmd': ['InlineEdit']
            \ }

nnoremap <leader>ie :InlineEdit<cr>
xnoremap <leader>ie :InlineEdit<cr>
inoremap <leader>ie <esc>:InlineEdit<cr>a

NeoBundleLazy 'AndrewRadev/linediff.vim', {
            \   'on_cmd': ['Linediff', 'LinediffReset']
            \ }

vnoremap <leader>ld :Linediff<cr>
nnoremap <leader>ld :Linediff<cr>
nnoremap <leader>lr :LinediffReset<cr>

NeoBundle 'bling/vim-airline'

let g:airline_detect_modified=1
let g:airline_inactive_collapse=1
let g:airline_detect_paste=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep=' '
let g:airline#extensions#tabline#left_alt_sep='¦'
let g:airline#extensions#tmuxline#enabled = 0
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#branch#enabled = 1

NeoBundleLazy 'AndrewRadev/switch.vim', {
            \   'on_cmd': ['Switch']
            \ }

let g:switch_mapping = ""
let g:switch_custom_definitions =
            \ [
            \   ['/', '\\'],
            \   {
            \       '\v(\w+)\.(\w+)' : '\1[''\2'']',
            \       '\v(\w+)\[[''"](\w+)[''"]\]' : '\1.\2'
            \   }
            \ ]

NeoBundle 'SirVer/ultisnips'
NeoBundle 'honza/vim-snippets'
NeoBundle 'fuadsaud/vim-react-snippets'
NeoBundle 'pgilad/vim-react-proptypes-snippets'

"set to where my /mysnippets directory exists
set runtimepath+=~/.dotfiles/vim/
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<c-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsSnippetsDir="~/.dotfiles/vim/mysnippets"
let g:UltiSnipsSnippetDirectories=['UltiSnips', 'mysnippets']

""""""""""""""""""""""""""
"  Text Objects Plugins  "
""""""""""""""""""""""""""
NeoBundle 'kana/vim-textobj-user'
" al aL
NeoBundle 'kana/vim-textobj-line', { 'depends': 'kana/vim-textobj-user' }
" ai, ii, aI, iI
NeoBundle 'kana/vim-textobj-indent', { 'depends': 'kana/vim-textobj-user' }
" ae, ie
NeoBundle 'kana/vim-textobj-entire', { 'depends': 'kana/vim-textobj-user' }
" a, i,
NeoBundle 'PeterRincker/vim-argumentative'

NeoBundleLazy 'scrooloose/syntastic'

let filetypes = [
            \  'javascript', 'coffee', 'zsh', 'json', 'less',
            \ 'css', 'jade', 'ruby', 'html', 'sh', 'php',
            \ 'python', 'bash'
            \ ]
call neobundle#config({
            \   'autoload' : {
            \     'on_ft' : filetypes
            \     }
            \ })
let g:syntastic_mode_map = {
            \ 'mode': 'passive',
            \ 'active_filetypes': filetypes,
            \ 'passive_filetypes': [] }
let g:syntastic_python_checkers = ['python', 'pylint -E']
let g:syntastic_ruby_checkers = ['rubocop']

function! s:SetLocalNodeBin(curpath, program, syntastic_option)
    " try to use a local exec in node_modules
    let local_program = finddir('node_modules', '.;') . '/.bin/' . a:program
    if matchstr(local_program, '^\/\\w') == ''
        let local_program = a:curpath . '/' . local_program
    endif
    if executable(local_program)
        execute 'let ' . a:syntastic_option . ' = "'.local_program.'"'
    endif
endfunction

function! s:JavascriptCheckers(curpath)
    let checkers = []
    call s:SetLocalNodeBin(a:curpath, 'eslint', 'g:syntastic_javascript_eslint_exec')
    call s:SetLocalNodeBin(a:curpath, 'jshint', 'g:syntastic_javascript_eslint_exec')
    call s:SetLocalNodeBin(a:curpath, 'jscs', 'g:syntastic_javascript_eslint_exec')
    if filereadable(a:curpath . '/.jscsrc')
        call add(checkers, 'jscs')
    endif
    if filereadable(a:curpath . '/.jshintrc')
        call add(checkers, 'jshint')
    endif
    if len(globpath(a:curpath, '.eslintrc*')) > 0
        call add(checkers, 'eslint')
    endif
    return checkers
endfunction

let g:syntastic_javascript_checkers=s:JavascriptCheckers(getcwd())
let g:syntastic_enable_balloons = 0
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_aggregate_errors = 1
let g:syntastic_id_checkers = 1

NeoBundle 'junegunn/vim-pseudocl'
NeoBundle 'junegunn/vim-oblique', {
            \ 'depends' : 'junegunn/vim-pseudocl',
            \ }
NeoBundleLazy 'gorkunov/smartgf.vim', {
            \ 'on_map': '<Plug>(smartgf-search',
            \ 'disabled': !executable('ag')
            \ }

let g:smartgf_create_default_mappings = 0
let g:smartgf_enable_gems_search = 0
let g:smartgf_auto_refresh_ctags = 0
let g:smartgf_max_entries_per_page = 9
let g:smartgf_divider_width = 5
let g:smartgf_extensions = ['.js', '.coffee', '.json']

nmap gs <Plug>(smartgf-search)
vmap gs <Plug>(smartgf-search)
nmap gS <Plug>(smartgf-search-unfiltered)
vmap gS <Plug>(smartgf-search-unfiltered)

NeoBundle 'nanotech/jellybeans.vim'
let g:config.colorscheme = "jellybeans"
call neobundle#end()

if !has('vim_starting')
    " Installation check.
    NeoBundleCheck
endif
