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
