using System;
using System.Collections.Generic;

namespace Diploma_DB_Task_API.Models
{
    public partial class Orderline9802
    {
        public int Orderid { get; set; }
        public int Productid { get; set; }
        public int Quantity { get; set; }
        public decimal? Discount { get; set; }
        public decimal Subtotal { get; set; }

        public virtual Order9802 Order { get; set; }
        public virtual Product9802 Product { get; set; }
    }
}
