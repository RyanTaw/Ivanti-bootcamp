using Microsoft.EntityFrameworkCore;

namespace ContainerApp.ItemsApi.Models
{
    public class MyDbContext : DbContext
    {
        public MyDbContext(DbContextOptions<MyDbContext> options)
            : base(options)
        {
        }

        public DbSet<Items> Items { get; set; }
    }
}