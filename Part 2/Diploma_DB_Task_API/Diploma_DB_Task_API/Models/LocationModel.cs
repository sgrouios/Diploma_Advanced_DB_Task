using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Diploma_DB_Task_API.Models
{
    public class LocationModel
    {
        public string LocationID { get; set; }
        public string LocationName { get; set; }
        public string Address { get; set; }
        public string Manager { get; set; }

        public LocationModel()
        {

        }
        public LocationModel(string locid, string locname, string add, string manager)
        {
            LocationID = locid;
            LocationName = locname;
            Address = add;
            Manager = manager;
        }
    }
}
