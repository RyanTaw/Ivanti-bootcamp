using ContainerApp.ItemsApi.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ContainerApp.ItemsApi.Repository.Interfaces
{  
    public interface IItemsRepository   
    {
        /*
        Exemplo de como implementar repository pattern
        https://www.c-sharpcorner.com/article/repository-pattern-in-asp-net-core/
        */

        Task<bool> Add(Items model);  
        Task<List<Items>> GetAll();  
        Task<Items> Get(int id);  
        Task<bool> Delete(int id);  
        Task<bool> Update(Items model);  
    }  
}