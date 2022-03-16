call plug#begin()
Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
call plug#end()

function! CWD()
    let l:path = fnamemodify(getcwd(),":t")
    return l:path
endfunction

lua <<EOF
require('lualine').setup {
  sections = {
    lualine_a = {
      {'mode', fmt = function(str) return str:sub(1,1) end}
    },
    lualine_c = {
        {
        'filename',
        file_status = true, -- displays file status (readonly status, modified status)
        path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
        }
      },
  },
  tabline = {
    lualine_a = {'tabs'},
    lualine_b = {'CWD'},
    lualine_y = {'buffers'},
  },
  inactive_sections = {
    lualine_a = {function() return [[•]] end},
    lualine_c = {
        {
        'filename',
        path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
        }
      },
  },
}
EOF
