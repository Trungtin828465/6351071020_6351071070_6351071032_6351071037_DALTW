using System;
using System.Collections.Generic;
using System.Data.Common.CommandTrees.ExpressionBuilder;
using System.Data.Entity.Infrastructure;
using System.IO;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Web;
using System.Web.DynamicData;
using System.Web.Mvc;
using WebApplication1.Models;
using HtmlAgilityPack;

namespace admin4.Controllers
{
    public class ProductImageViewModel
    {
        public string Hinh { get; set; }
    }

    public class ProductController : Controller
    {
        // GET: Product

        public ActionResult Index(string search = "", string sortColumn = "Id", string iconClass = "fa-sort-asc", int page = 1, int entriesPerPage = 10, string status = "Category")
        {
            WatchStoreEntities9 db = new WatchStoreEntities9();

            // Lấy sản phẩm ban đầu dưới dạng IQueryable để áp dụng các bộ lọc động
            var products1 = db.Product.AsQueryable();

            // Áp dụng bộ lọc danh mục nếu đã chọn
            if (!string.IsNullOrEmpty(status) && status != "Category")
            {
                products1 = products1.Where(p => p.Category.CategoryName == status);
            }

            // Áp dụng tìm kiếm nếu có
            if (!string.IsNullOrEmpty(search))
            {
                products1 = products1.Where(p => p.ProductName.Contains(search));
            }

            // Áp dụng sắp xếp
            switch (sortColumn)
            {
                case "Id":
                    products1 = iconClass == "fa-sort-asc" ? products1.OrderBy(p => p.ProductID) : products1.OrderByDescending(p => p.ProductID);
                    break;
                case "ProductName":
                    products1 = iconClass == "fa-sort-asc" ? products1.OrderBy(p => p.ProductName) : products1.OrderByDescending(p => p.ProductName);
                    break;
                case "UnitPrice":
                    products1 = iconClass == "fa-sort-asc" ? products1.OrderBy(p => p.Price) : products1.OrderByDescending(p => p.Price);
                    break;
            }

            // Tổng số sản phẩm sau khi áp dụng các bộ lọc
            int totalEntries = products1.Count();
            int totalPages = (int)Math.Ceiling((double)totalEntries / entriesPerPage);

            // Tính toán dữ liệu phân trang
            int skipRecords = (page - 1) * entriesPerPage;
            var paginatedProducts = products1.Skip(skipRecords).Take(entriesPerPage).ToList();

            // Thiết lập các giá trị ViewBag cho View
            ViewBag.Category = status;
            ViewBag.search = search;
            ViewBag.SortColumn = sortColumn;
            ViewBag.IconClass = iconClass;
            ViewBag.EntriesPerPage = entriesPerPage;
            ViewBag.TotalEntries = totalEntries;
            ViewBag.Page = page;
            ViewBag.NoOfPages = totalPages;

            return View(paginatedProducts);
        }


        public ActionResult Create()
        {
            using (var db = new WatchStoreEntities9())
            {
                // Lấy danh sách Category từ database
                var categories = db.Category.ToList();  // Hoặc db.Category.ToList() nếu tên bảng là Category

                // Kiểm tra xem categories có null không
                if (categories == null)
                {
                    // Xử lý trường hợp danh sách categories không có dữ liệu
                    ViewBag.Categorie = new List<Category>(); // Tránh lỗi nếu không có category
                }
                else
                {
                    // Gán danh sách Category vào ViewBag
                    ViewBag.Categorie = categories;
                }


                // Lấy danh sách Brands từ database
                var brands = db.Brand.ToList();  // Hoặc db.Brand.ToList() tùy vào tên bảng

                // Kiểm tra xem brands có null không
                if (brands == null)
                {
                    ViewBag.Brands = new List<Brand>(); // Tránh lỗi nếu không có dữ liệu
                }
                else
                {
                    ViewBag.Brands = brands; // Gán danh sách vào ViewBag
                }







                // Lấy danh sách nhà cung cấp từ database
                var suppliers = db.Supplier.ToList();

                // Kiểm tra xem suppliers có null không
                if (suppliers == null)
                {
                    ViewBag.Suppliers = new List<Supplier>(); // Tránh lỗi nếu không có dữ liệu
                }
                else
                {
                    ViewBag.Suppliers = suppliers; // Gán danh sách nhà cung cấp vào ViewBag
                }

                return View();
            }
        }

