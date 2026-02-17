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

### Available Themes
  [*Preview avialable below*](#Previews:)

  - **Rover**
    - Rover (Female): `rover-female`
    - Rover (Male): `rover-male`

  - **Huang Long**
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

  - **Black Shores**
    - Aalto: `aalto`
    - Buling: `buling`
    - Camellya: `camellya`
    - Encore: `encore`
    - Galbrena: `galbrena`
    - The Shorekeeper: `shorekeeper`
  
  - **Ragunna**
    - Brant: `brant`
    - Cantarella: `cantarella`
    - Carlotta: `carlotta`
    - Cartethyia: `cartethyia`
    - Ciaccona: `ciaccona`
    - Phoebe: `phoebe`
    - Roccia: `roccia`
    - Zani: `zani`

  - **Septimont**
    - Augusta: `augusta`
    - Luno: `luno`
    - Lupa: `lupa`

  - **Startorch Academy**
    - Aemeath: `aemeath`
    - Chisa: `chisa`
    - Lynae: `lynae`

  - **Spacetrek Collective**
    - Mornye: `mornye`

  - **The Fractsidus**
    - Phlorova: `phlorova`

  - **Unknown**
    - Calcharo: `calcharo`

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

### Rover
<details>
<summary><b>Rover (Female)</b></summary>

![Rover (Female)](./previews/rover-female.jpg)
</details>

<details>
<summary><b>Rover (Male)</b></summary>

![Rover (Male)](./previews/rover-male.jpg)
</details>

### Huang Long
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

### Black Shores
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

### Ragunna
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

### Septimont
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

### Startorch Academy
<details>
<summary><b>Aemeath</b></summary>

![Aemeath](./previews/aemeath.jpg)
</details>

<details>
<summary><b>Chisa</b></summary>

![Chisa](./previews/chisa.jpg)
</details>

<details>
<summary><b>Lynae</b></summary>

![Lynae](./previews/lynae.jpg)
</details>

### Spacetrek Collective
<details>
<summary><b>Mornye</b></summary>

![Mornye](./previews/mornye.jpg)
</details>

### The Fractsidus
<details>
<summary><b>Phlorova</b></summary>

![Phlorova](./previews/phlorova.jpg)
</details>

### Unknown
<details>
<summary><b>Calcharo</b></summary>

![Calcharo](./previews/calcharo.jpg)
</details>

## Documents

[Grub2 theme reference](https://wiki.rosalab.ru/en/index.php/Grub2_theme_/_reference)

[Grub2 theme tutorial](https://wiki.rosalab.ru/en/index.php/Grub2_theme_tutorial)
