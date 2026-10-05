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
  `~/.cache/nvim/jdtls/workspace/<root-folder-name>`. jdtls only starts for `java` buffers. The
  root is found by searching upwards from the file:

  1. The nearest folder with a `.jdtls-root` file (an empty file; the name is `JDTLS_ROOT_MARKER`
     in `init.lua`). This takes precedence over any default marker, even a nearer one.
  2. Otherwise, lspconfig's default markers: `gradlew`, `settings.gradle`, `.git`, etc., then
     `build.gradle`, `pom.xml`, etc.

  With no marker at all, jdtls doesn't start. jdtls imports every Gradle/Maven project it finds
  under the root. Projects linked by `includeBuild()` share one server, and its workspace is named
  after the first one opened (see below).
- Gradle projects are imported with Buildship, the same library Eclipse uses. Buildship writes and
  owns `.project`, `.classpath` and `.settings/`.
- Only the first open of a project runs a full Gradle sync. Later sessions reuse the cached
  workspace, so changes to `settings.gradle` / `build.gradle` (e.g. a new `includeBuild()`) aren't
  picked up automatically.

### Composite builds (`includeBuild()` of sibling projects)

An included build appears in `.classpath` as a **workspace project reference**, e.g.
`<classpathentry kind="src" path="/fx-common"/>`. The leading `/` means "the workspace project
named `fx-common`", not a filesystem path. It resolves only if the sibling build was imported into
the same jdtls workspace and is still there.

Out of the box this breaks in three ways. `init.lua` works around each one, finding the included
builds by following `includeBuild()` in `settings.gradle` / `settings.gradle.kts` (transitively):

1. **jdtls deletes included builds from its workspace.** Buildship imports them, but jdtls then
   removes every Gradle project that isn't inside one of its root folders and isn't a subproject of
   one. `before_init` passes every included build as a root folder. jdtls (1.60) reads its initial
   root folders only from `initializationOptions.workspaceFolders`, not from the LSP
   `workspaceFolders`.
2. **Gradle's Eclipse model drops `compileOnly` dependencies on included builds.** It only takes
   included builds from the runtime classpaths, so a `compileOnly` sibling is missing from main's
   classpath, or marked test-only (`test="true"`, invisible to main sources) when it is also a
   `testImplementation` dependency. `.config/nvim/jdtls/composite-compile-only.gradle` adds them
   back; jdtls passes it to Gradle via the `java.import.gradle.arguments` setting. It only affects
   the model jdtls imports, not command-line builds.
3. **Separate jdtls servers sharing an included build overwrite each other.** Every server writes
   `.project`, `.classpath` and `.settings/` into each included build's directory. `reuse_client`
   reuses a running jdtls when the new project shares any build with it, and adds the builds it
   doesn't have yet as workspace folders. This only works within one Neovim instance, so don't
   open related projects in two instances at once.

`~/.config/nvim` must contain both `init.lua` and `jdtls/composite-compile-only.gradle`.

If classes from a sibling build still don't resolve:

1. **Don't use Gradle's `eclipse` plugin (`gradle eclipse`) alongside jdtls.** Remove
   `id("eclipse")` from `build.gradle`.
2. **Quit Neovim**, so no jdtls is running.
3. **Delete the generated files** in the project and every build it includes, so Buildship can
   regenerate them:

   ```shell
   rm -rf .classpath .settings
   ```

4. **Force a full re-import** by deleting the cached workspaces, then reopen a Java file:

   ```shell
   rm -rf ~/.cache/nvim/jdtls/workspace/*
   ```

   To check that the included builds were imported and kept, list the workspace's projects. The
   sibling project names should appear next to the main one:

   ```shell
   ls ~/.cache/nvim/jdtls/workspace/<project>/.metadata/.plugins/org.eclipse.core.resources/.projects
   ```

### `:JdtUpdateConfig`

After editing `settings.gradle` / `build.gradle`, run `:JdtUpdateConfig` from a Java buffer.
It sends `java/projectConfigurationUpdate` to jdtls to re-sync the Gradle project without wiping
the workspace.