        [HttpPost]
        [ValidateInput(false)]

        public ActionResult Create(Product product, Detail detail,HttpPostedFileBase ImageUrl, HttpPostedFileBase Image1, HttpPostedFileBase Image2, HttpPostedFileBase Image3, HttpPostedFileBase Image4, HttpPostedFileBase Image5, HttpPostedFileBase ImageDetail, string URLVideo)
        {
            using (WatchStoreEntities9 db = new WatchStoreEntities9())
            {
                // Kiểm tra xem sản phẩm đã tồn tại trong cùng một thương hiệu chưa
                var existingProduct = db.Product
                                        .FirstOrDefault(p => p.ProductName == product.ProductName && p.BrandID == product.BrandID);

                if (existingProduct != null)
                {
                    // Nếu sản phẩm đã tồn tại trong cùng thương hiệu, thêm lỗi vào ModelState
                    ModelState.AddModelError("ProductName", "Sản phẩm này đã tồn tại trong thương hiệu này.");
                    return View(product);  // Trả lại view với thông báo lỗi
                }
                // Kiểm tra nếu StockQuantity không âm
                if (product.StockQuantity < 0)
                {
                    ModelState.AddModelError("StockQuantity", "Stock quantity cannot be negative.");
                    return View(product);
                }
                // Kiểm tra nếu StockQuantity không âm
                if (product.Price < 0)
                {
                    ModelState.AddModelError("price", "price  cannot be negative.");
                    return View(product);
                }
                 

                if (product.Discount < 0)
                {
                    ModelState.AddModelError("Discount", "Discount  cannot be negative.");
                    return View(product);
                }
                // Kiểm tra nếu SupplierID hợp lệ
                var supplierExists = db.Supplier.Any(s => s.SupplierID == product.SupplierID);
                if (!supplierExists)
                {
                    ModelState.AddModelError("SupplierID", "The selected supplier does not exist.");
                    return View(product);
                }

                // Kiểm tra nếu Brand hợp lệ
                var brandExists = db.Brand.Any(b => b.BrandID == product.BrandID);
                if (!brandExists)
                {
                    ModelState.AddModelError("BrandID", "The selected Brand does not exist.");
                    return View(product);
                }

                //Kiểm tra nếu Category hợp lệ
                var categoryExists = db.Category.Any(c => c.CategoryID == product.CategoryID);
                if (!categoryExists)
                {
                    ModelState.AddModelError("CategoryID", "The selected Category does not exist.");
                    return View(product);
                }

                db.SaveChanges();
              

                // Handle the image file if it was uploaded
                if (ImageUrl != null && ImageUrl.ContentLength > 0)
                {
                    // Create directory path for the brand and product
                    var brand = db.Brand.FirstOrDefault(b => b.BrandID == product.BrandID)?.BrandName;
                    var productName = product.ProductName;

                    var directoryPath = Path.Combine(Server.MapPath("~/Content/img/"), brand, productName);
                    if (Directory.Exists(directoryPath))
                    {
                        ModelState.AddModelError("ImageUrl", "Sản phẩm đã được tạo");
                        //return View(product);
                    }
                    else
                    if (!Directory.Exists(directoryPath))
                    {
                        // Tạo thư mục mới với tên bao gồm productName + "Default"
                        string newDirectoryPathdefault = Path.Combine(directoryPath, productName + " Default");
                        string newDirectoryPathRelity = Path.Combine(directoryPath, productName + " Reality");
                        string newDirectoryPathFeedback = Path.Combine(directoryPath, productName + " Feedback");

                        Directory.CreateDirectory(newDirectoryPathdefault);
                        Directory.CreateDirectory(newDirectoryPathRelity);
                        Directory.CreateDirectory(newDirectoryPathFeedback);



                        // Generate the image file name and path
                        string fileName = Path.GetFileName(ImageUrl.FileName);
                        //string fileNameReality = Path.GetFileName(ImageDetail.FileName);
                        string filePath = Path.Combine(directoryPath, fileName);
                        ImageUrl.SaveAs(filePath);
                        product.ImageUrl = fileName;
                        // xg url


                        string fileNameReality = Path.GetFileName(ImageDetail.FileName);
                        string filePathReality = Path.Combine(newDirectoryPathRelity, fileName);
                        ImageDetail.SaveAs(filePath);

                        var realityImage = new Images_Reality
                        {
                            ProductID = product.ProductID,
                            URL_Images_Reality = (fileNameReality)
                        };
                        ImageDetail.SaveAs(filePathReality);

                        db.Images_Reality.Add(realityImage);
                        // xong Relity
                        SaveProductImageToDatabase(db, product, Image1, 1, newDirectoryPathdefault);
                        SaveProductImageToDatabase(db, product, Image2, 2, newDirectoryPathdefault);
                        SaveProductImageToDatabase(db, product, Image3, 3, newDirectoryPathdefault);
                        SaveProductImageToDatabase(db, product, Image4, 4, newDirectoryPathdefault);
                        SaveProductImageToDatabase(db, product, Image5, 5, newDirectoryPathdefault);
                        // xg default
                        // Save URL Video to the Video table
                        // Lưu URL video vào bảng Video
                        if (!string.IsNullOrEmpty(URLVideo))
                        {
                            var video = new Video
                            {
                                ProductID = product.ProductID,
                                URLVideo = URLVideo
                            };

                            db.Video.Add(video);
                            //db.SaveChanges();

                        }

                        product.CategoryID = 1;
                        product.AverageRating = 0;
                        product.Check_Remove = 1;
                        product.CreatedBy = 1;
                        product.CreatedAt = DateTime.Now;
                        //product.Discount = 0;
                      

                    }
                }

                // Kiểm tra xem đối tượng product và detail có hợp lệ không
                if (product == null || detail == null)
                {
                    ModelState.AddModelError("", "Product or detail cannot be null.");
                    return View();
                }

                if (string.IsNullOrEmpty(product.Description.ToString()))
                {
                    ModelState.AddModelError("Description", "Description cannot be empty.");
                    return View(product);
                }
                // Gán ProductID cho Detail
                detail.ProductID = product.ProductID; // Gán ProductID từ product vào detail

                // Kiểm tra các trường của Detail từ form nhập
                if (string.IsNullOrEmpty(detail.Waterproof.ToString()))
                {
                    ModelState.AddModelError("Waterproof", "The selected Waterproof cannot be empty.");
                }
                else
                {
                    // Thêm "MM" vào sau giá trị của Waterproof
                    detail.Waterproof = detail.Waterproof.ToString() + " ATM";
                }

                if (string.IsNullOrEmpty(detail.Thickness.ToString()))
                {
                    ModelState.AddModelError("Thickness", "The selected Thickness cannot be empty.");
                }
                else
                {
                    // Thêm "MM" vào sau giá trị của Waterproof
                    detail.Thickness = detail.Thickness.ToString() + " mm";
                }

                if (string.IsNullOrEmpty(detail.FaceSize.ToString()))
                {
                    ModelState.AddModelError("FaceSize", "The selected FaceSize cannot be empty.");
                }
                else
                {
                    // Thêm "MM" vào sau giá trị của Waterproof
                    detail.FaceSize = detail.FaceSize.ToString() + " mm";
                }


                if (string.IsNullOrEmpty(detail.GlassMaterial))
                {
                    ModelState.AddModelError("GlassMaterial", "The selected GlassMaterial cannot be empty.");
                }

                if (string.IsNullOrEmpty(detail.Material))
                {
                    ModelState.AddModelError("Material", "The selected Material cannot be empty.");
                }

                if (string.IsNullOrEmpty(detail.Typeof))
                {
                    ModelState.AddModelError("Typeof", "The selected Typeof cannot be empty.");
                }

                if (string.IsNullOrEmpty(detail.Origin))
                {
                    ModelState.AddModelError("Origin", "The selected Origin cannot be empty.");
                }
                var genderValue = Request.Form["GenderObject"];
                if (!string.IsNullOrEmpty(genderValue))
                {
                    // Chuyển đổi giá trị thành tên tương ứng
                    switch (genderValue)
                    {
                        case "1":
                            detail.GenderObject = "Nam";
                            break;
                        case "2":
                            detail.GenderObject = "Nữ";
                            break;
                        case "3":
                            detail.GenderObject = "cả Nam và Nữ";
                            break;
                        default:
                            detail.GenderObject = "Không xác định";
                            break;
                    }
                }


                // Nếu ModelState có lỗi thì trả lại view hiện tại
                if (!ModelState.IsValid)
                {
                    return View(product); // Hoặc return View(detail);
                }


                // Lưu sản phẩm vào cơ sở dữ liệu
                db.Product.Add(product);
                db.Detail.Add(detail);

                db.SaveChanges();

                return RedirectToAction("Index");
            }
        }

