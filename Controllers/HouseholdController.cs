using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using MelvinYap_GovernmentGrantAPI.Models;

namespace MelvinYap_GovernmentGrantAPI.Controllers
{
    public class HouseholdController : ApiController
    {
        // Create instance of LINQ to SQL
        private HouseholdsClassesDataContext ctxHouseholds;

        public HouseholdController()
        {
            ctxHouseholds = new HouseholdsClassesDataContext();
        }

        // End-Point 3 - List Households
        // Usage: List all households and their family members
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

        // End-Point 4 - Show Household
        // Usage: Provides details of a specified household in the HouseholdsDb database
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
                    SpouseName = ((DateTime.Today - fm.DOB).TotalDays / 365.25).ToString(), //fm.SpouseName,
                    OccupationType = fm.OccupationType,
                    AnnualIncome = fm.AnnualIncome.Value,
                    DOB = fm.DOB
                }).ToList()
            }).ToList();

            return households;
        }

        // End-Point (Miscellaneous) - Show Family Member
        // Usage: Provides details of a specified family member of a household
        // GET api/Household/Family/{id}
        [Route("api/Household/Family/{id}")]
        public IEnumerable<FamilyMemberViewModel> GetFamilyMember(int id)
        {
            IList<FamilyMemberViewModel> familyMembers = null;

            familyMembers = ctxHouseholds.FamilyMembers
                .Where(fm => fm.MemberId == id)
                .Select(fm => new FamilyMemberViewModel()
            {
                MemberId = fm.MemberId,
                Name = fm.Name,
                Gender = fm.Gender,
                MaritalStatus = fm.MaritalStatus,
                SpouseName = fm.SpouseName,
                OccupationType = fm.OccupationType,
                AnnualIncome = fm.AnnualIncome.Value,
                DOB = fm.DOB
            }).ToList();

            return familyMembers;
        }

        // End-Point 5 - Search For Households and Recipients of Grant Disbursement
        // Usage: Provides details of selected households and family members based on the grant disbursement criteria
        // GET api/Household?hhIncome={hhIncome}&gtAge={gtAge}&ltAge={ltAge}&hasMarried={hasMarried}
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

        // End-Point 1 - Create Household
        // Usage: Creates a new household
        // POST api/Household/PostHousehold
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

        // End-Point 2 - Add Family Member to Household
        // Usage: Adds a new family member to a household
        // POST api/Household/PostFamilyMember
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

        // PUT api/<controller>/5
        // Not in use
        //public void Put(int id, [FromBody] string value)
        //{
        //}


        // Optional End-Point 1 - Delete Household
        // Purpose: To remove a specified household and its family members
        // Usage:   DELETE api/Household/6
        public HttpResponseMessage Delete(int id)
        {
            try
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

                return Request.CreateResponse(HttpStatusCode.OK, "Household ID " + id.ToString() + " and its family members have been successfully deleted.");
            }
            catch (Exception ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);
            }
            
        }

        
        // Optional End-Point 2 - Delete Family Member
        // Purpose: To remove a specified family member from the household
        // Usage:   DELETE api/Household?hid={hid}&fid={fid}
        public HttpResponseMessage Delete(int hid, int fid)
        {
            try
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

                return Request.CreateResponse(HttpStatusCode.OK, "Family Member ID " + fid.ToString() + " is successfully deleted. Member belongs to Household ID " + hid.ToString());
            }
            catch (Exception ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);
            }
        }
    }
}