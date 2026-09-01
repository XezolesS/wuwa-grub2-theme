# wuwa-grub2-themes

![banner](banner.png?raw=true)

**This repository is a fork of
[vinceliuice/Wuthering-grub2-themes](https://github.com/vinceliuice/Wuthering-grub2-themes)
and is heavily modified.**

## Prerequisites

- `bash`
- `curl` (when --remote|-r flag is passed)
- `git` (to clone this repository)
- `zenity` (for GUI Installer)

## Installation

### Method 1. Remote Install (Recommended)

With this method, installation script is fetched using `curl`.
The script will automatically download assets from this GitHub repository.
It is recommended due to the large number of backgrounds, a whole repo is quite
chunky to download.

#### Method 1.1. Remotely execute GUI installer

**Make sure you have `zenity` installed.**

Copy this command below and execute it.

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/XezolesS/wuwa-grub2-theme/master/scripts/install-theme-gui.sh)"
```

<img src="./.readme_assets/gui-installer.png"
  alt="gui-installer"/>

#### Method 1.2. Remotely execute install script

Copy this command below and execute it with parameters.

```bash
curl -fsSL https://raw.githubusercontent.com/XezolesS/wuwa-grub2-theme/master/scripts/install-theme.sh | sudo bash -s -- -r [PARAM]
```

_e.g. Download a 'jinhsi' theme in a UHD resolution, onto a boot directory,
with verbose output._

```bash
curl -fsSL https://raw.githubusercontent.com/XezolesS/wuwa-grub2-theme/master/scripts/install-theme.sh | sudo bash -s -- -r -bv jinhsi uhd
```

### Method 2. Local Install

With this method, you are going to clone this repository and execute a script locally.

```bash
git clone https://github.com/XezolesS/wuwa-grub2-theme.git
cd ./wuwa-grub2-themes/scripts
sudo ./install-theme-gui.sh       # for GUI installer
sudo ./install-theme.sh [PARAM]   # for CLI script
```

### `install-theme.sh` Usage

```ansi
Usage: ./install-theme.sh [OPTION] THEME [RESOLUTION]

THEME:
  Name of the theme to install.
  If '--background-path' is a file, this will be ignored, but required.

[RESOLUTION]: [fhd | qhd | uhd]
  Resolution of a monitor. Defaults to 'fhd'.

[OPTIONS]:
  -b, --boot          Install theme to boot directory. (/boot/grub/theme)
  -r, --remote        Fetch the theme list from a remote repository.
[background-path] will be ignored.
  --backgrounds-path  Custom background path. Can be either file or directory.
  -o, --output        Output directory. Instead of installing theme to GRUB, it
compiles it to other directory. Cannot be used with --boot.
  -v, --verbose       Verbose messages.
  -h, --help          Show this help.
```

### Custom theme background

Check [Adding a custom theme](#adding-a-custom-theme)

## Uninstallation

### Method 1. Remote Uninstall (Recommended)

Unlike installation, this script need interactive tty to confirm a user to
delete a theme. It can be done when a script doesn't have a parameter, but
unfortunately, the script has it. So you have to download the script separately
and then run it locally.

```bash
curl -fsSL https://raw.githubusercontent.com/XezolesS/wuwa-grub2-theme/master/scripts/uninstall-theme.sh > uninstall-theme.sh
chmod 755 uninstall-theme.sh
sudo ./uninstall-theme.sh [PARAM]
rm uninstall-theme.sh
```

### Method 2. Local Uninstall

With this method, you are going to execute a script locally.

```bash
sudo <wuwa-grub2-theme-path>/scripts/install-theme.sh [PARAM]
```

### `uninstall-theme.sh` Usage

```ansi
Usage: ./uninstall-theme.sh [OPTION] [THEMES ...]

THEMES:
  Themes to uninstall.
  If it's empty, uninstall all themes that are intalled by this project.

  [OPTIONS]:
  -v, --verbose       Verbose messages.
  -h, --help          Show this help.
