using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Remoting.Contexts;
using System.Web;
using System.Web.Mvc;
using WebApplication1.Models;
using Newtonsoft.Json;  // Thêm thư viện này để sử dụng JsonConvert
using System.Globalization;
using System.IO;
using System.Data.Entity.Validation;
using iTextSharp.text.pdf;
using iTextSharp.text;



namespace admin4.Controllers
{
    public class AdiminController : Controller
    {

        public class TopProduct
        {
            public string ProductName { get; set; }
            public string BrandName { get; set; }
            public string ImageUrl { get; set; }
            public int TotalSold { get; set; }
        }
        // Models/TopCustomer.cs
        public class TopCustomer
        {
            public int CustomerID { get; set; }
            public string FullName { get; set; }
            public string Address { get; set; }
            public string ImageUrl { get; set; }  // Make sure ImageUrl is added
            public decimal TotalSpent { get; set; }
        }

        public ActionResult Index()
        {// Khởi tạo ngữ cảnh cơ sở dữ liệu
            WatchStoreEntities9 db = new WatchStoreEntities9();

            // Tổng số hóa đơn 
            var totalOrders = db.Order
                .Where(o => o.OrderDate.HasValue)
                .Count();

            // Tổng doanh thu 
            var totalRevenue = db.Order
                .Where(o => o.OrderDate.HasValue)
                .Join(db.OrderItem,
                    o => o.OrderID,
                    oi => oi.OrderID,
                    (o, oi) => new { oi.Quantity, oi.UnitPrice })
                .Sum(x => x.Quantity * x.UnitPrice);


            // Tổng số khách hàng đã mua hàng trong năm 2024
            var totalCustomers = db.Order
                 .Where(o => o.OrderDate.HasValue)  // Lọc những đơn hàng có ngày mua
                 .Select(o => o.CustomerID)         // Chọn CustomerID
                 .Distinct()                        // Lọc bỏ các giá trị trùng lặp (tính mỗi khách hàng 1 lần)
                 .Count();                          // Đếm số khách hàng


            // Truyền dữ liệu sang ViewBag để hiển thị trong view
            ViewBag.TotalOrders = totalOrders;
            ViewBag.TotalRevenue = totalRevenue;
            //ViewBag.BestSellingProduct = bestSellingProduct;
            ViewBag.TotalCustomers = totalCustomers;

            var result = db.OrderItem
      .Where(oi => oi.Order.OrderStatus == 1)  // Chỉ lấy đơn hàng đã thanh toán
      .GroupBy(oi => oi.Product.ProductName)   // Nhóm theo tên sản phẩm
      .OrderByDescending(g => g.Sum(oi => oi.Quantity)) // Sắp xếp theo tổng số lượng bán (giảm dần)
      .Select(g => g.Key)  // Lấy tên sản phẩm
      .FirstOrDefault();   // Lấy sản phẩm bán nhiều nhất
            ViewBag.result = result;






            // khach
            // Lấy số lượng khách hàng trong các năm 2023 và 2024
            var customerData = (from o in db.Order
                                join c in db.Customer on o.CustomerID equals c.CustomerID
                                where o.OrderStatus == 1 && (o.OrderDate.HasValue && (o.OrderDate.Value.Year == 2023 || o.OrderDate.Value.Year == 2024)) // chỉ tính các đơn hàng đã thanh toán trong năm 2023 và 2024
                                group o by o.OrderDate.Value.Year into yearGroup
                                orderby yearGroup.Key
                                select new
                                {
                                    Year = yearGroup.Key,
                                    TotalCustomers = yearGroup.Select(o => o.CustomerID).Distinct().Count() // Đếm số khách hàng duy nhất
                                }).ToList();

            // Truyền dữ liệu vào ViewBag
            ViewBag.CustomerYears = customerData.Select(x => x.Year).ToList();
            ViewBag.CustomerCounts = customerData.Select(x => x.TotalCustomers).ToList();



            //Lay ra gioi tinh khach hang
            var genderCounts = db.Customer
        .GroupBy(c => c.Gender)
        .Select(g => new
        {
            Gender = g.Key,
            TotalCustomers = g.Count()
        })
        .ToList();
            // Count the number of Male customers
            int maleCount = db.Customer.Count(c => c.Gender == "Nam");

            // Count the number of Female customers
            int femaleCount = db.Customer.Count(c => c.Gender == "Nữ");

            // Pass the counts to ViewBag
            ViewBag.MaleCount = maleCount;
            ViewBag.FemaleCount = femaleCount;

            // Pass the result to ViewBag
            ViewBag.GenderCounts = genderCounts;



            // top 10 sp
            var topProducts = db.OrderItem
         .Where(oi => oi.Order.OrderStatus == 1) // Chỉ lấy các đơn hàng đã thanh toán
         .GroupBy(oi => oi.Product) // Nhóm theo sản phẩm
         .Select(group => new TopProduct
         {
             ProductName = group.Key.ProductName,
             BrandName = group.Key.Brand.BrandName,
             ImageUrl = group.Key.ImageUrl,
             TotalSold = group.Sum(oi => oi.Quantity)
         })
         .OrderByDescending(x => x.TotalSold) // Sắp xếp theo số lượng bán giảm dần
         .Take(8) // Lấy 10 sản phẩm bán chạy nhất
         .ToList();

            // Truyền danh sách sản phẩm bán chạy vào ViewBag
            ViewBag.TopProducts = topProducts;





            var topCustomers = db.Order
    .Where(o => o.OrderStatus == 1) // Chỉ lấy các đơn hàng đã thanh toán
    .Join(db.OrderItem, o => o.OrderID, oi => oi.OrderID, (o, oi) => new { o, oi })
    .GroupBy(x => new
    {
        x.o.CustomerID,
        x.o.Customer.FullName,
        x.o.Customer.Address,
        ImgCustomer = x.o.Customer.ImgCustomer ?? "" // Xử lý null
    })
    .Select(group => new TopCustomer
    {
        CustomerID = group.Key.CustomerID,
        FullName = group.Key.FullName,
        Address = group.Key.Address,
        ImageUrl = group.Key.ImgCustomer, // Thay `ImageUrl` thành `ImgCustomer`
        TotalSpent = group.Sum(x => x.oi.Quantity * x.oi.UnitPrice) ?? 0 // Use ?? to handle null values
    })
    .OrderByDescending(x => x.TotalSpent) // Sắp xếp theo TotalSpent giảm dần
    .Take(5) // Lấy top 5 khách hàng
    .ToList();

            // Pass kết quả sang View
            ViewBag.TopCustomers = topCustomers;



            // Nếu bạn lấy giá trị trung bình của đơn hàng
            var averagePricePerOrder = db.Order
                .Where(o => o.OrderID == 1) // Thay 1 bằng ID đơn hàng cần tính
                .Select(o => new
                {
                    OrderID = o.OrderID,
                    AveragePrice = o.OrderItem.Average(oi => oi.UnitPrice) // Tính giá trung bình của các sản phẩm
                })
                .FirstOrDefault(); // Lấy kết quả đầu tiên

            // Truyền kết quả vào ViewBag
            if (averagePricePerOrder != null)
            {
                ViewBag.OrderID = averagePricePerOrder.OrderID;
                // Ép kiểu decimal và định dạng theo kiểu tiền tệ
                ViewBag.AveragePrice = ((decimal)averagePricePerOrder.AveragePrice).ToString("C0");
            }


            // 10 sản phẩm mắc
            var productst = db.Product
                      .OrderByDescending(p => p.Price)
                      .Take(8)
                      .ToList();

            // Lấy tên sản phẩm và giá đã được định dạng
            var productNames = productst.Select(p => p.ProductName).ToList();
            var productPrices = productst.Select(p => p.Price.ToString("#,0", CultureInfo.InvariantCulture)).ToList();


            ViewBag.ProductNames = JsonConvert.SerializeObject(productNames);
            ViewBag.ProductPrices = JsonConvert.SerializeObject(productPrices);
            //


            var revenueData = (from o in db.Order
                               join oi in db.OrderItem on o.OrderID equals oi.OrderID
                               where o.OrderStatus == 1
                               group new { oi.Quantity, oi.UnitPrice, o.OrderDate } by new
                               {
                                   Year = o.OrderDate.HasValue ? o.OrderDate.Value.Year : (int?)null,
                                   Quarter = o.OrderDate.HasValue ? (o.OrderDate.Value.Month <= 3 ? "Q1" :
                                                                    (o.OrderDate.Value.Month <= 6 ? "Q2" :
                                                                    (o.OrderDate.Value.Month <= 9 ? "Q3" : "Q4"))) : null
                               } into g
                               select new
                               {
                                   Year = g.Key.Year,
                                   Quarter = g.Key.Quarter,
                                   TotalRevenue = g.Sum(x => x.Quantity * x.UnitPrice)
                               }).OrderBy(r => r.Year).ThenBy(r => r.Quarter).ToList();

            // Lấy danh sách tên quý và danh sách doanh thu
            var quarters = revenueData.Select(r => r.Quarter + " " + r.Year).ToList();
            //var revenues = revenueData.Select(p => p.TotalRevenue.ToString("#,0", CultureInfo.InvariantCulture)).ToList();
            var revenues = revenueData.Select(p => String.Format("{0:N0}", p.TotalRevenue)).ToList();

            //ViewBag.Quarterss = (quarters);
            //ViewBag.Revenuess = (revenues);
            // Truyền dữ liệu vào ViewBag
            ViewBag.Quarters = JsonConvert.SerializeObject(quarters);
            ViewBag.Revenues = JsonConvert.SerializeObject(revenues);

            // tong so san pham ban ra
            // Tổng số lượng sản phẩm đã bán (chỉ tính đơn hàng đã thanh toán)
            ViewBag.TotalSoldQuantity = db.OrderItem
                .Where(oi => oi.Order.OrderStatus == 1)
                .Sum(oi => (int?)oi.Quantity) ?? 0; // Tránh lỗi null bằng cách dùng (int?) và thay null bằng 0.

            //
            // Lấy sản phẩm có AverageRating cao nhất và số lượng bán nhiều nhất
            var topRatedProduct = db.Product
                .Where(p => p.Check_Remove == 1)  // Lọc sản phẩm chưa bị xóa
                .OrderByDescending(p => p.AverageRating)  // Sắp xếp theo AverageRating giảm dần
                .ThenByDescending(p => db.OrderItem
                    .Where(oi => oi.ProductID == p.ProductID)
                    .Sum(oi => oi.Quantity))  // Sắp xếp theo tổng số lượng bán
                .FirstOrDefault();

            // Đổ dữ liệu vào ViewBag để sử dụng trong View
            ViewBag.TopRatedProduct = topRatedProduct.ProductName;

            // Lấy sản phẩm có AverageRating thấp nhất nhưng đã được mua và có đánh giá
            var lowestRatedProduct = db.Product
                .Where(p => p.Check_Remove == 1)  // Lọc sản phẩm chưa bị xóa
                .Where(p => db.OrderItem.Any(oi => oi.ProductID == p.ProductID))  // Lọc sản phẩm đã được mua
                .Where(p => p.AverageRating > 0)  // Chỉ lấy sản phẩm có đánh giá (tránh lấy sản phẩm chưa có đánh giá)
                .OrderBy(p => p.AverageRating)  // Sắp xếp theo AverageRating tăng dần (đánh giá thấp nhất)
                .ThenByDescending(p => db.OrderItem
                    .Where(oi => oi.ProductID == p.ProductID)
                    .Sum(oi => oi.Quantity))  // Sắp xếp theo tổng số lượng bán (nếu có nhiều sản phẩm đánh giá giống nhau)
                .FirstOrDefault();
            ViewBag.LowestRatedProductName = lowestRatedProduct.ProductName;





            List<Product> products = db.Product.ToList();

            return View(products);
        }



