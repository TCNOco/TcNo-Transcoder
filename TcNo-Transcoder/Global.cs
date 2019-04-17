using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TcNo_Transcoder
{
    class Global
    {
        public static string LineString = "---------------------";
        public static string QueueFile = "extra/queue.txt";
        public static string AttemptFile = "extra/attempt";
        public static string SettingsFileLocation = "";

        // Global variable definitions
        // Global static strings that won't change, and can be localised will be located in GlobalStr.resx, and their different language counterparts.
        public static int Bit;                  // Operating system bit
        public static string Nvexe;             // NVEncC executable, operating system bit specific
        public static string NvexeFull;         // Full locatino of NVEncC executable.
        public static string ExeLocation;       // Folder in which the program's .exe is
        public static DateTime EncodeStartTime;
        public static DateTime QueueStartTime;
        public static string LastFileEncoded;
        public static bool CustomFolder = false;
        public static bool QueueValid;          // If queue.txt contains text, or it's just empty
        public static string QueueText;         // For storing queue.txt lines
        public static float GPUDriver;

        public static string InputFile;
        public static string OutputFile;



        // User settings
        public static Dictionary<string, string> Settings =
            new Dictionary<string, string>();
    }
}
