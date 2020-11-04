![CI](https://github.com/Actr0n/swTestSetup/workflows/CI/badge.svg?branch=master)

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

# Run tests

In order to run tests, select your source file, which runs the tests and click the play button at the top right corner (`Run Code (Ctrl+Alt+N)`) of Visual Studio Code or press its shortcut.

# TODOs

The matrix functions are that far finished for compatibility only, by which i mean advanced calculations may result in
oob errors.
When that's the case, please fix those issues, thanks.

# Framework interaction

## Fire events

The `testsuite.event` namespace contains all events which are being called by the stormworks server.

## Arrange environment variables

To prepare the framework for the test, you can set values like players position with the `testsuite.test` namespace.

# .gitignore

You can prefix files you don't want to be commited with "SECRET_" or "HIDDEN_".
