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