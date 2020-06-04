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
    public class OrderController : ControllerBase
    {
        private readonly Diploma_DB_TaskContext _context;

        public OrderController(Diploma_DB_TaskContext context)
        {
            _context = context;
        }

        // GET: api/Order
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Order9802>>> GetOrders()
        {
            var sql = "EXEC GET_OPEN_ORDERS";
            return await _context.Order9802.FromSqlRaw(sql).ToListAsync();
        }

        [HttpPost]
        public async Task<int> CreateOrder(Order9802 order)
        {
            SqlParameter orderId = new SqlParameter()
            {
                ParameterName = "@ORDERID",
                DbType = System.Data.DbType.Int32,
                Direction = System.Data.ParameterDirection.Output,
                Size = 200
            };

            SqlParameter p1 = new SqlParameter("@PSHIPPINGADDRESS", order.Shippingaddress);
            SqlParameter p2 = new SqlParameter("@PUSERID", order.Userid);
            var sql = "EXEC @ORDERID = CREATE_ORDER @PSHIPPINGADDRESS, @PUSERID";

            await _context.Database.ExecuteSqlRawAsync(sql, orderId, p1, p2);
            return Convert.ToInt32(orderId.Value);
        }


        [HttpGet("id")]
        public async Task<ActionResult<IEnumerable<OrderDetails>>> GetOrderById(Order9802 order)
        {
            SqlParameter p1 = new SqlParameter("@PORDERID", order.Orderid);
            var sql = "EXEC GET_ORDER_BY_ID @PORDERID";
            return await _context.OrderDetails.FromSqlRaw(sql, p1).ToListAsync();
        }

        // check this with Tim
        [HttpPut]
        public async Task<IActionResult> FulfillOrder(int orderId)
        {
            SqlParameter p1 = new SqlParameter("@PORDERID", orderId);
            var sql = "EXEC FULLFILL_ORDER @PORDERID";

            await _context.Database.ExecuteSqlRawAsync(sql, p1);

            return Accepted();
        }

    }
}