        // Hàm hỗ trợ để lưu ảnh vào Images_Default
        private void SaveProductImageToDatabase(WatchStoreEntities9 db, Product product, HttpPostedFileBase image, int imageNumber, string newDirectoryPathdefault)
        {
            if (image != null && image.ContentLength > 0)
            {
                string fileName = Path.GetFileName(image.FileName);
                string filePath = Path.Combine(newDirectoryPathdefault, (fileName));
                image.SaveAs(filePath);

                var defaultImage = new Images_Default
                {
                    ProductID = product.ProductID,
                    URL_Images_Default = (fileName)
                };
                db.Images_Default.Add(defaultImage);
            }
        }




        public ActionResult Edit(int id)
        {
            using (WatchStoreEntities9 db = new WatchStoreEntities9())
            {
                var product = db.Product.Find(id);
                if (product == null)
                {
                    return HttpNotFound();
                }

                // Populate the dropdowns
                ViewBag.Brands = db.Brand.ToList();
                ViewBag.Categorie = db.Category.ToList();


                return View(product);
            }
        }


        [HttpPost]
        public ActionResult Edit(Product pro, HttpPostedFileBase ImageUrl)
        {
            using (WatchStoreEntities9 db = new WatchStoreEntities9())
            {
                // Find the existing product in the database
                var product = db.Product.Find(pro.ProductID);
                if (product == null)
                {
                    return HttpNotFound();
                }

                // Check if the SupplierId is valid
                var supplierExists = db.Supplier.Any(s => s.SupplierID == pro.SupplierID);
                if (!supplierExists && pro.SupplierID != 0)
                {
                    ModelState.AddModelError("", "The selected supplier does not exist.");
                    return View(pro);
                }

                // Check if the BrandId is valid
                var brandExists = db.Brand.Any(b => b.BrandID == pro.BrandID);
                if (!brandExists && pro.BrandID != 0)
                {
                    ModelState.AddModelError("", "The selected brand does not exist.");
                    return View(pro);
                }

                // Check if the CategoryId is valid
                var categoryExists = db.Category.Any(c => c.CategoryID == pro.CategoryID);
                if (!categoryExists && pro.CategoryID != 0)
                {
                    ModelState.AddModelError("", "The selected category does not exist.");
                    return View(pro);
                }

                // Kiểm tra nếu có ảnh mới được tải lên
                if (ImageUrl != null && ImageUrl.ContentLength > 0)
                {
                    // Lấy tên file và đường dẫn
                    string fileName = Path.GetFileName(ImageUrl.FileName);
                    string directoryPath = Path.Combine(Server.MapPath("~/Content/img/"), product.Brand.BrandName,pro.ProductName );
                    string filePath = Path.Combine(directoryPath, fileName);

                    // Kiểm tra thư mục có tồn tại không, nếu không thì tạo
                    if (!Directory.Exists(directoryPath))
                    {
                        Directory.CreateDirectory(directoryPath);
                    }

                    // Kiểm tra nếu tệp đã tồn tại
                    if (!System.IO.File.Exists(filePath))
                    {
                        // Lưu ảnh mới nếu tệp chưa tồn tại
                        ImageUrl.SaveAs(filePath);
                    }

                    // Cập nhật tên file vào trường ImageUrl
                    product.ImageUrl = fileName;
                }
                else
                {
                    // Nếu không có ảnh mới, giữ nguyên ảnh cũ
                    product.ImageUrl = product.ImageUrl ?? ""; // Nếu ImageUrl cũ là null thì gán giá trị rỗng
                }

                // Cập nhật chi tiết sản phẩm chỉ khi giá trị mới hợp lệ
                product.ProductName = !string.IsNullOrEmpty(pro.ProductName) ? pro.ProductName : product.ProductName;
                product.Price = pro.Price > 0 ? pro.Price : product.Price;
                product.BrandID = pro.BrandID > 0 ? pro.BrandID : product.BrandID;
                product.CategoryID = pro.CategoryID > 0 ? pro.CategoryID : product.CategoryID;
                product.SupplierID = pro.SupplierID > 0 ? pro.SupplierID : product.SupplierID;
                product.StockQuantity = pro.StockQuantity > 0 ? pro.StockQuantity : product.StockQuantity;
                product.Discount = pro.Discount >= 0 ? pro.Discount : product.Discount;

                // Lưu thay đổi vào cơ sở dữ liệu
                db.SaveChanges();

                return RedirectToAction("Index");
            }
        }



