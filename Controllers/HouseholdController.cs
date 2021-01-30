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
        // Create new instance of LINQ to SQL class
        HouseholdsClassesDataContext ctx = new HouseholdsClassesDataContext();

        // GET api/<controller>
        public IEnumerable<Household> Get()
        {
            //return new string[] { "value1", "value2" };
            return ctx.Households.ToList().AsEnumerable();
        }

        // GET api/<controller>/5
        public string Get(int id)
        {
            return "value";
        }

        // POST api/<controller>
        public void Post([FromBody] string value)
        {
        }

        // PUT api/<controller>/5
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE api/<controller>/5
        public void Delete(int id)
        {
        }
    }
}