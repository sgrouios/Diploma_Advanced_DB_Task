using System;
using System.Collections.Generic;

namespace Diploma_DB_Task_API.Models
{
    public partial class Clientaccount9802
    {
        public Clientaccount9802()
        {
            Accountpayment9802 = new HashSet<Accountpayment9802>();
            Authorisedperson9802 = new HashSet<Authorisedperson9802>();
        }

        public int Accountid { get; set; }
        public string Acctname { get; set; }
        public decimal Balance { get; set; }
        public decimal Creditlimit { get; set; }

        public virtual ICollection<Accountpayment9802> Accountpayment9802 { get; set; }
        public virtual ICollection<Authorisedperson9802> Authorisedperson9802 { get; set; }
    }
}
