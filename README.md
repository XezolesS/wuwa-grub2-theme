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

 - Install jinhsi theme into /boot/grub/themes:

```sh
sudo ./install.sh -b -t jinhsi
```

 - Uninstall yinlin theme:

```sh
sudo ./install.sh -r -t yinlin
```

### Available Themes
[*Preview available below*](#previews)

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
  - Qiuyuan: `qiuyuan`
  - Sanhua: `sanhua`
  - Taoqi: `taoqi`
  - Verina: `verina`
  - Xiangli Yao: `xiangli_yao`
  - Yangyang: `yangyang`
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
  - Luno: `luno`
  - Lupa: `lupa`
</details>

<details>
<summary><b>Startorch Academy</b></summary>

  - Aemeath: `aemeath`
  - Chisa: `chisa`
  - Luuk Herssen: `luuk-herssen`
  - Lynae: `lynae`
</details>

<details>
<summary><b>Spacetrek Collective</b></summary>

  - Mornye: `mornye`
</details>

<details>
<summary><b>The Roya Tribe</b></summary>

  - Sigrika: `sigrika`
</details>

<details>
<summary><b>The Fractsidus</b></summary>

  - Phlorova: `phlorova`
</details>

<details>
<summary><b>Unknown</b></summary>

  - Calcharo: `calcharo`
</details>

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

## Previews:

*Click to reveal*

<details>
<summary>
  <div align="center">
    <picture align="center">
        <img src="./previews/affiliation_icons/rover.png" alt="Rover" height=100 href="/">
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
        <img src="./previews/affiliation_icons/huanglong.png" alt="Huang Long" height=100 href="/">
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
  <summary><b>Qiuyuan</b></summary>

  ![Qiuyuan](./previews/qiuyuan.jpg)
  </details>

  <details>
  <summary><b>Sanhua</b></summary>

  ![Sanhua](./previews/sanhua.jpg)
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
        <img src="./previews/affiliation_icons/black_shores.png" alt="Black Shores" height=100 href="/">
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
        <img src="./previews/affiliation_icons/ragunna.png" alt="Ragunna" height=100 href="/">
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
        <img src="./previews/affiliation_icons/septimont.webp" alt="Septimont" height=100 href="/">
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
  <summary><b>Luno</b></summary>

  ![Luno](./previews/luno.jpg)
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
        <img src="./previews/affiliation_icons/startorch_academy.webp" alt="Startorch Academy" height=100 href="/">
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

  ![Luuk Herssen](./previews/luuk-herssen.jpg)
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
        <img src="./previews/affiliation_icons/spacetrek_collective.webp" alt="Spacetrek Collective" height=100 href="/">
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
  
  </blockquote>
</details>

<details>
<summary>
  <div align="center">
    <picture align="center">
        <img src="./previews/affiliation_icons/the_roya_tribe.webp" alt="The Roya Tribe" height=100 href="/">
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
        <img src="./previews/affiliation_icons/the_fractsidus.webp" alt="The Fractsidus" height=100 href="/">
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

  </blockquote>
</details>

## Documents

[Grub2 theme reference](https://wiki.rosalab.ru/en/index.php/Grub2_theme_/_reference)

[Grub2 theme tutorial](https://wiki.rosalab.ru/en/index.php/Grub2_theme_tutorial)
