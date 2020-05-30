using System;
using System.Collections.Generic;

namespace Diploma_DB_Task_API.Models
{
    public partial class Product9802
    {
        public Product9802()
        {
            Inventory9802 = new HashSet<Inventory9802>();
            Orderline9802 = new HashSet<Orderline9802>();
            Purchaseorder9802 = new HashSet<Purchaseorder9802>();
        }

        public int Productid { get; set; }
        public string Prodname { get; set; }
        public decimal? Buyprice { get; set; }
        public decimal? Sellprice { get; set; }

        public virtual ICollection<Inventory9802> Inventory9802 { get; set; }
        public virtual ICollection<Orderline9802> Orderline9802 { get; set; }
        public virtual ICollection<Purchaseorder9802> Purchaseorder9802 { get; set; }
    }
}
