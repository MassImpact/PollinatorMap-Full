using System;
using System.IO;
using System.Text;
using System.Data;
using System.Web;
using System.Reflection;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Security.Cryptography;
using System.Web.Security;

namespace Pollinator.Common
{
    public class DataHelper
    {

        /// <summary>
        /// Populates an instance of the entity.
        /// </summary>
        /// <param name="entity">The instance of the entity to populate.</param>
        /// <param name="record">The current Datareader record.</param>
        public static void PopulateEntity<T>(T entity, IDataRecord record)
        {
            if (record != null && record.FieldCount > 0)
            {
                Type type = entity.GetType();

                for (int i = 0; i < record.FieldCount; i++)
                {
                    if (DBNull.Value != record[i])
                    {
                        PropertyInfo property = type.GetProperty(record.GetName(i), BindingFlags.IgnoreCase | BindingFlags.Public | BindingFlags.Instance);
                        if (property != null)
                        {
                            property.SetValue(entity, record[property.Name], null);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Populates a List of entities of type T.
        /// </summary>
        /// <param name="dr">The DataReader with data of entities.</param>
        /// <returns></returns>
        public static List<T> PopulateEntities<T>(IDataReader dr)
        {
            List<T> entities = new List<T>();
            while (dr.Read())
            {
                T ent = Activator.CreateInstance<T>();
                PopulateEntity<T>(ent, dr);
                entities.Add(ent);
            }
            return entities;
        }

        /// <summary>
        /// Sanitize data to prevent SQL Injection
        /// </summary>
        public static string Sanitize(string stringValue)
        {
            if (stringValue == null)
                return stringValue;

            //Reference: http://www.mvvm.ro/2011/03/sanitize-strings-against-sql-injection.html
            string newStringValue = Regex.Replace(stringValue, "-{2,}", "-");  // transforms multiple --- in - use to comment in sql scripts
            newStringValue = Regex.Replace(newStringValue, @"[*/]+", string.Empty); // removes / and * used also to comment in sql scripts
            newStringValue = Regex.Replace(newStringValue, @"(;|\s)(exec|execute|select|insert|update|delete|create|alter|drop|rename|truncate|backup|restore)\s", string.Empty, RegexOptions.IgnoreCase);

            return newStringValue;
        }

        static byte[] bytes = ASCIIEncoding.ASCII.GetBytes("ZeroCool");

        public static string Encode(string originalString)
        {
            if (String.IsNullOrEmpty(originalString))
            {
                throw new ArgumentNullException("The string which needs to be encrypted can not be null.");
            }

            var cryptoProvider = new DESCryptoServiceProvider();
            var memoryStream = new MemoryStream();
            var cryptoStream = new CryptoStream(memoryStream, cryptoProvider.CreateEncryptor(bytes, bytes),
                CryptoStreamMode.Write);
            var writer = new StreamWriter(cryptoStream);
            writer.Write(originalString);
            writer.Flush();
            cryptoStream.FlushFinalBlock();
            writer.Flush();

            var encryptedText = Convert.ToBase64String(memoryStream.GetBuffer(), 0, (int)memoryStream.Length);

            return HttpUtility.UrlEncode(encryptedText);
        }

        public static string Decode(string encryptedString)
        {
            if (String.IsNullOrEmpty(encryptedString))
            {
                throw new ArgumentNullException("The string which needs to be decrypted can not be null.");
            }

            try
            {
                //encryptedString = HttpUtility.UrlDecode(encryptedString); //Unescaping strings

                var cryptoProvider = new DESCryptoServiceProvider();
                var memoryStream = new MemoryStream(Convert.FromBase64String(encryptedString));
                var cryptoStream = new CryptoStream(memoryStream, cryptoProvider.CreateDecryptor(bytes, bytes),
                    CryptoStreamMode.Read);
                var reader = new StreamReader(cryptoStream);
                return reader.ReadToEnd();
            }
            catch (Exception)
            {
                return "";
            }
        }


        /// <summary>
        /// Encrypt data to a string of only ASCII characters abc...ABC...0123...9. 
        /// No slash, hypen, comma... includes in the string. It's being used for encryting URI, query parameters...
        /// </summary>
        public static string Encrypt(string content)
        {
            return EncryptWithExpire(content, DateTime.Now.AddMinutes(30)); //Expired after 30 minutes
        }

        public static string EncryptWithExpire(string content, DateTime expiration)
        {
            //Note: This function is best used for encoding URL than CryptoStream because it doesn't contain the strange characters like / + - # ; etc.
            //Especially, you can't copy the links to somewhere else after it is expired.
            return FormsAuthentication.Encrypt(new FormsAuthenticationTicket(1,
                HttpContext.Current.Request.UserHostAddress, // or something fixed if you don't want to stick with the user's IP Address
                DateTime.Now, expiration, false, content));
        }

        public static string Decrypt(string encryptedContent)
        {
            FormsAuthenticationTicket ticket = FormsAuthentication.Decrypt(encryptedContent);
            if (!ticket.Expired)
                return ticket.UserData;

            return null; // or throw...
        }
    }
}
