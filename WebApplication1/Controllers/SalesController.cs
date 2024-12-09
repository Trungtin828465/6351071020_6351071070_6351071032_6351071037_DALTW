using iTextSharp.text.pdf;
using iTextSharp.text;
using Microsoft.Ajax.Utilities;
using Org.BouncyCastle.Asn1.X509;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using WebApplication1.Models;

namespace WebApplication1.Controllers
{

    public class TopProductByIncome
    {
        public string CustomerName { get; set; }
        public string ProductName { get; set; }
        public int Quantity { get; set; }
        public decimal Income { get; set; }
        public string brandName { get; set; }
        public string URL { get; set; }
    }

    public class ProductSales
    {
        public string ProductName { get; set; }
        public int TotalQuantitySold { get; set; }

        public decimal TotalRevenue { get; set; }
        public string brandName { get; set; }
        public string URL { get; set; }


    }

    public class SalesController : Controller
    {
        private WatchStoreEntities9 db = new WatchStoreEntities9();
        // GET: Sales

        //Doanh thu
        public JsonResult GetMonthlyRevenue(int? year)
        {
            {
                // Filter for approved orders
                var query = db.Order
                    .Where(o => o.Status == "Approved");

                // Filter by year if provided
                if (year.HasValue)
                {
                    query = query.Where(o => o.OrderDate.HasValue && o.OrderDate.Value.Year == year.Value);
                }

                // Calculate monthly revenue
                var revenueData = query
                    .SelectMany(o => o.OrderItem, (o, oi) => new
                    {
                        o.OrderDate,
                        Revenue = oi.Quantity * oi.UnitPrice
                    })
                    .GroupBy(x => new { Year = x.OrderDate.Value.Year, Month = x.OrderDate.Value.Month })
                    .Select(g => new
                    {
                        Year = g.Key.Year,
                        Month = g.Key.Month,
                        TotalRevenue = g.Sum(x => x.Revenue) // Sum revenue for the group
                    })
                    .OrderBy(result => result.Year)
                    .ThenBy(result => result.Month)
                    .ToList();

                return Json(revenueData, JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult GetYears()
        {
            var years = db.Order
                .Select(o => o.OrderDate.Value.Year)
                .Distinct()
                .OrderBy(y => y)
                .ToList();

            return Json(years, JsonRequestBehavior.AllowGet);
        }

        // API trả về số lượng đơn hàng theo trạng thái 'Approved', 'Pending', 'Rejected'
        public JsonResult GetOrderStatusCounts()
        {
            var orderStatusCounts = db.Order
                .Where(o => o.Status == "Approved" || o.Status == "Pending" || o.Status == "Rejected") // Lọc theo trạng thái
                .GroupBy(o => o.Status)
                .Select(group => new
                {
                    Status = group.Key,
                    Count = group.Count()
                })
                .OrderBy(result => result.Status) // Sắp xếp theo tên trạng thái
                .ToList();

            return Json(orderStatusCounts, JsonRequestBehavior.AllowGet);
        }

        public ActionResult OrderStatusChart()
        {
            return View();
        }


        // API trả về số lượng đơn hàng đã bán và chưa bán
        public JsonResult GetSalesStatusCounts()
        {
            var salesStatusCounts = db.Order
                .GroupBy(o => o.Status)
                .Where(group => group.Key == "Approved" || group.Key == "Pending" || group.Key == "Rejected")
                .Select(group => new
                {
                    Status = group.Key,
                    Count = group.Count()
                })
                .ToList();

            // Tạo một đối tượng chứa số lượng "Đã bán" và "Chưa bán"
            var result = new
            {
                Sold = salesStatusCounts.FirstOrDefault(s => s.Status == "Approved")?.Count ?? 0,
                NotSold = salesStatusCounts.Where(s => s.Status == "Pending" || s.Status == "Rejected").Sum(s => s.Count)
            };
            return Json(result, JsonRequestBehavior.AllowGet);
        }



        //Doanh thu trung binh
        public JsonResult GetMonthlyProfit(int? year)
        {
            WatchStoreEntities9 db = new WatchStoreEntities9();

            // Build the query with LINQ
            var query = db.Order
                .Where(o => o.Status == "Approved" && (year == null || o.OrderDate.Value.Year == year))
                .GroupBy(o => new { Year = o.OrderDate.Value.Year, Month = o.OrderDate.Value.Month })
                .Select(g => new
                {
                    Year = g.Key.Year,
                    Month = g.Key.Month,
                    AverageRevenue = g.Sum(o => o.OrderItem.Sum(oi => oi.Quantity * oi.UnitPrice))
                                    / g.Select(o => o.OrderID).Distinct().Count()
                })
                .OrderBy(r => r.Year)
                .ThenBy(r => r.Month)
                .ToList();

            // Return as JSON
            return Json(query, JsonRequestBehavior.AllowGet);
        }


        //Danh sach khách hang trong tháng 

        public ActionResult GetMonthlyCustomerCount()
        {
            using (var db = new WatchStoreEntities9())
            {
                var monthlyCustomerCounts = db.Order
                    .Where(o => o.Status == "Approved")
                    .AsEnumerable() // Đưa dữ liệu từ database vào bộ nhớ
                    .GroupBy(o => o.OrderDate.Value.ToString("yyyy-MM")) // Định dạng trong bộ nhớ
                    .Select(g => new
                    {
                        Month = g.Key,
                        CustomerCount = g.Select(o => o.CustomerID).Distinct().Count()
                    })
                    .OrderBy(result => result.Month)
                    .ToList();

                return Json(monthlyCustomerCounts, JsonRequestBehavior.AllowGet);
            }

        }


        public ActionResult Index()
        {
            // Lấy Top 5 sản phẩm theo thu nhập
            var topProductsByIncome = db.OrderItem
                .Where(oi => oi.Order.Status == "Approved") // Lọc các đơn hàng đã hoàn thành
                .Select(oi => new TopProductByIncome
                {
                    CustomerName = oi.Order.Customer.FullName,
                    ProductName = oi.Product.ProductName,
                    URL = oi.Product.ImageUrl,
                    Quantity = oi.Quantity,
                    Income = (decimal)(oi.Quantity * oi.UnitPrice),
                    brandName = oi.Product.Brand.BrandName,
                    

                })
                .OrderByDescending(x => x.Income) // Sắp xếp theo thu nhập giảm dần
                .Take(5) // Lấy 5 sản phẩm
                .ToList();

            // Truyền dữ liệu sang View bằng ViewBag
            ViewBag.TopProductsByIncome = topProductsByIncome;


            //top san phâm bán nhiêu nhất
            //     var topSellingProducts = db.OrderItem
            //.Where(oi => oi.Order.Status == "Approved") // Lọc các đơn hàng đã thanh toán
            //.GroupBy(oi => oi.Product) // Nhóm theo sản phẩm
            //.Select(group => new ProductSales
            //{
            //    ProductName = group.Key.ProductName, // Tên sản phẩm
            //    TotalQuantitySold = group.Sum(oi => oi.Quantity) // Tổng số lượng bán
            //})
            //.OrderByDescending(x => x.TotalQuantitySold) // Sắp xếp theo số lượng bán giảm dần
            //.Take(6) // Lấy 6 sản phẩm bán chạy nhất
            //.ToList();

            //     ViewBag.TopSellingProducts = topSellingProducts;
            var topSellingProducts = db.OrderItem
     .Where(oi => oi.Order.Status == "Approved") // Lọc các đơn hàng đã thanh toán
     .GroupBy(oi => new { oi.Product.ProductName, oi.Product.Brand.BrandName, oi.Product.ImageUrl }) // Nhóm theo sản phẩm và thương hiệu
     .Select(group => new ProductSales
     {
         ProductName = group.Key.ProductName, // Tên sản phẩm
         brandName = group.Key.BrandName, // Tên thương hiệu
         TotalQuantitySold = group.Sum(oi => oi.Quantity), // Tổng số lượng bán
         URL = group.Key.ImageUrl // URL hình ảnh
     })
     .OrderByDescending(x => x.TotalQuantitySold) // Sắp xếp theo số lượng bán giảm dần
     .Take(6) // Lấy 6 sản phẩm bán chạy nhất
     .ToList();

            ViewBag.TopSellingProducts = topSellingProducts;




            // san pham bán ít nhất 
            var top5LowestRevenueProducts = db.OrderItem
       .Where(oi => oi.Order.Status == "Approved") // Lọc các đơn hàng đã hoàn thành
     .GroupBy(oi => new { oi.Product.ProductName, oi.Product.Brand.BrandName, oi.Product.ImageUrl }) // Nhóm theo sản phẩm và thương hiệu
       .Select(group => new ProductSales
       {
           ProductName = group.Key.ProductName, // Tên sản phẩm
           TotalRevenue = group.Sum(oi => (decimal)(oi.Quantity * oi.UnitPrice)), // Tính doanh thu
                    brandName = group.Key.BrandName, // Tên thương hiệu
           URL = group.Key.ImageUrl // URL hình ảnh


       })
       .OrderBy(x => x.TotalRevenue) // Sắp xếp theo doanh thu tăng dần
       .Take(6) // Lấy 5 sản phẩm có doanh thu ít nhất
       .ToList();

            ViewBag.Top5LowestRevenueProducts = top5LowestRevenueProducts;



            // Lấy số lượng từng trạng thái cụ thể
            var pendingCount = db.Order.Count(o => o.Status == "Pending");
            var approvedCount = db.Order.Count(o => o.Status == "Approved");
            var rejectedCount = db.Order.Count(o => o.Status == "Rejected");

            // Gán vào ViewBag để sử dụng trong View
            ViewBag.PendingCount = pendingCount;
            ViewBag.ApprovedCount = approvedCount;
            ViewBag.RejectedCount = rejectedCount;


            return View();
        }


        public ActionResult ExportToPDF_top5LowestRevenueProducts()
        {
            // Lấy danh sách các sản phẩm có doanh thu thấp nhất
            var top5LowestRevenueProducts = db.OrderItem
                .Where(oi => oi.Order.Status == "Approved") // Lọc các đơn hàng đã hoàn thành
                .GroupBy(oi => oi.Product) // Nhóm theo sản phẩm
                .Select(group => new ProductSales
                {
                    ProductName = group.Key.ProductName, // Tên sản phẩm
                    TotalRevenue = group.Sum(oi => (decimal)(oi.Quantity * oi.UnitPrice)) // Tính doanh thu
                })
                .OrderBy(x => x.TotalRevenue) // Sắp xếp theo doanh thu tăng dần
                .Take(6) // Lấy 5 sản phẩm có doanh thu thấp nhất
                .ToList();

            // Tạo tài liệu PDF
            Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 20f, 20f);
            MemoryStream memoryStream = new MemoryStream();

            PdfWriter writer = PdfWriter.GetInstance(pdfDoc, memoryStream);
            pdfDoc.Open();

            try
            {
                // Đường dẫn đến file font
                string fontPath = Server.MapPath("~/Content/Font/NotoSans.ttf");

                // Kiểm tra nếu file font không tồn tại
                if (!System.IO.File.Exists(fontPath))
                {
                    throw new FileNotFoundException("Font không tồn tại tại đường dẫn: " + fontPath);
                }

                // Sử dụng font tùy chỉnh
                BaseFont baseFont = BaseFont.CreateFont(fontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
                Font font = new Font(baseFont, 12, Font.NORMAL);
                Font headerFont = new Font(baseFont, 14, Font.BOLD);

                // Tiêu đề
                pdfDoc.Add(new Paragraph("DANH SÁCH SẢN PHẨM DOANH THU THẤP NHẤT", headerFont));
                pdfDoc.Add(new Paragraph(" ")); // Dòng trống

                // Bảng dữ liệu
                PdfPTable table = new PdfPTable(2) { WidthPercentage = 100 }; // 2 cột: Tên sản phẩm và Doanh thu

                // Cài đặt độ rộng cột
                table.SetWidths(new float[] { 70f, 30f });

                // Thêm header
                table.AddCell(new PdfPCell(new Phrase("Tên Sản Phẩm", headerFont)) { HorizontalAlignment = Element.ALIGN_CENTER });
                table.AddCell(new PdfPCell(new Phrase("Doanh Thu", headerFont)) { HorizontalAlignment = Element.ALIGN_CENTER });

                // Thêm dữ liệu sản phẩm vào bảng
                foreach (var item in top5LowestRevenueProducts)
                {
                    table.AddCell(new PdfPCell(new Phrase(item.ProductName, font)) { HorizontalAlignment = Element.ALIGN_LEFT });
                    table.AddCell(new PdfPCell(new Phrase(item.TotalRevenue.ToString("C0"), font)) { HorizontalAlignment = Element.ALIGN_RIGHT }); // Hiển thị doanh thu dưới dạng tiền tệ
                }

                pdfDoc.Add(table);
            }
            catch (Exception ex)
            {
                // Thêm thông báo lỗi vào PDF (dành cho kiểm tra trong quá trình phát triển)
                pdfDoc.Add(new Paragraph("Có lỗi xảy ra: " + ex.Message));
            }
            finally
            {
                // Đóng tài liệu
                pdfDoc.Close();
            }

            // Trả file PDF về client
            byte[] bytes = memoryStream.ToArray();
            memoryStream.Close();

            return File(bytes, "application/pdf", "Top5LowestRevenueProducts.pdf");
        }




        //SAN PHAM BAN CHAY NHAT
        public ActionResult ExportToPDF_topSellingProducts()
        {
            // Lấy danh sách các sản phẩm bán chạy nhất
            var topSellingProducts = db.OrderItem
                .Where(oi => oi.Order.Status == "Approved") // Lọc các đơn hàng đã thanh toán
                .GroupBy(oi => oi.Product) // Nhóm theo sản phẩm
                .Select(group => new ProductSales
                {
                    ProductName = group.Key.ProductName, // Tên sản phẩm
                    TotalQuantitySold = group.Sum(oi => oi.Quantity) // Tổng số lượng bán
                })
                .OrderByDescending(x => x.TotalQuantitySold) // Sắp xếp theo số lượng bán giảm dần
                .Take(6) // Lấy 6 sản phẩm bán chạy nhất
                .ToList();

            // Tạo tài liệu PDF
            Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 20f, 20f);
            MemoryStream memoryStream = new MemoryStream();

            PdfWriter writer = PdfWriter.GetInstance(pdfDoc, memoryStream);
            pdfDoc.Open();

            try
            {
                // Đường dẫn đến file font
                string fontPath = Server.MapPath("~/Content/Font/NotoSans.ttf");

                // Kiểm tra nếu file font không tồn tại
                if (!System.IO.File.Exists(fontPath))
                {
                    throw new FileNotFoundException("Font không tồn tại tại đường dẫn: " + fontPath);
                }

                // Sử dụng font tùy chỉnh
                BaseFont baseFont = BaseFont.CreateFont(fontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
                Font font = new Font(baseFont, 12, Font.NORMAL);
                Font headerFont = new Font(baseFont, 14, Font.BOLD);

                // Tiêu đề
                pdfDoc.Add(new Paragraph("DANH SÁCH SẢN PHẨM BÁN CHẠY", headerFont));
                pdfDoc.Add(new Paragraph(" ")); // Dòng trống

                // Bảng dữ liệu
                PdfPTable table = new PdfPTable(2) { WidthPercentage = 100 }; // 2 cột: Tên sản phẩm và Số lượng bán

                // Cài đặt độ rộng cột
                table.SetWidths(new float[] { 70f, 30f });

                // Thêm header
                table.AddCell(new PdfPCell(new Phrase("Tên Sản Phẩm", headerFont)) { HorizontalAlignment = Element.ALIGN_CENTER });
                table.AddCell(new PdfPCell(new Phrase("Tổng Số Lượng Bán", headerFont)) { HorizontalAlignment = Element.ALIGN_CENTER });

                // Thêm dữ liệu sản phẩm vào bảng
                foreach (var item in topSellingProducts)
                {
                    table.AddCell(new PdfPCell(new Phrase(item.ProductName, font)) { HorizontalAlignment = Element.ALIGN_LEFT });
                    table.AddCell(new PdfPCell(new Phrase(item.TotalQuantitySold.ToString(), font)) { HorizontalAlignment = Element.ALIGN_RIGHT });
                }

                pdfDoc.Add(table);
            }
            catch (Exception ex)
            {
                // Thêm thông báo lỗi vào PDF (dành cho kiểm tra trong quá trình phát triển)
                pdfDoc.Add(new Paragraph("Có lỗi xảy ra: " + ex.Message));
            }
            finally
            {
                // Đóng tài liệu
                pdfDoc.Close();
            }

            // Trả file PDF về client
            byte[] bytes = memoryStream.ToArray();
            memoryStream.Close();

            return File(bytes, "application/pdf", "TopSellingProducts.pdf");
        }




        //Khach hang chi tieu nhieu nhat
        public ActionResult ExportToPDF_TopProductByIncome()
        {
            // Lấy danh sách các sản phẩm có thu nhập cao nhất
            var topProductsByIncome = db.OrderItem
                .Where(oi => oi.Order.Status == "Approved") // Lọc các đơn hàng đã hoàn thành
                .Select(oi => new TopProductByIncome
                {
                    CustomerName = oi.Order.Customer.FullName,
                    ProductName = oi.Product.ProductName,
                    Quantity = oi.Quantity,
                    Income = (decimal)(oi.Quantity * oi.UnitPrice) // Tính doanh thu
                })
                .OrderByDescending(x => x.Income) // Sắp xếp theo thu nhập giảm dần
                .Take(5) // Lấy 5 sản phẩm có thu nhập cao nhất
                .ToList();

            // Tạo tài liệu PDF
            Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 20f, 20f);
            MemoryStream memoryStream = new MemoryStream();

            PdfWriter writer = PdfWriter.GetInstance(pdfDoc, memoryStream);
            pdfDoc.Open();

            try
            {
                // Đường dẫn đến file font
                string fontPath = Server.MapPath("~/Content/Font/NotoSans.ttf");

                // Kiểm tra nếu file font không tồn tại
                if (!System.IO.File.Exists(fontPath))
                {
                    throw new FileNotFoundException("Font không tồn tại tại đường dẫn: " + fontPath);
                }

                // Sử dụng font tùy chỉnh
                BaseFont baseFont = BaseFont.CreateFont(fontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
                Font font = new Font(baseFont, 12, Font.NORMAL);
                Font headerFont = new Font(baseFont, 14, Font.BOLD);

                // Tiêu đề
                pdfDoc.Add(new Paragraph("DANH SÁCH SẢN PHẨM THEO DOANH THU", headerFont));
                pdfDoc.Add(new Paragraph(" ")); // Dòng trống

                // Bảng dữ liệu
                PdfPTable table = new PdfPTable(4) { WidthPercentage = 100 }; // 4 cột: Tên khách hàng, Sản phẩm, Số lượng, Doanh thu

                // Cài đặt độ rộng cột
                table.SetWidths(new float[] { 30f, 30f, 20f, 20f });

                // Thêm header
                table.AddCell(new PdfPCell(new Phrase("Tên Khách Hàng", headerFont)) { HorizontalAlignment = Element.ALIGN_CENTER });
                table.AddCell(new PdfPCell(new Phrase("Sản Phẩm", headerFont)) { HorizontalAlignment = Element.ALIGN_CENTER });
                table.AddCell(new PdfPCell(new Phrase("Số Lượng", headerFont)) { HorizontalAlignment = Element.ALIGN_CENTER });
                table.AddCell(new PdfPCell(new Phrase("Doanh Thu", headerFont)) { HorizontalAlignment = Element.ALIGN_CENTER });

                // Thêm dữ liệu sản phẩm theo doanh thu vào bảng
                foreach (var item in topProductsByIncome)
                {
                    table.AddCell(new PdfPCell(new Phrase(item.CustomerName, font)) { HorizontalAlignment = Element.ALIGN_LEFT });
                    table.AddCell(new PdfPCell(new Phrase(item.ProductName, font)) { HorizontalAlignment = Element.ALIGN_LEFT });
                    table.AddCell(new PdfPCell(new Phrase(item.Quantity.ToString(), font)) { HorizontalAlignment = Element.ALIGN_RIGHT });
                    table.AddCell(new PdfPCell(new Phrase(item.Income.ToString("C0"), font)) { HorizontalAlignment = Element.ALIGN_RIGHT }); // Format doanh thu là tiền tệ
                }

                pdfDoc.Add(table);
            }
            catch (Exception ex)
            {
                // Thêm thông báo lỗi vào PDF (dành cho kiểm tra trong quá trình phát triển)
                pdfDoc.Add(new Paragraph("Có lỗi xảy ra: " + ex.Message));
            }
            finally
            {
                // Đóng tài liệu
                pdfDoc.Close();
            }

            // Trả file PDF về client
            byte[] bytes = memoryStream.ToArray();
            memoryStream.Close();

            return File(bytes, "application/pdf", "TopProductByIncome.pdf");
        }



    }
}