```

## Available Themes

[_Previews available below_](#previews)

<details>
<summary><b>Rover</b></summary>

- Rover (Female): `rover-female`
- Rover (Male): `rover-male`

</details>

<details>
<summary><b>Huang Long</b></summary>

- Baizhi: `baizhi`
- Changli: `changli`
- Chixia: `chixia`
- Danjin: `danjin`
- Jianxin: `jianxin`
- Jinhsi: `jinhsi`
- Lingyang: `lingyang`
- Lumi: `lumi`
- Mortefi: `mortefi`
- Qingxiao: `qingxiao`
- Qiuyuan: `qiuyuan`
- Sanhua: `sanhua`
- Suisui: `suisui`
- Taoqi: `taoqi`
- Verina: `verina`
- Xiangli Yao: `xiangli_yao`
- Yangyang: `yangyang`
- Yangyang: Xuanling: `yangyang-xuanling`
- Yinlin: `yinlin`
- Youhu: `youhu`
- Yuanwu: `yuanwu`
- Zhezhi: `zhezhi`

</details>

<details>
<summary><b>Black Shores</b></summary>

- Aalto: `aalto`
- Buling: `buling`
- Camellya: `camellya`
- Encore: `encore`
- Galbrena: `galbrena`
- The Shorekeeper: `shorekeeper`

</details>
  
<details>
<summary><b>Ragunna</b></summary>

- Brant: `brant`
- Cantarella: `cantarella`
- Carlotta: `carlotta`
- Cartethyia: `cartethyia`
- Ciaccona: `ciaccona`
- Phoebe: `phoebe`
- Roccia: `roccia`
- Zani: `zani`

</details>

<details>
<summary><b>Septimont</b></summary>

- Augusta: `augusta`
- Iuno: `iuno`
- Lupa: `lupa`

</details>

<details>
<summary><b>Startorch Academy</b></summary>

- Aemeath: `aemeath`
- Chisa: `chisa`
- Luuk Herssen: `luuk_herssen`
- Lynae: `lynae`

</details>

<details>
<summary><b>Spacetrek Collective</b></summary>

- Mornye: `mornye`
- Lucilla: `lucilla`

</details>

<details>
<summary><b>The Roya Tribe</b></summary>

- Sigrika: `sigrika`

</details>

<details>
<summary><b>Flaming Sakura</b></summary>

- Hiyuki: `kiyuki`

</details>

<details>
<summary><b>The Fractsidus</b></summary>

- Phlorova: `phlorova`

</details>

<details>
<summary><b>Unknown</b></summary>

- Calcharo: `calcharo`
- Denia: `denia`

</details>

## Issues / Tweaks

### Adding a custom theme

You can pass your custom background image as a parameter `--backgrounds-path`.
It can be either file or directory.

If it's given as a file, the name of the theme(`THEME` argument) will be ignored,
though it is mandatory so just pass any value.

If it's given as a directory, you should pass a valid theme name. The name will
be one of the PNG file inside of the directory, without an extension.

And make sure your image is:

- In **8-bit, non-indexed PNG format**
- Matches your screen resolution.
- Contains only alphanumerics, dashes(`-`), underscores(`_`) in its name. **NO SPACES!**

### Correcting display resolution

- On the grub screen, press `c` to enter the command line
- Enter `vbeinfo` or `videoinfo` to check available resolutions
- Open `/etc/default/grub`, and edit `GRUB_GFXMODE=[height]x[width]x32` to match
your resolution
- Finally, run `grub-mkconfig -o /boot/grub/grub.cfg` to update your grub config

## Contributing

- If you add new background, make sure create a new `index.txt`:
  - Run `./scripts/write-theme-index.sh`
- If you made changes to fonts, make sure create a new `index.txt`:
  - Run `./scripts/makefont.sh`
- If you made changes to icons, or added a new one:
  - Make sure you have `inkscape` and `optipng` installed.
  - Delete the existing icon, if there is one
  - Run `./scripts/render-assets.sh`
- Create a pull request from your branch or fork
- If any issues occur, report then to the [issue](issues) page

## Previews

Click to reveal

<details>
<summary>
  <div align="center">
    <picture align="center">
        <img src="./.readme_assets/affiliation-icons/rover.webp"
          alt="Rover" height=100 href="/">
    </picture>
  </div>
  <div align="center">
    <b>Rover</b>
  </div>
</summary>

  <blockquote>

  <details>
  <summary><b>Rover (Female)</b></summary>

  ![Rover (Female)](./.readme_assets/rover-female.webp)
  </details>

  <details>
  <summary><b>Rover (Male)</b></summary>

  ![Rover (Male)](./.readme_assets/rover-male.webp)
  </details>

  </blockquote>
</details>

<details>
<summary>
  <div align="center">
    <picture align="center">
        <img src="./.readme_assets/affiliation-icons/huanglong.webp"
          alt="Huang Long" height=100 href="/">
    </picture>
  </div>
  <div align="center">
    <b>Huang Long</b>
  </div>
</summary>

  <blockquote>

  <details>
  <summary><b>Baizhi</b></summary>

  ![Baizhi](./.readme_assets/themes/baizhi.webp)
  </details>

  <details>
  <summary><b>Changli</b></summary>

  ![Changli](./.readme_assets/themes/changli.webp)
  </details>

  <details>
  <summary><b>Chixia</b></summary>

  ![Chixia](./.readme_assets/themes/chixia.webp)
  </details>

  <details>
  <summary><b>Danjin</b></summary>

  ![Danjin](./.readme_assets/themes/danjin.webp)
  </details>

  <details>
  <summary><b>Jianxin</b></summary>

  ![Jianxin](./.readme_assets/themes/jianxin.webp)
  </details>

  <details>
  <summary><b>Jinhsi</b></summary>

  ![Jinhsi](./.readme_assets/themes/jinhsi.webp)
  </details>

  <details>
  <summary><b>Lingyang</b></summary>

  ![Lingyang](./.readme_assets/themes/lingyang.webp)
  </details>

  <details>
  <summary><b>Lumi</b></summary>

  ![Lumi](./.readme_assets/themes/lumi.webp)
  </details>

  <details>
  <summary><b>Mortefi</b></summary>

  ![Mortefi](./.readme_assets/themes/mortefi.webp)
  </details>

  <details>
  <summary><b>Qingxiao</b></summary>

  ![Qingxiao](./.readme_assets/themes/qingxiao.webp)
  </details>

  <details>
  <summary><b>Qiuyuan</b></summary>

  ![Qiuyuan](./.readme_assets/themes/qiuyuan.webp)
  </details>

  <details>
  <summary><b>Sanhua</b></summary>

  ![Sanhua](./.readme_assets/themes/sanhua.webp)
  </details>

  <details>
  <summary><b>Suisui</b></summary>

  ![Suisui](./.readme_assets/themes/suisui.webp)
  </details>

  <details>
  <summary><b>Taoqi</b></summary>

  ![Taoqi](./.readme_assets/themes/taoqi.webp)
  </details>

  <details>
  <summary><b>Verina</b></summary>

  ![Verina](./.readme_assets/themes/verina.webp)
  </details>

  <details>
  <summary><b>Xiangli Yao</b></summary>

  ![Xiangli Yao](./.readme_assets/themes/xiangli_yao.webp)
  </details>

  <details>
  <summary><b>Yangyang</b></summary>

  ![Yangyang](./.readme_assets/themes/yangyang.webp)
  </details>

  <details>
  <summary><b>Yangyang: Xuanling</b></summary>

  ![Yangyang: Xuanling](./.readme_assets/yangyang-xuanling.webp)
  </details>

  <details>
  <summary><b>Yinlin</b></summary>

  ![Yinlin](./.readme_assets/themes/yinlin.webp)
  </details>

  <details>
  <summary><b>Youhu</b></summary>

  ![Youhu](./.readme_assets/themes/youhu.webp)
  </details>

  <details>
  <summary><b>Yuanwu</b></summary>

  ![Yuanwu](./.readme_assets/themes/yuanwu.webp)
  </details>

  <details>
  <summary><b>Zhezhi</b></summary>

  ![Zhezhi](./.readme_assets/themes/zhezhi.webp)
  </details>

  </blockquote>
</details>

<details>
<summary>
  <div align="center">
    <picture align="center">
        <img src="./.readme_assets/affiliation-icons/black_shores.webp"
          alt="Black Shores" height=100 href="/">
    </picture>
  </div>
  <div align="center">
    <b>Black Shores</b>
  </div>
</summary>

  <blockquote>

  <details>
  <summary><b>Aalto</b></summary>

  ![Aalto](./.readme_assets/themes/aalto.webp)
  </details>

  <details>
  <summary><b>Buling</b></summary>

  ![Buling](./.readme_assets/themes/buling.webp)
  </details>

  <details>
  <summary><b>Camellya</b></summary>

  ![Camellya](./.readme_assets/themes/camellya.webp)
  </details>

  <details>
  <summary><b>Encore</b></summary>

  ![Encore](./.readme_assets/themes/encore.webp)
  </details>

  <details>
  <summary><b>Galbrena</b></summary>

  ![Galbrena](./.readme_assets/themes/galbrena.webp)
  </details>

  <details>
  <summary><b>The Shorekeeper</b></summary>

  ![The Shorekeeper](./.readme_assets/themes/shorekeeper.webp)
  </details>

  </blockquote>
</details>

<details>
<summary>
  <div align="center">
    <picture align="center">
        <img src="./.readme_assets/affiliation-icons/ragunna.webp"
          alt="Ragunna" height=100 href="/">
    </picture>
  </div>
  <div align="center">
    <b>Ragunna</b>
  </div>
</summary>

  <blockquote>

  <details>
  <summary><b>Brant</b></summary>

  ![Brant](./.readme_assets/themes/brant.webp)
  </details>

  <details>
  <summary><b>Cantarella</b></summary>

  ![Cantarella](./.readme_assets/themes/cantarella.webp)
  </details>

  <details>
  <summary><b>Carlotta</b></summary>

  ![Carlotta](./.readme_assets/themes/carlotta.webp)
  </details>

  <details>
  <summary><b>Cartethyia</b></summary>

  ![Cartethyia](./.readme_assets/themes/cartethyia.webp)
  </details>

  <details>
  <summary><b>Ciaccona</b></summary>

  ![Ciaccona](./.readme_assets/themes/ciaccona.webp)
  </details>

  <details>
  <summary><b>Phoebe</b></summary>

  ![Phoebe](./.readme_assets/themes/phoebe.webp)
  </details>

  <details>
  <summary><b>Roccia</b></summary>

  ![Roccia](./.readme_assets/themes/roccia.webp)
  </details>

  <details>
  <summary><b>Zani</b></summary>

  ![Zani](./.readme_assets/themes/zani.webp)
  </details>

  </blockquote>
</details>

<details>
<summary>
  <div align="center">
    <picture align="center">
        <img src="./.readme_assets/affiliation-icons/septimont.webp"
          alt="Septimont" height=100 href="/">
    </picture>
  </div>
  <div align="center">
    <b>Septimont</b>
  </div>
</summary>

  <blockquote>

  <details>
  <summary><b>Augusta</b></summary>

  ![Augusta](./.readme_assets/themes/augusta.webp)
  </details>

  <details>
  <summary><b>Iuno</b></summary>

  ![Iuno](./.readme_assets/themes/iuno.webp)
  </details>

  <details>
  <summary><b>Lupa</b></summary>

  ![Lupa](./.readme_assets/themes/lupa.webp)
  </details>

  </blockquote>
</details>

<details>
<summary>
  <div align="center">
    <picture align="center">
        <img src="./.readme_assets/affiliation-icons/startorch_academy.webp"
          alt="Startorch Academy" height=100 href="/">
    </picture>
  </div>
  <div align="center">
    <b>Startorch Academy</b>
  </div>
</summary>

  <blockquote>

  <details>
  <summary><b>Aemeath</b></summary>

  ![Aemeath](./.readme_assets/themes/aemeath.webp)
  </details>

  <details>
  <summary><b>Chisa</b></summary>

  ![Chisa](./.readme_assets/themes/chisa.webp)
  </details>

  <details>
  <summary><b>Luuk Herssen</b></summary>

  ![Luuk Herssen](./.readme_assets/themes/luuk_herssen.webp)
  </details>

  <details>
  <summary><b>Lynae</b></summary>

  ![Lynae](./.readme_assets/themes/lynae.webp)
  </details>

  </blockquote>
</details>

<details>
<summary>
  <div align="center">
    <picture align="center">
        <img src="./.readme_assets/affiliation-icons/spacetrek_collective.webp"
          alt="Spacetrek Collective" height=100 href="/">
    </picture>
  </div>
  <div align="center">
    <b>Spacetrek Collective</b>
  </div>
</summary>

  <blockquote>

  <details>
  <summary><b>Mornye</b></summary>

  ![Mornye](./.readme_assets/themes/mornye.webp)
  </details>
  
  <details>
  <summary><b>Lucilla</b></summary>

  ![Lucilla](./.readme_assets/themes/lucilla.webp)
  </details>

  </blockquote>
</details>

<details>
<summary>
  <div align="center">
    <picture align="center">
        <img src="./.readme_assets/affiliation-icons/the_roya_tribe.webp"
          alt="The Roya Tribe" height=100 href="/">
    </picture>
  </div>
  <div align="center">
    <b>The Roya Tribe</b>
  </div>
</summary>

  <blockquote>

  <details>
  <summary><b>Sigrika</b></summary>

  ![Sigrika](./.readme_assets/themes/sigrika.webp)
  </details>
  
  </blockquote>
</details>

<details>
<summary>
  <div align="center">
    <picture align="center">
        <img src="./.readme_assets/affiliation-icons/flaming_sakura.webp"
          alt="Flaming Sakura" height=100 href="/">
    </picture>
  </div>
  <div align="center">
    <b>Flaming Sakura</b>
  </div>
</summary>

  <blockquote>

  <details>
  <summary><b>Hiyuki</b></summary>

  ![Hiyuki](./.readme_assets/themes/hiyuki.webp)
  </details>

  </blockquote>
</details>

<details>
<summary>
  <div align="center">
    <picture align="center">
        <img src="./.readme_assets/affiliation-icons/the_fractsidus.webp"
          alt="The Fractsidus" height=100 href="/">
    </picture>
  </div>
  <div align="center">
    <b>The Fractsidus</b>
  </div>
</summary>

  <blockquote>

  <details>
  <summary><b>Phlorova</b></summary>

  ![Phlorova](./.readme_assets/themes/phlorova.webp)
  </details>

  </blockquote>
</details>

<details>
<summary>
  <div align="center">
    <picture align="center">
        <img src="./.readme_assets/affiliation-icons/unknown.webp" alt="Unknown" height=100 href="/">
    </picture>
  </div>
  <div align="center">
    <b>Unknown</b>
  </div>
</summary>

  <blockquote>

  <details>
  <summary><b>Calcharo</b></summary>

  ![Calcharo](./.readme_assets/themes/calcharo.webp)
  </details>

  <details>
  <summary><b>Denia</b></summary>

  ![Denia](./.readme_assets/themes/denia.webp)
  </details>

  </blockquote>
</details>

## Documents

[Grub2 theme reference](https://wiki.rosalab.ru/en/index.php/Grub2_theme_/_reference)

[Grub2 theme tutorial](https://wiki.rosalab.ru/en/index.php/Grub2_theme_tutorial)