        public ActionResult ExportToPDF_TopCustomer()
        {
            WatchStoreEntities9 db = new WatchStoreEntities9();
            // Lọc danh sách khách hàng chi tiêu nhiều nhất
            var topCustomers = db.Order
                .Where(o => o.OrderStatus == 1) // Chỉ lấy các đơn hàng đã thanh toán
                .Join(db.OrderItem, o => o.OrderID, oi => oi.OrderID, (o, oi) => new { o, oi })
                .GroupBy(x => new { x.o.CustomerID, x.o.Customer.FullName, x.o.Customer.Address }) // Nhóm theo Customer
                .Select(group => new TopCustomer
                {
                    CustomerID = group.Key.CustomerID,
                    FullName = group.Key.FullName,
                    Address = group.Key.Address,
                    TotalSpent = group.Sum(x => x.oi.Quantity * x.oi.UnitPrice) ?? 0 // Sử dụng ?? để thay thế null bằng 0
                })
                .OrderByDescending(x => x.TotalSpent) // Sắp xếp theo tổng chi tiêu giảm dần
                .Take(5) // Lấy 5 khách hàng chi tiêu nhiều nhất
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

                // Tiêu đề cho phần khách hàng chi tiêu nhiều nhất
                pdfDoc.Add(new Paragraph("DANH SÁCH KHÁCH HÀNG CHI TIÊU NHIỀU NHẤT", headerFont));
                pdfDoc.Add(new Paragraph(" ")); // Dòng trống

                // Bảng dữ liệu khách hàng chi tiêu nhiều nhất
                PdfPTable customerTable = new PdfPTable(4) { WidthPercentage = 100 }; // 4 cột cho khách hàng
                customerTable.SetWidths(new float[] { 20f, 30f, 30f, 20f });

                // Thêm header bảng khách hàng
                customerTable.AddCell(new PdfPCell(new Phrase("Mã khách hàng", headerFont)) { HorizontalAlignment = Element.ALIGN_CENTER });
                customerTable.AddCell(new PdfPCell(new Phrase("Tên khách hàng", headerFont)) { HorizontalAlignment = Element.ALIGN_CENTER });
                customerTable.AddCell(new PdfPCell(new Phrase("Địa chỉ", headerFont)) { HorizontalAlignment = Element.ALIGN_CENTER });
                customerTable.AddCell(new PdfPCell(new Phrase("Giá", headerFont)) { HorizontalAlignment = Element.ALIGN_CENTER });

                // Thêm dữ liệu khách hàng vào bảng
                foreach (var customer in topCustomers)
                {
                    customerTable.AddCell(new PdfPCell(new Phrase(customer.CustomerID.ToString(), font)) { HorizontalAlignment = Element.ALIGN_LEFT });
                    customerTable.AddCell(new PdfPCell(new Phrase(customer.FullName, font)) { HorizontalAlignment = Element.ALIGN_LEFT });
                    customerTable.AddCell(new PdfPCell(new Phrase(customer.Address ?? "N/A", font)) { HorizontalAlignment = Element.ALIGN_LEFT });
                    customerTable.AddCell(new PdfPCell(new Phrase(customer.TotalSpent.ToString("C0"), font)) { HorizontalAlignment = Element.ALIGN_RIGHT });
                }

                pdfDoc.Add(customerTable);
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

            return File(bytes, "application/pdf", "TopCustomerReport.pdf");
        }



