Name:           dnf-pri
Version:        1.1.0
Release:        1%{?dist}
Summary:        A tool to set and show priority of installed dnf repositories
License:        GPL-3.0-or-later
BuildArch:      noarch

Source0:        %{name}-%{version}.tar.gz

Requires:       dnf
Requires:       dnf-plugins-core

%description
dnf-pri is a tool to quickly lookup and set priority for dnf repositories installed.

%prep
%autosetup

%install
# Create directory and install the script
mkdir -p %{buildroot}%{_bindir}
install -p -m 755 dnf-pri %{buildroot}%{_bindir}/dnf-pri

%files
# Package metadata and executable files
%license LICENSE
%doc README.md
%{_bindir}/dnf-pri

%changelog
* Fri Mar 06 2026 Alrcatraz <alrcatraz@gmx.com> - 1.0.0-1
- Initial package for dnf-pri

* Sun Mar 08 2026 Alrcatraz <alrcatraz@gmx.com> - 1.1.0-1
- Add `--all` parameter to show all repositories
- Enhance `set` command, now it will set priority by default, and can somewhat be used like a shortcut of `config-manager --save --setopt=` command