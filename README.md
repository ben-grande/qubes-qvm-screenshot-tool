# qvm-screenshot-tool

The _**qvm-screenshot**_ is a screenshot tool for [Qubes OS](https://qubes-os.org/)<br>
This tool provide functionality to make screenshots at Qubes dom0 and upload it automatically to AppVM, to Imgurl service thought this AppVm and some other tasks.
This tool must be places and used only at **dom0** <br>
No need to upload something to TemplateVM.

Need example? All screenshots on this tutorial done by this tool :)

### Known bugs
0.1 beta support multi upload (you can start multiple copies if the tool at ones). This version also support then, but "editor" mode will only work on single mode. Do not launch two editors at the time before it will not be fixed.

# How to use it

You will be asked for actions by GUI prompt.`qvm-screenshot` support `ksnapshot` (KDE5 tool) and `scrot` console tool to make screenshots which is not available by default at dom0, but it can by simple installed to it with one command `sudo qubes-dom0-update scrot`<br>
![screenshot png](https://i.imgur.com/h3h1dMW.png)

Qubes Team plan to remove `KDE5` from Qubes by default, therefore `ksnapshot` will be also removed. Accordingly, I highly recommend to use it with `scrot`.

### How to use the tool with Ksnapshot

0. You can start `ksnapshot` first and make your screenshot with it, then start `qvm-screenshot` or you can start `qvm-screenshot` and select `ksnapshot` option at dialog window.
0. After `qvm-screenshot` started. It will pop-up confirmation dialog. Do not close it, if you are NOT ready to do something with your screenshot at `ksnapshot`! Make screenshot first.
0. If you are happy with result at `ksnapshot` preview window. Then click `yes` on `qvm-screenshot` dialog.
0. New dialog will appear and then you can choose options to upload screenshot etc. (read more below)

![screenshot png](https://i.imgur.com/kGMGAOr.png)

### How to use it with scrot

All other options on first dialog use `scrot` tool to make screenshots.

0. Start tool with `./qvm-screenshot` or hotkey which you already setup (see install section)
0. Choose e.g. `region or window`
0. Simple click on window to make screenshot of that window. Drag mouse with left button down to select region of the screen.
0. Then select actions what you want to do with screenshot. e.g. upload it to Imgurl server, only it to AppVM or dom0
0. You will be prompted. Select destination AppVM. Later on, this VM utility will upload screenshot to Imgurl server.
0. Then amazing dialog appear at AppVM window. You will find URLs on it. Simple select them with the mouse and `Ctrl+C`them to put to clipboard.
0. If `nautilus` mode was selected it will be started with `$PATH` opened. If `xcopy` is installed. URL will be copy to clipboard.

![screenshot png](https://i.imgur.com/r7IT8TK.png)

### How to use the editor

You can edit screenshot before upload it to Imgurl or move them to AppVM.

0. Select edit mode (and upload move if need to also upload)
0. You will see image on the screen. Click on it to get menu.
0. Edit the image. If you do something wrong clock "Ctrl-Z" to undo changes.
0. When you are ready to upload. Go to File -> Save and choose predefined position<br> **0000-SAVE-EDITED-SHOT-HERE-TO-PROCESS.png**<br>to save it to (or we will continue with not edited screenshot)
0. Just Quit from the editor and tool will continue to move screenshot to AppVM or uploading.

![screenshot png](https://i.imgur.com/qPPmF7X.png)


Descriptions of the settings
----
![screenshot png](https://i.imgur.com/Kro9bhO.png)

`Exit` -- screenshot already stored at ~/Pictures on `dom0`. If this option selected tool immediately exit and nothing more<br>
`Upload tp AppVM only` -- tool will upload the image to selected destination AppVM. You can also select to open it with `Nautilus` and `remove image from dom0`<br>
`Upload to Imgurl` - will do this magic for you, if options above not selected.<br>
`Start Nautilus at AppVM` -- will start `nautilus` with opened directory where the image stored<br>
`Keep screenshot at dom0` -- will keep the image at dom0. By default its removed (expect `Exit` goal)<br>

Features
----
* Make screenshots with ksnapshot or scrot
* Upload screenshots to AppVM
* Auto-Start VM if it's not running
* Upload screenshots to Imgurl server and provide URLs
* Copy link to AppVM clipboard
* Last upload log with Imgurl link and **deletion link** is stored at AppVM: ~/Pictures/imgurl.log
* Automatic image deletion from dom0 (you can switch it off on dialog)
* URLs notifications are where from you can copy URLs to clipboard
* NEW! Support command line arguments to skip dialog and quickly to the same job.

Installation
----

## WARNING! ALWAYS REVIEW ANY CODE THAT YOU UPLOAD TO DOM0 BEFORE DO THAT!
First, you **must** review the code, before upload it to dom0 ! Always do that if you are uploading code to dom0 from some
other source and other way then Qubes Team recommend it !!!

Discussion thread on the qubes mailing list about the code:<br>
https://groups.google.com/forum/#!topic/qubes-users/dcsRRPf0Fxk


### Manual install

Just save `qvm-screenshot` as a file to any AppVM. Then copy it to `dom0` with the following command at dom0 terminal:

```shell
qvm-run --pass-io NAMEOFAPPVM 'cat /path/to/qvm-screenshot' > /home/user/Pictures/qvm-screenshot
```
Then give it execute privileges at dom0 terminal:

```shell
chmod +x /home/user/Pictures/qvm-screenshot
```

Of course, you can start it for testing purposes from command line:

```shell
./qvm-screenshot
```

It's possible to skip first dialog and make choice from command like with `--region-only` or `--fullscreen` :

```shell
./qvm-screenshot --region-only
./qvm-screenshot --fullscreen
```

Now, you are ready to setup it on some hotkey combination. Go to `System -> Keyboard settings` and bind the script to your favorite shortcut `PrintScreen` key or to e.g. `Ctrl+PrintScreen` combination.



Dependencies
----

Most are probably pre-installed at `Qubes OS` by default.<br>
Tested at 3.2rc1

* **Linux only AppVMs supported**
* curl at Linux AppVM
* zenity at dom0 and at AppVM.
* scrot at dom0 <i>(recommended) or ksnapshot</i>
* ImageMagick (already at dom0 pre-installed)
* xclip at AppVM <i>(only need if you want also copy URL to clipboard automatically to AppVM)</i>

OS support
----
Qubes OS only. :-)

This will not fully work on Windows AppVMs. Only if Qubes Team will add something like cygwin. But are you really want Windows support for uploading images to Imgurl service? <br>

**Also its is almost ready for GNOME !!!**

How to contribute
----

* Report [issues](https://github.com/ben-grande/qvm-screenshot-tool/issues)
* Submit feature request
* Make a pull request
* If you like this tool, you can donate Qubes OS developers https://www.qubes-os.org/donate/#bitcoin and maybe send me notification at `qubes-users` mailing list that you are happy with this tool and you do that, because of it :)

#### Plans

* Show last uploaded URLs (log) if the window was closed.
