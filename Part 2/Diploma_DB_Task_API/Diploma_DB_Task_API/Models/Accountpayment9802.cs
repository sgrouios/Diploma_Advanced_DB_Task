using System;
using System.Collections.Generic;

namespace Diploma_DB_Task_API.Models
{
    public partial class Accountpayment9802
    {
        public int Accountid { get; set; }
        public DateTime Datetimereceived { get; set; }
        public decimal Amount { get; set; }

        public virtual Clientaccount9802 Account { get; set; }
    }
}
