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
    public class Location9802Controller : ControllerBase
    {
        private readonly Diploma_DB_TaskContext _context;

        public Location9802Controller(Diploma_DB_TaskContext context)
        {
            _context = context;
        }

        // GET: api/Location9802
        [HttpGet("id")]
        public async Task<ActionResult<IEnumerable<Location9802>>> GetLocationById(string id)
        {
            return await _context.Location9802.FromSqlRaw($"EXEC GET_LOCATION_BY_ID @PLOCID = {id}").ToListAsync();
        }

        [HttpPost]
        public string AddLocation(Location9802 location)
        {
            var output = new SqlParameter()
            {
                ParameterName = "@LOCID",
                DbType = System.Data.DbType.String,
                Size = 8,
                Direction = System.Data.ParameterDirection.Output
        };

            var sql = $"EXEC ADD_LOCATION '{location.Locationid}', '{location.Locname}', '{location.Address}', '{location.Manager}', @LOCID OUT";
            _context.Database.ExecuteSqlRaw(sql, output);
            return output.Value.ToString();
        }

        public async Task<ActionResult<IEnumerable<Location9802>>> GetLocation9802()
        {
            return await _context.Location9802.ToListAsync();
        }

        /*[HttpGet]
        // GET: api/Location9802/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Location9802>> GetLocation9802(string id)
        {
            var location9802 = await _context.Location9802.FindAsync(id);

            if (location9802 == null)
            {
                return NotFound();
            }

            return location9802;
        }*/

        // PUT: api/Location9802/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        /*[HttpPut("{id}")]
        public async Task<IActionResult> PutLocation9802(string id, Location9802 location9802)
        {
            if (id != location9802.Locationid)
            {
                return BadRequest();
            }

            _context.Entry(location9802).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!Location9802Exists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }*/

        // POST: api/Location9802
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        /*[HttpPost]
        public async Task<ActionResult<Location9802>> PostLocation9802(Location9802 location9802)
        {
            _context.Location9802.Add(location9802);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (Location9802Exists(location9802.Locationid))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtAction("GetLocation9802", new { id = location9802.Locationid }, location9802);
        }*/

        // DELETE: api/Location9802/5
        /*[HttpDelete("{id}")]
        public async Task<ActionResult<Location9802>> DeleteLocation9802(string id)
        {
            var location9802 = await _context.Location9802.FindAsync(id);
            if (location9802 == null)
            {
                return NotFound();
            }

            _context.Location9802.Remove(location9802);
            await _context.SaveChangesAsync();

            return location9802;
        }
        */
        private bool Location9802Exists(string id)
        {
            return _context.Location9802.Any(e => e.Locationid == id);
        }
    }
}
