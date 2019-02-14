
<p align="center">
    <img src="/docs/img/banner1.png">
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

 1. Download this repo as a .zip and extract it.
 2. Edit `settings.bat` to your liking.
 3. Either:
	 -	For single file transcoding:
		 - Start `NVEncC.bat` with Command Prompt.
		 - Drag and Drop a video file in.
	- For multiple file transcoding:
		- Drag and Drop one or more video files onto the actual `NVEncC.bat` file.
 5. Follow the steps, and you'll have yourself a transcoded file in no time!

By default; no transcoding to audio is done. You can add such via setting `otherargs` in `settings.bat`

## Requirements
- Windows 7, 8, 8.1, 10 (x86 / x64)
- **NVENC supported hardware** *(NVIDIA GeForce Kepler gen or later (GT / GTX 6xx or later))*
- NVIDIA graphics driver **418.81 or later**
> **Note:** You can downgrade NVEncC by downloading older releases from [rigaya/NVEnc
](https://github.com/rigaya/NVEnc/releases) Min NVIDIA graphics driver version: **334.89**


### Planned:
FFMPEG support is planned, instead of NVEncC, and possibly more in the future.
If you have anything to add, then don't be afraid :)

For more info regarding NVEncC, such as supported codecs: https://github.com/rigaya/NVEnc
