using System;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Web.Mvc;
using WebApplication1.Models;

namespace admin4.Controllers
{
    public class ChartController : Controller
    {
        private WatchStoreEntities9 db = new WatchStoreEntities9(); 

        public ActionResult Index()
        {
            // Filter data to only include orders from the year 2024

            // Filter and aggregate order data for the year 2023
            var data = db.Order
                .Where(o => o.OrderDate.HasValue && o.OrderDate.Value.Year == 2024) // Filter for orders in 2023
                .Join(db.OrderItem,
                      o => o.OrderID,
                      oi => oi.OrderID,
                      (o, oi) => new { o.OrderDate, oi.Quantity, oi.UnitPrice }) // Project required fields
                .GroupBy(x => new
                {
                    OrderYear = x.OrderDate.Value.Year, // Group by Year
                    OrderMonth = x.OrderDate.Value.Month // Group by Month
                })
                .Select(g => new
                {
                    OrderYear = g.Key.OrderYear, // Year
                    OrderMonth = g.Key.OrderMonth, // Month
                    TotalQuantity = g.Sum(x => x.Quantity), // Total Quantity
                    TotalRevenue = g.Sum(x => x.Quantity * x.UnitPrice) // Total Revenue
                })
                .OrderBy(x => x.OrderYear) // Order by Year
                .ThenBy(x => x.OrderMonth) // Then order by Month
                .ToList(); // Execute the query and convert to list


            // Check data (optional: for debugging purposes)
            foreach (var item in data)
            {
                Console.WriteLine($"Year: {item.OrderYear}, Month: {item.OrderMonth}, Quantity: {item.TotalQuantity}, Revenue: {item.TotalRevenue}");
            }

            // Pass data to ViewBag
            ViewBag.Dates = data.Select(d => $"{d.OrderMonth}-{d.OrderYear}").ToArray();
            ViewBag.TotalQuantities = data.Select(d => d.TotalQuantity).ToArray();
            ViewBag.TotalRevenues = data.Select(d => d.TotalRevenue).ToArray();

            return View();
        }

        public ActionResult Index2()
        {
            // Filter and aggregate order data for the year 2023
            var data = db.Order
                .Where(o => o.OrderDate.HasValue && o.OrderDate.Value.Year == 2023) // Filter for orders in 2023
                .Join(db.OrderItem,
                      o => o.OrderID,
                      oi => oi.OrderID,
                      (o, oi) => new { o.OrderDate, oi.Quantity, oi.UnitPrice }) // Project required fields
                .GroupBy(x => new
                {
                    OrderYear = x.OrderDate.Value.Year, // Group by Year
                    OrderMonth = x.OrderDate.Value.Month // Group by Month
                })
                .Select(g => new
                {
                    OrderYear = g.Key.OrderYear, // Year
                    OrderMonth = g.Key.OrderMonth, // Month
                    TotalQuantity = g.Sum(x => x.Quantity), // Total Quantity
                    TotalRevenue = g.Sum(x => x.Quantity * x.UnitPrice) // Total Revenue
                })
                .OrderBy(x => x.OrderYear) // Order by Year
                .ThenBy(x => x.OrderMonth) // Then order by Month
                .ToList(); // Execute the query and convert to list

            //// Check data (optional: for debugging purposes)
            foreach (var item in data)
            {
                Console.WriteLine($"Year: {item.OrderYear}, Month: {item.OrderMonth}, Quantity: {item.TotalQuantity}, Revenue: {item.TotalRevenue}");
            }

            // Pass data to ViewBag
            ViewBag.Dates = data.Select(d => $"{d.OrderMonth}-{d.OrderYear}").ToArray();
            ViewBag.TotalQuantities = data.Select(d => d.TotalQuantity).ToArray();
            ViewBag.TotalRevenues = data.Select(d => d.TotalRevenue).ToArray();

            return View();
        }

    }
}