        public ActionResult ExportToPDF_TopSP()
        {
            WatchStoreEntities9 db = new WatchStoreEntities9();
            // Lọc danh sách sản phẩm bán chạy
            var topProducts = db.OrderItem
                                .Where(oi => oi.Order.OrderStatus == 1) // Chỉ lấy các đơn hàng đã thanh toán
                                .GroupBy(oi => oi.Product) // Nhóm theo sản phẩm
                                .Select(group => new TopProduct
                                {
                                    ProductName = group.Key.ProductName,
                                    BrandName = group.Key.Brand.BrandName,
                                    ImageUrl = group.Key.ImageUrl,
                                    TotalSold = group.Sum(oi => oi.Quantity)
                                })
                                .OrderByDescending(x => x.TotalSold) // Sắp xếp theo số lượng bán giảm dần
                                .Take(8) // Lấy 8 sản phẩm bán chạy nhất
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

                // Tiêu đề cho phần sản phẩm bán chạy
                pdfDoc.Add(new Paragraph("SẢN PHẨM BÁN CHẠY NHẤT", headerFont));
                pdfDoc.Add(new Paragraph(" ")); // Dòng trống

                // Bảng dữ liệu sản phẩm bán chạy
                PdfPTable productTable = new PdfPTable(3) { WidthPercentage = 100 }; // 3 cột cho sản phẩm
                productTable.SetWidths(new float[] { 40f, 40f, 20f });

                // Thêm header bảng sản phẩm bán chạy
                productTable.AddCell(new PdfPCell(new Phrase("Tên Sản Phẩm", headerFont)) { HorizontalAlignment = Element.ALIGN_CENTER });
                productTable.AddCell(new PdfPCell(new Phrase("Hãng", headerFont)) { HorizontalAlignment = Element.ALIGN_CENTER });
                productTable.AddCell(new PdfPCell(new Phrase("Số Lượng Bán", headerFont)) { HorizontalAlignment = Element.ALIGN_CENTER });

                // Thêm dữ liệu sản phẩm bán chạy vào bảng
                foreach (var product in topProducts)
                {
                    productTable.AddCell(new PdfPCell(new Phrase(product.ProductName, font)) { HorizontalAlignment = Element.ALIGN_LEFT });
                    productTable.AddCell(new PdfPCell(new Phrase(product.BrandName, font)) { HorizontalAlignment = Element.ALIGN_LEFT });
                    productTable.AddCell(new PdfPCell(new Phrase(product.TotalSold.ToString(), font)) { HorizontalAlignment = Element.ALIGN_RIGHT });
                }

                pdfDoc.Add(productTable);
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

            return File(bytes, "application/pdf", "DanhSachSanPhamBanChay.pdf");
        }






