set -x EDITOR "subl -w"
set PATH /Users/todd/.rbenv/shims /usr/local/bin /usr/bin /bin /usr/sbin /sbin /usr/X11R6/bin

alias g git
alias be "bundle exec"

set -x CLICOLOR 1

function _git_in_repo
	set -l dir (pwd)
	while [ (dirname $dir) != "/" ]
		[ -d "$dir/.git" ]; and return
		set dir (dirname $dir)
	end
	false
end

function _git_dirty_mark
	# test -z (git diff --shortstat 2> /dev/null | tail -n1)
	if test (git status --porcelain 2> /dev/null | wc -l) -gt 0
		printf 'Δ'
	end
end

function _git_branch
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
end

function fish_prompt -d "Write out the prompt"
	printf '%s@%s%s' (whoami) (hostname|cut -d . -f 1) (set_color normal) 

	# Color read-only dirs red
	if test -w "."
		printf ' %s%s' (set_color $fish_color_cwd) (prompt_pwd)
	else
		printf ' %s%s' (set_color red) (prompt_pwd)
	end

	# Print git branch
	if _git_in_repo
		printf ' %s%s\(%s%s%s%s\)' (set_color normal) (set_color blue) (_git_branch) (set_color red) (_git_dirty_mark) (set_color blue)
	end
	
	printf '%s> ' (set_color normal)
end
