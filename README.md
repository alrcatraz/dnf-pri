# dnf-pri
a tool to set and show priority of installed dnf repositories

## How To Use

```
dnf-pri [options]
```

### Options

`--sort <sort_method>`

Define how result table is organised. Possible `sort_method` are below:

- **id**: Based on the order of ID of repositories
- **name**: Based on the order or name of repositories
- **pri**: Based on priority value set to repositories. Smaller value means higher priority

If this option is not set individually, it will be `id` by default.
