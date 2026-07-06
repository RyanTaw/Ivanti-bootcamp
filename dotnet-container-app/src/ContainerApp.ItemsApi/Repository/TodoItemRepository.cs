using System;
using System.Collections.Generic;
using ContainerApp.ItemsApi.Models;
using ContainerApp.ItemsApi.Repository.Interfaces;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace ContainerApp.ItemsApi.Repository
{
    public class ItemsItemRepository : IItemsItemRepository
    {
        private readonly MyDbContext _context;

        public ItemsItemRepository(MyDbContext context)
        {
            _context = context;
        }
        async Task<bool> IItemsItemRepository.Add(ItemsItem model)
        {
            _context.ItemsItems.Add(model);
            int res = await _context.SaveChangesAsync();
            return true;
        }

        async Task<bool> IItemsItemRepository.Delete(int id)
        {
            var _item = await _context.ItemsItems.FindAsync(id);
            _context.ItemsItems.Remove(_item);
            int res = await _context.SaveChangesAsync();
            return true;
        }

        async Task<ItemsItem> IItemsItemRepository.Get(int id)
        {
            return await _context.ItemsItems.FindAsync(id);
        }

        async Task<List<ItemsItem>> IItemsItemRepository.GetAll()
        {
            return await _context.ItemsItems.ToListAsync();
        }

        async Task<bool> IItemsItemRepository.Update(ItemsItem model)
        {
            _context.Entry(model).State = EntityState.Modified;
            int res = await _context.SaveChangesAsync();
            return true;
        }
    }
}