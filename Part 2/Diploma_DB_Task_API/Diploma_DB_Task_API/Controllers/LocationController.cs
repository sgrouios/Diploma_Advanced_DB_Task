using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Diploma_DB_Task_API.Models;
using Microsoft.Data.SqlClient;
using Microsoft.CodeAnalysis;
using System.Data;

namespace Diploma_DB_Task_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LocationController : ControllerBase
    {
        private readonly Diploma_DB_TaskContext _context;

        public LocationController(Diploma_DB_TaskContext context)
        {
            _context = context;
        }

        //GET: api/Location
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Location9802>>> GetLocation()
        {
            return await _context.Location9802.ToListAsync();
        }

        //POST: api/Location
        [HttpPost]
        public async Task<string> AddLocation(Location9802 location)
        {
            var output = new SqlParameter()
            {
                ParameterName = "@LOCID",
                DbType = System.Data.DbType.String,
                Size = 8,
                Direction = System.Data.ParameterDirection.Output
            };

            SqlParameter p1 = new SqlParameter("@PLOCID", location.Locationid);
            SqlParameter p2 = new SqlParameter("@PLOCNAME", location.Locname);
            SqlParameter p3 = new SqlParameter("@PLOCADDRESS", location.Address);
            SqlParameter p4 = new SqlParameter("@PMANAGER", location.Manager);

            var sql = "EXEC ADD_LOCATION @PLOCID, @PLOCNAME, @PLOCADDRESS, @PMANAGER, @LOCID OUT";
            await _context.Database.ExecuteSqlRawAsync(sql, p1, p2, p3, p4, output);
            return output.Value.ToString();
        }

        // GET: api/Location/id/{id}
        [HttpGet("id/{id}")]
        public async Task<ActionResult<IEnumerable<Location9802>>> GetLocationById(string id)
        {
            SqlParameter p1 = new SqlParameter("@PLOCID", id);
            return await _context.Location9802.FromSqlRaw("EXEC GET_LOCATION_BY_ID @PLOCID", p1).ToListAsync();
        }

    }
}
