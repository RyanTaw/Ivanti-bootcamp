using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;
using System.Linq;
using ContainerApp.ItemsApi.Repository.Interfaces;
using ContainerApp.ItemsApi.Repository;
using ContainerApp.ItemsApi.Models;

namespace ContainerApp.Test
{
    [TestClass]
    public class ItemsIntegrationTest
    {
        private IItemsRepository _repository;

        [TestInitialize()]
        public void Initialize()
        {
            var options = new DbContextOptionsBuilder<MyDbContext>()
                .UseInMemoryDatabase(databaseName: "MyDataDatabase")
                .Options;

            _repository = new ItemsRepository(new MyDbContext(options));
        }

        [TestMethod]
        [TestCategory("Category1")]
        [Priority(1)]
        public void Add_Items_Items()
        {
            Task.Run(async () =>
            {
                Items Items1 = new Items();
                Items1.Name = "Items Item Name 1";
                Items1._IsComplete = 0;
                var res1 = await _repository.Add(Items1);
                Assert.IsTrue(res1);

            }).GetAwaiter().GetResult();
        }

        [TestMethod]
        [TestCategory("Category1")]
        [Priority(1)]
        public void Add_Two_Items_Items()
        {
            Task.Run(async () =>
            {
                Items Items2 = new Items();
                Items2.Name = "Items Item Name 2";
                Items2._IsComplete = 0;
                var res2 = await _repository.Add(Items2);
                Assert.IsTrue(res2);

                Items Items3 = new Items();
                Items3.Name = "Items Item Name 3";
                Items3._IsComplete = 1;
                var res3 = await _repository.Add(Items3);
                Assert.IsTrue(res3);

            }).GetAwaiter().GetResult();
        }

        [TestMethod]
        [TestCategory("Category2")]
        [Priority(2)]
        public void Get_All_Itemss()
        {
            Task.Run(async () =>
            {
                var resGetAll = await _repository.GetAll();
                Assert.IsTrue(resGetAll.Count > 0 );
                Assert.AreEqual(resGetAll.ElementAt(0).Name, "Items Item Name 1");

            }).GetAwaiter().GetResult();
        }

        [TestMethod]
        [TestCategory("Category2")]
        [Priority(2)]
        public void Get_Items_By_Id()
        {
            Task.Run(async () =>
            {
                var resGet = await _repository.Get(1);
                Assert.IsNotNull(resGet);
                Assert.AreEqual(resGet.Name, "Items Item Name 1");
            }).GetAwaiter().GetResult();
        }

        [TestMethod]
        [TestCategory("Category2")]
        [Priority(2)]
        public void Delete_Items_By_Id()
        {
            Task.Run(async () =>
            {
                var res = await _repository.Delete(1);
                Assert.IsTrue(res);
            }).GetAwaiter().GetResult();
        }

        [TestMethod]
        [TestCategory("Category2")]
        [Priority(2)]
        public void Update_Items_Item()
        {
            Task.Run(async () =>
            {
                var resGet = await _repository.Get(2);
                resGet.Name = "Items Item Name Update";
                resGet._IsComplete = 1;
                var res1 = await _repository.Update(resGet);
                Assert.IsTrue(res1);

            }).GetAwaiter().GetResult();
        }

        [TestMethod]
        [TestCategory("Category2")]
        [Priority(2)]
        public void MyTest_Items_Item()
        {
            Assert.IsTrue(true);
        }
    }
}