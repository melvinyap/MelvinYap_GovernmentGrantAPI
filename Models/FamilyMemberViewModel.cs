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