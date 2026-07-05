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
    public class ItemsItemsController : ControllerBase
    {
        private IItemsItemRepository _repository;
        private ILogger<ItemsItemsController> _logger;

        public ItemsItemsController(IItemsItemRepository repository, ILogger<ItemsItemsController> logger)
        {
            _repository = repository;
            _logger = logger;
        }

        // GET ALL
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ItemsItem>>> GetItemsItems()
        {
            try
            {
                _logger.LogInformation("Method - GetItemsItems");
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
        public async Task<ActionResult<ItemsItem>> GetItemsItem(int id)
        {
            try
            {
                _logger.LogInformation("Method - GetItemsItem");
                _logger.LogInformation("Param - Id = " + id);

                var itemsItem = await _repository.Get(id);

                if (itemsItem == null)
                {
                    return NotFound();
                }

                return itemsItem;
            }
            catch(Exception ex)
            {
                _logger.LogError("ERROR: " + ex.ToString());
                throw;
            }
            
        }

        // UPDATE
        [HttpPut("{id}")]
        public async Task<IActionResult> PutItemsItem(int id, ItemsItem itemsItem)
        {
            try
            {
                _logger.LogInformation("Method - PutItemsItem");
                _logger.LogInformation("Param - Id = " + id);
                _logger.LogInformation("Param - itemsItem = " + itemsItem);
                
                if (id != itemsItem.Id)
                {
                    return BadRequest();
                }

                await _repository.Update(itemsItem);
            
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
        public async Task<ActionResult<ItemsItem>> PostItemsItem(ItemsItem itemsItem)
        {
            try
            {
                _logger.LogInformation("Method - PostItemsItem");
                _logger.LogInformation("Param - itemsItem = " + itemsItem);

                await _repository.Add(itemsItem);
                
                return CreatedAtAction(nameof(GetItemsItem), new { id = itemsItem.Id }, itemsItem);
            }
            catch(Exception ex)
            {
                _logger.LogError("ERROR: " + ex.ToString());
                throw;
            }
        }

        // DELETE
        [HttpDelete("{id}")]
        public async Task<ActionResult> DeleteItemsItem(int id)
        {
            try
            {
                _logger.LogInformation("Method - DeleteItemsItem");
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