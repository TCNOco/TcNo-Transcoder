﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
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
        public const string Version = "0.1.1";
        // NvencC 4.31 info:
        // - Released: 12/02/2019
        // - GitHub: https://github.com/rigaya/NVEnc/releases
        public const string NvencCVersion = "4.31";
        public const string MinNvidiaDriver = "418.81";
    }
    class Program
    {
        static void Main(string[] args)
        {

            Console.Title = "TechNobo's Transcoder";
            Global.ExeLocation = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            Functions.LoadSettingsFile();
            Functions.VerifySettingsFile();

            Functions.CheckOSBit();



            //TEST
            Functions.ProcessFile("f");
            Console.Read();

            //


            if (args.Length != 0)
            {
                switch (args[0])
                {
                    case "-h":
                    case "--help":
                        Functions.Information("Help");
                        break;
                    case "-i":
                    case "--info":
                        Console.WriteLine("INFO");
                        break;
                    case "-d":
                    case "--devices":
                        Functions.Information("Devices");
                        break;
                    case "-a":
                    case "--audio":
                        Functions.Information("Audio");
                        break;
                    case "-v":
                    case "--video":
                        Functions.Information("Video");
                        Functions.AnyKeyToClose();
                        break;
                    case "-q":
                    case "--queue":
                        Console.WriteLine("TO DO");
                        break;

                }

                // If there were files dragged onto the program
                Console.WriteLine(GlobalStrings.PrgDragDropNotice);
                foreach (var i in args)
                {
                    Console.WriteLine(i);
                }
                Console.WriteLine();
                


                if (System.IO.File.Exists("skipcheck"))
                {
                    Console.WriteLine("Check skipped");
                }
                else
                {
                    while (true)
                    {
                        Console.Write(GlobalStrings.PrgContinue + " (Y/N): ");
                        string response = Console.ReadLine();
                        if (response.ToLower() == "y")
                        {
                            Console.WriteLine("Yes");
                            break;
                        }
                        else if (response.ToLower() == "n")
                        {
                            Console.WriteLine(GlobalStrings.PrgProcessingCancelled);
                            Functions.AnyKeyToClose();
                        }
                    }
                }
            } else
            {
                Console.WriteLine("Launched without arguments");
            }
            Console.Read();
        }

        public static void Help()
        {

        }
    }
}
