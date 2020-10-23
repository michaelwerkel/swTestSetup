# VSCode Extensions:

- formulahendry's Code Runner (Windows, Linux)
- sumneko's Lua (Windows, Linux)
- actboy168's Lua Debug

# Applications required:

- Lua, at least 5.3 (Only required when ran with Code Runner)

## Lua installation

1. [Download](http://luabinaries.sourceforge.net/#installation) the minimum required version, extract the archive and rename the lua*.exe to lua.exe.
2. Copy the folder into a persistent folder (like Program Files) and add this folder to the PATH environment variable.
3. Restart VSCode

# Framework interaction

## Fire events

The `testsuite.event` namespace contains all events which are being called by the stormworks server.

## Arrange environment variables

To prepare the framework for the test, you can set values like players position with the `testsuite.test` namespace.

# .gitignore

You can prefix files you don't want to be commited with "SECRET_" or "HIDDEN_".
