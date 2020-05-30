using System;
using System.Collections.Generic;

namespace Diploma_DB_Task_API.Models
{
    public partial class Order9802
    {
        public Order9802()
        {
            Orderline9802 = new HashSet<Orderline9802>();
        }

        public int Orderid { get; set; }
        public string Shippingaddress { get; set; }
        public DateTime Datetimecreated { get; set; }
        public DateTime? Datetimedispatched { get; set; }
        public decimal Total { get; set; }
        public int Userid { get; set; }

        public virtual Authorisedperson9802 User { get; set; }
        public virtual ICollection<Orderline9802> Orderline9802 { get; set; }
    }
}
