
SEKYFSR (C) S.Laflamme

Gentoo Overlay by Nicolas Pinto

## Warning

Use at your own risks -- be careful, it could break your leg.

## Installation

### Option 1: using layman
    emerge layman
    echo 'source /var/lib/layman/make.conf' >> /etc/make.conf
    layman -o https://github.com/npinto/sekyfsr-gentoo-overlay/raw/master/overlay.xml -f -a sekyfsr
    layman -S

### Option 2: manually
1. ``git clone git://github.com/npinto/sekyfsr-gentoo-overlay.git``
2. Add to ``/etc/make.conf``:
``PORTDIR_OVERLAY="/path/to/overlay"``
3. Edit ``/etc/portage/package.keywords/package_name`` and unmask desired packages

