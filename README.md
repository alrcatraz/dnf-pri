# dnf-pri

`dnf-pri` is a lightweight command-line tool designed to manage and display the priorities of installed DNF/DNF5 repositories. It provides a clean, sorted table view of repositories and an easy way to set priority values.

## Features

- **List Repositories**: Display all enabled repositories with their ID, name, and current priority.
- **Adaptive Progress Bar**: Shows real-time progress while fetching metadata.
- **Flexible Sorting**: Sort the output table by Repository ID, Name, or Priority.
- **Priority Management**: Set or update repository priorities directly (requires root privileges).

## Prerequisites

- **DNF**: The package manager.
- **dnf-plugins-core**: Provides the `config-manager` command used by this tool.
- **Bash**: The script is written in Shell.

## Usage

### Listing Repositories
By default, the tool lists repositories sorted by ID:
```bash
dnf-pri
```

To sort by a specific field:
```bash
dnf-pri --sort id
dnf-pri --sort name
dnf-pri --sort pri
```

### Setting Configurations (Requires `sodo`)
The `set` command is a smart wrapper for `dnf config-manager`.

#### Set Priority
```bash
sudo dnf-pri set <repo-id> <priority>
# Example:
sudo dnf-pri set fedora 10
```

#### Toggle Status
```bash
sudo dnf-pri set epel --enable
sudo dnf-pri set epel --disable
```

#### Advanced Options
```bash
# Here are some examples
sudo dnf-pri set epel --includepkgs "librime*"
sudo dnf-pri set epel --excludepkgs "librime*"
```


## Installation

This package is also avaliable in Copr. To enable the repository and install this package, run following command on `RHEL` / `RockyLinux` / `AlmaLinux` / `CentOS Stream` / `Fedora`:
```bash
sudo dnf copr enable alrcatraz/alrcatraz-utils
sudo dnf install dnf-pri
```

## License

This project is licensed under the GNU General Public License v3.0 or later (GPL-3.0-or-later). See the [LICENSE](LICENSE) file for details.