# Advanced Git Status Prompt

Git is the most advanced and flexible version control system in existence.
Truthfully, it is a complete filesystem built on top of your existing
filesystem.  It's perfectly suited for anything involving text, and makes
large scale or extremely frequent edits a breeze.  No fuss about backups;
if you make a mistake in editing you can just check the file back out
from git and you're all set.

Switching between branches is a very common action with git, and the
repo that I forked this repository from had a much simpler version of
code, which would simply allow you to display the name of the currently
checked out branch in your command line prompt.

I went a little further than that.  For me, although I do switch branches
frequently, the real *action* I'm doing is editing files.  The reason that
I personally need to run `git status` frequently is not to see what branch
I'm on so much as to see which files I've modified, whether I've staged
the modifications to be committed, whether I've created any new files that
are as of yet untracked by git, etc.  I wanted a prompt that could display
all of that information at a glance--color coded.

That's what I've created here.

There are a few caveats with regard to extremely advanced states that you
may get into (merge in progress, rebase in progress, possibly cherry-pick
in progress, etc).  These are mentioned briefly below.  They're rather
difficult to parse from the `git status --porcelain` command, though--
actually most of these special states aren't even indicated in any way
by `git status --porcelain`--so I've ignored these for the most part.

The basic table of colors that will be shown is:

- blue - clean working directory, nothing to commit
- green - changes have been staged but not committed
- red - changes have been made in the working directory but not staged
- yellow - there are changes in the index and further changes in the working directory

If there are untracked files in your working directory, a bold white
asterisk will be added after the branch name for any of the above statuses.

And, of course, if you're not in a git repository your prompt will
work as it normally does.

Note that this makes for a total of 8 options.  I've separated these
fairly cleanly in the code, so feel free to tweak them to your preference.

## Caveats

Note that there are some edge cases if a merge is in progress, which are
difficult to parse.  Therefore in *most* cases if you are merging, the
branch name will appear in purple followed by the word "merging", but in
certain advanced scenarios (i.e. stopping during an interactive rebase to
edit a commit, or performing a nonconflicting merge with `--no-commit`)
you will simply have to use the 'git status' command to get a proper
explanation of what's going on.  I can't do everything.  :)

## Installation

Clone the project to a `.bash` folder in your home directory:

```bash
mkdir ~/.bash
cd ~/.bash
git clone git://github.com/jimeh/git-aware-prompt.git
```

Edit your `~/.bash_profile` or `~/.profile` and add the following to the top:

```bash
export GITAWAREPROMPT=~/.bash/git-aware-prompt
source "${GITAWAREPROMPT}/main.sh"
```

## Alternate Installation

My own preference is to have all related data in a single file.  I *could*
use `colors.sh` by itself, but since I only use it for this script, I have
made a standalone version of all the code from this repo,
`standalone_prompt.sh`, which can be sourced by itself and will work with
no layers of indirection.  For actual installation you may want to comment
out the line in the standalone prompt file which sets your `PS1` variable
and set it yourself in your `.bashrc` or `.bash_profile`.

## Configuring

Once installed, just include `$git_prompt` in your `PS1` environment variable
at the point you want the colorized git branch to be displayed.

#### Mac OS X

Default prompt from Apple:

```bash
PS1='\h:\W \u\$ '
```

Prompt customized to include git branch information:

```bash
PS1='\h:\W \u$git_prompt\$ '
```

The prompt I use on my Mac:

```bash
PS1='\t [\u \W]$git_prompt \! \$ '
```
