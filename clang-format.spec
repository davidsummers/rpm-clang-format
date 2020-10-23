Name: clang-format
Version: 11.0.0
Release: 1%{?dist}
#Vendor: David Summers
#URL: http://someurl.com
License: CLANG License
Summary: Formats source code according to specification file.
Source: %{name}-%{version}.tar.gz
Group: Utilities/System
Packager: david@summersoft.fay.ar.us
BuildRequires: gcc
BuildRequires: gcc-c++
BuildRequires: cmake3
ExcludeArch: noarch

%description
Clang-format formats source code according to specification file.

%changelog
* Fri Oct 23 2020 David Summers <david@summersoft.fay-ar.us> 11.0.0-1
- Clang-format 11.0.0

%prep
%setup -q -n llvm-project

%build
# Build the distribution.
mkdir -p build
cd build
cmake3 ../llvm -DLLVM_ENABLE_PROJECTS="clang"
make

%install

# Install executable
mkdir -p $RPM_BUILD_ROOT/usr/bin
cp build/bin/clang-format $RPM_BUILD_ROOT/usr/bin

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
#%doc AUTHORS COPYING web/NEWS README doc/*
/usr/bin/*
