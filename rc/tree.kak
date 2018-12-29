declare-option str tree_cmd "kak-tree"
declare-option str tree_log "/tmp/kak-tree.log"

declare-option -hidden str tree_draft

define-command -hidden tree-command -params 1..2 %{
    evaluate-commands -draft -no-hooks %{exec '%'; set buffer tree_draft %val{selection}}
    evaluate-commands %sh{

tree_draft=$(printf '%s.' "${kak_opt_tree_draft}" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | sed "s/$(printf '\t')/\\\\t/g")

tree_draft=${tree_draft%.}

printf '
op = "%s"
param = "%s"
filetype  = "%s"
selections_desc = "%s"
content = """
%s"""
' $1 "$2" "${kak_opt_filetype}" "${kak_selections_desc}" "${tree_draft}" | ${kak_opt_tree_cmd} 2>${kak_opt_tree_log}
    }
}



define-command tree-select-node %{ tree-command SelectNode }
define-command tree-select-next-node %{ tree-command SelectNextNode }
define-command tree-select-prev-node %{ tree-command SelectPrevNode }
define-command tree-select-first-child %{ tree-command SelectFirstChild }
define-command tree-select-children %{ tree-command SelectChildren }
define-command tree-node-sexp %{ tree-command NodeSExp }
define-command tree-select-nodes -params 1 %{ tree-command SelectNodes %arg{1} }


