using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Diploma_DB_Task_API.Models;
using Microsoft.Data.SqlClient;
using System.Data;

namespace Diploma_DB_Task_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductController : ControllerBase
    {
        private readonly Diploma_DB_TaskContext _context;

        public ProductController(Diploma_DB_TaskContext context)
        {
            _context = context;
        }

        // GET: api/Product
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Product9802>>> GetProducts()
        {
            return await _context.Product9802.ToListAsync();
        }

        //POST: api/Product
        [HttpPost]
        public async Task<int> AddProduct(Product9802 product)
        {
            SqlParameter output = new SqlParameter()
            {
                ParameterName = "@RETURN",
                DbType = System.Data.DbType.Int32,
                Direction = ParameterDirection.Output
            };

            SqlParameter p1 = new SqlParameter("@PRODNAME", product.Prodname);
            SqlParameter p2 = new SqlParameter("@PBUYPRICE", product.Buyprice);
            SqlParameter p3 = new SqlParameter("@PSELLPRICE", product.Sellprice);

            var sql = "EXEC @RETURN = ADD_PRODUCT @PRODNAME, @PBUYPRICE, @PSELLPRICE";
            await _context.Database.ExecuteSqlRawAsync(sql, output, p1, p2, p3);
            return Convert.ToInt32(output.Value);
        }

        // GET: api/Product/id/{id}
        [HttpGet("id/{id}")]
        public async Task<ActionResult<IEnumerable<Product9802>>> GetProductById(string id)
        {
            SqlParameter p1 = new SqlParameter("@PPRODID", id);
            return await _context.Product9802.FromSqlRaw("EXEC GET_PRODUCT_BY_ID @PPRODID", p1).ToListAsync();
        }
    }
}
