using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ContainerApp.ItemsApi.Models;
using Microsoft.Extensions.Logging;
using ContainerApp.ItemsApi.Repository.Interfaces;

namespace ContainerApp.ItemsApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ItemsController : ControllerBase
    {
        private IItemsRepository _repository;
        private ILogger<ItemsController> _logger;

        public ItemsController(IItemsRepository repository, ILogger<ItemsController> logger)
        {
            _repository = repository;
            _logger = logger;
        }

        // GET ALL
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Items>>> GetItems()
        {
            try
            {
                _logger.LogInformation("Method - GetItems");
                return await _repository.GetAll();
            }
            catch(Exception ex)
            {
                _logger.LogError("ERROR: " + ex.ToString());
                throw;
            }
        }

        // GET
        [HttpGet("{id}")]
        public async Task<ActionResult<Items>> GetItems(int id)
        {
            try
            {
                _logger.LogInformation("Method - GetItems");
                _logger.LogInformation("Param - Id = " + id);

                var Items = await _repository.Get(id);

                if (Items == null)
                {
                    return NotFound();
                }

                return Items;
            }
            catch(Exception ex)
            {
                _logger.LogError("ERROR: " + ex.ToString());
                throw;
            }
            
        }

        // UPDATE
        [HttpPut("{id}")]
        public async Task<IActionResult> PutItems(int id, Items Items)
        {
            try
            {
                _logger.LogInformation("Method - PutItems");
                _logger.LogInformation("Param - Id = " + id);
                _logger.LogInformation("Param - Items = " + Items);
                
                if (id != Items.Id)
                {
                    return BadRequest();
                }

                await _repository.Update(Items);
            
                return Ok();
            }
            catch(Exception ex)
            {
                _logger.LogError("ERROR: " + ex.ToString());
                throw;
            }
        }

        // ADD
        [HttpPost]
        public async Task<ActionResult<Items>> PostItems(Items Items)
        {
            try
            {
                _logger.LogInformation("Method - PostItems");
                _logger.LogInformation("Param - Items = " + Items);

                await _repository.Add(Items);
                
                return CreatedAtAction(nameof(GetItems), new { id = Items.Id }, Items);
            }
            catch(Exception ex)
            {
                _logger.LogError("ERROR: " + ex.ToString());
                throw;
            }
        }

        // DELETE
        [HttpDelete("{id}")]
        public async Task<ActionResult> DeleteItems(int id)
        {
            try
            {
                _logger.LogInformation("Method - DeleteItems");
                _logger.LogInformation("Param - Id = " + id);

                bool res = await _repository.Delete(id);
                
                return Ok();
            }
            catch(Exception ex)
            {
                _logger.LogError("ERROR: " + ex.ToString());
                throw;
            }
        }
    }
}