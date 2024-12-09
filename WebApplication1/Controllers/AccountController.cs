using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using WebApplication1.Models;
using System.IO;
using System.Data.Entity.Migrations;
using System.Data.SqlClient;
using static System.Net.WebRequestMethods;
using System.Net.Mail;
using System.Net;


namespace WebApplication1.Controllers
{
    public class AccountController : Controller
    {
        WatchStoreEntities9 db = new WatchStoreEntities9();
        // GET: Account
       
        public ActionResult Register()
        {
            return View();
        }
       
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Register(Customer customer, HttpPostedFileBase Images)
        {

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
            if (string.IsNullOrWhiteSpace(customer.Address))
            {
                ModelState.AddModelError("Address", "Address is required.");
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
                    string filePath = Path.Combine(Server.MapPath("~/Content/img_customer/"), fileName);
                    Images.SaveAs(filePath);

                    // Lưu đường dẫn hình ảnh vào model
                    customer.ImgCustomer = fileName;
                }

                // Thêm khách hàng vào cơ sở dữ liệu
                customer.check_Remove = 1;
                customer.CreatedAt = DateTime.Now;
                db.Customer.Add(customer);
                db.SaveChanges();

                // Chuyển hướng về danh sách khách hàng sau khi lưu thành công
                return RedirectToAction("Login");
            }

            // Nếu model không hợp lệ, trả lại view
            return View(customer);
        }


        public ActionResult Login()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Login(login l)
        {
            var query1 = db.Customer
                  .FirstOrDefault(m => m.Email == l.Email && m.Password == l.Password);
            var query2 = db.Admin
                           .FirstOrDefault(a => a.Email == l.Email && a.Password == l.Password);
            if (query1 != null)
            {
                Session["UserLoggedIn"] = query1.FullName; // Lưu tên người dùng vào session
                Session["userEmail"] = query1.Email;
                Session["userId"] = query1.CustomerID;
                return RedirectToAction("Xuhuong", "Xuhuong");
            }
            else if (query2 != null)
            {
                Session["AddminLoggedIn"] = query2.FullName; // Lưu tên admin vào session
                Session["AdminID"] = query2.AdminID;
                Session["AdminEmail"] = query2.Email;
                Session["AdminRole"] = query2.Role;
                Session["imgAdmin"] = query2.ImgAdmin;



                return RedirectToAction("Index", "Adimin");
            }
            else
            {
                ModelState.AddModelError("", "Tên người dùng hoặc mật khẩu không đúng.");
            }
            return View();
        }   
        public ActionResult Logout()
        {
            Session.Abandon();
            return RedirectToAction("Xuhuong", "Xuhuong");
        }

        public ActionResult ProfileUser()
        {
            List<Customer> customers = db.Customer.ToList();
            return View(customers);
        }
        public ActionResult EditProfileUser()
        {
            // Lấy email từ session để xác định người dùng hiện tại
            string userEmail = Session["userEmail"]?.ToString();
            if (userEmail == null) return RedirectToAction("Login", "Account");

            var customer = db.Customer.FirstOrDefault(c => c.Email == userEmail);
            if (customer == null) return HttpNotFound();

            return View(customer);
        }
        [HttpPost]
        public ActionResult EditProfileUser(Customer model, HttpPostedFileBase fileupload)
        {
            if (ModelState.IsValid)
            {
                var customer = db.Customer.FirstOrDefault(c => c.CustomerID == model.CustomerID);
                if (customer != null)
                {
                    string fileName = null;

                    // Xử lý tệp tải lên
                    if (fileupload != null)
                    {
                        try
                        {
                            fileName = Path.GetFileName(fileupload.FileName);
                            var path = Path.Combine(Server.MapPath("~/Content/img_customer/"), fileName);

                            // Kiểm tra nếu tệp đã tồn tại
                            if (!System.IO.File.Exists(path))
                            {
                                // Lưu file nếu chưa tồn tại
                                fileupload.SaveAs(path);
                            }
                            else
                            {
                                ViewBag.Thongbao = "Hình ảnh đã tồn tại, sử dụng ảnh đã tồn tại.";
                            }
                        }
                        catch (Exception ex)
                        {
                            ViewBag.Thongbao = "Lỗi khi lưu hình ảnh: " + ex.Message;
                            return View(model);
                        }
                    }

                    // Cập nhật thông tin khách hàng
                    customer.FullName = model.FullName;
                    customer.Email = model.Email;
                    customer.Phone = model.Phone;
                    customer.Address = model.Address;
                    customer.Gender = model.Gender;

                    // Cập nhật ảnh đại diện nếu có tải lên
                    if (!string.IsNullOrEmpty(fileName))
                    {
                        customer.ImgCustomer = fileName;
                    }

                    // Lưu thay đổi vào cơ sở dữ liệu
                    db.Customer.AddOrUpdate(customer); // Hoặc db.Entry(customer).State = EntityState.Modified;
                    db.SaveChanges();
                    Session["UserLoggedIn"] = customer.FullName;
                    ViewBag.Message = "Profile updated successfully!";
                    return RedirectToAction("ProfileUser");
                }
            }

            // Trả lại view với model nếu xảy ra lỗi
            return View(model);
        }
        // khanh
        public ActionResult ResetPassword()
        {
            return View();
        }

