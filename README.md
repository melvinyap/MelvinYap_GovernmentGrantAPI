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
        public decimal AnnualIncome { get; set; }
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
        .Where(f1 => f1.FamilyMembers.Any(dob => (DateTime.Today - dob.DOB).Days / 365.25 > gtAge && (DateTime.Today - dob.DOB).Days / 365.25 < ltAge))
        .Where(f2 => f2.FamilyMembers.Sum(ai => ai.AnnualIncome) < hhIncome).ToList();

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
