# See https://fishshell.com/docs/current/interactive.html#syntax-highlighting
### Syntax Highlighting ###
# default color
set fish_color_normal {foreground.strip}
# commands like echo
set fish_color_command {color4.strip}
# keywords like if - this falls back on the command color if unset
#set fish_color_keyword
# quoted text like "abc"
set fish_color_quote {color5.strip}
# IO redirections like >/dev/null
set fish_color_redirection {color2.strip}
# process separators like ; and &
set fish_color_end {color1.strip}
# syntax errors
set fish_color_error {color1.strip}
# ordinary command parameters
set fish_color_param {color6.strip}
# parameters that are filenames (if the file exists)
set fish_color_valid_path {color5.strip}
# options starting with “-”, up to the first “--” parameter
set fish_color_option {color5.strip}
# comments like ‘# important’
set fish_color_comment {color3.strip}
# selected text in vi visual mode
set fish_color_selection {color6.strip}
# parameter expansion operators like * and ~
set fish_color_operator {color2.strip}
# character escapes like \n and \x70
set fish_color_escape {color3.strip}
# autosuggestions (the proposed rest of a command)
#set fish_color_autosuggestion
# the current working directory in the default prompt
#set fish_color_cwd
# the current working directory in the default prompt for the root user
#set fish_color_cwd_root
# the username in the default prompt
#set fish_color_user
# the hostname in the default prompt
#set fish_color_host
# the hostname in the default prompt for remote sessions (like ssh)
#set fish_color_host_remote
# the last command’s nonzero exit code in the default prompt
#set fish_color_status
# the ‘^C’ indicator on a canceled command
set fish_color_cancel {color3.strip}
# history search matches and selected pager items (background only)
set fish_color_search_match {color3.strip}
# the current position in the history for commands like dirh and cdh
#set fish_color_history_current

### Pager colors ###
# the progress bar at the bottom left corner
#set fish_pager_color_progress
# the background color of a line
#set fish_pager_color_background
# the prefix string, i.e. the string that is to be completed
#set fish_pager_color_prefix
# the completion itself, i.e. the proposed rest of the string
#set fish_pager_color_completion
# the completion description
#set fish_pager_color_description
# background of the selected completion
#set fish_pager_color_selected_background
# prefix of the selected completion
#set fish_pager_color_selected_prefix
# suffix of the selected completion
#set fish_pager_color_selected_completion
# description of the selected completion
#set fish_pager_color_selected_description
# background of every second unselected completion
#set fish_pager_color_secondary_background
# prefix of every second unselected completion
#set fish_pager_color_secondary_prefix
# suffix of every second unselected completion
#set fish_pager_color_secondary_completion
# description of every second unselected completion
#set fish_pager_color_secondary_description
