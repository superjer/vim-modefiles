modefiles
=========
Avoid gunking up your files with modelines!

Modefiles are like modelines (see :h modeline), but without putting crap in
every file. Simply use :Set instead of :set to make option(s) sticky to the
current file.

<pre>
:Set option ...      Set options now & in the future when this file is opened
:Set                 View the currently :Set options
:Set! option ...     Like :Set but clear any previously saved options
:Set!                Edit file containing your :Set options in a new window
</pre>

When reopening a file, your :Set options will be reloaded automatically.
All errors are silently ignored! This should prevent problems when moving to
an older version of Vim. To check for errors, source the modefile yourself:

<pre>
:Set!
:source %
</pre>

To specify the directory for saving modefiles, add to your .vimrc:
<pre>
let g:modefilesdir = 'your/own/dir'
</pre>
The default is '~/.vim/modefiles' and will be created automatically.

To use a command other than :split with the :Set! command, do this:
<pre>
let g:modefileseditcmd = 'vsplit'
</pre>
