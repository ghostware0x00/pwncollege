# ================================================================
# PwnLab Powerlevel10k configuration
# Based on the user's existing P10k rainbow configuration.
#
# Host:
#   Arch Linux / Kitty / Zsh
#
# Container:
#   Ubuntu / Zsh / P10k
#
# The visual style intentionally remains:
#   Nerd Font v3
#   Rainbow
#   Unicode
#   24-hour time
#   Angled separators
#   Sharp heads/tails
#   Two lines
#   Disconnected
#   Full frame
#   Transient prompt
# ================================================================

# ------------------------------------------------
# Prompt layout
# ------------------------------------------------

typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    dir
    vcs
    newline
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status
    command_execution_time
    background_jobs
    virtualenv
    context
    time
    newline
)

# ------------------------------------------------
# Font / icons
# ------------------------------------------------

typeset -g POWERLEVEL9K_MODE=nerdfont-v3
typeset -g POWERLEVEL9K_ICON_PADDING=none

# ------------------------------------------------
# Prompt spacing
# ------------------------------------------------

typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

# ------------------------------------------------
# Multiline frame
# ------------------------------------------------

typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='%244F╭─'
typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX='%244F├─'
typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='%244F╰─'

typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX='%244F─╮'
typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX='%244F─┤'
typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX='%244F─╯'

typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR=' '
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_BACKGROUND=
typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_GAP_BACKGROUND=

# ------------------------------------------------
# Powerline separators
# ------------------------------------------------

typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='\uE0B1'
typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR='\uE0B3'

typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR='\uE0B0'
typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR='\uE0B2'

typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL='\uE0B0'
typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='\uE0B2'

typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL='\uE0B2'
typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL='\uE0B0'

# ------------------------------------------------
# Prompt character
# ------------------------------------------------

typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND=

typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=76
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=196

typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'

typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true

typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=
typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=

typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_LEFT_WHITESPACE=
typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_RIGHT_WHITESPACE=

# ------------------------------------------------
# Directory
# ------------------------------------------------

typeset -g POWERLEVEL9K_DIR_BACKGROUND=4
typeset -g POWERLEVEL9K_DIR_FOREGROUND=254

typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=

typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=250
typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=255
typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true

typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=80

typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS=40
typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT=50

typeset -g POWERLEVEL9K_DIR_HYPERLINK=false
typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=v3

# ------------------------------------------------
# Git
# ------------------------------------------------

typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=2
typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=3
typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=2
typeset -g POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND=3
typeset -g POWERLEVEL9K_VCS_LOADING_BACKGROUND=8

typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=
typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'

typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1
typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='~'

typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)

# ------------------------------------------------
# Status
# ------------------------------------------------

typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true

typeset -g POWERLEVEL9K_STATUS_OK=true
typeset -g POWERLEVEL9K_STATUS_OK_VISUAL_IDENTIFIER_EXPANSION='✔'
typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=2
typeset -g POWERLEVEL9K_STATUS_OK_BACKGROUND=0

typeset -g POWERLEVEL9K_STATUS_ERROR=true
typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='✘'
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=3
typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=1

typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true
typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_VISUAL_IDENTIFIER_EXPANSION='✘'
typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=3
typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_BACKGROUND=1

# ------------------------------------------------
# Command execution time
# ------------------------------------------------

typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=0
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=3

typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'

typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION=

# ------------------------------------------------
# Background jobs
# ------------------------------------------------

typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=6
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND=0
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false

# ------------------------------------------------
# Python virtualenv
# ------------------------------------------------

typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=0
typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND=4

typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_WITH_PYENV=false

typeset -g POWERLEVEL9K_VIRTUALENV_LEFT_DELIMITER=
typeset -g POWERLEVEL9K_VIRTUALENV_RIGHT_DELIMITER=

# ------------------------------------------------
# Container identity
# ------------------------------------------------
#
# IMPORTANT:
# Always display pwn@pwnlab inside the Docker environment.
#
# This prevents accidentally confusing the container with
# your Arch host.
# ------------------------------------------------

typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=3
typeset -g POWERLEVEL9K_CONTEXT_BACKGROUND=0

typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=1
typeset -g POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND=0

typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='pwn@pwnlab'
typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE='pwn@pwnlab'

typeset -g POWERLEVEL9K_CONTEXT_REMOTE_TEMPLATE='pwn@pwnlab'
typeset -g POWERLEVEL9K_CONTEXT_REMOTE_SUDO_TEMPLATE='pwn@pwnlab'

# Unlike the original host configuration, always show the
# container identity.
typeset -g POWERLEVEL9K_CONTEXT_DEFAULT_CONTENT_EXPANSION=
typeset -g POWERLEVEL9K_CONTEXT_SUDO_CONTENT_EXPANSION=

# ------------------------------------------------
# Time
# ------------------------------------------------

typeset -g POWERLEVEL9K_TIME_FOREGROUND=0
typeset -g POWERLEVEL9K_TIME_BACKGROUND=7

typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false

typeset -g POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION=

# ------------------------------------------------
# Transient prompt
# ------------------------------------------------

typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always

# ------------------------------------------------
# Instant prompt
# ------------------------------------------------

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# ------------------------------------------------
# Performance
# ------------------------------------------------

typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

# ------------------------------------------------
# Tell p10k where this configuration lives
# ------------------------------------------------

typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}

# ------------------------------------------------
# Reload
# ------------------------------------------------

(( ! $+functions[p10k] )) || p10k reload
