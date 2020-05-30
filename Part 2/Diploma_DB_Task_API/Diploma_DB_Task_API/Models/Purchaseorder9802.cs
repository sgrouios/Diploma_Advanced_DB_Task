using System;
using System.Collections.Generic;

namespace Diploma_DB_Task_API.Models
{
    public partial class Purchaseorder9802
    {
        public int Productid { get; set; }
        public string Locationid { get; set; }
        public DateTime Datetimecreated { get; set; }
        public int? Quantity { get; set; }
        public decimal? Total { get; set; }

        public virtual Location9802 Location { get; set; }
        public virtual Product9802 Product { get; set; }
    }
}
