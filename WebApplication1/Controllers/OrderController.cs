using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Remoting.Messaging;
using System.Web;
using System.Web.Mvc;
using System.Data.Entity;
using WebApplication1.Models;
using iTextSharp.text;
using iTextSharp.text.pdf;
using System.IO;
namespace admin4.Controllers
{
    public class OrderController : Controller
    {
        private WatchStoreEntities9 db = new WatchStoreEntities9();

        // GET: Order
        // GET: Order
        public ActionResult Index(int page = 1, int entriesPerPage = 10, string status = "All", string search = "")
        {
            // Start with all orders as a queryable collection
            var orders = db.Order.AsQueryable();

            // Apply the search filter if the search term is provided
            if (!string.IsNullOrEmpty(search))
            {
                orders = orders.Where(o => o.Customer.FullName.Contains(search));
            }

            // Filter based on status
            if (status != "All") // Adjusted to check for "All"
            {
                orders = orders.Where(o => o.Status == status);
            }

            // Set ViewBag values to keep track of the selected status and search term
            ViewBag.Status = status;
            ViewBag.SearchResults = search;

            // Ensure there's sorting applied before pagination
            orders = orders.OrderBy(o => o.OrderDate); // Change this to the field you want to sort by

            // Get the count of filtered entries
            var totalEntries = orders.Count();
            var totalPages = (int)Math.Ceiling((double)totalEntries / entriesPerPage);
            var skipRecords = (page - 1) * entriesPerPage;

            // Apply pagination
            var paginatedOrders = orders.Skip(skipRecords).Take(entriesPerPage).ToList();

            // Calculate range of items being displayed
            int startEntry = skipRecords + 1;
            int endEntry = Math.Min(skipRecords + entriesPerPage, totalEntries);

            // Set ViewBag values for pagination
            ViewBag.TotalEntries = totalEntries;
            ViewBag.Page = page;
            ViewBag.NoOfPages = totalPages;
            ViewBag.StartEntry = startEntry;
            ViewBag.EndEntry = endEntry;
            ViewBag.EntriesPerPage = entriesPerPage;

            return View(paginatedOrders);
        }




        // POST: Order/Approve/5
        [HttpPost]
        public ActionResult Approve(int id)
        {
            var order = db.Order.Find(id);
            if (order != null)
            {
                order.Status = "Approved"; // Thay đổi trạng thái thành Approved
                db.SaveChanges();
            }
            return RedirectToAction("Index");
        }

        // POST: Order/Reject/5
        [HttpPost]
        public ActionResult Reject(int id)
        {
            var order = db.Order.Find(id);
            if (order != null)
            {
                order.Status = "Rejected"; // Thay đổi trạng thái thành Rejected
                db.SaveChanges();
            }
            return RedirectToAction("Index");
        }

        public ActionResult Invoice(int id)
        {
            // Truy vấn đơn hàng cùng với các OrderItems và Products liên quan
            var order = db.Order
                .Include(o => o.OrderItem.Select(oi => oi.Product)) // Include các OrderItems và Products
                .FirstOrDefault(o => o.OrderID == id);

            if (order == null)
            {
                return HttpNotFound("Không tìm thấy đơn hàng với ID: " + id);
            }

            return View(order);
        }
        //timn
        public ActionResult Index2()
        {
           

            return View();
        }
        // in pdf





        public ActionResult ExportToPDF_donhang()
        {
            var order = db.Order.OrderBy(p => p.OrderID).ToList(); // Lấy tất cả đơn hàng, không lọc

            // Tạo tài liệu PDF
            Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 20f, 20f);
            MemoryStream memoryStream = new MemoryStream();
            PdfWriter writer = PdfWriter.GetInstance(pdfDoc, memoryStream);
            pdfDoc.Open();

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
            pdfDoc.Add(new Paragraph("DANH SÁCH ĐƠN HÀNG", headerFont));
            pdfDoc.Add(new Paragraph(" "));

            // Bảng dữ liệu
            PdfPTable table = new PdfPTable(5); // 5 cột: STT, Name, Order Date, Email, Status
            table.WidthPercentage = 100;
            table.SetWidths(new float[] { 10f, 25f, 25f, 25f, 15f });  // Cài đặt chiều rộng các cột

            // Thêm header
            table.AddCell(new PdfPCell(new Phrase("STT", headerFont)) { HorizontalAlignment = Element.ALIGN_CENTER });
            table.AddCell(new PdfPCell(new Phrase("Tên khách hàng", headerFont)) { HorizontalAlignment = Element.ALIGN_CENTER });
            table.AddCell(new PdfPCell(new Phrase("Ngày đặt hàng", headerFont)) { HorizontalAlignment = Element.ALIGN_CENTER });
            table.AddCell(new PdfPCell(new Phrase("Email", headerFont)) { HorizontalAlignment = Element.ALIGN_CENTER });
            table.AddCell(new PdfPCell(new Phrase("Trạng thái ", headerFont)) { HorizontalAlignment = Element.ALIGN_CENTER });

            // Thêm dữ liệu vào bảng
            int stt = 1; // Số thứ tự
            foreach (var orderItem in order)
            {
                // Lấy thông tin đơn hàng và khách hàng
                var customer = orderItem.Customer;
                string status = orderItem.OrderStatus == 1 ? "Đã thanh toán" : "Chưa thanh toán";  // Ví dụ, trạng thái đơn hàng

                // Thêm dữ liệu vào bảng
                table.AddCell(new PdfPCell(new Phrase(stt.ToString(), font)) { HorizontalAlignment = Element.ALIGN_CENTER });
                table.AddCell(new PdfPCell(new Phrase(customer.FullName, font)) { HorizontalAlignment = Element.ALIGN_LEFT });
                table.AddCell(new PdfPCell(new Phrase(orderItem.OrderDate.Value.ToString("dd/MM/yyyy"), font)) { HorizontalAlignment = Element.ALIGN_CENTER });
                table.AddCell(new PdfPCell(new Phrase(customer.Email, font)) { HorizontalAlignment = Element.ALIGN_LEFT });
                table.AddCell(new PdfPCell(new Phrase(status, font)) { HorizontalAlignment = Element.ALIGN_CENTER });

                stt++; // Tăng số thứ tự
            }

            // Thêm bảng vào PDF
            pdfDoc.Add(table);

            // Đóng tài liệu
            pdfDoc.Close();

            // Trả file PDF về client
            byte[] bytes = memoryStream.ToArray();
            memoryStream.Close();

            return File(bytes, "application/pdf", "DanhSachDonHang.pdf");
        }
    }
}