        [HttpPost]
        public ActionResult ResetPassword(login l)
        {
            var selectedCustomer = db.Customer.FirstOrDefault(m => m.Email == l.Email);
            if (selectedCustomer != null)
            {
                var random = new Random();
                var otpCode = random.Next(100000, 999999).ToString();

                try
                {
                    var smtpClient = new SmtpClient("smtp.gmail.com")
                    {
                        Port = 587, // Cổng SMTP của Gmail
                        Credentials = new NetworkCredential("watchstore4conga@gmail.com", "wfxx gjdt ucie kzdk"),
                        EnableSsl = true, // Bật SSL để bảo mật
                    };

                    var mailMessage = new MailMessage
                    {
                        From = new MailAddress("watchstore4conga@gmail.com"), // Địa chỉ email gửi
                        Subject = "OTP đổi mật khẩu.",
                        Body = "Mã OTP của bạn là: " + otpCode,
                        IsBodyHtml = true,
                    };
                    mailMessage.To.Add(selectedCustomer.Email);
                    smtpClient.Send(mailMessage);
                }
                catch (Exception ex)
                {
                    TempData["ErrorMessage"] = "Gửi email thất bại tới: " + selectedCustomer.Email + $" {ex.Message}";
                }

                var newOtp = new OTP
                {
                    CustomerID = selectedCustomer.CustomerID,
                    OTPCode = otpCode,
                    ExpiresAt = DateTime.Now.AddMinutes(10) // OTP hết hạn sau 10 phút
                };

                db.OTP.Add(newOtp);
                db.SaveChanges();

                Session["selectedEmail"] = selectedCustomer.Email;
                return RedirectToAction("ConfirmOTP");
            }
            else
            {
                ModelState.AddModelError("", "Email không được tìm thấy!");
            }
            return View();
        }

        public ActionResult ConfirmOTP()
        {
            string selectedEmail = Session["selectedEmail"].ToString();
            if (selectedEmail == null)
                return RedirectToAction("ResetPassword");
            return View();
        }

        [HttpPost]
        public ActionResult ConfirmOTP(OTP o)
        {
            string selectedEmail = Session["selectedEmail"].ToString();
            if (selectedEmail == null)
                return RedirectToAction("ResetPassword");

            var selectedConfirmOTP = db.OTP.FirstOrDefault(m => m.OTPCode == o.OTPCode && m.ExpiresAt > DateTime.Now && m.Customer.Email == selectedEmail);
            if (selectedConfirmOTP != null)
            {

                return RedirectToAction("ChangePassword");
            }
            else
            {
                ModelState.AddModelError("", "Mã OTP không đúng hoặc đã hết hạn");
            }
            return View();
        }

        public ActionResult ChangePassword()
        {
            string selectedEmail = Session["selectedEmail"].ToString();
            if (selectedEmail == null)
                return RedirectToAction("ResetPassword");
            return View();
        }

        [HttpPost]
        public ActionResult ChangePassword(login l)
        {
            string selectedEmail = Session["selectedEmail"]?.ToString();
            var selectedCustomer = db.Customer.FirstOrDefault(c => c.Email == selectedEmail);

            if (string.IsNullOrEmpty(l.Password))
                ModelState.AddModelError("Password", "Mật khẩu không được để trống.");

            else if (string.IsNullOrEmpty(l.ConfirmPassword))
                ModelState.AddModelError("ConfirmPassword", "Xác nhận mật khẩu không được để trống.");

            else if (l.Password != l.ConfirmPassword)
                ModelState.AddModelError("ConfirmPassword", "Xác nhận mật khẩu không khớp.");

            else
            {
                if (selectedCustomer != null)
                {
                    selectedCustomer.Password = l.Password;
                    db.SaveChanges();

                    return RedirectToAction("Login");
                }

                else
                {
                    ModelState.AddModelError("", "Không tìm thấy khách hàng với email đã chọn.");
                    return View();
                }
            }
            return View();
        }
    }
}