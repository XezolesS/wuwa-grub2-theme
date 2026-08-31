# wuwa-grub2-themes

![banner](banner.png?raw=true)

**This repository is a fork of [vinceliuice/Wuthering-grub2-themes](https://github.com/vinceliuice/Wuthering-grub2-themes)**

## Prerequisites

- `bash`
- `curl` (when --remote|-r flag is passed)
- `git` (to clone this repository)

## Installation

### Method 1. Remote Install (Recommended)

With this method, installation script is fetched using `curl`.
The script will automatically download assets from this GitHub repository.
It is recommended due to the increase of backgrounds, a whole repo is quite
chunky to download.

Copy this command below and run it with parameters.

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
sudo ./install-theme.sh [PARAM]
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
        <img src="./previews/affiliation_icons/rover.png"
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

  ![Rover (Female)](./previews/rover-female.jpg)
  </details>

  <details>
  <summary><b>Rover (Male)</b></summary>

  ![Rover (Male)](./previews/rover-male.jpg)
  </details>

  </blockquote>
</details>

<details>
<summary>
  <div align="center">
    <picture align="center">
        <img src="./previews/affiliation_icons/huanglong.png"
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

  ![Baizhi](./previews/baizhi.jpg)
  </details>

  <details>
  <summary><b>Changli</b></summary>

  ![Changli](./previews/changli.jpg)
  </details>

  <details>
  <summary><b>Chixia</b></summary>

  ![Chixia](./previews/chixia.jpg)
  </details>

  <details>
  <summary><b>Danjin</b></summary>

  ![Danjin](./previews/danjin.jpg)
  </details>

  <details>
  <summary><b>Jianxin</b></summary>

  ![Jianxin](./previews/jianxin.jpg)
  </details>

  <details>
  <summary><b>Jinhsi</b></summary>

  ![Jinhsi](./previews/jinhsi.jpg)
  </details>

  <details>
  <summary><b>Lingyang</b></summary>

  ![Lingyang](./previews/lingyang.jpg)
  </details>

  <details>
  <summary><b>Lumi</b></summary>

  ![Lumi](./previews/lumi.jpg)
  </details>

  <details>
  <summary><b>Mortefi</b></summary>

  ![Mortefi](./previews/mortefi.jpg)
  </details>

  <details>
  <summary><b>Qingxiao</b></summary>

  ![Qingxiao](./previews/qingxiao.jpg)
  </details>

  <details>
  <summary><b>Qiuyuan</b></summary>

  ![Qiuyuan](./previews/qiuyuan.jpg)
  </details>

  <details>
  <summary><b>Sanhua</b></summary>

  ![Sanhua](./previews/sanhua.jpg)
  </details>

  <details>
  <summary><b>Suisui</b></summary>

  ![Suisui](./previews/suisui.jpg)
  </details>

  <details>
  <summary><b>Taoqi</b></summary>

  ![Taoqi](./previews/taoqi.jpg)
  </details>

  <details>
  <summary><b>Verina</b></summary>

  ![Verina](./previews/verina.jpg)
  </details>

  <details>
  <summary><b>Xiangli Yao</b></summary>

  ![Xiangli Yao](./previews/xiangli_yao.jpg)
  </details>

  <details>
  <summary><b>Yangyang</b></summary>

  ![Yangyang](./previews/yangyang.jpg)
  </details>

  <details>
  <summary><b>Yangyang: Xuanling</b></summary>

  ![Yangyang: Xuanling](./previews/yangyang-xuanling.jpg)
  </details>

  <details>
  <summary><b>Yinlin</b></summary>

  ![Yinlin](./previews/yinlin.jpg)
  </details>

  <details>
  <summary><b>Youhu</b></summary>

  ![Youhu](./previews/youhu.jpg)
  </details>

  <details>
  <summary><b>Yuanwu</b></summary>

  ![Yuanwu](./previews/yuanwu.jpg)
  </details>

  <details>
  <summary><b>Zhezhi</b></summary>

  ![Zhezhi](./previews/zhezhi.jpg)
  </details>

  </blockquote>
</details>

<details>
<summary>
  <div align="center">
    <picture align="center">
        <img src="./previews/affiliation_icons/black_shores.png"
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

  ![Aalto](./previews/aalto.jpg)
  </details>

  <details>
  <summary><b>Buling</b></summary>

  ![Buling](./previews/buling.jpg)
  </details>

  <details>
  <summary><b>Camellya</b></summary>

  ![Camellya](./previews/camellya.jpg)
  </details>

  <details>
  <summary><b>Encore</b></summary>

  ![Encore](./previews/encore.jpg)
  </details>

  <details>
  <summary><b>Galbrena</b></summary>

  ![Galbrena](./previews/galbrena.jpg)
  </details>

  <details>
  <summary><b>The Shorekeeper</b></summary>

  ![The Shorekeeper](./previews/shorekeeper.jpg)
  </details>

  </blockquote>
</details>

<details>
<summary>
  <div align="center">
    <picture align="center">
        <img src="./previews/affiliation_icons/ragunna.png"
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

  ![Brant](./previews/brant.jpg)
  </details>

  <details>
  <summary><b>Cantarella</b></summary>

  ![Cantarella](./previews/cantarella.jpg)
  </details>

  <details>
  <summary><b>Carlotta</b></summary>

  ![Carlotta](./previews/carlotta.jpg)
  </details>

  <details>
  <summary><b>Cartethyia</b></summary>

  ![Cartethyia](./previews/cartethyia.jpg)
  </details>

  <details>
  <summary><b>Ciaccona</b></summary>

  ![Ciaccona](./previews/ciaccona.jpg)
  </details>

  <details>
  <summary><b>Phoebe</b></summary>

  ![Phoebe](./previews/phoebe.jpg)
  </details>

  <details>
  <summary><b>Roccia</b></summary>

  ![Roccia](./previews/roccia.jpg)
  </details>

  <details>
  <summary><b>Zani</b></summary>

  ![Zani](./previews/zani.jpg)
  </details>

  </blockquote>
</details>

<details>
<summary>
  <div align="center">
    <picture align="center">
        <img src="./previews/affiliation_icons/septimont.webp"
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

  ![Augusta](./previews/augusta.jpg)
  </details>

  <details>
  <summary><b>Iuno</b></summary>

  ![Iuno](./previews/iuno.jpg)
  </details>

  <details>
  <summary><b>Lupa</b></summary>

  ![Lupa](./previews/lupa.jpg)
  </details>

  </blockquote>
</details>

<details>
<summary>
  <div align="center">
    <picture align="center">
        <img src="./previews/affiliation_icons/startorch_academy.webp"
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

  ![Aemeath](./previews/aemeath.jpg)
  </details>

  <details>
  <summary><b>Chisa</b></summary>

  ![Chisa](./previews/chisa.jpg)
  </details>

  <details>
  <summary><b>Luuk Herssen</b></summary>

  ![Luuk Herssen](./previews/luuk_herssen.jpg)
  </details>

  <details>
  <summary><b>Lynae</b></summary>

  ![Lynae](./previews/lynae.jpg)
  </details>

  </blockquote>
</details>

<details>
<summary>
  <div align="center">
    <picture align="center">
        <img src="./previews/affiliation_icons/spacetrek_collective.webp"
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

  ![Mornye](./previews/mornye.jpg)
  </details>
  
  <details>
  <summary><b>Lucilla</b></summary>

  ![Lucilla](./previews/lucilla.jpg)
  </details>

  </blockquote>
</details>

<details>
<summary>
  <div align="center">
    <picture align="center">
        <img src="./previews/affiliation_icons/the_roya_tribe.webp"
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

  ![Sigrika](./previews/sigrika.jpg)
  </details>
  
  </blockquote>
</details>

<details>
<summary>
  <div align="center">
    <picture align="center">
        <img src="./previews/affiliation_icons/flaming_sakura.webp"
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

  ![Hiyuki](./previews/hiyuki.jpg)
  </details>

  </blockquote>
</details>

<details>
<summary>
  <div align="center">
    <picture align="center">
        <img src="./previews/affiliation_icons/the_fractsidus.webp"
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

  ![Phlorova](./previews/phlorova.jpg)
  </details>

  </blockquote>
</details>

<details>
<summary>
  <div align="center">
    <picture align="center">
        <img src="./previews/affiliation_icons/unknown.png" alt="Unknown" height=100 href="/">
    </picture>
  </div>
  <div align="center">
    <b>Unknown</b>
  </div>
</summary>

  <blockquote>

  <details>
  <summary><b>Calcharo</b></summary>

  ![Calcharo](./previews/calcharo.jpg)
  </details>

  <details>
  <summary><b>Denia</b></summary>

  ![Denia](./previews/denia.jpg)
  </details>

  </blockquote>
</details>

## Documents

[Grub2 theme reference](https://wiki.rosalab.ru/en/index.php/Grub2_theme_/_reference)

[Grub2 theme tutorial](https://wiki.rosalab.ru/en/index.php/Grub2_theme_tutorial)
