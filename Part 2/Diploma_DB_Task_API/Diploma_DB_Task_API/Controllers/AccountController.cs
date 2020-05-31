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
    public class AccountController : ControllerBase
    {
        private readonly Diploma_DB_TaskContext _context;

        public AccountController(Diploma_DB_TaskContext context)
        {
            _context = context;
        }

        // GET: api/Account
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Clientaccount9802>>> GetClientaccount()
        {
            return await _context.Clientaccount9802.ToListAsync();
        }

        // GET: api/Account/id/{id}
        /*[HttpGet("id/{id}")]
        public async Task<ActionResult<IEnumerable<Clientaccount9802>>> GetAccountById(int id)
        {

            SqlParameter p1 = new SqlParameter("@PACCOUNTID", id);
            var sql = "EXEC GET_CLIENT_ACCOUNT_BY_ID @PACCOUNTID";
            return await _context.Database.ExecuteSqlRaw(sql, p1);

        }*/

    }
}
