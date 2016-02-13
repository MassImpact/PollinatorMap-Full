using System;
using System.Web;
using System.Web.Configuration;
using log4net;
using log4net.Appender;
using log4net.Config;
using log4net.Repository.Hierarchy;

namespace Pollinator.Common
{
    public class Logger
    {
        #region Constants

        private const string LOGGER_NAME = "Pollinator_Logger";
        private const string CONNECTION_NAME = "DefaultConnection";
        private const string APPENDER_NAME = "AdoNetAppender";
        private const string EMAIL_LISTCC = "";

        #endregion

        #region Member Variables

        private static readonly ILog _log = LogManager.GetLogger(LOGGER_NAME);
        private static string _emailList = "error.repository@gmail.com";

        #endregion

        #region Constructors

        /// <summary>
        /// Initializes a new instance of the <see cref="T:Logger"/> class.
        /// </summary>
        private Logger(){}

        /// <summary>
        /// Initializes the <see cref="T:Logger"/> class.
        /// </summary>
        static Logger()
        {
            var configManager = WebConfigurationManager.ConnectionStrings;
            string connectionString = "";

            if (configManager[CONNECTION_NAME] != null)
            {
                connectionString = configManager[CONNECTION_NAME].ConnectionString;
            }else{
                if (configManager.Count > 0) //Try to retrieve the first ConnectionString if available in web.config
                    connectionString = configManager[0].ConnectionString;
            }

            XmlConfigurator.Configure();
            var hierarchy = LogManager.GetRepository() as Hierarchy;
            if (hierarchy != null)
            {
                var adoNetAppender = (AdoNetAppender)hierarchy.GetLogger(LOGGER_NAME, hierarchy.LoggerFactory).GetAppender(APPENDER_NAME);
                if (adoNetAppender != null)
                {
                    adoNetAppender.ConnectionString = connectionString;
                    adoNetAppender.ActivateOptions();
                }
            }

            var logAdministrators = WebConfigurationManager.AppSettings["LogAdministrators"];
            if (logAdministrators != null)
                _emailList = logAdministrators;
        }

        #endregion

        #region Methods

        #region Public

        //Modified by Henry 2012/04/06: Avoid bubbling exception if it was already caught somewhere else.
        public static void Error(string friendlyMsg, Exception ex)
        {
            if (ex == null)
            {
                Error(friendlyMsg);
                return;
            }

            if (ex.HelpLink != null) return; //Already logged. It won't log again.

            SendUserInfoToLog();

            if (_log.IsErrorEnabled)
            {
                _log.Error(friendlyMsg, ex); //Write to DB

                string errorInfo = friendlyMsg.ToString();
                if (ex.Message != "")
                    errorInfo += string.Format("<br /><br /><strong>EXCEPTION:</strong> {0}", ex.Message);

                if (ex.InnerException != null && ex.InnerException.Message != "")
                    errorInfo += string.Format("<br /><br /><strong>INNER EXCEPTION:</strong> {0}", ex.InnerException.Message);

                if (ex.StackTrace != "")
                    errorInfo += string.Format("<br /><br /><strong>StackTrace:</strong> {0}", ex.StackTrace);

                Utility.SendExceptionViaEmail(_emailList, EMAIL_LISTCC, "Error Notification", errorInfo, string.Empty);
            }

            ex.HelpLink = "Already logged. Do not log again. Just throw the original exception to parent methods.";
        }

        public static void Error(string message)
        {
            SendUserInfoToLog();

            if (_log.IsErrorEnabled)
            {
                _log.Error(message); //Write to DB 
                Utility.SendExceptionViaEmail(_emailList, string.Empty, "Error Notification", message, string.Empty);
            }
        }

        //Modified by Henry 2012/04/06: Avoid bubbling exception if it was already caught somewhere else.
        public static void Information(string friendlyMsg, Exception ex)
        {
            if (ex == null)
            {
                Error(friendlyMsg);
                return;
            }

            if (ex.HelpLink != null) return;

            SendUserInfoToLog();

            if (_log.IsInfoEnabled)
            {
                _log.Info(friendlyMsg, ex); //Write to DB

                string errorInfo = friendlyMsg.ToString();
                if (ex.Message != "")
                    errorInfo += string.Format("<br /><br /><strong>EXCEPTION:</strong> {0}", ex.Message);

                if (ex.InnerException != null && ex.InnerException.Message != "")
                    errorInfo += string.Format("<br /><br /><strong>INNER EXCEPTION:</strong> {0}", ex.InnerException.Message);

                if (ex.StackTrace != "")
                    errorInfo += string.Format("<br /><br /><strong>StackTrace:</strong> {0}", ex.StackTrace);

                Utility.SendExceptionViaEmail(_emailList, string.Empty, "Error", errorInfo, string.Empty);
            }

            //Use this property (just like Tag) to represent a status flag
            ex.HelpLink = "Already logged. Do not log again. Just throw the original exception to parent methods.";
        }

        public static void Information(string message)
        {
            SendUserInfoToLog();

            if (_log.IsInfoEnabled)
            {
                _log.Info(message); //Write to DB
                Utility.SendExceptionViaEmail(_emailList, string.Empty, "Error", message, string.Empty);
            }
        }

        #endregion

        #region Private
        private static void SendUserInfoToLog()
        {
            //set user to log4net context, so we can use %X{user} in the appenders
            if (HttpContext.Current.User != null && HttpContext.Current.User.Identity.IsAuthenticated)
                MDC.Set("user", HttpContext.Current.User.Identity.Name);
            else
            {
                var windowsIdentity = System.Security.Principal.WindowsIdentity.GetCurrent();
                if (windowsIdentity != null && windowsIdentity.IsAuthenticated == true)
                    MDC.Set("user", windowsIdentity.Name); 
                else
                    MDC.Set("user", "Anonymous");
            }
        }
        #endregion
        #endregion

    }
}
