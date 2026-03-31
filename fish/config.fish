set fish_greeting

set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
set -gx DIRENV_LOG_FORMAT ""

uv generate-shell-completion fish | source
uvx --generate-shell-completion fish | source
direnv hook fish | source
