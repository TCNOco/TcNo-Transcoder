using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TcNo_Transcoder
{
    class Program
    {
        static class Global
        {
            // Global variable definitions
            // Global static strings that won't change, and can be localised will be located in GlobalStr.resx, and their different language counterparts.
            public static int bit;          // Operating system bit
            public static string nvexe;     // NVEncC version, operating system bit specific
        }
        static void Main(string[] args)
        {

            Console.Title = "TechNobo's Transcoder";


            if (Environment.Is64BitProcess)
            {
                Global.bit = 64;
                Global.nvexe = "NVEncC64.exe";
            } else
            {
                Global.bit = 32;
                Global.nvexe = "NVEncC.exe";
            }
            Console.WriteLine(GlobalStr.HelpInfo, Global.nvexe);

            foreach (string s in args)
                switch (s)
                {
                    case "-h":
                    case "--help":
                        Help();
                        break;
                    case "-i":
                    case "--info":
                        Console.WriteLine("INFO");
                        break;
                    case "-d":
                    case "--devices":
                        Console.WriteLine("DEVICES");
                        break;
                    case "-a":
                    case "--audio":
                        Console.WriteLine("AUDIO");
                        break;
                    case "-v":
                    case "--video":
                        Console.WriteLine("VIDEO");
                        break;
                    case "-q":
                    case "--queue":
                        Console.WriteLine("QUEUE");
                        break;

                }
            Console.Read();
        }

        public static void Help()
        {

        }
    }
}
