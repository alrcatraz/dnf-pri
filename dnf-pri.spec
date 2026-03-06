Name:           dnf-pri
Version:        1.0.0
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
mkdir -p %{buildroot}%{_bindir}
install -p -m 755 dnf-pri %{buildroot}%{_bindir}/dnf-pri

%files
%license LICENSE
%doc README.md
%{_bindir}/dnf-pri

%changelog
* Fri Mar 06 2026 Alrcatraz <alrcatraz@gmx.com> - 1.0.0-1
- Initial package for dnf-pri