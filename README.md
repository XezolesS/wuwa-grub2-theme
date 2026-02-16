![banner](banner.png?raw=true)

**This repository is a fork of [vinceliuice/Wuthering-grub2-themes](https://github.com/vinceliuice/Wuthering-grub2-themes)**

## Installation:

Usage:  `sudo ./install.sh [OPTIONS...]`

```
  -t, --theme     Background theme variant(s)
  -s, --screen    Screen display variant(s)   [1080p|2k|4k] (default is 1080p)
  -r, --remove    Remove/Uninstall theme
  -b, --boot      install theme into '/boot/grub' or '/boot/grub2'
  -h, --help      Show this help
```

_If no options are used, a user interface `dialog` will show up instead_

### Examples:
 - Install yinlin theme on 2k display device:

```sh
sudo ./install.sh -t yinlin -s 2k
```

 - Install jinxi theme into /boot/grub/themes:

```sh
sudo ./install.sh -b -t jinxi
```

 - Uninstall yinlin theme:

```sh
sudo ./install.sh -r -t yinlin
```

## Issues / Tweaks:

### Adding a custom theme:
Put your custom background image under `./backgrounds` directory. The script will recognize your image automatically.  
Just make sure your image is:
 - In **8-bit, non-indexed PNG format**
 - Matches your screen resolution.
 - Contains only alphanumerics, dashes(`-`), underscores(`_`) in its name. **NO SPACES!**

### Correcting display resolution:
 - On the grub screen, press `c` to enter the command line
 - Enter `vbeinfo` or `videoinfo` to check available resolutions
 - Open `/etc/default/grub`, and edit `GRUB_GFXMODE=[height]x[width]x32` to match your resolution
 - Finally, run `grub-mkconfig -o /boot/grub/grub.cfg` to update your grub config

## Contributing:
 - If you made changes to icons, or added a new one:
   - Make sure you have `inkscape` and `optipng` installed.
   - Delete the existing icon, if there is one
   - Run `cd assets; ./render-all.sh`
 - Create a pull request from your branch or fork
 - If any issues occur, report then to the [issue](issues) page

## Documents

[Grub2 theme reference](https://wiki.rosalab.ru/en/index.php/Grub2_theme_/_reference)

[Grub2 theme tutorial](https://wiki.rosalab.ru/en/index.php/Grub2_theme_tutorial)
