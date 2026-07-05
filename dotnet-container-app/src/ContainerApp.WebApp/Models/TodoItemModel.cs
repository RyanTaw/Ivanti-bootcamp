using System.ComponentModel.DataAnnotations;

namespace ContainerApp.WebApp.Models
{
    public class ItemsItemModel
    {
        public long Id { get; set; }
        //[Required]
        public string Name { get; set; }
        public bool IsComplete { get; set; }
    }
}