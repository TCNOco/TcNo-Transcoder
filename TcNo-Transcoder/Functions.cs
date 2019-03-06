using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TcNo_Transcoder
{
    class Functions
    {
        public static void Information(string SIn)
        {
            int BeforeLeft = Console.CursorLeft;
            int BeforeTop = Console.CursorTop;
            switch (SIn)
            {
                case "Audio":
                    string[] lines = GlobalStrings.InfoAudio.Split('#');
                    Console.WriteLine(lines[0]);
                    RunProgram(Global.NvexeFull, "--check-encoders");

                    Console.WriteLine(lines[1]);
                    RunProgram(Global.NvexeFull, "--check-decoders");

                    Console.WriteLine(lines[2]);
                    break;
                case "Devices":
                    Console.WriteLine(GlobalStrings.InfoDevices, Global.Nvexe);
                    RunProgram(Global.NvexeFull, "--check-device");
                    break;
                case "Help":
                    Console.WriteLine(GlobalStrings.InfoHelp, Constants.Version, Constants.NvencCVersion, Constants.MinNvidiaDriver, Global.ExeLocation);
                    break;
                case "Video":
                    Console.WriteLine(GlobalStrings.InfoVideo, Global.Nvexe);
                    break;
            }
            Console.WriteLine();
            Console.WriteLine(GlobalStrings.PrgAnyKeyToClose);
            // Get cursor position to set it back later. Stops weird text overwriting in console.
            int AfterLeft = Console.CursorLeft;
            int AfterTop = Console.CursorTop;
            // Bring cursor to top (to scroll user up) and hide.
            Console.CursorVisible = false;
            Console.SetCursorPosition(BeforeLeft, BeforeTop);

            Console.ReadKey();
            // Brings cursor back down to end of output above, and shows.
            Console.SetCursorPosition(AfterLeft, AfterTop);
            Console.CursorVisible = true;
            System.Environment.Exit(1);
        }

        public static void RunProgram(string SProgram, string SArguments)
        {
            var info = new ProcessStartInfo(SProgram, SArguments)
            {
                UseShellExecute = false
            };
            var proc = Process.Start(info);
            proc.WaitForExit();
        }

        // Settings functions
        // -----------------------------------
        #region Settings Functions
        public static void LoadSettingsFile()
        {
            try
            {
                string SettingsFileLocation = String.Format(@"{0}\settings.cfg", Global.ExeLocation);
                string[] lines = System.IO.File.ReadAllLines(SettingsFileLocation);
                foreach (var line in lines)
                {
                    if (line.Contains('='))
                    {
                        GetSetting(line);
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(GlobalStrings.ErrFailedSettingsRead, e.Message);
            }
        }

        public static void GetSetting(string input)
        {
            string SSetting = input.Split('=')[0];
            string SValue = input.Split('=')[1];
            Global.Settings.Add(SSetting, SValue);
        }

        public static void VerifySettingsFile()
        {
            string[] SettingsList = new string[] { "OutputFormat", "CopyAudio", "AudioCodec", "Suffix", "OutputDirectory", "Resolution", "FPS", "VideoCodec", "EncoderProfile", "Level", "Preset", "OutputDepth", "CUDASchedule", "DecodeMode", "SampleAspectRatio", "Lookahead", "GOPLength", "BFrames", "ReferenceFrames", "MVPrecision", "Colormatrix", "CABAC", "Deblock", "Bitrate", "VBRQuality", "MaxBitrate", "GPU", "OtherArgs", "Override", "DeleteOldQueue", "AfterCompletion" };
            foreach (var s in SettingsList)
            {
                try
                {
                    string temp = Global.Settings[s];
                }
                catch (Exception)
                {
                    Console.WriteLine(GlobalStrings.ErrSettingNotFound, s);
                    Console.WriteLine();
                    AnyKeyToClose();
                }
            }
        }
        #endregion  
        // -----------------------------------

        public static void AnyKeyToClose()
        {
            Console.WriteLine(GlobalStrings.PrgAnyKeyToClose);
            Console.ReadKey();
            System.Environment.Exit(1);
        }
        
        public static void CheckOSBit()
        {
            if (Environment.Is64BitOperatingSystem)
            {
                Global.Bit = 64;
                Global.Nvexe = "NVEncC64.exe";
            }
            else
            {
                Global.Bit = 32;
                Global.Nvexe = "NVEncC.exe";
            }
            Global.NvexeFull = String.Format(@"{0}\x{1}\{2}", Global.ExeLocation, Global.Bit.ToString(), Global.Nvexe);
        }

        public static void ProcessFile(string inputFile)
        {
            string Arg = "-i \"" + inputFile + "\"";
            Arg += " --" + Global.Settings["DecodeMode"];
            Arg += " --codec " + Global.Settings["VideoCodec"];
            Arg += " --fps " + Global.Settings["FPS"];
            Arg += " --output-res " + Global.Settings["Resolution"];
            Arg += " --profile " + Global.Settings["EncoderProfile"];
            Arg += " --level " + Global.Settings["Level"];
            Arg += " -- " + Global.Settings["Bitrate"];
            Arg += " --preset " + Global.Settings["Preset"];
            Arg += " --lookahead " + Global.Settings["Lookahead"];
            Arg += " --cuda-schedule " + Global.Settings["CUDASchedule"];
            Arg += " --gop-len " + Global.Settings["GOPLength"];
            Arg += " --bframes " + Global.Settings["BFrames"];
            Arg += " --ref " + Global.Settings["ReferenceFrames"];
            Arg += " --mv-precision " + Global.Settings["MVPrecision"];
            Arg += " --colormatrix " + Global.Settings["Colormatrix"];
            Arg += " --output " + Global.Settings["Colormatrix"];
            Console.WriteLine(Arg);
        }
    }
}
