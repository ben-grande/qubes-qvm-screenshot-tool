# qvm-screenshot-tool

_**qvm-screenshot**_ is a screenshot tool for [Qubes OS](https://qubes-os.org/).

Take screenshot in Qubes GuiVM, optional to copy/move to qube and open file
manager in the target.

## Features

* Modes: `fullscreen`, `window` or `region`
* Screenshot programs: `scrot`, `maim`, `xfce4-screenshooter`, spectacle
* Dialog programs: `zenity`, `kdialog`
* Destiny: open file manager in qube
* Targets: type the qube name to find it when using `kdialog`

## OS support

Qubes OS GuiVM.

DomUs which have Qrexec support:

* Linux: fully supported
* BSD: some OSes may require to change the command `xdg-open`
* Windows: when Qubes Windows Tools is installed

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

You can set different key combinations to different modes, such as setting:

* Fullscreen: `PrintScreen: qvm-screenshot --fullscreen`
* Window: `Alt+PrintScreen: qvm-screenshot --window`
* Region: `Shift+PrintScreen: qvm-screenshot --region`

## Usage

Initiate the program, it will prompt for screenshot actions. You can choose
the screenshot type between `Fullscreen`, `Window` or `Region`.

After the screenshot is made, you will be prompted for the screenshot destiny,
you can select multiple options. If you click `Exit`, the screenshot will
remain solely in `Dom0`. If you select `Move`, the image will be moved to the
qube and will be removed from `Dom0`. When selecting `Open file manager in
qube`, the default MIME handler for directories will be called and the file
manager will be opened in the target after the screenshot if available in the
qube.

At last, select the qube you desire to upload the screenshot to. When using
`kdialog`, you can type strings to find the qube name while with `zenity`, you
can scroll the list.

### Caveats

Depending on the screenshot tool you use, it has different behaviors.

* `maim` and `scrot`: They do not have a separate option for region or window,
  therefore, selecting either of them will have the same effect, which is,
  capture a window by clicking on it, capture a region by dragging the mouse.
* `xfce4-screenshooter`: Window option can only capture the active window.
* `spectacle`: After screenshot is captured and edited, click on 'Save' and
  then close the window to continue the operation.

## How to contribute

* Report [issues](https://github.com/ben-grande/qvm-screenshot-tool/issues)
* Submit a feature request
* Make a pull request
* Donate to [Qubes OS](https://www.qubes-os.org/donate/)

## Credits

This tool was originally developed by @evadogstar in 2017 and has since
received many contributions from the community and the Qubes OS Team, being
rewritten in 2024 by @ben-grande.
