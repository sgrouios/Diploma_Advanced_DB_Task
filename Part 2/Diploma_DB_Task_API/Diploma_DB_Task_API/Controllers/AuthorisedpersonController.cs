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
    public class AuthorisedpersonController : ControllerBase
    {
        private readonly Diploma_DB_TaskContext _context;

        public AuthorisedpersonController(Diploma_DB_TaskContext context)
        {
            _context = context;
        }

        //POST: api/Authorisedperson
        [HttpPost]
        public async Task<int> AddAuthorisedPerson(Authorisedperson9802 authPer)
        {
            var accountNum = new SqlParameter()
            {
                ParameterName = "@ACCOUNTNUM",
                DbType = System.Data.DbType.Int32,
                Direction = System.Data.ParameterDirection.Output
            };

            SqlParameter p1 = new SqlParameter("@PFIRSTNAME", authPer.Firstname);
            SqlParameter p2 = new SqlParameter("@PSURNAME", authPer.Surname);
            SqlParameter p3 = new SqlParameter("@PEMAIL", authPer.Email);
            SqlParameter p4 = new SqlParameter("@PPASSWORD", authPer.Password);
            SqlParameter p5 = new SqlParameter("@PACCOUNTID", authPer.Accountid);

            var sql = "EXEC @ACCOUNTNUM = ADD_AUTHORISED_PERSON @PFIRSTNAME, @PSURNAME, @PEMAIL, @PPASSWORD, @PACCOUNTID";
            await _context.Database.ExecuteSqlRawAsync(sql, accountNum, p1, p2, p3, p4, p5);
            return Convert.ToInt32(accountNum.Value);
        }

    }
}
