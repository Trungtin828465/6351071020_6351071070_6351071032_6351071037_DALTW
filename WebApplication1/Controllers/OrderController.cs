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


            // Tính tổng tiền từ các OrderItems
            decimal totalAmount = order.OrderItem.Sum(item => (decimal?)(item.UnitPrice)) ?? 0;
            decimal totalOrder = order.TotalPrice ?? 0;
            // Lưu tổng tiền vào ViewBag
            ViewBag.TotalAmount = totalAmount;
            ViewBag.TotalOrder = totalOrder;


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
        // in chi tiet
        public ActionResult ExportToPDF_chitietdonhang(int orderId)
        {
           
            var orderDetails = db.Order.Include(o => o.OrderItem)
                           .FirstOrDefault(o => o.OrderID == orderId);

            if (orderDetails == null)
            {
                return HttpNotFound("Không tìm thấy đơn hàng.");
            }

            using (var stream = new MemoryStream())
            {
                // Khởi tạo tài liệu PDF
                var document = new Document(PageSize.A4, 25, 25, 30, 30);
                PdfWriter.GetInstance(document, stream);
                document.Open();

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





                // Thêm tiêu đề
                document.Add(new Paragraph("Chi tiết đơn hàng", headerFont));
                document.Add(new Paragraph("\n")); // Khoảng trống

                // Thông tin cơ bản của đơn hàng
                document.Add(new Paragraph($"Mã đơn hàng: {orderDetails.OrderID}", font));
                document.Add(new Paragraph($"Ngày đặt: {orderDetails.OrderDate:dd/MM/yyyy}", font));
                document.Add(new Paragraph("\n")); // Khoảng trống

                // Thông tin người đặt
                document.Add(new Paragraph("Thông tin người đặt:", headerFont));
                document.Add(new Paragraph($"- Họ và tên: {orderDetails.Customer.FullName}", font));
                document.Add(new Paragraph($"- Số điện thoại: {orderDetails.Customer.Phone}", font));
                document.Add(new Paragraph($"- Email: {orderDetails.Customer.Email}", font));
                document.Add(new Paragraph("\n")); // Khoảng trống

                // Thông tin người nhận
                document.Add(new Paragraph("Thông tin người nhận:", headerFont));
                document.Add(new Paragraph($"- Họ và tên: {orderDetails.ReceiverName}", font));
                document.Add(new Paragraph($"- Số điện thoại: {orderDetails.ReceiverPhone}", font));
                document.Add(new Paragraph($"- Địa chỉ: {orderDetails.ReceiverAddress}, {orderDetails.HouseNumber}", font));
                document.Add(new Paragraph("\n")); // Khoảng trống

                // Danh sách sản phẩm
                document.Add(new Paragraph("Danh sách sản phẩm:", font));

                // Tạo bảng chi tiết sản phẩm
                var table = new PdfPTable(5) { WidthPercentage = 100 };
                table.SetWidths(new float[] { 10, 40, 15, 15, 20 });

                // Thêm tiêu đề bảng

                table.AddCell(new PdfPCell(new Phrase("STT", font)) { HorizontalAlignment = Element.ALIGN_CENTER });
                table.AddCell(new PdfPCell(new Phrase("Tên sản phẩm", font)) { HorizontalAlignment = Element.ALIGN_CENTER });
                table.AddCell(new PdfPCell(new Phrase("Số lượng", font)) { HorizontalAlignment = Element.ALIGN_CENTER });
                table.AddCell(new PdfPCell(new Phrase("Đơn giá", font)) { HorizontalAlignment = Element.ALIGN_CENTER });
                table.AddCell(new PdfPCell(new Phrase("Thành tiền", font)) { HorizontalAlignment = Element.ALIGN_CENTER });

                // Thêm dữ liệu sản phẩm
                int index = 1;
                foreach (var item in orderDetails.OrderItem)
                {
                    //float donGia =  (float)item.Product.Price * (1 - (item.Product.Discount / 100));

                    table.AddCell(new PdfPCell(new Phrase(index.ToString(), font)) { HorizontalAlignment = Element.ALIGN_CENTER });
                    table.AddCell(new PdfPCell(new Phrase(item.Product.ProductName, font)));
                    table.AddCell(new PdfPCell(new Phrase(item.Quantity.ToString(), font)) { HorizontalAlignment = Element.ALIGN_CENTER });
                    table.AddCell(new PdfPCell(new Phrase($"{item.Product.Price * (1 - (Convert.ToDecimal(item.Product.Discount) / 100))} đ", font)) { HorizontalAlignment = Element.ALIGN_RIGHT });
                    table.AddCell(new PdfPCell(new Phrase($"{item.UnitPrice} đ", font)) { HorizontalAlignment = Element.ALIGN_RIGHT });
                    index++;
                }
                //Price * (1 - CAST(Discount AS DECIMAL(10, 2)) / 100)
                document.Add(table);
                document.Add(new Paragraph("\n")); // Khoảng trống

                // Tổng tiền thanh toán
                document.Add(new Paragraph($"Tổng tiền thanh toán: {orderDetails.TotalPrice:0,0} đ", headerFont));

                // Ghi chú đơn hàng nếu có
                if (!string.IsNullOrEmpty(orderDetails.Note))
                {
                    document.Add(new Paragraph("\n"));
                    document.Add(new Paragraph("Ghi chú đơn hàng:", font));
                    document.Add(new Paragraph(orderDetails.Note, font));
                }

                // Đóng tài liệu
                document.Close();

                // Trả về file PDF
                return File(stream.ToArray(), "application/pdf", $"ChiTietDonHang_{orderDetails.OrderID}.pdf");
            }
        }
    }
}