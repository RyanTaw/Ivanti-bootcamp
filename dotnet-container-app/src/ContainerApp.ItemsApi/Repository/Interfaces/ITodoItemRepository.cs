using ContainerApp.ItemsApi.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ContainerApp.ItemsApi.Repository.Interfaces
{  
    public interface IItemsItemRepository   
    {
        /*
        Exemplo de como implementar repository pattern
        https://www.c-sharpcorner.com/article/repository-pattern-in-asp-net-core/
        */

        Task<bool> Add(ItemsItem model);  
        Task<List<ItemsItem>> GetAll();  
        Task<ItemsItem> Get(int id);  
        Task<bool> Delete(int id);  
        Task<bool> Update(ItemsItem model);  
    }  
}