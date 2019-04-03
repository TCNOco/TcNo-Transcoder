

<p align="center">
    <a href="">
	<img src="/docs/img/banner1.png"></a>
</p>
<p align="center">
    <a href="https://tcno.co/">
        <img alt="Website" src="/docs/img/web.svg" height=20"></a>
    <a href="https://discord.gg/wkJp38m">
        <img alt="Discord server" src="https://img.shields.io/discord/217649733915770880.svg?label=Discord&logo=discord&style=flat-square"></a>
    <a href="https://twitter.com/TcNobo">
        <img alt="Twitter" src="https://img.shields.io/twitter/follow/TcNobo.svg?label=Follow%20%40TcNobo&logo=Twitter&style=flat-square"></a>
    <img alt="Last commit" src="https://img.shields.io/github/last-commit/TcNobo/TcNo-Transcoder.svg?label=Last%20commit&logo=GitHub&style=flat-square">
    <img alt="Repo size" src="https://img.shields.io/github/repo-size/TcNobo/TcNo-Transcoder.svg?label=Repo%20size&logo=GitHub&style=flat-square">
</p>

This is a simple Windows based video transcoder, that **copies ALL audio tracks**. It's **simple**, and **extremely fast**, utilizing Nvidia's NVENC.

If you find yourself needing compressed 'proxy' video files for editing software, like Adobe Premiere Pro, and it can't create them itsself due to no multitrack audio support, then this is by far the simplest solution.

It's simple to use, fast and efficient.


## How to use

 1. Download the respective release from [Releases](https://github.com/TcNobo/TcNo-Transcoder/releases) and extract it.
 2. Edit `settings.cfg` to your liking. (Consider it a template for transcoding)
 3. Either:
	 - Start `TcNo-Transcoder.exe` and Drag and Drop a video file or folder in.
	- Drag and Drop one or more video files or folders onto `TcNo-Transcoder.exe`
	- Queue up multiple files for later transcoding:
		- See [Queueing](https://github.com/TcNobo/TcNo-Transcoder/wiki/Queueing) 
 5. Follow the steps, and you'll process your videos in no time.

By default; no transcoding to audio is done, it is copied. You can add such via setting `otherargs` in `settings.cfg`.
Most people won't need to change this.

### Check the Wiki for more information: [TcNo Transcoder Wiki](https://github.com/TcNobo/TcNo-Transcoder/wiki)

## Requirements
- Windows 7, 8, 8.1, 10 (x86 / x64)
- **NVENC supported hardware** *(NVIDIA GeForce Kepler gen or later (GT / GTX 6xx or later))*
- NVIDIA graphics driver **418.81 or later**
> **Note:** You can downgrade NVEncC by downloading older releases from [rigaya/NVEnc
](https://github.com/rigaya/NVEnc/releases) Min NVIDIA graphics driver version: **334.89**


### Planned:
FFMPEG support is planned, on top of NVEncC, and possibly more in the future.
If you have anything to add, then don't be afraid :)

For more info regarding NVEncC, such as supported codecs: https://github.com/rigaya/NVEnc