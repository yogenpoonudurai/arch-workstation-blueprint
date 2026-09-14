# starship — minimal, palette-synced. Rendered by theme-render, do not edit.
format = "$directory$git_branch$git_status$cmd_duration$line_break$character"

[directory]
style = "{{accent}}"
truncation_length = 3
truncate_to_repo = true

[git_branch]
style = "{{muted}}"
format = "[$branch]($style) "

[git_status]
style = "{{yellow}}"
format = "[$all_status]($style)"

[cmd_duration]
min_time = 2000
style = "{{muted}}"

[character]
success_symbol = "[❯]({{accent}})"
error_symbol = "[❯]({{red}})"
