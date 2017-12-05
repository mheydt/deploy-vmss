using Monitor.Core.Utilities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using TestWebApp.Util;

namespace TestWebApp
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            //JunctionPoint.Create(@"c:\server\workspace\client\files", "z:\\", true);
            /*
            try
            {
                var un = ConfigurationManager.AppSettings["share_username"];
                var key = ConfigurationManager.AppSettings["share_key"];
                var unc = ConfigurationManager.AppSettings["share_unc"];

                Utils.MountShare(unc, "Z:", un, key);
                File.AppendAllLines("c:\\iis.log", new[] { "Mapped the drive" });
            }
            catch (Exception ex)
            {
                File.AppendAllLines("c:\\iis.log", new[] { ex.Message });
            }
            */
            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }
    }
}
