if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

setlocal commentstring=--\ %s
setlocal comments=:--
setlocal foldmethod=syntax
setlocal foldlevel=99

let b:undo_ftplugin = "setlocal commentstring< comments< foldmethod< foldlevel<"
