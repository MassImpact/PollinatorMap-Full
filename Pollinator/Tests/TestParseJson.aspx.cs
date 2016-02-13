using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Newtonsoft.Json.Linq;

public partial class Tests_TestParseJson : System.Web.UI.Page
{

    public class ImportFields
    {
        public string LineNumber;
        public string State;
        public string CityName;
        public string CityKey;
        public string ZipCode;
        public string Type;
        public string PrimatyCity;
        public string County;
        public string TimeZone;
    }


    protected void Page_Load(object sender, EventArgs e)
    {        
        //  dynamic stuff = JObject.Parse("{ 'Name': 'Jon Smith', 'Address': { 'City': 'New York', 'State': 'NY' }, 'Age': 42 }");
        // string name = stuff.Name;
        // string address = stuff.Address.City;

    }
    protected void btnCity_Click(object sender, EventArgs e)
    {
        string targetDirectory = @"D:\Working\EC\usacity";
        string[] fileEntries = Directory.GetFiles(targetDirectory);
        string stateKey;
        string strJson;
        dynamic objJson;
   
        string sqlLines = "";
        string csvLines = "State,city name,city key";
        string name;
        string stateCode;
        foreach (string fileName in fileEntries)
        {
            if (Path.GetExtension(fileName) != ".json")
                continue;

            stateKey = Path.GetFileNameWithoutExtension(fileName).Replace("-all.geo", "");
            stateCode=stateKey.Replace("us-", "").ToUpper();
            strJson = System.IO.File.ReadAllText(fileName);
            objJson = JObject.Parse(strJson).Last;

            foreach (dynamic feature in objJson.Value)
            {              
                name = feature.properties.name;
                name = name.Replace("'", "''");
                sqlLines += "INSERT INTO `area` (`country_code`, `name`, `geo_code`, `region_type`,level,parent_id) " +
                    "SELECT 'us','" + name + "','" + feature.properties["hc-key"] + "','City',2, id FROM area where geo_code='" + stateKey + "' ;\r\n";
                csvLines += stateCode + "," + name + "," + feature.properties["hc-key"] + "\r\n";
            }
        }

        // Write the string to a file.
        System.IO.StreamWriter fileSql = new System.IO.StreamWriter(@"D:\Working\EC\usacity\city.sql");
        fileSql.WriteLine(sqlLines);
        fileSql.Close();
        System.IO.StreamWriter fileCSV = new System.IO.StreamWriter(@"D:\Working\EC\usacity\cityCSV.csv");
        fileCSV.WriteLine(csvLines);
        fileCSV.Close();
    }

    protected void btnZipCode_Click(object sender, EventArgs e)
    {
        string[] stringSeparators = new string[] { "\r\n" };

        //Read highchart city
        string content1 = File.ReadAllText(@"D:\Working\EC\usacity\cityCSV.csv");     
        // Parse content    
        string[] lines1 = content1.Split(stringSeparators, StringSplitOptions.RemoveEmptyEntries);

        ImportFields data;

        List<ImportFields> listData1 = new List<ImportFields>();
        int numRecord1 = lines1.Length;

        for (int i = 1; i < numRecord1; i++)
        {            
            string[] values = ImportExportUltility.GetCsvRecord(lines1[i]);
            data = new ImportFields();
            data.State = values[0].Trim();
            data.CityName = values[1].Trim();
            data.CityKey = values[2].Trim();
            listData1.Add(data);
        }

        //Read zicode file
        string content2 = File.ReadAllText(@"D:\Working\EC\usacity\zip_code_database.csv");    
        string[] lines2 = content2.Split(stringSeparators, StringSplitOptions.RemoveEmptyEntries);

        List<ImportFields> listData2 = new List<ImportFields>();
        int numRecord2 = lines2.Length;
       
        string sqlLines = "";
        string csvLines = "hc-key,zip,type,primary_city,acceptable_cities,unacceptable_cities,state,county,timezone,area_codes,latitude,longitude,world_region,country,decommissioned,estimated_population,notes";
        for (int i = 1; i < numRecord2; i++)
        {
            string[] values = ImportExportUltility.GetCsvRecord(lines2[i]);
            data = new ImportFields();
            data.ZipCode = values[0].Trim();
            data.Type= values[1].Trim();
            data.PrimatyCity= values[2].Trim();
            data.State = values[5].Trim();
            data.County = values[6].Trim();
            data.TimeZone = values[7].Trim();
            //Tim hc-key
            var hightchartdata = (from pi in listData1
                                  where pi.CityName == data.PrimatyCity
                                  select pi).FirstOrDefault();
            if (hightchartdata != null)
                data.CityKey = hightchartdata.CityKey;
            else
            {
                hightchartdata = (from pi in listData1
                                  where data.County.Contains(pi.CityName)
                                  select pi).FirstOrDefault();
                if (hightchartdata != null)
                    data.CityKey = hightchartdata.CityKey;
                else
                {
                    hightchartdata = (from pi in listData1
                                      where data.TimeZone.Contains(pi.CityName)
                                      select pi).FirstOrDefault();
                    if (hightchartdata != null)
                        data.CityKey = hightchartdata.CityKey;
                }
            }
            if (!String.IsNullOrEmpty(data.CityKey))
            {
                sqlLines += "INSERT INTO `zip_code`  (`zip_code`, `area_id`) " +
                      "SELECT '" + data.ZipCode + "', id FROM area where geo_code='" + data.CityKey + "' ;\r\n";
            }
            csvLines += data.CityKey + "," + values[0] + "," + values[1] + "," + values[2] + "," + values[3] + "," + values[4] + "," + values[5] + "," + values[6] + "," + values[7] + "," + values[8] + "," + values[9] + "," + values[10] + "," + values[11] + "," + values[12] + "," + values[13] + "," + values[14] + "\r\n";

            listData2.Add(data);           
        }



        // Write the string to a file.
        System.IO.StreamWriter fileSql = new System.IO.StreamWriter(@"D:\Working\EC\usacity\zipcode.sql");
        fileSql.WriteLine(sqlLines);
        fileSql.Close();
        System.IO.StreamWriter fileCSV = new System.IO.StreamWriter(@"D:\Working\EC\usacity\megerzipcodeCSV.csv");
        fileCSV.WriteLine(csvLines);
        fileCSV.Close();



    }
}