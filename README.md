# Backend Technical Assessment Deliverable
The **Government Grant Disbursement API** is developed as a Web API project in Visual Studio 2019 using C#. It connects to a local SQL Server Express 2019 database that stores data for Households and Family Members.

The API endpoints' functionalities were tested with Fiddler.

*Disclaimer: All data records in the database are entirely fictional and meant to serve for the purpose of understanding and testing the API functions.*
## Prerequisites
 1. [Visual Studio 2019 Community Edition](https://visualstudio.microsoft.com/downloads/)
 2. [SQL Server 2019 Express](https://www.microsoft.com/en-sg/sql-server/sql-server-downloads)
 3. [Telerik Fiddler](https://www.telerik.com/fiddler)
## Open This Repository in Visual Studio 2019
Refer to the Microsoft website on how to [open the Web API project from the GitHub repository](https://docs.microsoft.com/en-us/visualstudio/get-started/tutorial-open-project-from-repo?view=vs-2019&tabs=vs168later).
## Database Tables Design and Mapping to Objects
**Household** and **FamilyMember** tables are created in SQL Server 2019 Express. Links to the SQL scripts are as follows:
 1. [Creation of HouseholdsDb](https://github.com/melvinyap/MelvinYap_GovernmentGrantAPI/blob/master/Scripts/HouseholdsDb.sql)
 2. [Creation of Household table with sample data](https://github.com/melvinyap/MelvinYap_GovernmentGrantAPI/blob/master/Scripts/Household.sql)
 3. [Creation of FamilyMember table with sample data](https://github.com/melvinyap/MelvinYap_GovernmentGrantAPI/blob/master/Scripts/FamilyMember.sql)

The tables' design is illustrated in the diagram below.

![enter image description here](https://github.com/melvinyap/MelvinYap_GovernmentGrantAPI/blob/master/img/table_design.png)

Connection to the *HouseholdsDb* database is set up in Visual Studio via the Server Explorer.

The Web API project leverages on [LINQ to SQL](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/sql/linq/) to perform mapping between the relational schema and objects. When LINQ to SQL classes are created in the Visual Studio project, a *dbml* file is provided that facilitates dragging and dropping of Household and FamilyMember tables from the Server Explorer. In doing so, a *HouseholdsClassesDataContext* class is created.
## List of C# Work Files Used for the Web API Project
|File Path| Description |
|--|--|
Models/HouseholdViewModel.cs|The **Household Model Class** is used in the view to populate Household data as well as collection of Family Member data records. It is used as a Data Transfer Object (DTO) that defines how the Household and FamilyMember data will be sent via the Web API.|
Models/FamilyMemberViewModel.cs|The **Family Member Model Class** is used in the view to populate Family Member data used as a DTO. This is used in a collection as part of the Household Model Class.
|Controllers/HouseholdController.cs| The file contains the **Household Web API Controller Class** that handles different types of incoming HTTP requests for processing Household and Family Member records, and sends the responses back to the caller.|
## Model Classes
Below are the source codes for the model classes.

### Household Model Class
The Household Model Class is created to return both Household and its Family Member records shown below.
```C#
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
 
namespace MelvinYap_GovernmentGrantAPI.Models
{
    public class HouseholdViewModel
    {
        public int HouseholdId { get; set; }
        public string HousingType { get; set; }

        public ICollection<FamilyMemberViewModel> FamilyMembers { get; set; }
    }
}
```
### Family Member Model Class
The Family Member Model Class is created to be used by the Household Model Class to return a collection of Family Member records.
```C#
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MelvinYap_GovernmentGrantAPI.Models
{
    public class FamilyMemberViewModel
    {
        public int MemberId { get; set; }
        public string Name { get; set; }
        public string Gender { get; set; }
        public string MaritalStatus { get; set; }
        public string SpouseName { get; set; }
        public string OccupationType { get; set; }
        public decimal? AnnualIncome { get; set; }
        public DateTime DOB { get; set; }
    }
}
```
## Web API Controller For CRUD Operations
The **Household Web API Controller Class** implements the GET, POST and DELETE methods for CRUD operations using LINQ to SQL. A new Data Context object is instantiated from the *HouseholdsClassesDataContext* class (see code below) to perform the database data manipulation.
```C#
        private HouseholdsClassesDataContext ctxHouseholds;

        public HouseholdController()
        {
            ctxHouseholds = new HouseholdsClassesDataContext();
        }        
```
The API endpoints are described below in accordance to the requirements of the Backend Technical Assessment.
### Endpoint #1 - Create Household
The endpoint allows the caller to create a new household as shown in the code below.
```C#
[Route("api/Household/PostHousehold")]
[HttpPost]
public HttpResponseMessage PostHousehold([FromBody] Household household)
{
    try
    {
        ctxHouseholds.Households.InsertOnSubmit(household);
        ctxHouseholds.SubmitChanges();

        var response = Request.CreateResponse(HttpStatusCode.Created, household);
        response.Headers.Location = new Uri(Request.RequestUri.GetLeftPart(UriPartial.Authority) + "/Household/" + household.HouseholdId.ToString());
        return response;
    }
    catch (Exception ex)
    {
        return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);
    }
}
```
### Endpoint #2 - Add a Family Member to Household
The endpoint allows the caller to add a new family member to an existing collection of family members (if any) in a household as shown in the code below.
```C#
[Route("api/Household/PostFamilyMember")]
[HttpPost]
public HttpResponseMessage PostFamilyMember([FromBody] FamilyMember familyMember)
{
    try
    {
        ctxHouseholds.FamilyMembers.InsertOnSubmit(familyMember);
        ctxHouseholds.SubmitChanges();

        var response = Request.CreateResponse(HttpStatusCode.Created, familyMember);
        response.Headers.Location = new Uri(Request.RequestUri.GetLeftPart(UriPartial.Authority) + "/Household/FamilyMember/" + familyMember.MemberId.ToString());
        return response;
    }
    catch (Exception ex)
    {
        return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);
    }
}
```
### Endpoint #3 - List Households
The endpoint lists all the households and respective collection of family members in the *HouseholdsDB* database as shown in the code below.
```C#
// GET api/Household
public IEnumerable<HouseholdViewModel> Get()
{
    IList<HouseholdViewModel> households = null;

    households = ctxHouseholds.Households.Select(hh => new HouseholdViewModel()
    {
        HouseholdId = hh.HouseholdId,
        HousingType = hh.HousingType,
        FamilyMembers = hh.FamilyMembers.Select(fm => new FamilyMemberViewModel()
        {
            Name = fm.Name,
            Gender = fm.Gender,
            MaritalStatus = fm.MaritalStatus,
            SpouseName = fm.SpouseName,
            OccupationType = fm.OccupationType,
            AnnualIncome = fm.AnnualIncome.Value,
            DOB = fm.DOB
        }).ToList()
    }).ToList();

    return households;
}
```
### Endpoint #4 - Show Household
The endpoint shows the details of a specified household in the *HouseholdsDb* database as shown in the code below.
```C#
// GET api/Household/{id}
public IEnumerable<HouseholdViewModel> Get(int id)
{
    IList<HouseholdViewModel> households = null;

    households = ctxHouseholds.Households.Where(hid => hid.HouseholdId == id).Select(hh => new HouseholdViewModel()
    {
        HouseholdId = hh.HouseholdId,
        HousingType = hh.HousingType,
        FamilyMembers = hh.FamilyMembers.Select(fm => new FamilyMemberViewModel()
        {
            Name = fm.Name,
            Gender = fm.Gender,
            MaritalStatus = fm.MaritalStatus,
            SpouseName = fm.SpouseName,
            OccupationType = fm.OccupationType,
            AnnualIncome = fm.AnnualIncome.Value,
            DOB = fm.DOB
        }).ToList()
    }).ToList();

    return households;
}
```
### Endpoint #5 - Search For Households and Recipients of Grant Disbursement
The endpoint shows the details of selected households and family members based on the grant disbursement criteria as shown in the code below.

The following are assumptions made when implementing the query conditions:
1. 2 family members of "Married" marital status are a married couple;
2. The married couple are parents to the children in the same household.
```C#
// GET api/Household?hhIncome=100000&gtAge=0&ltAge=50&hasMarried=true
public IEnumerable<HouseholdViewModel> Get(decimal? hhIncome, int gtAge = 0, int ltAge = 150, bool hasMarried = false)
{
    IList<HouseholdViewModel> households = null;

    households = ctxHouseholds.Households
        .Select(hh => new HouseholdViewModel()
        {
            HouseholdId = hh.HouseholdId,
            HousingType = hh.HousingType,
            FamilyMembers = hh.FamilyMembers.Select(fm => new FamilyMemberViewModel()
            {
                Name = fm.Name,
                Gender = fm.Gender,
                MaritalStatus = fm.MaritalStatus,
                OccupationType = fm.OccupationType,
                AnnualIncome = fm.AnnualIncome.Value,
                DOB = fm.DOB
            }).ToList()
        }).ToList();

    households = households
        .Where(f1 => f1.FamilyMembers.Any(dob => (DateTime.Today - dob.DOB).TotalDays / 365.25 < ltAge))
        .Where(f2 => f2.FamilyMembers.Any(dob => (DateTime.Today - dob.DOB).TotalDays / 365.25 > gtAge)).ToList();

    if (hhIncome > 0)
    {
        households = households
            .Where(f3 => f3.FamilyMembers.Sum(ai => ai.AnnualIncome) < hhIncome).ToList();
    }

    if (hasMarried)
    {
        households = households
            .Where(f3 => f3.FamilyMembers.Count(m => m.MaritalStatus.Equals("Married")) >= 2).ToList();
    }

    return households;
}
```
### Endpoint #6 - Delete Household
The endpoint removes the specified household and its family members as shown in the code below.
```C#
// Optional End-Point 1 - Delete Household
// Usage:   DELETE api/Household/6
public void Delete(int id)
{
    var result = from hh in ctxHouseholds.Households
                 join fm in ctxHouseholds.FamilyMembers on hh.HouseholdId equals fm.HouseholdId
                 where hh.HouseholdId.Equals(id)
                 select new { household = hh, familyMember = fm };

    foreach (var item in result)
    {
        ctxHouseholds.FamilyMembers.DeleteOnSubmit(item.familyMember);
        ctxHouseholds.Households.DeleteOnSubmit(item.household);
    }
    ctxHouseholds.SubmitChanges();
}
```
### Endpoint #7 - Delete Family Member
The endpoint removes the specified family member from the household as shown in the code below.
```C#
// Optional End-Point 2 - Delete Family Member
// Usage:   DELETE api/Household?hid={hid}&fid={fid}
public void Delete(int hid, int fid)
{
    var result = from hh in ctxHouseholds.Households
                 join fm in ctxHouseholds.FamilyMembers on hh.HouseholdId equals fm.HouseholdId
                 where hh.HouseholdId.Equals(hid) && fm.MemberId.Equals(fid)
                 select new { household = hh, familyMember = fm };

    foreach (var item in result)
    {
        ctxHouseholds.FamilyMembers.DeleteOnSubmit(item.familyMember);
    }
    ctxHouseholds.SubmitChanges();
}
```
## Testing the Endpoints
The following are the results for making API calls for the various endpoint scenarios stated in the assessment requirements.
### 1. Create Household

Request:
```
POST https://localhost:44371/api/Household/PostHousehold HTTP/1.1
User-Agent: Fiddler
Host: localhost:44371
Content-Length: 24
content-type: application/json
accept: application/json

{"HousingType":"Landed"}
```
Response:
```
HTTP/1.1 201 Created
Cache-Control: no-cache
Pragma: no-cache
Content-Type: application/json; charset=utf-8
Expires: -1
Location: https://localhost:44371/api/Household/PostHousehold/11
Server: Microsoft-IIS/10.0
X-AspNet-Version: 4.0.30319
X-SourceFiles: =?UTF-8?B?RDpcTWVsdmluIFlhcFxEb2N1bWVudHNcVmlzdWFsIFN0dWRpbyAyMDE5XE15IFByb2plY3RzXE1lbHZpbllhcF9Hb3Zlcm5tZW50R3JhbnRBUElcYXBpXEhvdXNlaG9sZFxQb3N0SG91c2Vob2xk?=
X-Powered-By: ASP.NET
Date: Tue, 02 Feb 2021 12:48:21 GMT
Content-Length: 60

{"HouseholdId":11,"HousingType":"Landed","FamilyMembers":[]}
```

### 2. Add Family Member to Household

Request:
```
POST https://localhost:44371/api/Household/PostFamilyMember HTTP/1.1
User-Agent: Fiddler
Host: localhost:44371
Content-Length: 158
content-type: application/json
accept: application/json

{
"Name" : "Tan Ah Kow",
"Gender" : "Male",
"MaritalStatus" : "Single",
"OccupationType" : "Employed",
"AnnualIncome" : 100001,
"DOB" : "12-Dec-2000"
}
```
Response:
```
HTTP/1.1 201 Created
Cache-Control: no-cache
Pragma: no-cache
Content-Type: application/json; charset=utf-8
Expires: -1
Location: https://localhost:44371/Household/FamilyMember/29
Server: Microsoft-IIS/10.0
X-AspNet-Version: 4.0.30319
X-SourceFiles: =?UTF-8?B?RDpcTWVsdmluIFlhcFxEb2N1bWVudHNcVmlzdWFsIFN0dWRpbyAyMDE5XE15IFByb2plY3RzXE1lbHZpbllhcF9Hb3Zlcm5tZW50R3JhbnRBUElcYXBpXEhvdXNlaG9sZFxQb3N0RmFtaWx5TWVtYmVy?=
X-Powered-By: ASP.NET
Date: Tue, 02 Feb 2021 14:24:32 GMT
Content-Length: 210

{"MemberId":29,"Name":"Tan Ah Kow","Gender":"Male","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Employed","AnnualIncome":100001.0,"DOB":"2000-12-12T00:00:00","HouseholdId":null,"Household":null}
```

### 3. List Households

Request:
```
GET https://localhost:44371/api/Household HTTP/1.1
User-Agent: Fiddler
Host: localhost:44371
```
Response:
```
HTTP/1.1 200 OK
Cache-Control: no-cache
Pragma: no-cache
Content-Type: application/json; charset=utf-8
Expires: -1
Server: Microsoft-IIS/10.0
X-AspNet-Version: 4.0.30319
X-SourceFiles: =?UTF-8?B?RDpcTWVsdmluIFlhcFxEb2N1bWVudHNcVmlzdWFsIFN0dWRpbyAyMDE5XE15IFByb2plY3RzXE1lbHZpbllhcF9Hb3Zlcm5tZW50R3JhbnRBUElcYXBpXEhvdXNlaG9sZA==?=
X-Powered-By: ASP.NET
Date: Sat, 30 Jan 2021 17:02:22 GMT
Content-Length: 5111

[{"HouseholdId":1,"HousingType":"HDB","FamilyMembers":[{"MemberId":0,"Name":"John Tan","Gender":"Male","MaritalStatus":"Married","SpouseName":"Jane Lim","OccupationType":"Employed","AnnualIncome":90000.0000,"DOB":"1994-02-01T00:00:00","Household":null},{"MemberId":0,"Name":"Jane Lim","Gender":"Female","MaritalStatus":"Married","SpouseName":"John Tan","OccupationType":"Unemployed","AnnualIncome":null,"DOB":"1995-06-23T00:00:00","Household":null},{"MemberId":0,"Name":"Caden Tan","Gender":"Male","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Unemployed","AnnualIncome":null,"DOB":"2020-04-12T00:00:00","Household":null}]},{"HouseholdId":2,"HousingType":"HDB","FamilyMembers":[{"MemberId":0,"Name":"Teo Boon Hwee","Gender":"Male","MaritalStatus":"Married","SpouseName":"Chua Ai Ling","OccupationType":"Employed","AnnualIncome":55000.0000,"DOB":"1983-10-21T00:00:00","Household":null},{"MemberId":0,"Name":"Chua Ai Ling","Gender":"Female","MaritalStatus":"Married","SpouseName":"Teo Boon Hwee","OccupationType":"Employed","AnnualIncome":40000.0000,"DOB":"1987-09-10T00:00:00","Household":null}]},{"HouseholdId":3,"HousingType":"HDB","FamilyMembers":[{"MemberId":0,"Name":"Lim Siew Mui","Gender":"Female","MaritalStatus":"Widowed","SpouseName":"Teo Kim Soon","OccupationType":"Unemployed","AnnualIncome":null,"DOB":"1965-08-11T00:00:00","Household":null},{"MemberId":0,"Name":"Justin Ong","Gender":"Male","MaritalStatus":"Married","SpouseName":"Ang Li Peng","OccupationType":"Employed","AnnualIncome":120000.0000,"DOB":"1990-01-11T00:00:00","Household":null},{"MemberId":0,"Name":"Ang Li Peng","Gender":"Feale","MaritalStatus":"Married","SpouseName":"Justin Ong","OccupationType":"Employed","AnnualIncome":98000.0000,"DOB":"1989-04-24T00:00:00","Household":null},{"MemberId":0,"Name":"Clarissa Ong","Gender":"Female","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Unemployed","AnnualIncome":null,"DOB":"2014-01-13T00:00:00","Household":null},{"MemberId":0,"Name":"Caden Ong","Gender":"Male","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Unemployed","AnnualIncome":null,"DOB":"2018-03-05T00:00:00","Household":null}]},{"HouseholdId":4,"HousingType":"Condominium","FamilyMembers":[{"MemberId":0,"Name":"Kelvin Chew","Gender":"Male","MaritalStatus":"Divorced","SpouseName":"Goh Aileen","OccupationType":"Employed","AnnualIncome":200000.0000,"DOB":"1971-02-01T00:00:00","Household":null},{"MemberId":0,"Name":"Lee Hui Ling","Gender":"Female","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Employed","AnnualIncome":70000.0000,"DOB":"1987-09-10T00:00:00","Household":null}]},{"HouseholdId":5,"HousingType":"Condominium","FamilyMembers":[{"MemberId":0,"Name":"Goh Soon Lee","Gender":"Male","MaritalStatus":"Married","SpouseName":"Judy Chua","OccupationType":"Employed","AnnualIncome":250000.0000,"DOB":"1969-12-01T00:00:00","Household":null},{"MemberId":0,"Name":"Judy Chua","Gender":"Female","MaritalStatus":"Married","SpouseName":"Goh Soon Lee","OccupationType":"Unemployed","AnnualIncome":null,"DOB":"1972-11-19T00:00:00","Household":null},{"MemberId":0,"Name":"Sophie Goh","Gender":"Female","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Unemployed","AnnualIncome":null,"DOB":"1999-09-16T00:00:00","Household":null},{"MemberId":0,"Name":"Shawn Goh","Gender":"Male","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Unemployed","AnnualIncome":null,"DOB":"2004-04-22T00:00:00","Household":null}]},{"HouseholdId":6,"HousingType":"Landed","FamilyMembers":[{"MemberId":0,"Name":"Lim Kim Teck","Gender":"Male","MaritalStatus":"Married","SpouseName":"Ong Keng Mui","OccupationType":"Employed","AnnualIncome":300000.0000,"DOB":"1964-12-12T00:00:00","Household":null},{"MemberId":0,"Name":"Ong Keng Mui","Gender":"Female","MaritalStatus":"Married","SpouseName":"Lim Kim Teck","OccupationType":"Unemployed","AnnualIncome":null,"DOB":"1968-06-01T00:00:00","Household":null},{"MemberId":0,"Name":"Darren Lim","Gender":"Male","MaritalStatus":"Married","SpouseName":"Lisa Wong","OccupationType":"Employed","AnnualIncome":190000.0000,"DOB":"1986-06-15T00:00:00","Household":null},{"MemberId":0,"Name":"Lisa Wong","Gender":"Female","MaritalStatus":"Married","SpouseName":"Darren Lim","OccupationType":"Employed","AnnualIncome":105000.0000,"DOB":"1994-02-01T00:00:00","Household":null},{"MemberId":0,"Name":"David Lim","Gender":"Male","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Employed","AnnualIncome":290000.0000,"DOB":"1990-05-17T00:00:00","Household":null},{"MemberId":0,"Name":"Mark Lim","Gender":"Male","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Unemployed","AnnualIncome":null,"DOB":"2008-10-23T00:00:00","Household":null},{"MemberId":0,"Name":"Joshua Lim","Gender":"Male","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Unemployed","AnnualIncome":null,"DOB":"2010-04-11T00:00:00","Household":null},{"MemberId":0,"Name":"Jessica Lim","Gender":"Female","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Unemployed","AnnualIncome":null,"DOB":"2012-07-31T00:00:00","Household":null}]}]
```

### 4. Show Household

Request:
```
GET https://localhost:44371/api/Household/2 HTTP/1.1
User-Agent: Fiddler
Host: localhost:44371
Content-Length: 0
content-type: application/json
accept: application/json
```
Response:
```
HTTP/1.1 200 OK
Cache-Control: no-cache
Pragma: no-cache
Content-Type: application/json; charset=utf-8
Expires: -1
Server: Microsoft-IIS/10.0
X-AspNet-Version: 4.0.30319
X-SourceFiles: =?UTF-8?B?RDpcTWVsdmluIFlhcFxEb2N1bWVudHNcVmlzdWFsIFN0dWRpbyAyMDE5XE15IFByb2plY3RzXE1lbHZpbllhcF9Hb3Zlcm5tZW50R3JhbnRBUElcYXBpXEhvdXNlaG9sZFwy?=
X-Powered-By: ASP.NET
Date: Wed, 03 Feb 2021 17:20:37 GMT
Content-Length: 439

[{"HouseholdId":2,"HousingType":"HDB","FamilyMembers":[{"MemberId":0,"Name":"Teo Boon Hwee","Gender":"Male","MaritalStatus":"Married","SpouseName":"Chua Ai Ling","OccupationType":"Employed","AnnualIncome":55000.0000,"DOB":"1983-10-21T00:00:00"},{"MemberId":0,"Name":"Chua Ai Ling","Gender":"Female","MaritalStatus":"Married","SpouseName":"Teo Boon Hwee","OccupationType":"Employed","AnnualIncome":40000.0000,"DOB":"1987-09-10T00:00:00"}]}]
```

### 5. Search For Households and Recipients of Grant Disbursement
#### i. Student Encouragement Bonus - children < 16 years old, household income < $150,000

Request:
```
GET https://localhost:44371/api/Household?hhIncome=150000&ltAge=16 HTTP/1.1
User-Agent: Fiddler
Host: localhost:44371
Content-Length: 0
content-type: application/json
accept: application/json
```
Response:
```
HTTP/1.1 200 OK
Cache-Control: no-cache
Pragma: no-cache
Content-Type: application/json; charset=utf-8
Expires: -1
Server: Microsoft-IIS/10.0
X-AspNet-Version: 4.0.30319
X-SourceFiles: =?UTF-8?B?RDpcTWVsdmluIFlhcFxEb2N1bWVudHNcVmlzdWFsIFN0dWRpbyAyMDE5XE15IFByb2plY3RzXE1lbHZpbllhcF9Hb3Zlcm5tZW50R3JhbnRBUElcYXBpXEhvdXNlaG9sZA==?=
X-Powered-By: ASP.NET
Date: Wed, 03 Feb 2021 18:12:25 GMT
Content-Length: 576

[{"HouseholdId":1,"HousingType":"HDB","FamilyMembers":[{"MemberId":0,"Name":"John Tan","Gender":"Male","MaritalStatus":"Married","SpouseName":null,"OccupationType":"Employed","AnnualIncome":90000.0000,"DOB":"1994-02-01T00:00:00"},{"MemberId":0,"Name":"Jane Lim","Gender":"Female","MaritalStatus":"Married","SpouseName":null,"OccupationType":"Unemployed","AnnualIncome":null,"DOB":"1995-06-23T00:00:00"},{"MemberId":0,"Name":"Caden Tan","Gender":"Male","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Unemployed","AnnualIncome":null,"DOB":"2020-04-12T00:00:00"}]}]
```

#### ii. Family Togetherness Scheme - husband & wife, children < 18 years old

Request:
```
GET https://localhost:44371/api/Household?ltAge=18&hasMarried=true HTTP/1.1
User-Agent: Fiddler
Host: localhost:44371
Content-Length: 0
content-type: application/json
accept: application/json
```
Response:
```
HTTP/1.1 200 OK
Cache-Control: no-cache
Pragma: no-cache
Content-Type: application/json; charset=utf-8
Expires: -1
Server: Microsoft-IIS/10.0
X-AspNet-Version: 4.0.30319
X-SourceFiles: =?UTF-8?B?RDpcTWVsdmluIFlhcFxEb2N1bWVudHNcVmlzdWFsIFN0dWRpbyAyMDE5XE15IFByb2plY3RzXE1lbHZpbllhcF9Hb3Zlcm5tZW50R3JhbnRBUElcYXBpXEhvdXNlaG9sZA==?=
X-Powered-By: ASP.NET
Date: Wed, 03 Feb 2021 18:18:23 GMT
Content-Length: 4685

[{"HouseholdId":1,"HousingType":"HDB","FamilyMembers":[{"MemberId":0,"Name":"John Tan","Gender":"Male","MaritalStatus":"Married","SpouseName":"Jane Lim","OccupationType":"Employed","AnnualIncome":90000.0000,"DOB":"1994-02-01T00:00:00"},{"MemberId":0,"Name":"Jane Lim","Gender":"Female","MaritalStatus":"Married","SpouseName":"John Tan","OccupationType":"Unemployed","AnnualIncome":null,"DOB":"1995-06-23T00:00:00"},{"MemberId":0,"Name":"Caden Tan","Gender":"Male","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Unemployed","AnnualIncome":null,"DOB":"2020-04-12T00:00:00"}]},{"HouseholdId":2,"HousingType":"HDB","FamilyMembers":[{"MemberId":0,"Name":"Teo Boon Hwee","Gender":"Male","MaritalStatus":"Married","SpouseName":"Chua Ai Ling","OccupationType":"Employed","AnnualIncome":55000.0000,"DOB":"1983-10-21T00:00:00"},{"MemberId":0,"Name":"Chua Ai Ling","Gender":"Female","MaritalStatus":"Married","SpouseName":"Teo Boon Hwee","OccupationType":"Employed","AnnualIncome":40000.0000,"DOB":"1987-09-10T00:00:00"}]},{"HouseholdId":3,"HousingType":"HDB","FamilyMembers":[{"MemberId":0,"Name":"Lim Siew Mui","Gender":"Female","MaritalStatus":"Widowed","SpouseName":"Teo Kim Soon","OccupationType":"Unemployed","AnnualIncome":null,"DOB":"1965-08-11T00:00:00"},{"MemberId":0,"Name":"Justin Ong","Gender":"Male","MaritalStatus":"Married","SpouseName":"Ang Li Peng","OccupationType":"Employed","AnnualIncome":120000.0000,"DOB":"1990-01-11T00:00:00"},{"MemberId":0,"Name":"Ang Li Peng","Gender":"Feale","MaritalStatus":"Married","SpouseName":"Justin Ong","OccupationType":"Employed","AnnualIncome":98000.0000,"DOB":"1989-04-24T00:00:00"},{"MemberId":0,"Name":"Clarissa Ong","Gender":"Female","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Student","AnnualIncome":null,"DOB":"2014-01-13T00:00:00"},{"MemberId":0,"Name":"Caden Ong","Gender":"Male","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Student","AnnualIncome":null,"DOB":"2018-03-05T00:00:00"}]},{"HouseholdId":4,"HousingType":"Condominium","FamilyMembers":[{"MemberId":0,"Name":"Kelvin Chew","Gender":"Male","MaritalStatus":"Divorced","SpouseName":"Goh Aileen","OccupationType":"Employed","AnnualIncome":200000.0000,"DOB":"1971-02-01T00:00:00"},{"MemberId":0,"Name":"Lee Hui Ling","Gender":"Female","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Employed","AnnualIncome":70000.0000,"DOB":"1987-09-10T00:00:00"}]},{"HouseholdId":5,"HousingType":"Condominium","FamilyMembers":[{"MemberId":0,"Name":"Goh Soon Lee","Gender":"Male","MaritalStatus":"Married","SpouseName":"Judy Chua","OccupationType":"Employed","AnnualIncome":250000.0000,"DOB":"1969-12-01T00:00:00"},{"MemberId":0,"Name":"Judy Chua","Gender":"Female","MaritalStatus":"Married","SpouseName":"Goh Soon Lee","OccupationType":"Unemployed","AnnualIncome":null,"DOB":"1972-11-19T00:00:00"},{"MemberId":0,"Name":"Sophie Goh","Gender":"Female","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Unemployed","AnnualIncome":null,"DOB":"1999-09-16T00:00:00"},{"MemberId":0,"Name":"Shawn Goh","Gender":"Male","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Student","AnnualIncome":null,"DOB":"2004-04-22T00:00:00"}]},{"HouseholdId":6,"HousingType":"Landed","FamilyMembers":[{"MemberId":0,"Name":"Lim Kim Teck","Gender":"Male","MaritalStatus":"Married","SpouseName":"Ong Keng Mui","OccupationType":"Employed","AnnualIncome":300000.0000,"DOB":"1964-12-12T00:00:00"},{"MemberId":0,"Name":"Ong Keng Mui","Gender":"Female","MaritalStatus":"Married","SpouseName":"Lim Kim Teck","OccupationType":"Unemployed","AnnualIncome":null,"DOB":"1968-06-01T00:00:00"},{"MemberId":0,"Name":"Darren Lim","Gender":"Male","MaritalStatus":"Married","SpouseName":"Lisa Wong","OccupationType":"Employed","AnnualIncome":190000.0000,"DOB":"1986-06-15T00:00:00"},{"MemberId":0,"Name":"Lisa Wong","Gender":"Female","MaritalStatus":"Married","SpouseName":"Darren Lim","OccupationType":"Employed","AnnualIncome":105000.0000,"DOB":"1994-02-01T00:00:00"},{"MemberId":0,"Name":"David Lim","Gender":"Male","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Employed","AnnualIncome":290000.0000,"DOB":"1990-05-17T00:00:00"},{"MemberId":0,"Name":"Mark Lim","Gender":"Male","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Student","AnnualIncome":null,"DOB":"2008-10-23T00:00:00"},{"MemberId":0,"Name":"Joshua Lim","Gender":"Male","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Student","AnnualIncome":null,"DOB":"2010-04-11T00:00:00"},{"MemberId":0,"Name":"Jessica Lim","Gender":"Female","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Student","AnnualIncome":null,"DOB":"2012-07-31T00:00:00"}]}]
```

#### iii. Elder Bonus

Request:
```
GET https://localhost:44371/api/Household?hhIncome=0&gtAge=50 HTTP/1.1
User-Agent: Fiddler
Host: localhost:44371
Content-Length: 0
content-type: application/json
accept: application/json
```
Response:
```
HTTP/1.1 200 OK
Cache-Control: no-cache
Pragma: no-cache
Content-Type: application/json; charset=utf-8
Expires: -1
Server: Microsoft-IIS/10.0
X-AspNet-Version: 4.0.30319
X-SourceFiles: =?UTF-8?B?RDpcTWVsdmluIFlhcFxEb2N1bWVudHNcVmlzdWFsIFN0dWRpbyAyMDE5XE15IFByb2plY3RzXE1lbHZpbllhcF9Hb3Zlcm5tZW50R3JhbnRBUElcYXBpXEhvdXNlaG9sZA==?=
X-Powered-By: ASP.NET
Date: Thu, 04 Feb 2021 03:52:29 GMT
Content-Length: 3573

[{"HouseholdId":3,"HousingType":"HDB","FamilyMembers":[{"MemberId":0,"Name":"Lim Siew Mui","Gender":"Female","MaritalStatus":"Widowed","SpouseName":null,"OccupationType":"Unemployed","AnnualIncome":null,"DOB":"1965-08-11T00:00:00"},{"MemberId":0,"Name":"Justin Ong","Gender":"Male","MaritalStatus":"Married","SpouseName":null,"OccupationType":"Employed","AnnualIncome":120000.0000,"DOB":"1990-01-11T00:00:00"},{"MemberId":0,"Name":"Ang Li Peng","Gender":"Feale","MaritalStatus":"Married","SpouseName":null,"OccupationType":"Employed","AnnualIncome":98000.0000,"DOB":"1989-04-24T00:00:00"},{"MemberId":0,"Name":"Clarissa Ong","Gender":"Female","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Student","AnnualIncome":null,"DOB":"2014-01-13T00:00:00"},{"MemberId":0,"Name":"Caden Ong","Gender":"Male","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Student","AnnualIncome":null,"DOB":"2018-03-05T00:00:00"}]},{"HouseholdId":4,"HousingType":"Condominium","FamilyMembers":[{"MemberId":0,"Name":"Kelvin Chew","Gender":"Male","MaritalStatus":"Divorced","SpouseName":null,"OccupationType":"Employed","AnnualIncome":200000.0000,"DOB":"1971-02-01T00:00:00"},{"MemberId":0,"Name":"Lee Hui Ling","Gender":"Female","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Employed","AnnualIncome":70000.0000,"DOB":"1987-09-10T00:00:00"}]},{"HouseholdId":5,"HousingType":"Condominium","FamilyMembers":[{"MemberId":0,"Name":"Goh Soon Lee","Gender":"Male","MaritalStatus":"Married","SpouseName":null,"OccupationType":"Employed","AnnualIncome":250000.0000,"DOB":"1969-12-01T00:00:00"},{"MemberId":0,"Name":"Judy Chua","Gender":"Female","MaritalStatus":"Married","SpouseName":null,"OccupationType":"Unemployed","AnnualIncome":null,"DOB":"1972-11-19T00:00:00"},{"MemberId":0,"Name":"Sophie Goh","Gender":"Female","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Unemployed","AnnualIncome":null,"DOB":"1999-09-16T00:00:00"},{"MemberId":0,"Name":"Shawn Goh","Gender":"Male","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Student","AnnualIncome":null,"DOB":"2004-04-22T00:00:00"}]},{"HouseholdId":6,"HousingType":"Landed","FamilyMembers":[{"MemberId":0,"Name":"Lim Kim Teck","Gender":"Male","MaritalStatus":"Married","SpouseName":null,"OccupationType":"Employed","AnnualIncome":300000.0000,"DOB":"1964-12-12T00:00:00"},{"MemberId":0,"Name":"Ong Keng Mui","Gender":"Female","MaritalStatus":"Married","SpouseName":null,"OccupationType":"Unemployed","AnnualIncome":null,"DOB":"1968-06-01T00:00:00"},{"MemberId":0,"Name":"Darren Lim","Gender":"Male","MaritalStatus":"Married","SpouseName":null,"OccupationType":"Employed","AnnualIncome":190000.0000,"DOB":"1986-06-15T00:00:00"},{"MemberId":0,"Name":"Lisa Wong","Gender":"Female","MaritalStatus":"Married","SpouseName":null,"OccupationType":"Employed","AnnualIncome":105000.0000,"DOB":"1994-02-01T00:00:00"},{"MemberId":0,"Name":"David Lim","Gender":"Male","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Employed","AnnualIncome":290000.0000,"DOB":"1990-05-17T00:00:00"},{"MemberId":0,"Name":"Mark Lim","Gender":"Male","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Student","AnnualIncome":null,"DOB":"2008-10-23T00:00:00"},{"MemberId":0,"Name":"Joshua Lim","Gender":"Male","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Student","AnnualIncome":null,"DOB":"2010-04-11T00:00:00"},{"MemberId":0,"Name":"Jessica Lim","Gender":"Female","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Student","AnnualIncome":null,"DOB":"2012-07-31T00:00:00"}]}]
```

#### iv. Baby Sunshine Grant

Request:
```
GET https://localhost:44371/api/Household?hhIncome=0&ltAge=5 HTTP/1.1
User-Agent: Fiddler
Host: localhost:44371
Content-Length: 0
content-type: application/json
accept: application/json
```

Response:
```
HTTP/1.1 200 OK
Cache-Control: no-cache
Pragma: no-cache
Content-Type: application/json; charset=utf-8
Expires: -1
Server: Microsoft-IIS/10.0
X-AspNet-Version: 4.0.30319
X-SourceFiles: =?UTF-8?B?RDpcTWVsdmluIFlhcFxEb2N1bWVudHNcVmlzdWFsIFN0dWRpbyAyMDE5XE15IFByb2plY3RzXE1lbHZpbllhcF9Hb3Zlcm5tZW50R3JhbnRBUElcYXBpXEhvdXNlaG9sZA==?=
X-Powered-By: ASP.NET
Date: Thu, 04 Feb 2021 03:56:09 GMT
Content-Length: 1507

[{"HouseholdId":1,"HousingType":"HDB","FamilyMembers":[{"MemberId":0,"Name":"John Tan","Gender":"Male","MaritalStatus":"Married","SpouseName":null,"OccupationType":"Employed","AnnualIncome":90000.0000,"DOB":"1994-02-01T00:00:00"},{"MemberId":0,"Name":"Jane Lim","Gender":"Female","MaritalStatus":"Married","SpouseName":null,"OccupationType":"Unemployed","AnnualIncome":null,"DOB":"1995-06-23T00:00:00"},{"MemberId":0,"Name":"Caden Tan","Gender":"Male","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Unemployed","AnnualIncome":null,"DOB":"2020-04-12T00:00:00"}]},{"HouseholdId":3,"HousingType":"HDB","FamilyMembers":[{"MemberId":0,"Name":"Lim Siew Mui","Gender":"Female","MaritalStatus":"Widowed","SpouseName":null,"OccupationType":"Unemployed","AnnualIncome":null,"DOB":"1965-08-11T00:00:00"},{"MemberId":0,"Name":"Justin Ong","Gender":"Male","MaritalStatus":"Married","SpouseName":null,"OccupationType":"Employed","AnnualIncome":120000.0000,"DOB":"1990-01-11T00:00:00"},{"MemberId":0,"Name":"Ang Li Peng","Gender":"Feale","MaritalStatus":"Married","SpouseName":null,"OccupationType":"Employed","AnnualIncome":98000.0000,"DOB":"1989-04-24T00:00:00"},{"MemberId":0,"Name":"Clarissa Ong","Gender":"Female","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Student","AnnualIncome":null,"DOB":"2014-01-13T00:00:00"},{"MemberId":0,"Name":"Caden Ong","Gender":"Male","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Student","AnnualIncome":null,"DOB":"2018-03-05T00:00:00"}]}]
```

#### v. YOLO GST Grant

Request:
```
GET https://localhost:44371/api/Household?hhIncome=100000 HTTP/1.1
User-Agent: Fiddler
Host: localhost:44371
Content-Length: 0
content-type: application/json
accept: application/json
```
Response:
```
HTTP/1.1 200 OK
Cache-Control: no-cache
Pragma: no-cache
Content-Type: application/json; charset=utf-8
Expires: -1
Server: Microsoft-IIS/10.0
X-AspNet-Version: 4.0.30319
X-SourceFiles: =?UTF-8?B?RDpcTWVsdmluIFlhcFxEb2N1bWVudHNcVmlzdWFsIFN0dWRpbyAyMDE5XE15IFByb2plY3RzXE1lbHZpbllhcF9Hb3Zlcm5tZW50R3JhbnRBUElcYXBpXEhvdXNlaG9sZA==?=
X-Powered-By: ASP.NET
Date: Thu, 04 Feb 2021 03:58:01 GMT
Content-Length: 993

[{"HouseholdId":1,"HousingType":"HDB","FamilyMembers":[{"MemberId":0,"Name":"John Tan","Gender":"Male","MaritalStatus":"Married","SpouseName":null,"OccupationType":"Employed","AnnualIncome":90000.0000,"DOB":"1994-02-01T00:00:00"},{"MemberId":0,"Name":"Jane Lim","Gender":"Female","MaritalStatus":"Married","SpouseName":null,"OccupationType":"Unemployed","AnnualIncome":null,"DOB":"1995-06-23T00:00:00"},{"MemberId":0,"Name":"Caden Tan","Gender":"Male","MaritalStatus":"Single","SpouseName":null,"OccupationType":"Unemployed","AnnualIncome":null,"DOB":"2020-04-12T00:00:00"}]},{"HouseholdId":2,"HousingType":"HDB","FamilyMembers":[{"MemberId":0,"Name":"Teo Boon Hwee","Gender":"Male","MaritalStatus":"Married","SpouseName":null,"OccupationType":"Employed","AnnualIncome":55000.0000,"DOB":"1983-10-21T00:00:00"},{"MemberId":0,"Name":"Chua Ai Ling","Gender":"Female","MaritalStatus":"Married","SpouseName":null,"OccupationType":"Employed","AnnualIncome":40000.0000,"DOB":"1987-09-10T00:00:00"}]}]
```

### 6. Delete Household

Request:
```
DELETE https://localhost:44371/api/Household/5 HTTP/1.1
User-Agent: Fiddler
Host: localhost:44371
Content-Length: 0
content-type: application/json
accept: application/json
```
Response:
```
HTTP/1.1 200 OK
Cache-Control: no-cache
Pragma: no-cache
Content-Type: application/json; charset=utf-8
Expires: -1
Server: Microsoft-IIS/10.0
X-AspNet-Version: 4.0.30319
X-SourceFiles: =?UTF-8?B?RDpcTWVsdmluIFlhcFxEb2N1bWVudHNcVmlzdWFsIFN0dWRpbyAyMDE5XE15IFByb2plY3RzXE1lbHZpbllhcF9Hb3Zlcm5tZW50R3JhbnRBUElcYXBpXEhvdXNlaG9sZFw1?=
X-Powered-By: ASP.NET
Date: Thu, 04 Feb 2021 04:33:39 GMT
Content-Length: 71

"Household ID 5 and its family members have been successfully deleted."
```

### 7. Delete Family Member

Request:
```
DELETE https://localhost:44371/api/Household?hid=12&fid=4 HTTP/1.1
User-Agent: Fiddler
Host: localhost:44371
Content-Length: 0
content-type: application/json
accept: application/json
```
Response:
```
HTTP/1.1 200 OK
Cache-Control: no-cache
Pragma: no-cache
Content-Type: application/json; charset=utf-8
Expires: -1
Server: Microsoft-IIS/10.0
X-AspNet-Version: 4.0.30319
X-SourceFiles: =?UTF-8?B?RDpcTWVsdmluIFlhcFxEb2N1bWVudHNcVmlzdWFsIFN0dWRpbyAyMDE5XE15IFByb2plY3RzXE1lbHZpbllhcF9Hb3Zlcm5tZW50R3JhbnRBUElcYXBpXEhvdXNlaG9sZA==?=
X-Powered-By: ASP.NET
Date: Thu, 04 Feb 2021 04:32:37 GMT
Content-Length: 79

"Family Member ID 4 is successfully deleted. Member belongs to Household ID 12."
```