        public ActionResult Detail(int? id)
        {
            WatchStoreEntities9 db = new WatchStoreEntities9();

            // Lấy thông tin sản phẩm
            Product pro = db.Product.FirstOrDefault(row => row.ProductID == id);
            if (pro == null)
            {
                // Nếu không tìm thấy sản phẩm
                ViewBag.AverageRating = 0;
                ViewBag.TotalQuantitySold = 0;
                ViewBag.StockQuantity = 0;
                ViewBag.feedback = new Feedback { ProductID = id, Rating = 0 };
                ViewBag.ProductImage = new List<ProductImageViewModel>();
                return View(); // Trả về View rỗng
            }

            // Lấy thông tin phản hồi
            Feedback f = db.Feedback.FirstOrDefault(row => row.ProductID == id) ?? new Feedback
            {
                ProductID = id.Value,
                Rating = 0
            };

            if (f.Rating == null) f.Rating = 0;
            ViewBag.feedback = f;

            // Lấy chi tiết sản phẩm
            Detail d = db.Detail.FirstOrDefault(row => row.ProductID == id);
            ViewBag.detail = d;

            // Truy vấn tổng số lượng đã bán
            var productSales = db.OrderItem
                .Join(db.Order, oi => oi.OrderID, o => o.OrderID, (oi, o) => new { oi, o })
                .Where(temp => temp.oi.ProductID == id && temp.o.Status == "Approved")
                .GroupBy(temp => temp.oi.ProductID)
                .Select(g => new
                {
                    TotalQuantitySold = g.Sum(x => x.oi.Quantity)
                })
                .FirstOrDefault();

            ViewBag.TotalQuantitySold = productSales?.TotalQuantitySold ?? 0;

            // Lấy số lượng tồn kho
            ViewBag.StockQuantity = pro.StockQuantity ?? 0;

            // Lấy hình ảnh sản phẩm
            var productImages = db.Images_Default
                .Where(img => img.ProductID == id)
                .Select(img => new ProductImageViewModel { Hinh = img.URL_Images_Default })
                .ToList();

            ViewBag.ProductImage = productImages;
            int feedbackCount = db.Feedback.Count(feedback => feedback.ProductID == id);
            ViewBag.a = feedbackCount;

            return View(pro);
        }


        public ActionResult Delete(int id)
        {


            WatchStoreEntities9 db = new WatchStoreEntities9();
            Product product = db.Product.Where(row => row.ProductID == id).FirstOrDefault();

            return View(product);
        }
        [HttpPost]
        public ActionResult Delete(int id, Product pro)
        {
            using (WatchStoreEntities9 db = new WatchStoreEntities9())
            {
                // Find the product to delete
                Product product = db.Product.Where(p => p.ProductID == id).FirstOrDefault();

                if (product == null)
                {
                    return HttpNotFound();
                }

                // Find and delete related OrderItem
                //var orderItems = db.OrderItem.Where(oi => oi.ProductID == id).ToList();
                //foreach (var orderItem in orderItems)
                //{
                //    db.OrderItem.Remove(orderItem);
                //}

                //// Now delete the product
                //db.Product.Remove(product);
                product.Check_Remove = 0;
                db.SaveChanges();

                return RedirectToAction("Index");
            }
        }




     


    }
}