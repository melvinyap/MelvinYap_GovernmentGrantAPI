# Backend Technical Assessment Deliverable
The **Government Grant Disbursement API** is developed in C# using Visual Studio 2019. It connects to a local SQL Server Express 2019 database that stores data for Households and FamilyMembers tables.

The API was tested with Fiddler.

*Disclaimer: All data records in the database are entirely fictional and meant to serve for the purpose of understanding and testing the API functions.*
## Prerequisites
 1. [Visual Studio 2019 Community Edition](https://visualstudio.microsoft.com/downloads/)
 2. [SQL Server 2019 Express](https://www.microsoft.com/en-sg/sql-server/sql-server-downloads)
 3. [Telerik Fiddler](https://www.telerik.com/fiddler)
## Open This Repository in Visual Studio 2019
Refer to the Microsoft website on how to [open the project from the GitHub repository](https://docs.microsoft.com/en-us/visualstudio/get-started/tutorial-open-project-from-repo?view=vs-2019&tabs=vs168later).

## List of C# Work Files Used for API Development
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
