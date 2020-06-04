using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Diploma_DB_Task_API.Models;
using Microsoft.Data.SqlClient;

namespace Diploma_DB_Task_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PaymentController : ControllerBase
    {
        private readonly Diploma_DB_TaskContext _context;

        public PaymentController(Diploma_DB_TaskContext context)
        {
            _context = context;
        }

        //POST: api/Payment
        [HttpPost]
        public async Task<IActionResult> MakeAccountPayment(Accountpayment9802 payment)
        {
            SqlParameter p1 = new SqlParameter("@PACCOUNTID", payment.Accountid);
            SqlParameter p2 = new SqlParameter("@PAMOUNT", payment.Amount);

            var sql = "EXEC MAKE_ACCOUNT_PAYMENT @PACCOUNTID, @PAMOUNT";
            await _context.Database.ExecuteSqlRawAsync(sql, p1, p2);

            return Accepted();
        }
    }
}
