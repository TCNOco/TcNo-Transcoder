using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;


/*---------------------------------------------------------
 * TcNo-Transcoder
 * Created by TechNobo (Wesley Pyburn): https://tcno.co/
 * GitHub Repo: https://github.com/TcNobo/TcNo-Transcoder
 *--------------------------------------------------------- */
namespace TcNo_Transcoder
{
    class Constants
    {
        public const string Version = "0.3.3";
        // NvencC 4.45 info:
        // - Released: 19/08/2019
        // - GitHub: https://github.com/rigaya/NVEnc/releases
        public const string NvencCVersion = "4.45";
        public const string MinNvidiaDriver = "418.81";
    }
    class Program
    {
        static void Main(string[] args)
        {

            /////////////////////////////////////--------------------------------
            // TODO:
            // Add update checker, that checks with a file on GitHub. Just notifies user and gives the link to download the update. Can only do when committed to Main, however.
            // -- v Future v --
            // Add FFMPEG compatability (Possibly a second settings file, and/or a whole new settings folder. Shared settings?
            /////////////////////////////////////--------------------------------
            Console.Title = "TechNobo's Transcoder";
            Global.ExeLocation = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            Directory.SetCurrentDirectory(Global.ExeLocation); // Make sure it's running in the right directory. Without this, -q and --queue from Shell command (via Registry) fails, as it's running in the wrong folder.
            Functions.LoadSettingsFile();
            Functions.VerifySettingsFile();

            Functions.CheckOSBit();

            Functions.CheckIfCustomFolder();

            Console.WriteLine(String.Format(GlobalStrings.InfoWelcome, Constants.Version) + "\n");

            Functions.GetNvidiaDriver();
            Functions.GraphicsDriverMet();

            if (args.Length != 0)
            {
                switch (args[0])
                {
                    case "-h":
                    case "--help":
                        Functions.Information("Help", true);
                        Functions.AnyKeyToClose();
                        break;
                    case "-i":
                    case "--info":
                        Functions.Information("Info", true);
                        Functions.AnyKeyToClose();
                        break;
                    case "-d":
                    case "--devices":
                        Functions.Information("Devices", true);
                        Functions.AnyKeyToClose();
                        break;
                    case "-a":
                    case "--audio":
                        Functions.Information("Audio", true);
                        Functions.AnyKeyToClose();
                        break;
                    case "-v":
                    case "--video":
                        Functions.Information("Video", true);
                        Functions.AnyKeyToClose();
                        break;
                    case "-s":
                    case "--shell":
                        Functions.Information("Shell info", true);
                        Console.WriteLine();
                        break;
                    case "-q":
                    case "--queue":
                        if (!Functions.QueueExists())
                        {
                            Console.WriteLine(GlobalStrings.ErrQueueNotFound);
                        } else
                        {
                            Functions.LoadQueue();
                            if (!Global.QueueValid)
                            {
                                Console.WriteLine(GlobalStrings.ErrQueueEmpty);
                            } else
                            {
                                Functions.QueryQueue();
                            }
                        }
                        Functions.AnyKeyToClose();
                        break;
                    case "-n":
                    case "--new":
                        Functions.NewQueue();
                        break;
                }

                // If there were files dragged onto the program
                Console.WriteLine("\n" + GlobalStrings.PrgDragDropNotice);
                // Display each file to be processed
                foreach (var i in args)
                {
                    // If not file or folder, it will skip argument
                    if (Functions.IsFileOrFolder(i))
                    {
                        Functions.ListFileOrFolder(i);
                    }
                }
                Console.WriteLine(Global.LineString + "\n");

                // Process files after confirmation.
                while (true)
                {
                    Console.Write(GlobalStrings.PrgCorrect + " ");
                    string response = Console.ReadLine();
                    if (response.ToLower() == "y")
                    {
                        foreach (var i in args)
                        {
                            Functions.ProcessFileOrFolder(i, Global.Settings["OutputDirectory"]);
                        }
                        break;
                    }
                    else if (response.ToLower() == "n")
                    {
                        Console.WriteLine(GlobalStrings.PrgProcessingCancelled);
                        Functions.AnyKeyToClose();
                    }
                    }
            }
            else
            {
                // Queue file processing option, if file exists.
                if (Functions.QueueExists())
                {
                    Functions.LoadQueue();
                    if (!Global.QueueValid)
                    {
                        Console.WriteLine(GlobalStrings.ErrQueueEmpty);
                    }
                    else
                    {
                        Console.Write(GlobalStrings.PrgQueryQueue);
                        if (Console.ReadKey().Key == ConsoleKey.Y)
                        {
                            Console.WriteLine();
                            Functions.QueryQueue();
                        }
                    }
                }

                while (true)
                {
                    bool CommandInput = true;
                    string usrInput = "";
                    while (CommandInput)
                    {
                        // Program launched without arguments
                        Console.Write("\n" + GlobalStrings.PrgDragDropPrompt + " "); // Asks user to drag in file or folder
                        usrInput = Console.ReadLine().Replace("\"", ""); // Remove surrounding quotations, if applicable.
                        if (!(usrInput == "" || usrInput == String.Empty))
                        {
                            string ContextMenuApp = Global.ExeLocation + "\\extra\\TcNo-Transcode-ContextMenu.exe";
                            ProcessStartInfo ContextInfo = default(ProcessStartInfo);

                            ContextInfo = new ProcessStartInfo(ContextMenuApp)
                            {
                                UseShellExecute = true,
                                Verb = "runas",
                                WindowStyle = ProcessWindowStyle.Normal,
                                FileName = ContextMenuApp,
                                CreateNoWindow = false
                            };

                            switch (usrInput.ToLower())
                            {
                                case "help":
                                    Functions.Information("Help", false);
                                    //Console.WriteLine();
                                    break;
                                case "info":
                                    Functions.Information("Info", false);
                                    Console.WriteLine();
                                    break;
                                case "help shell":
                                    Functions.Information("Shell info", false);
                                    Console.WriteLine();
                                    break;
                                case "shell add":
                                    Console.WriteLine(GlobalStrings.InfoAdminPrompt);
                                    ContextInfo.Arguments = "-add";
                                    Process ContextProcessADD = Process.Start(ContextInfo);
                                    ContextProcessADD.WaitForExit();
                                    Console.WriteLine(GlobalStrings.InfoContextMenuComplete);
                                    break;
                                case "shell remove":
                                    Console.WriteLine(GlobalStrings.InfoAdminPrompt);
                                    ContextInfo.Arguments = "-remove";
                                    Process ContextProcessREM = Process.Start(ContextInfo);
                                    ContextProcessREM.WaitForExit();
                                    Console.WriteLine(GlobalStrings.InfoContextMenuComplete);
                                    break;
                                default:
                                    CommandInput = false;
                                    break;
                            }

                        }

                    }

                    // Check if the input file or folder actually exists before continuing
                    if (File.Exists(usrInput))
                    {
                        // Set output folder to user settings, or original file's dir, if not specified.
                        string outputFolder = Functions.GetOutputDiretory(usrInput);

                        // Prompts the user that if they want to change the directory, they must change it under settings.
                        Console.WriteLine("\n" + String.Format(GlobalStrings.PrgChangeDir, "NVEncC x" + Global.Bit.ToString(), outputFolder));
                        Console.ReadLine();

                        // Tells the user the current transcode settings
                        Console.WriteLine(String.Format(GlobalStrings.PrgVerifyRenderSettings, usrInput, Global.Settings["Resolution"], Global.Settings["FPS"], Global.Settings["VideoCodec"]));

                        // Either lists files (if a folder was supplied), or tells the user what commmand will be run on the file they entered.
                        if (Functions.IsDirectory(usrInput))
                        {
                            Console.WriteLine(GlobalStrings.PrgFollowingFiles + "\n" + Global.LineString);
                            Functions.ListFileOrFolder(usrInput);
                            Console.WriteLine(Global.LineString + "\n" + GlobalStrings.PrgScrollUp);
                        }
                        else
                        {
                            Console.WriteLine("\n" + Global.Nvexe + " " + Functions.GetTaskArgs(usrInput, outputFolder));
                        }

                        Functions.AnyKeyToContinue();

                        Console.WriteLine();
                        Global.EncodeStartTime = DateTime.Now;
                        Functions.ProcessFileOrFolder(usrInput, outputFolder);
                        Console.WriteLine("\n" + GlobalStrings.InfoComplete, Global.EncodeStartTime, DateTime.Now);
                    }
                    else
                    {
                        Console.WriteLine(GlobalStrings.ErrInaccess);
                    }
                }
            }
            
        }
    }
}
