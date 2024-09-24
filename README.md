# qvm-screenshot-tool

_**qvm-screenshot**_ is a screenshot tool for [Qubes OS](https://qubes-os.org/).

Take screenshot in Qubes Dom0, optional to copy/move to qube and open file
manager in the target.

## Features

* Modes: fullscreen, window or region
* Screenshot programs: scrot, maim, xfce4-screenshooter,
  spectacle
* Dialog programs: zenity, kdialog
* Destiny: open file manager in qube
* Targets: type the qube name to find it when using kdialog

## OS support

Qubes OS Dom0.

DomUs:

* Linux: fully supported
* BSD: some OSes may require to change the command `xdg-open`
* Windows: unsupported

## Installation

Add the contributed packages repository:

```shell
sudo qubes-dom0-update qubes-repo-contrib
```

Install the screenshot tool:

```shell
sudo qubes-dom0-update --clean qvm-screenshot-tool
```

Now, you are ready to setup it on some hotkey combination.

* **Xfce**: go to `System` -> `Keyboard settings` and bind the program to the
  `PrintScreen` key combination.
* **KDE**: `Custom Shortcuts`, right-click on `Custom` -> `New` -> `Global
  Shortcut` -> `Command/URL`, set the `Action: qvm-screenshot` and `Trigger:
  PrintScreen`.

You can set different key combinations to different modes, such as setting

`PrintScreen: qvm-screenshot --fullscreen` and `Alt+PrintScreen:
qvm-screenshot --region`.

## Usage

Initiate the program, it will prompt for screenshot actions. You can choose
if the screenshot will be `Fullscreen` of `Window or Region`. If you choose
`Window or Region`, you can click the mouse on a window to choose the whole
window or drag the mouse across the region you want to capture and release
it when everything you desire is selected.

After the screenshot is made, you will be prompted for the screenshot
destiny, you can select multiple options. If you click `Exit`, the screenshot
will remain solely in `Dom0`. If you select `Move`, the image will be moved
to the qube and will be removed from `Dom0`. When selecting `Open file
manager in qube`, the default MIME handler for directories will be called and
the file manager will be opened in the target after the screenshot if
available in the qube.

At last, select the qube you desire to upload the screenshot to. When using
`kdialog`, you can type strings to find the qube name.

## How to contribute

* Report [issues](https://github.com/ben-grande/qvm-screenshot-tool/issues)
* Submit a feature request
* Make a pull request
* Donate to [Qubes OS](https://www.qubes-os.org/donate/)

## Credits

This tool was originally developed by @evadogstar in 2017 and has since
received many contributions from the community and the Qubes OS Team, being
rewritten in 2024 by @ben-grande.
