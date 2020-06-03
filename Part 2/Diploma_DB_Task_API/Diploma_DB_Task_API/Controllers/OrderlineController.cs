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
    public class OrderlineController : ControllerBase
    {
        private readonly Diploma_DB_TaskContext _context;

        public OrderlineController(Diploma_DB_TaskContext context)
        {
            _context = context;
        }

        [HttpPost]
        public async Task AddProductToOrder(Orderline9802 order)
        {
            SqlParameter p1 = new SqlParameter("@PORDERID", order.Orderid);
            SqlParameter p2 = new SqlParameter("@PPRODID", order.Productid);
            SqlParameter p3 = new SqlParameter("@PQTY", order.Quantity);
            SqlParameter p4 = new SqlParameter("@DISCOUNT", order.Discount);
            var sql = "EXEC ADD_PRODUCT_TO_ORDER @PORDERID, @PPRODID, @PQTY, @DISCOUNT";
            
            await _context.Database.ExecuteSqlRawAsync(sql, p1, p2, p3, p4);

        }

    }
}
