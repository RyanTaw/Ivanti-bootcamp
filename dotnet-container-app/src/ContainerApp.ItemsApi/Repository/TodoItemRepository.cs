using System;
using System.Collections.Generic;
using ContainerApp.ItemsApi.Models;
using ContainerApp.ItemsApi.Repository.Interfaces;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace ContainerApp.ItemsApi.Repository
{
    public class ItemsRepository : IItemsRepository
    {
        private readonly MyDbContext _context;

        public ItemsRepository(MyDbContext context)
        {
            _context = context;
        }
        async Task<bool> IItemsRepository.Add(Items model)
        {
            _context.Items.Add(model);
            int res = await _context.SaveChangesAsync();
            return true;
        }

        async Task<bool> IItemsRepository.Delete(int id)
        {
            var _item = await _context.Items.FindAsync(id);
            _context.Items.Remove(_item);
            int res = await _context.SaveChangesAsync();
            return true;
        }

        async Task<Items> IItemsRepository.Get(int id)
        {
            return await _context.Items.FindAsync(id);
        }

        async Task<List<Items>> IItemsRepository.GetAll()
        {
            return await _context.Items.ToListAsync();
        }

        async Task<bool> IItemsRepository.Update(Items model)
        {
            _context.Entry(model).State = EntityState.Modified;
            int res = await _context.SaveChangesAsync();
            return true;
        }
    }
}