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

        //POST: api/Account
        [HttpPost]
        public async Task<int> AddClientAccount(Clientaccount9802 account)
        {
            var accountNum = new SqlParameter()
            {
                ParameterName = "@ACCOUNTNUM",
                DbType = System.Data.DbType.Int32,
                Direction = System.Data.ParameterDirection.Output
            };

            SqlParameter p1 = new SqlParameter("@PACCTNAME", account.Acctname);
            SqlParameter p2 = new SqlParameter("@PBALANCE", account.Balance);
            SqlParameter p3 = new SqlParameter("@PCREDITLIMIT", account.Creditlimit);

            var sql = "EXEC @ACCOUNTNUM = ADD_CLIENT_ACCOUNT @PACCTNAME, @PBALANCE, @PCREDITLIMIT";
            await _context.Database.ExecuteSqlRawAsync(sql, accountNum, p1, p2, p3);
            return Convert.ToInt32(accountNum.Value);
        }

        // GET: api/Account/id/{id}
        [HttpGet("id/{id}")]
        public async Task<ActionResult<IEnumerable<ClientAuthorised>>> GetAccountById(int id)
        {
            SqlParameter p1 = new SqlParameter("@PACCOUNTID", id);
            var sql = "EXEC GET_CLIENT_ACCOUNT_BY_ID @PACCOUNTID";
            return await _context.ClientAuthorised.FromSqlRaw(sql, p1).ToListAsync();

        }

    }
}