        // trang thong tin admin
        public ActionResult qlAdmin(string search = "", string SortColumn = "AdminID", string IconClass = "fa-sort-asc", int page = 1, int entriesPerPage = 10, string role = "Role")
        {
            WatchStoreEntities9 db = new WatchStoreEntities9();
            var Role = Session["AdminRole"].ToString();
            ViewBag.Rolee = Role;
            // Initialize the queryable for Admins
            var admins = db.Admin.AsQueryable();

            // Apply role filter if a valid value is selected
            if (!string.IsNullOrWhiteSpace(role) && role.Trim() != "Role")
            {
                admins = admins.Where(a => a.Role == role.Trim());
            }

            // Store the selected role in ViewBag
            ViewBag.Role = role;

            // Filter Admins based on search input
            if (!string.IsNullOrEmpty(search))
            {
                admins = admins.Where(a => a.FullName.Contains(search) || a.Email.Contains(search) || a.Phone.Contains(search));
            }

            // Store the search term in ViewBag to keep it in the search field
            ViewBag.SearchTerm = search;

            // Sorting logic
            switch (SortColumn)
            {
                case "FullName":
                    admins = IconClass == "fa-sort-asc" ? admins.OrderBy(a => a.FullName) : admins.OrderByDescending(a => a.FullName);
                    break;
                case "Email":
                    admins = IconClass == "fa-sort-asc" ? admins.OrderBy(a => a.Email) : admins.OrderByDescending(a => a.Email);
                    break;
                case "Role":
                    admins = IconClass == "fa-sort-asc" ? admins.OrderBy(a => a.Role) : admins.OrderByDescending(a => a.Role);
                    break;
                case "CreatedAt":
                    admins = IconClass == "fa-sort-asc" ? admins.OrderBy(a => a.CreatedAt) : admins.OrderByDescending(a => a.CreatedAt);
                    break;
                default: // Default sorting by AdminID
                    admins = IconClass == "fa-sort-asc" ? admins.OrderBy(a => a.AdminID) : admins.OrderByDescending(a => a.AdminID);
                    break;
            }

            // Store sorting details in ViewBag
            ViewBag.SortColumn = SortColumn;
            ViewBag.IconClass = IconClass;

            // Pagination logic
            int totalEntries = admins.Count();
            int totalPages = (int)Math.Ceiling((double)totalEntries / entriesPerPage);

            // Prevent division by zero (if entriesPerPage is 0)
            if (entriesPerPage <= 0)
            {
                entriesPerPage = 10; // Default to 10 if invalid
            }

            // Calculate records to skip for pagination
            var paginatedAdmins = admins
                .Skip((page - 1) * entriesPerPage)
                .Take(entriesPerPage)
                .ToList();

            // Set ViewBag values for pagination
            ViewBag.TotalEntries = totalEntries;
            ViewBag.Page = page;
            ViewBag.NoOfPages = totalPages;
            ViewBag.StartEntry = (page - 1) * entriesPerPage + 1;
            ViewBag.EndEntry = Math.Min(page * entriesPerPage, totalEntries);

            // Pass the paginated Admin list to the view
            return View(paginatedAdmins);
        }

