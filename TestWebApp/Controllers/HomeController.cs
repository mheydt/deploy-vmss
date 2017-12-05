using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.File;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;

namespace TestWebApp.Controllers
{
    public class FilesViewModel
    {
        public FileViewModel[] ViaSymlink { get; set; }
        public FileViewModel[] ViaAPI { get; set; }

        public FilesViewModel()
        {
            ViaSymlink = new FileViewModel[] { };
            ViaAPI = new FileViewModel[] { };
        }
    }
    public class FileViewModel
    {
        public string Name { get; set; }
    }

    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            ViewBag.FileMessage = "";
            ViewBag.ExceptionMessage = "";
            ViewBag.Message = "";

            var msg1 = "";
            var msg2 = "";

            var vm = new FilesViewModel();

            try
            {

                var cs = ConfigurationManager.AppSettings["StorageConnectionString"];
                var account = CloudStorageAccount.Parse(cs);
                var fileClient = account.CreateCloudFileClient();
                var share = fileClient.GetShareReference("workspace-file-storage-pri");
                if (share.Exists())
                {
                    var rootDir = share.GetRootDirectoryReference();
                    if (rootDir.Exists())
                    {
                        var contents = rootDir.ListFilesAndDirectories();
                        vm.ViaAPI = contents.Where(i => i.GetType() == typeof(CloudFile)).Select(f => new FileViewModel() { Name = Path.GetFileName(f.Uri.LocalPath) }).ToArray();
                        msg1 = $"Got {vm.ViaAPI.Length} files via API";

                    }
                }
            }
            catch (Exception ex)
            {
                msg1 = ex.Message;
            }

            try
            {
                var files = Directory.GetFiles("c:\\server\\workspace\\client\\files");
                vm.ViaSymlink = files.Select(f => new FileViewModel() { Name = WebUtility.UrlEncode(new FileInfo(f).Name) }).ToArray();
                msg2 = $"Got {vm.ViaSymlink.Length} files via symlink";
            }
            catch (Exception ex)
            {
                msg2 = ex.Message;
            }

            ViewBag.Message1 = msg1;
            ViewBag.Message2 = msg2;

            return View(vm);
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}