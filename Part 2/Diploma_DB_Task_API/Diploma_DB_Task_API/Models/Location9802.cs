using System;
using System.Collections.Generic;

namespace Diploma_DB_Task_API.Models
{
    public partial class Location9802
    {
        public Location9802()
        {
            Inventory9802 = new HashSet<Inventory9802>();
            Purchaseorder9802 = new HashSet<Purchaseorder9802>();
        }

        public string Locationid { get; set; }
        public string Locname { get; set; }
        public string Address { get; set; }
        public string Manager { get; set; }

        public virtual ICollection<Inventory9802> Inventory9802 { get; set; }
        public virtual ICollection<Purchaseorder9802> Purchaseorder9802 { get; set; }
    }
}
