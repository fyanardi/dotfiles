# dotfiles

Collection of Linux configuration files and setup scripts

## Bash customisation

Add this to `.bashrc` to load custom scripts separate from distribution-managed defaults:

```shell
if [ -d ~/.bashrc.d ]; then
    for file in ~/.bashrc.d/*.sh; do
        [ -r "$file" ] && . "$file"
    done
fi
```

## Neovim: Java with jdtls

`.config/nvim/init.lua` enables `jdtls` through nvim-lspconfig's default config (`vim.lsp.enable('jdtls')`).
The `jdtls` binary must be on `PATH`, e.g. `~/.local/bin/jdtls -> /opt/jdtls/bin/jdtls`.

### How the workspace works

- jdtls keeps one Eclipse workspace per project root folder, under
  `~/.cache/nvim/jdtls/workspace/<root-folder-name>`. The root is the nearest folder with
  `gradlew`, `settings.gradle`, `.git`, etc.
- Gradle projects are imported with Buildship, the same library Eclipse uses. Buildship writes and
  owns `.project`, `.classpath` and `.settings/`.
- Only the first open of a project runs a full Gradle sync. Later sessions reuse the cached
  workspace, so changes to `settings.gradle` / `build.gradle` (e.g. a new `includeBuild()`) aren't
  picked up automatically.

### Composite builds (`includeBuild()` of sibling projects)

An included build appears in `.classpath` as a **workspace project reference**, e.g.
`<classpathentry kind="src" path="/fx-common"/>`. The leading `/` means "the workspace project
named `fx-common`", not a filesystem path. It resolves only if the sibling build was imported into
the same jdtls workspace. Buildship does this for included builds during a full sync.

If classes from a sibling build don't resolve:

1. **Don't use Gradle's `eclipse` plugin (`gradle eclipse`) alongside jdtls.** Remove
   `id("eclipse")` from `build.gradle` and delete the files it generated, so Buildship can
   regenerate them:

   ```shell
   rm -rf .classpath .settings
   ```

2. **Force a full re-import** by deleting the cached workspace for the project, then reopen a Java
   file:

   ```shell
   rm -rf ~/.cache/nvim/jdtls/workspace/<project>
   ```

   To check that the included builds were imported, list the workspace's projects. The sibling
   project names should appear next to the main one:

   ```shell
   ls ~/.cache/nvim/jdtls/workspace/<project>/.metadata/.plugins/org.eclipse.core.resources/.projects
   ```

### `:JdtUpdateConfig`

After editing `settings.gradle` / `build.gradle`, run `:JdtUpdateConfig` from a Java buffer.
It sends `java/projectConfigurationUpdate` to jdtls to re-sync the Gradle project without wiping
the workspace.
