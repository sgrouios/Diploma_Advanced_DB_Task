using System;
using System.Collections.Generic;

namespace Diploma_DB_Task_API.Models
{
    public partial class Authorisedperson9802
    {
        public Authorisedperson9802()
        {
            Order9802 = new HashSet<Order9802>();
        }

        public int Userid { get; set; }
        public string Firstname { get; set; }
        public string Surname { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public int Accountid { get; set; }

        public virtual Clientaccount9802 Account { get; set; }
        public virtual ICollection<Order9802> Order9802 { get; set; }
    }
}