        public ActionResult ExportToPDFAdmins(int? customerId, string searchTerm = "")
        {
            WatchStoreEntities9 db = new WatchStoreEntities9();

            // Lấy danh sách các admin
            var admins = db.Admin.OrderBy(p => p.AdminID).ToList(); // Lấy tất cả admin, có thể áp dụng lọc nếu cần

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
                pdfDoc.Add(new Paragraph("DANH SÁCH ADMIN", headerFont));
                pdfDoc.Add(new Paragraph($"Tìm kiếm: {(string.IsNullOrEmpty(searchTerm) ? "Tất cả" : searchTerm)}", font));
                pdfDoc.Add(new Paragraph(" ")); // Dòng trống

                // Bảng dữ liệu
                PdfPTable table = new PdfPTable(6) { WidthPercentage = 100 }; // 6 cột: AdminID, FullName, Email, Phone, Role, Gender

                // Cài đặt độ rộng cột
                table.SetWidths(new float[] { 10f, 25f, 30f, 20f, 30f, 15f });

                // Thêm header
                table.AddCell(new PdfPCell(new Phrase("AdminID", headerFont)) { HorizontalAlignment = Element.ALIGN_CENTER });
                table.AddCell(new PdfPCell(new Phrase("FullName", headerFont)) { HorizontalAlignment = Element.ALIGN_CENTER });
                table.AddCell(new PdfPCell(new Phrase("Email", headerFont)) { HorizontalAlignment = Element.ALIGN_CENTER });
                table.AddCell(new PdfPCell(new Phrase("Phone", headerFont)) { HorizontalAlignment = Element.ALIGN_CENTER });
                table.AddCell(new PdfPCell(new Phrase("Role", headerFont)) { HorizontalAlignment = Element.ALIGN_CENTER });
                table.AddCell(new PdfPCell(new Phrase("Gender", headerFont)) { HorizontalAlignment = Element.ALIGN_CENTER });

                // Thêm dữ liệu admin vào bảng
                foreach (var admin in admins)
                {
                    table.AddCell(new PdfPCell(new Phrase(admin.AdminID.ToString(), font)) { HorizontalAlignment = Element.ALIGN_LEFT });
                    table.AddCell(new PdfPCell(new Phrase(admin.FullName, font)) { HorizontalAlignment = Element.ALIGN_LEFT });
                    table.AddCell(new PdfPCell(new Phrase(admin.Email, font)) { HorizontalAlignment = Element.ALIGN_LEFT });
                    table.AddCell(new PdfPCell(new Phrase(admin.Phone, font)) { HorizontalAlignment = Element.ALIGN_LEFT });
                    table.AddCell(new PdfPCell(new Phrase(admin.Role, font)) { HorizontalAlignment = Element.ALIGN_LEFT });
                    table.AddCell(new PdfPCell(new Phrase(admin.Gender, font)) { HorizontalAlignment = Element.ALIGN_LEFT });
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

            return File(bytes, "application/pdf", "DanhSachAdmin.pdf");
        }





        public ActionResult Edit(int id)
        {
            using (WatchStoreEntities9 db = new WatchStoreEntities9())
            {
                var admin = db.Admin.Find(id);
                if (admin == null)
                {
                    return HttpNotFound();
                }

                return View(admin);
            }
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(Admin Admin, HttpPostedFileBase ImageUrl)
        {
            using (WatchStoreEntities9 db = new WatchStoreEntities9())
            {
                // Find the existing product in the database
                var admin = db.Admin.Find(Admin.AdminID);
                if (admin == null)
                {
                    return HttpNotFound();
                }

                if (string.IsNullOrEmpty(Admin.Adminname))
                {
                    ModelState.AddModelError("", "Tên đăng nhập không được trống");
                    return View(Admin);
                }

                if (string.IsNullOrEmpty(Admin.Email))
                {
                    ModelState.AddModelError("", "Email không được trống");
                    return View(Admin);
                }
                if (string.IsNullOrEmpty(Admin.Role))
                {
                    ModelState.AddModelError("", "Vui lòng nhập quyền Admin");
                    return View(Admin);
                }


                if (string.IsNullOrEmpty(Admin.Password) || Admin.Password.Length < 6)
                {
                    ModelState.AddModelError("", "Mật khẩu phải >= 6 kí tự");
                    return View(Admin);
                }

                if (string.IsNullOrEmpty(Admin.Phone) || Admin.Phone.Length != 10)
                {
                    ModelState.AddModelError("", "Nhập SDT đủ 10 số");
                    return View(Admin);
                }

                if (!ModelState.IsValid)
                {
                    // In ra các lỗi của ModelState để debug
                    foreach (var error in ModelState.Values.SelectMany(v => v.Errors))
                    {
                        System.Diagnostics.Debug.WriteLine(error.ErrorMessage);
                    }
                    return View(Admin);
                }

                if (ImageUrl != null && ImageUrl.ContentLength > 0)
                {
                    // Lấy tên file gốc
                    string fileName = Path.GetFileName(ImageUrl.FileName);
                    string filePath = Path.Combine(Server.MapPath("~/Content/img_admin/"), fileName);
                    string directoryPath = Server.MapPath("~/Content/img_admin/");
                    if (!Directory.Exists(directoryPath))
                    {
                        Directory.CreateDirectory(directoryPath);
                    }

                    ImageUrl.SaveAs(filePath);
                    admin.ImgAdmin = fileName; // Nếu tên file không bị thay đổi, chỉ cần lưu lại tên file gốc
                }


                admin.FullName = Admin.FullName;
                admin.Password = Admin.Password;
                admin.Adminname = Admin.Adminname;
                admin.Email = Admin.Email;
                admin.Phone = Admin.Phone;
                admin.Role = Admin.Role;
                admin.Gender = Admin.Gender;

                try
                {
                    db.SaveChanges();
                    return RedirectToAction("Index");

                }
                catch (DbEntityValidationException ex)
                {
                    // Duyệt qua tất cả các entity bị lỗi và in ra thông tin chi tiết
                    foreach (var validationErrors in ex.EntityValidationErrors)
                    {
                        foreach (var validationError in validationErrors.ValidationErrors)
                        {
                            // In ra thông tin lỗi chi tiết
                            System.Diagnostics.Debug.WriteLine($"Property: {validationError.PropertyName}, Error: {validationError.ErrorMessage}");
                        }
                    }

                    // Thêm thông báo lỗi chung
                    ModelState.AddModelError("", "Có lỗi xảy ra khi lưu dữ liệu. Vui lòng kiểm tra lại.");

                    // Trả lại view với dữ liệu chưa lưu
                    return View(Admin);
                }


            }
        }



        // GET: Delete
        public ActionResult Delete(int id)
        {
            WatchStoreEntities9 db = new WatchStoreEntities9();
            Admin admin = db.Admin.Where(row => row.AdminID == id).FirstOrDefault();

            if (admin == null)
            {
                return HttpNotFound();
            }

            return View(admin);  // Passing the admin object to the view
        }

        // POST: Delete
        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            using (WatchStoreEntities9 db = new WatchStoreEntities9())
            {
                // Find the admin to delete
                Admin admin = db.Admin.Where(p => p.AdminID == id).FirstOrDefault();

                if (admin == null)
                {
                    return HttpNotFound();
                }

                // Remove the admin from the database
                db.Admin.Remove(admin);

                // Save changes to the database
                db.SaveChanges();

                // Redirect to the Index action after deletion
                return RedirectToAction("Index");
            }
        }


        public ActionResult Register()
        {
            return View();
     
        
        }
        //[HttpPost]
        //public ActionResult Register(register sign, HttpPostedFileBase fileupload)
        //{
        //    if (ModelState.IsValid)
        //    {
        //        // Kiểm tra Email đã tồn tại chưa
        //        if (db.Customer.Any(x => x.Email == sign.Email) || db.Admin.Any(x => x.Email == sign.Email))
        //        {
        //            ViewBag.Message = "Email đã được đăng ký.";
        //            return View();
        //        }

        //        // Biến lưu tên file ảnh
        //        string fileName = null;

        //        // Xử lý tệp tải lên
        //        if (fileupload != null)
        //        {
        //            try
        //            {
        //                fileName = Path.GetFileName(fileupload.FileName);
        //                var path = Path.Combine(Server.MapPath("~/Content/imgCustomer/"), fileName);

        //                // Kiểm tra nếu tệp đã tồn tại
        //                if (!System.IO.File.Exists(path))
        //                {
        //                    // Lưu file nếu chưa tồn tại
        //                    fileupload.SaveAs(path);
        //                }
        //                else
        //                {
        //                    ViewBag.Thongbao = "Hình ảnh đã tồn tại, sử dụng ảnh đã tồn tại.";
        //                }
        //            }
        //            catch (Exception ex)
        //            {
        //                ViewBag.Thongbao = "Lỗi khi lưu hình ảnh: " + ex.Message;
        //                return View();
        //            }
        //        }
        //        else
        //        {
        //            ViewBag.Thongbao = "Vui lòng tải lên một hình ảnh.";
        //            return View();
        //        }

        //        // Tạo đối tượng Customer
        //        var newCustomer = new Customer
        //        {
        //            FullName = sign.FullName,
        //            Email = sign.Email,
        //            Password = sign.Password,
        //            Phone = sign.Phone,
        //            Gender = sign.Gender,
        //            Address = sign.Address,
        //            CreatedAt = DateTime.Now,
        //            ImgCustomer = fileName // Lưu tên file ảnh vào SQL
        //        };

        //        // Thêm khách hàng mới vào cơ sở dữ liệu
        //        db.Customer.Add(newCustomer);
        //        db.SaveChanges();

        //        return RedirectToAction("Login", "Account");
        //    }





        //    return View();
        //}
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Register(Admin customer, HttpPostedFileBase Images)
        {
            WatchStoreEntities9 db = new WatchStoreEntities9();
            // Kiểm tra nếu các trường bắt buộc không bị trống
            if (string.IsNullOrWhiteSpace(customer.FullName))
            {
                ModelState.AddModelError("FullName", "Full name is required.");
            }
            if (string.IsNullOrWhiteSpace(customer.Email))
            {
                ModelState.AddModelError("Email", "Email is required.");
            }
            else
            {
                // Kiểm tra nếu email đã tồn tại trong cơ sở dữ liệu
                var existingCustomer = db.Customer.FirstOrDefault(c => c.Email == customer.Email);
                if (existingCustomer != null)
                {
                    ModelState.AddModelError("Email", "The email address is already in use.");
                }
            }
            if (string.IsNullOrWhiteSpace(customer.Phone))
            {
                ModelState.AddModelError("Phone", "Phone number is required.");
            }
            if (string.IsNullOrWhiteSpace(customer.Gender))
            {
                ModelState.AddModelError("Gender", "Gender is required.");
            }
            if (string.IsNullOrWhiteSpace(customer.Adminname))
            {
                ModelState.AddModelError("Adminname", "Adminname is required.");
            }
            if (string.IsNullOrWhiteSpace(customer.Role))
            {
                ModelState.AddModelError("Role", "Role is required.");
            }

            // Kiểm tra nếu có lỗi trong ModelState thì trả lại view
            if (!ModelState.IsValid)
            {
                return View(customer);
            }
            if (ModelState.IsValid)
            {
                // Kiểm tra nếu người dùng đã tải lên ảnh
                if (Images != null && Images.ContentLength > 0)
                {
                    // Lưu hình ảnh vào thư mục Images trong dự án (hoặc thư mục tùy ý)
                    string fileName = Path.GetFileName(Images.FileName);
                    string filePath = Path.Combine(Server.MapPath("~/Content/img_admin/"), fileName);
                    Images.SaveAs(filePath);

                    // Lưu đường dẫn hình ảnh vào model
                    customer.ImgAdmin = fileName;
                }

                // Thêm khách hàng vào cơ sở dữ liệu
                customer.check_Remove = 1;
                customer.CreatedAt = DateTime.Now;
                db.Admin.Add(customer);
                db.SaveChanges();

                // Chuyển hướng về danh sách khách hàng sau khi lưu thành công
                return RedirectToAction("qlAdmin");
            }

            // Nếu model không hợp lệ, trả lại view
            return View(customer);
        }


    }
}
