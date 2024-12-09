using System;
using System.Collections.Generic;
using System.Drawing.Printing;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Net;
using System.Web;
using System.Web.Mvc;
using System.Web.UI;
using WebApplication1.Models;
using System.Data.Entity;
using Antlr.Runtime.Tree;
using Org.BouncyCastle.Asn1.X509;


namespace WebApplication1.Controllers
{
    public class XuhuongController : Controller
    {
        private int _savedProductId;
        public double AverageRating { get; set; }

        public int GetId1()
        {
            return _savedProductId; // Trả về giá trị ID đã lưu
        }

        public class YourViewModel
        {
            public List<Product> Product { get; set; } // Danh sách sản phẩm
            public List<Customer> Customer { get; set; } // Danh sách sản phẩm
            public List<Detail> Detail { get; set; } // Danh sách chi tiết sản phẩm
            public List<Images_Default> Images_Default { get; set; } // Hình ảnh mặc định
            public List<Images_Reality> Images_Realities { get; set; } // Hình ảnh thực tế
            public List<Images_Certification> images_Certifications { get; set; }
            public List<Feedback> feedbacks { get; set; } // Danh sách thương hiệu
            public List<Brand> Brand { get; set; } // Danh sách thương hiệu
            public List<Video> Videos { get; set; }
            public int ProductId { get; set; } // ID của sản phẩm
            public string BrandName { get; set; } // Tên thương hiệu
            public string ImageUrl { get; set; } // Tên sản phẩm
            public string ProductName { get; set; } // Tên sản phẩm
            public string PageID { get; set; }
            public string checkSoLuong { get; set; }
            public string tabChild { get; set; }
            public string tab { get; set; }

            public List<Product> Producttab { get; set; } // Danh sách sản phẩm
            public List<Product> searchProduct { get; set; } // Danh sách sản phẩm



        }

        // GET: Xuhuong
        public ActionResult GioiThieu()
        {

            return View();
        }
        public ActionResult Xuhuong()
        {
            using (WatchStoreEntities9 db = new WatchStoreEntities9())
            {
                var products = db.Product.ToList();
                var brands = db.Brand.ToList();
                var detail = db.Detail.ToList();
                var viewModel = new YourViewModel
                {
                    Product = products,
                    Detail = detail,
                    Brand = brands,
                };
                return View(viewModel);
            }
        }
        [HttpPost]
        public ActionResult XuHuong(string imageName)
        {
            // Lưu tên ảnh vào Session
            Session["ImageName"] = imageName;

            return Json(new { result = imageName }, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public ActionResult XuHuong2(string tab, string tabChild)
        {
            Session["Tab"] = tab;
            Session["TabChild"] = tabChild;

            return Json(new { tab = tab, tabChild = tabChild }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult BanHang(int page = 1, string filterType = "")
        {
            var previousImageName = Session["PreviousImageName"] as string;
            var previousTabChild = Session["PreviousTabChild"] as string;

            var imageName = Session["ImageName"] as string;
            var tab = Session["tab"] as string;
            var tabChild = Session["tabChild"] as string;

            if (!string.IsNullOrEmpty(imageName) && imageName != previousImageName)
            {
                tab = null;
                tabChild = null;

                Session["PreviousImageName"] = imageName;
            }
            else if (!string.IsNullOrEmpty(tabChild) && tabChild != previousTabChild && tab == "search")
            {
                imageName = null;

                Session["PreviousTabChild"] = tabChild;
            }
            else if (!string.IsNullOrEmpty(tabChild) && tabChild != previousTabChild)
            {
                imageName = null;

                Session["PreviousTabChild"] = tabChild;
            }

            Session["ImageName"] = imageName;
            Session["tab"] = tab;
            Session["tabChild"] = tabChild;

            using (WatchStoreEntities9 db = new WatchStoreEntities9())
            {
                int pageSize = 8;
                var query = db.Product
                    .Where(p => p.Brand.BrandName == imageName);
                IEnumerable<Product> queryLayout = (from product in db.Product
                                                    join Detail in db.Detail
                                                    on product.ProductID equals Detail.ProductID
                                                    where
                                                     
                                                      (
                                                          // Điều kiện tìm kiếm theo tên sản phẩm khi tab == "search"
                                                          (tab == "search" && product.ProductName.Contains(tabChild))
                                                      ) ||
                                                      // latout Nam Nu
                                                      (Detail.GenderObject==tab && (( 
                                                      (tabChild == "duoi1trieu" && product.Price < 1000000)    || 
                                                      (tabChild == "1den2trieu" && (product.Price >= 1000000 && product.Price < 2000000)) || 
                                                      (tabChild == "2den4trieu" && (product.Price >= 2000000 && product.Price < 4000000))   || 
                                                      (tabChild == "tren4trieu" && product.Price >= 4000000))  || 
                                                      product.Brand.BrandName == tabChild ||
                                                      Detail.Typeof == tabChild))
                                                      
                                                  
                                                     || ((tab == "nuoc" &&
                                                           (Detail.Origin == tabChild ||
                                                            Detail.Material == tabChild
                                                        ))) ||
                                                        (tab=="xuhuong"&&(tabChild== "Luxury" && product.Price>4000000)|| (tabChild == "giare" && product.Price < 1000000))
                                                        || (tabChild == "xuhuong" && product.CreatedAt.HasValue && product.CreatedAt.Value.Year == 2024)
                                                    select product)
                                        .Distinct()
                                        .ToList();


                switch (filterType)
                {
                    case "NoiBat":
                        if (!string.IsNullOrEmpty(imageName))
                        {
                            // Lấy ra sản phẩm có tổng số lượng bán ra nhiều nhất và sắp xếp giảm dần
                            query = query
                            .Join(db.OrderItem, p => p.ProductID, oi => oi.ProductID, (p, oi) => new { p, oi })
                            .GroupBy(x => x.p.ProductID)
                            .Select(g => new
                            {
                                Product = g.FirstOrDefault().p,
                                TotalSold = g.Sum(x => x.oi.Quantity)
                            })
                            .OrderByDescending(p => p.TotalSold)
                            .Select(p => p.Product);
                        }
                        else if (!string.IsNullOrEmpty(tabChild))
                        {
                            queryLayout = queryLayout
                                .Join(db.OrderItem, p => p.ProductID, oi => oi.ProductID, (p, oi) => new { p, oi })
                                .GroupBy(x => x.p.ProductID)
                                .Select(g => new
                                {
                                    Product = g.FirstOrDefault().p,
                                    TotalSold = g.Sum(x => x.oi.Quantity)
                                })
                                .OrderByDescending(p => p.TotalSold)
                                .Select(p => p.Product);

                        }
                        break;


                    case "DanhGiaNhieu":
                        if (!string.IsNullOrEmpty(imageName))
                        {
                            // Lấy ra sản phẩm có AverageRating lớn nhất và sắp xếp giảm dần theo AverageRating
                            query = query
                            .OrderByDescending(p => p.AverageRating)
                            .Select(p => p);
                        }
                        else if (!string.IsNullOrEmpty(tabChild))
                        {
                            queryLayout = queryLayout
                           .OrderByDescending(p => p.AverageRating)
                           .Select(p => p);
                        }
                        break;


                    case "SaleLon":
                        // Lọc sản phẩm có Discountlon
                        if (!string.IsNullOrEmpty(imageName))
                        {
                            query = query
                                .Where(p => p.Discount < 50)
                                .OrderByDescending(p => p.Discount);
                            queryLayout = null;

                        }
                        else if (!string.IsNullOrEmpty(tabChild))
                        {
                            queryLayout = queryLayout
                                .Where(p => p.Discount < 50)
                                .OrderByDescending(p => p.Discount);
                        }
                        break;

                    case "GiaGiamDan":
                        // Sắp xếp giá giảm dần
                        if (!string.IsNullOrEmpty(imageName))
                        {
                            query = query.OrderByDescending(p => p.Price);
                        }
                        else if (!string.IsNullOrEmpty(tabChild))
                        {
                            queryLayout = queryLayout.OrderByDescending(p => p.Price);
                        }
                        break;
                    case "GiaTangDan":
                        if (!string.IsNullOrEmpty(tabChild))
                        {
                            queryLayout = queryLayout.OrderBy(p => p.Price);
                        }
                        else if (!string.IsNullOrEmpty(imageName))
                        {
                            // Sắp xếp giá tăng dần
                            query = query.OrderBy(p => p.Price);
                        }

                        break;
                    case "Duoi1Trieu":
                        if (!string.IsNullOrEmpty(imageName))
                        {
                            // Lọc sản phẩm có giá dưới 1 triệu và sắp xếp theo giá giảm dần
                            query = query.Where(p => p.Price < 1000000).OrderByDescending(p => p.Price);
                        }
                        else if (!string.IsNullOrEmpty(tabChild))
                        {
                            queryLayout = queryLayout.Where(p => p.Price < 1000000).OrderByDescending(p => p.Price);
                        }
                        break;

                    case "Tu1Den2Trieu":
                        if (!string.IsNullOrEmpty(imageName))
                        {
                            // Lọc sản phẩm có giá từ 1 triệu đến 2 triệu và sắp xếp theo giá giảm dần
                            query = query.Where(p => p.Price >= 1000000 && p.Price <= 2000000).OrderByDescending(p => p.Price);
                        }
                        else if (!string.IsNullOrEmpty(tabChild))
                        {
                            queryLayout = queryLayout.Where(p => p.Price >= 1000000 && p.Price <= 2000000).OrderByDescending(p => p.Price);
                        }
                        break;

                    case "Tu2Den4Trieu":
                        // Lọc sản phẩm có giá từ 2 triệu đến 4 triệu và sắp xếp theo giá giảm dần
                        if (!string.IsNullOrEmpty(imageName))
                        {
                            query = query.Where(p => p.Price >= 2000000 && p.Price <= 4000000).OrderByDescending(p => p.Price);
                        }
                        else if (!string.IsNullOrEmpty(tabChild))
                        {
                            queryLayout = queryLayout.Where(p => p.Price >= 2000000 && p.Price <= 4000000).OrderByDescending(p => p.Price);
                        }
                        break;

                    case "Tren4Trieu":
                        // Lọc sản phẩm có giá trên 4 triệu và sắp xếp theo giá giảm dần
                        if (!string.IsNullOrEmpty(imageName))
                        {
                            query = query.Where(p => p.Price > 4000000).OrderByDescending(p => p.Price);
                        }
                        else if (!string.IsNullOrEmpty(tabChild))
                        {
                            queryLayout = queryLayout.Where(p => p.Price > 4000000).OrderByDescending(p => p.Price);
                        }

                        break;

                    case "Nam":
                        // Lọc sản phẩm có CategoryName == "Nam"

                        // Gộp bảng Product và Detail, lọc không phân biệt chữ hoa, chữ thường
                        if (!string.IsNullOrEmpty(imageName))
                        {
                            query = query
                                  .Join(db.Detail,
                                        p => p.ProductID,
                                        c => c.ProductID,
                                        (p, c) => new { Product = p, Detail = c })
                                  .Where(x => x.Detail.GenderObject== "Nam")
                                  .Select(x => x.Product)
                                  .OrderBy(x => Guid.NewGuid());

                        }
                        else if (!string.IsNullOrEmpty(tabChild))
                        {
                            queryLayout = queryLayout
                                  .Join(db.Detail,
                                        p => p.ProductID,
                                        c => c.ProductID,
                                        (p, c) => new { Product = p, Detail = c })
                                  .Where(x => x.Detail.GenderObject == "Nam")
                                  .Select(x => x.Product)
                                  .OrderBy(x => Guid.NewGuid());
                        }
                        break;
                    case "Nu":
                        if (!string.IsNullOrEmpty(imageName))
                        {
                            query = query
                            .Join(db.Detail, p => p.ProductID, c => c.ProductID, (p, c) => new { p, c })
                            .Where(x => x.c.GenderObject == "Nữ")
                            .Select(x => x.p)
                            .OrderBy(p => p.ProductID);
                        }
                        else if (!string.IsNullOrEmpty(tabChild))
                        {
                            queryLayout = queryLayout
                           .Join(db.Detail, p => p.ProductID, c => c.ProductID, (p, c) => new { p, c })
                           .Where(x => x.c.GenderObject == "Nữ")
                           .Select(x => x.p)
                           .OrderBy(p => p.ProductID);
                        }
                        break;

                    case "TheThao":
                        // Lọc sản phẩm có CategoryName == "Nam"
                        if (!string.IsNullOrEmpty(imageName))
                        {
                            query = query
                            .Join(db.Category, p => p.CategoryID, c => c.CategoryID, (p, c) => new { p, c })
                            .Where(x => x.p.CategoryID == 2)
                            .Select(x => x.p);

                            query = query.AsEnumerable()
                                         .OrderBy(x => Guid.NewGuid())
                                         .AsQueryable();

                        }
                        else if (!string.IsNullOrEmpty(tabChild))
                        {

                            queryLayout = queryLayout
                          .Join(db.Category, p => p.CategoryID, c => c.CategoryID, (p, c) => new { p, c })
                          .Where(x => x.p.CategoryID == 4)
                          .Select(x => x.p);

                            queryLayout = queryLayout.AsEnumerable()
                                         .OrderBy(x => Guid.NewGuid())
                                         .AsQueryable();
                        }
                        break;
                    case "ThoiTrang":
                        // Lọc sản phẩm có CategoryName == "Nam"
                        if (!string.IsNullOrEmpty(imageName))
                        {
                            query = query
                            .Join(db.Category, p => p.CategoryID, c => c.CategoryID, (p, c) => new { p, c })
                            .Where(x => x.p.CategoryID == 1)
                            .Select(x => x.p);

                            query = query.AsEnumerable()
                                         .OrderBy(x => Guid.NewGuid())
                                         .AsQueryable();

                        }
                        else if (!string.IsNullOrEmpty(tabChild))
                        {


                            queryLayout = queryLayout
                          .Join(db.Category, p => p.CategoryID, c => c.CategoryID, (p, c) => new { p, c })
                          .Where(x => x.p.CategoryID == 5)
                          .Select(x => x.p);
                            queryLayout = queryLayout.AsEnumerable()
                                         .OrderBy(x => Guid.NewGuid())
                                         .AsQueryable();
                        }
                        break;
                    case "Unisex":
                        if (!string.IsNullOrEmpty(imageName))
                        {
                            query = query
                                    .Join(db.Detail,
                                          p => p.ProductID,
                                          c => c.ProductID,
                                          (p, c) => new { Product = p, Detail = c })
                                    .Where(x => x.Detail.GenderObject.ToLower() == "cả nam và nữ")
                                    .Select(x => x.Product)
                                    .OrderBy(x => Guid.NewGuid());
                        }
                        else if (!string.IsNullOrEmpty(tabChild))
                        {
                            queryLayout = queryLayout
                                    .Join(db.Detail,
                                          p => p.ProductID,
                                          c => c.ProductID,
                                          (p, c) => new { Product = p, Detail = c })
                                    .Where(x => x.Detail.GenderObject.ToLower() == "cả nam và nữ")
                                    .Select(x => x.Product)
                                    .OrderBy(x => Guid.NewGuid());
                        }
                        break;
                    case "Automatic":
                    case "Quartz":
                    case "Solar":
                    case "Cơ":
                    case "Mechanical":
                        if (!string.IsNullOrEmpty(imageName))
                        {
                            query = query
                            .Join(db.Detail, p => p.ProductID, c => c.ProductID, (p, c) => new { p, c })
                            .Where(x => x.c.Typeof == filterType)
                            .Select(x => x.p)
                            .OrderBy(p => p.ProductID);
                        }
                        else if (!string.IsNullOrEmpty(tabChild))
                        {
                            queryLayout = queryLayout
                           .Join(db.Detail, p => p.ProductID, c => c.ProductID, (p, c) => new { p, c })
                           .Where(x => x.c.Typeof == filterType)
                           .Select(x => x.p)
                           .OrderBy(p => p.ProductID);
                        }
                        break;
                    case "Sapphire":
                    case "Mineral":
                    case "Hardlex":
                    case "Kính Khoáng":
                        if (!string.IsNullOrEmpty(imageName))
                        {
                            query = query
                            .Join(db.Detail, p => p.ProductID, c => c.ProductID, (p, c) => new { p, c })
                            .Where(x => x.c.GlassMaterial == filterType)
                            .Select(x => x.p)
                            .OrderBy(p => p.ProductID);
                        }
                        else if (!string.IsNullOrEmpty(tabChild))
                        {
                            queryLayout = queryLayout
                          .Join(db.Detail, p => p.ProductID, c => c.ProductID, (p, c) => new { p, c })
                          .Where(x => x.c.GlassMaterial == filterType)
                          .Select(x => x.p)
                          .OrderBy(p => p.ProductID);
                        }
                        break;

                    case "36mm":
                    case "37mm":
                    case "38mm":
                    case "39mm":
                    case "40mm":
                    case "41mm":
                    case "42mm":
                    case "43mm":
                    case "45mm":
                    case "50mm":
                        if (!string.IsNullOrEmpty(imageName))
                        {
                            query = query
                            .Join(db.Detail, p => p.ProductID, c => c.ProductID, (p, c) => new { p, c })
                            .Where(x => x.c.FaceSize == filterType)
                            .Select(x => x.p)
                            .OrderBy(p => p.ProductID);
                        }
                        else if (!string.IsNullOrEmpty(tabChild))
                        {

                            queryLayout = queryLayout
                          .Join(db.Detail, p => p.ProductID, c => c.ProductID, (p, c) => new { p, c })
                          .Where(x => x.c.FaceSize == filterType)
                          .Select(x => x.p)
                          .OrderBy(p => p.ProductID);
                        }
                        break;



                    case "Dây Cao Su":
                    case "Dây Kim Loại":
                    case "Dây Da":
                    case "Dây Nhựa":
                    case "Dây Thép":
                    case "Dây Bạc":
                    case "Dây Inox":
                        if (!string.IsNullOrEmpty(imageName))
                        {
                            query = query
                            .Join(db.Detail, p => p.ProductID, c => c.ProductID, (p, c) => new { p, c })
                            .Where(x => x.c.Material == filterType)
                            .Select(x => x.p)
                            .OrderBy(p => p.ProductID);
                        }
                        else if (!string.IsNullOrEmpty(tabChild))
                        {

                            queryLayout = queryLayout
                         .Join(db.Detail, p => p.ProductID, c => c.ProductID, (p, c) => new { p, c })
                         .Where(x => x.c.Material == filterType)
                         .Select(x => x.p)
                         .OrderBy(p => p.ProductID);
                        }
                        break;

                    case "Nhật Bản":
                    case "Switzerland":
                    case "Đức":
                    case "Anh":
                    case "Ba Lan":
                    case "Hàn Quốc":
                    case "Pháp":
                    case "Trung Quốc":
                    case "Hoa Kỳ":
                    case "Thụy Sỹ":
                    case "Ý":
                    case "Tây Ban Nha":
                    case "Thái Lan":
                        if (!string.IsNullOrEmpty(imageName))
                        {
                            query = query
                            .Join(db.Detail, p => p.ProductID, c => c.ProductID, (p, c) => new { p, c })
                            .Where(x => x.c.Origin == filterType)
                            .Select(x => x.p)
                            .OrderBy(p => p.ProductID);
                        }
                        else if (!string.IsNullOrEmpty(tabChild))
                        {
                            queryLayout = queryLayout
                           .Join(db.Detail, p => p.ProductID, c => c.ProductID, (p, c) => new { p, c })
                           .Where(x => x.c.Origin == filterType)
                           .Select(x => x.p)
                           .OrderBy(p => p.ProductID);
                        }
                        break;


                    default:
                        // Sắp xếp mặc định nếu không có filterType
                        query = query.OrderBy(p => p.ProductID);
                        queryLayout = queryLayout.OrderBy(p => p.ProductID);
                        break;
                }


                if (!query.Any())
                {

                    ViewBag.NoProductsMessage = "Không có sản phẩm cho yêu cầu của bạn.";
                }



                // Kiểm tra nếu imageName có dữ liệu thì phân trang cho query
                if (!string.IsNullOrEmpty(imageName))
                {
                    var pagedProducts = query
                        .Skip((page - 1) * pageSize)
                        .Take(pageSize)
                        .ToList();


                    int totalProducts = query.Count();
                    int totalPages = (int)Math.Ceiling((double)totalProducts / pageSize);

                    var viewModel = new YourViewModel
                    {
                        Product = pagedProducts,
                        Producttab = new List<Product>(),
                        Detail = db.Detail.ToList(),
                        Brand = db.Brand.ToList(),
                        PageID = imageName,
                        tabChild = tabChild,
                        tab = tab,
                    };
                    ViewBag.TotalPages = totalPages;
                    ViewBag.CurrentPage = page;
                    ViewBag.FilterType = filterType;
                    return View(viewModel);
                }
                else if (!string.IsNullOrEmpty(tabChild))
                {
                    var pagedProductsTab = queryLayout
                        .Skip((page - 1) * pageSize)
                        .Take(pageSize)
                        .ToList();

                    int totalProductsTab = queryLayout.Count();
                    int totalPagesTab = (int)Math.Ceiling((double)totalProductsTab / pageSize);

                    ViewBag.TotalPagesTab = totalPagesTab;
                    ViewBag.CurrentPage = page;
                    ViewBag.FilterType = filterType;


                    var viewModel = new YourViewModel
                    {
                        Product = new List<Product>(),  // Không có dữ liệu cho imageName
                        Producttab = pagedProductsTab,
                        Detail = db.Detail.ToList(),
                        Brand = db.Brand.ToList(),
                        PageID = imageName,
                        tabChild = tabChild,
                        tab = tab,
                    };

                    return View(viewModel);
                }
                else
                {
                    // Trường hợp mặc định nếu cả imageName và tabChild đều không có dữ liệu
                    var viewModel = new YourViewModel
                    {
                        Product = new List<Product>(),  // Không có dữ liệu cho imageName
                        Producttab = new List<Product>(),  // Không có dữ liệu cho tabChild
                        Detail = db.Detail.ToList(),
                        Brand = db.Brand.ToList(),
                        PageID = imageName,
                        tabChild = tabChild,
                        tab = tab,
                    };

                    return View(viewModel);
                }

            }
        }



        public ActionResult partialBrand()
        {
            WatchStoreEntities9 db = new WatchStoreEntities9();
            var brand = db.Brand.ToList();
            return PartialView(brand);
        }

        public ActionResult Chi_tiet(int id)
        {
            _savedProductId = id;
            using (WatchStoreEntities9 db = new WatchStoreEntities9())
            {

                var products = db.Product.ToList();
                var customer = db.Customer.ToList();
                int productId = id;
                var selectedProduct = db.Product.FirstOrDefault(p => p.ProductID == productId);
                string brandName = null;
                string productName = null;
                string ImageUrl = null;
                int? brandId = null; // Để lưu BrandID nếu có

                if (selectedProduct != null)
                {
                    brandName = selectedProduct.Brand?.BrandName; // Lấy tên thương hiệu
                    productName = selectedProduct.ProductName; // Lấy tên sản phẩm
                    ImageUrl = selectedProduct.ImageUrl;
                    brandId = selectedProduct.BrandID; // Lấy BrandID từ sản phẩm


                }

                // Lấy danh sách chi tiết sản phẩm dựa trên ProductID
                var productDetails = db.Detail.Where(d => d.ProductID == productId).ToList();

                // Lấy danh sách hình ảnh mặc định dựa trên ProductID
                var imagesDefault = db.Images_Default.Where(i => i.ProductID == productId).ToList();

                // Lấy danh sách hình ảnh thực tế dựa trên ProductID
                var imagesReality = db.Images_Reality.Where(i => i.ProductID == productId).ToList();

                // Lấy danh sách chứng nhận (Images_Certification) theo BrandID
                var ImagesCertification = db.Images_Certification
                                            .Where(i => i.BrandID == brandId) // Lọc theo BrandID
                                            .ToList();

                var Feedback = db.Feedback.Where(i => i.ProductID == productId).ToList();

                var Video = db.Video.Where(i => i.ProductID == productId).ToList();


                // Lấy danh sách thương hiệu
                var brands = db.Brand.ToList();

                // Gộp dữ liệu vào ViewModel
                var viewModel = new YourViewModel
                {
                    Product = products,
                    Customer = customer,
                    Detail = productDetails, // Gán danh sách chi tiết sản phẩm vào ViewModel
                    Images_Default = imagesDefault, // Gán hình ảnh mặc định vào ViewModel
                    Images_Realities = imagesReality, // Gán hình ảnh thực tế vào ViewModel4
                    images_Certifications = ImagesCertification,

                    Videos = Video,
                    Brand = brands,
                    ProductId = productId, // Gán ID sản phẩm vào ViewModel
                    BrandName = brandName, // Gán tên thương hiệu vào ViewModel
                    ProductName = productName,// Gán tên sản phẩm vào ViewModel
                    ImageUrl = ImageUrl,
                    feedbacks = Feedback,
                };
                // Lấy 4 feedbacks đầu tiên
                var feedbacks = db.Feedback
                     .Where(f => f.ProductID == productId)
                     .OrderByDescending(f => f.CreatedAt)
                     .Take(4)  // Lấy 4 đánh giá mới nhất
                     .ToList();

                ViewBag.Feedbacks = feedbacks;


                var feedback = db.Feedback.Where(f => f.ProductID == productId).ToList();

                // Tính tổng số đánh giá
                var totalFeedbacks = feedback.Count();

                // Tính số lượng đánh giá cho mỗi mức sao
                var ratingCounts = new Dictionary<int, int>
                {
                    { 5, feedback.Count(f => f.Rating == 5) },
                    { 4, feedback.Count(f => f.Rating == 4) },
                    { 3, feedback.Count(f => f.Rating == 3) },
                    { 2, feedback.Count(f => f.Rating == 2) },
                    { 1, feedback.Count(f => f.Rating == 1) },
                };

                // Tính tỷ lệ phần trăm cho mỗi mức sao
                var ratingPercentages = ratingCounts.ToDictionary(
                    kvp => kvp.Key,
                    kvp => totalFeedbacks > 0 ? (kvp.Value / (double)totalFeedbacks) * 100 : 0
                );

                // Truyền dữ liệu vào ViewBag
                ViewBag.RatingCounts = ratingCounts;
                ViewBag.RatingPercentages = ratingPercentages;
                ViewBag.TotalFeedbacks = totalFeedbacks;
                var averageRating = feedbacks.Any() ? feedback.Average(f => f.Rating) : 0;

                // Truyền giá trị trung bình vào ViewBag
                ViewBag.AverageRating = averageRating;
                // Trả về View với ViewModel đã chuẩn bị
                return View(viewModel);
            }
        }



        public ActionResult LoadMoreFeedback(int productId, int skip)
        {
            WatchStoreEntities9 db = new WatchStoreEntities9();
            var feedbacks = db.Feedback
                              .Where(f => f.ProductID == productId)
                              .OrderByDescending(f => f.CreatedAt)
                              .Skip(skip)
                              .Take(2)
                              .ToList();

            ViewBag.Feedbacks = feedbacks;

            if (feedbacks.Any())
            {
                return PartialView("_FeedbackPartial");
            }
            else
            {
                return Content(""); // Nếu không có thêm feedbacks, trả về rỗng
            }
        }


        // Kiệt
        public ActionResult HistoryOrder()
        {
            WatchStoreEntities9 db = new WatchStoreEntities9();
            List<Order> orders = db.Order.ToList(); // Or fetch an existing order
            foreach (var a in orders)
            {
                var b = db.OrderItem.FirstOrDefault(n => n.OrderID == a.OrderID);
                a.TotalPrice = a.OrderItem.Sum(oi => oi.UnitPrice);
                if (b == null)
                {
                    db.Order.Remove(a);

                    db.SaveChanges();
                }
            }
            List<Order> orders2 = db.Order.ToList(); // Or fetch an existing order

            return View(orders2);
        }
        public ActionResult OrderDetails(int id)
        {
            WatchStoreEntities9 db = new WatchStoreEntities9();


            var orderItems = db.OrderItem
                               .Where(oi => oi.OrderID == id)
                               .Include(oi => oi.Product)
                               .ToList();

            if (orderItems == null || !orderItems.Any())
            {

                return RedirectToAction("XuHuong");
            }

            return View(orderItems);
        }

        public ActionResult XacNhanXoa(int id)
        {
            using (WatchStoreEntities9 db = new WatchStoreEntities9())
            {
                var orderItemToDelete = db.OrderItem.FirstOrDefault(o => o.OrderItemID == id);

                if (orderItemToDelete != null && orderItemToDelete.Order.Status == "Pending")
                {
                    int orderId = orderItemToDelete.OrderID.Value;

                    // Xóa OrderItem
                    db.OrderItem.Remove(orderItemToDelete);
                    db.SaveChanges();

                    // Kiểm tra nếu Order không còn OrderItem nào thì xóa Order
                    var remainingItems = db.OrderItem.Where(oi => oi.OrderID == orderId).ToList();
                    if (!remainingItems.Any())
                    {
                        var orderToDelete = db.Order.FirstOrDefault(o => o.OrderID == orderId);
                        if (orderToDelete != null)
                        {
                            db.Order.Remove(orderToDelete);
                            db.SaveChanges();
                        }
                    }
                    else
                    {
                        // Nếu còn OrderItem, cập nhật lại tổng tiền
                        var orderToUpdate = db.Order.FirstOrDefault(o => o.OrderID == orderId);
                        if (orderToUpdate != null)
                        {
                            orderToUpdate.TotalPrice = remainingItems.Sum(oi => oi.Quantity * oi.UnitPrice);
                            db.SaveChanges();
                        }
                    }

                    return RedirectToAction("OrderDetails", new { id = orderId });
                }
            }

            return RedirectToAction("XuHuong");
        }



        public ActionResult Find(string searchQuery)
        {
            return RedirectToAction("BanHang", new { search = searchQuery });
        }


        // Khanh
        public ActionResult GioHang()
        {
            WatchStoreEntities9 db = new WatchStoreEntities9();
            List<OrderItem> orderItems = db.OrderItem.ToList();
            var province = db.province.Select(p => new { p.province_id, p.province_name }).ToList();

            // Truyền danh sách tỉnh vào View dưới dạng SelectList
            ViewBag.Provinces = new SelectList(province, "province_id", "province_name");
            return View(orderItems);
        }
        [HttpGet]
        // Quận
        public ActionResult GetDistricts(int provinceId)
        {
            WatchStoreEntities9 db = new WatchStoreEntities9();

            // Lấy danh sách quận/huyện tương ứng với provinceId
            var district = db.district
                              .Where(d => d.province_id == provinceId)
                              .Select(d => new { d.district_id, d.name_district })
                              .ToList();

            // Trả về một phần tử JSON để cập nhật dropdown
            return Json(district, JsonRequestBehavior.AllowGet);
        }
        [HttpGet]
        // xã 
        public ActionResult GetWards(int districtId)
        {
            WatchStoreEntities9 db = new WatchStoreEntities9();

            // Lấy danh sách phường/xã tương ứng với districtId
            var wards = db.wards
                          .Where(w => w.district_id == districtId)
                          .Select(w => new { w.wards_id, w.wards_name })
                          .ToList();

            // Trả về một phần tử JSON để cập nhật dropdown phường/xã
            return Json(wards, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult IncreaseQuantity(int orderItemId)
        {
            System.Diagnostics.Debug.WriteLine($"Received OrderItemID: {orderItemId}");

            using (WatchStoreEntities9 db = new WatchStoreEntities9())
            {
                var orderItem = db.OrderItem.FirstOrDefault(o => o.OrderItemID == orderItemId && o.Order.OrderStatus == 0);
                if (orderItem != null)
                {
                    orderItem.Quantity += 1;
                    orderItem.UnitPrice = orderItem.Quantity * orderItem.Product.Price * (100 - orderItem.Product.Discount) / 100;
                    db.SaveChanges();

                    return Json(new { success = true, newQuantity = orderItem.Quantity, newPrice = orderItem.UnitPrice }, JsonRequestBehavior.AllowGet);
                }
                return Json(new { success = false });
            }
        }

        [HttpPost]
        public JsonResult DecreaseQuantity(int orderItemId)
        {
            System.Diagnostics.Debug.WriteLine($"Received OrderItemID: {orderItemId}");

            using (WatchStoreEntities9 db = new WatchStoreEntities9())
            {
                var orderItem = db.OrderItem.FirstOrDefault(o => o.OrderItemID == orderItemId && o.Order.OrderStatus == 0);
                if (orderItem != null)
                {
                    bool showConfirmation = false;

                    if (orderItem.Quantity == 1)
                    {
                        showConfirmation = true;
                    }
                    else
                    {
                        orderItem.Quantity -= 1; // Decrease quantity
                        orderItem.UnitPrice = orderItem.Quantity * orderItem.Product.Price * (100 - orderItem.Product.Discount) / 100;
                        db.SaveChanges();
                    }

                    return Json(new { success = true, newQuantity = orderItem.Quantity, newPrice = orderItem.UnitPrice, showConfirmation }, JsonRequestBehavior.AllowGet);
                }
                return Json(new { success = false });
            }
        }

        public ActionResult AddOrderItem()
        {
            return View();
        }

        [HttpPost]
        public ActionResult AddOrderItem(int productId)
        {
            using (WatchStoreEntities9 db = new WatchStoreEntities9())
            {
                string userEmail = Session["UserEmail"]?.ToString();
                if (string.IsNullOrEmpty(userEmail))
                    return RedirectToAction("Login", "Account");

                Random random = new Random();

                var product = db.Product.FirstOrDefault(p => p.ProductID == productId);
                var customer = db.Customer.FirstOrDefault(c => c.Email == userEmail);

                if (product == null || customer == null)
                    return RedirectToAction("GioHang");

                // Find an existing cart order (OrderStatus == 0) for the current customer
                var existingOrder = db.Order
                    .FirstOrDefault(o => o.CustomerID == customer.CustomerID && o.OrderStatus == 0);

                if (existingOrder == null)
                {
                    // Create a new order if no existing cart order is found
                    existingOrder = new Order
                    {
                        OrderDate = DateTime.Now,
                        CustomerID = customer.CustomerID,
                        //Discount_Code = random.Next(5, 15),
                        OrderStatus = 0,
                        Status = "Pending",
                    };
                    db.Order.Add(existingOrder);
                    db.SaveChanges();
                }

                // Check if the product is already in the cart
                var existingOrderItem = db.OrderItem
                    .FirstOrDefault(oi => oi.OrderID == existingOrder.OrderID && oi.ProductID == productId);

                if (existingOrderItem != null)
                {
                    // Increase the quantity if the item already exists
                    existingOrderItem.Quantity += 1;
                }
                else
                {
                    // Add a new item to the cart if it doesn't exist
                    OrderItem newOrderItem = new OrderItem
                    {
                        OrderID = existingOrder.OrderID,
                        ProductID = productId,
                        Quantity = 1,
                        UnitPrice = product.Price * (100 - product.Discount) / 100,
                    };
                    db.OrderItem.Add(newOrderItem);
                }

                db.SaveChanges();
                return RedirectToAction("Xuhuong");
            }
        }

        public ActionResult DeleteOrderItem(int id)
        {
            using (WatchStoreEntities9 db = new WatchStoreEntities9())
            {
                // Find the order by ID
                var orderToDelete = db.OrderItem.FirstOrDefault(o => o.OrderItemID == id && o.Order.OrderStatus == 0);

                if (orderToDelete != null)
                {
                    db.OrderItem.Remove(orderToDelete);
                    db.SaveChanges();
                }
                return RedirectToAction("GioHang");
            }
        }

        [HttpPost]

        public ActionResult Accept(int? id, FormCollection form)
        {
            decimal emailTotalPrice = 0;
            using (WatchStoreEntities9 db = new WatchStoreEntities9())
            {
                string userEmail = Session["UserEmail"]?.ToString();
                if (string.IsNullOrEmpty(userEmail))
                    return RedirectToAction("Login", "Account");

                var orderSelected = db.Order.FirstOrDefault(i => i.Customer.Email == userEmail && i.OrderStatus == 0);
                if (orderSelected == null)
                    return RedirectToAction("GioHang");


                string hoTen = form["HoTen"];
                if (!string.IsNullOrEmpty(hoTen))
                {
                    orderSelected.ReceiverName = hoTen; // Assign to ReceiverName field
                }

                string SoDienThoai = form["SoDienThoai"];
                if (!string.IsNullOrEmpty(SoDienThoai))
                {
                    orderSelected.ReceiverPhone = SoDienThoai; // Assign to ReceiverName field
                }

                // Retrieve form values
                string diaChi = form["DiaChi"]; // House number
                string idTinhThanh = form["Tinh"];  // Province
                string idQuanHuyen = form["QuanHuyen"]; // District
                string idPhuongXa = form["PhuongXa"];   // Ward
                string note = form["GhiChu"];
                string email = form["Email"];
                string voucher = form["MaGiamGia"];

                string nameTinh = db.province
                               .Where(p => p.province_id.ToString() == idTinhThanh)
                               .Select(p => p.province_name)
                               .FirstOrDefault();

                string nameHuyen = db.district
                               .Where(p => p.district_id.ToString() == idQuanHuyen)
                               .Select(p => p.name_district)
                               .FirstOrDefault();

                string nameXa = db.wards
                               .Where(p => p.wards_id.ToString() == idPhuongXa)
                               .Select(p => p.wards_name)
                               .FirstOrDefault();

                // Combine dropdown values for ReceiverAddress
                if (!string.IsNullOrEmpty(nameTinh) && !string.IsNullOrEmpty(nameHuyen) && !string.IsNullOrEmpty(nameXa))
                {
                    orderSelected.ReceiverAddress = $"{nameTinh} - {nameHuyen} - {nameXa}";
                }

                // Assign other fields
                if (!string.IsNullOrEmpty(hoTen))
                {
                    orderSelected.ReceiverName = hoTen;
                }

                if (!string.IsNullOrEmpty(diaChi))
                {
                    orderSelected.HouseNumber = diaChi;
                }
                if (!string.IsNullOrEmpty(note))
                {
                    orderSelected.Note = note;
                }

                var orderItems = db.OrderItem
                                   .Where(oi => oi.Order.Customer.Email == userEmail && oi.Order.OrderStatus == 0)
                                   .ToList();

                var usedVoucher = db.Voucher.FirstOrDefault(v => v.Code == voucher);
                if (usedVoucher != null)
                {
                    if (usedVoucher.Type == "P")
                    {
                        emailTotalPrice = (decimal)orderItems.Sum(oi => oi.UnitPrice) * (100 - usedVoucher.Value) / 100;
                        orderSelected.TotalPrice = orderItems.Sum(oi => oi.UnitPrice) * (100 - usedVoucher.Value) / 100;
                    }
                    else
                    {
                        emailTotalPrice = (decimal)orderItems.Sum(oi => oi.UnitPrice) - usedVoucher.Value;
                        orderSelected.TotalPrice = orderItems.Sum(oi => oi.UnitPrice) - usedVoucher.Value;
                    }


                    usedVoucher.RemainingUses--;
                }
                else
                {
                    emailTotalPrice = (decimal)orderItems.Sum(oi => oi.UnitPrice);
                    orderSelected.TotalPrice = orderItems.Sum(oi => oi.UnitPrice);
                }

                orderSelected.OrderStatus = 1;
                orderSelected.OrderDate = DateTime.Now;
                db.SaveChanges();

                try
                {
                    var smtpClient = new SmtpClient("smtp.gmail.com")
                    {
                        Port = 587, // Cổng SMTP của Gmail
                        Credentials = new NetworkCredential("watchstore4conga@gmail.com", "wfxx gjdt ucie kzdk"),
                        EnableSsl = true, // Bật SSL để bảo mật
                    };

                    string mailBody = "Đã đặt hàng lúc " + DateTime.Now + ":\n";
                    foreach (var item in db.OrderItem)
                    {
                        if (item.OrderID == orderSelected.OrderID)
                        {
                            mailBody += item.Product.ProductName + " x " + item.Quantity + "\n";
                        }
                    }

                    var mailMessage = new MailMessage
                    {
                        From = new MailAddress("watchstore4conga@gmail.com"), // Địa chỉ email gửi
                        Subject = "Lịch sử đặt hàng.",
                        Body = mailBody + "\nTổng giá trị: " + emailTotalPrice,
                        IsBodyHtml = true,
                    };

                    mailMessage.To.Add(Session["UserEmail"]?.ToString());

                    // Gửi email
                    smtpClient.Send(mailMessage);

                    TempData["ErrorMessage"] = "Gửi email thành công tới: " + Session["UserEmail"]?.ToString();
                }
                catch (Exception ex)
                {
                    TempData["ErrorMessage"] = $"Gửi email thất bại tới: " + Session["UserEmail"]?.ToString() + $" {ex.Message}";
                }
            }
            return RedirectToAction("GioHang");
        }



        [HttpPost]
        public ActionResult SubmitFeedback(
      string ChiaSe,
      string HoTen,
      string SDT,
      int? Rating,
      HttpPostedFileBase ImageFile,
      int ProductId)
        {
            WatchStoreEntities9 db = new WatchStoreEntities9();

            // Kiểm tra Session người dùng
            string userEmail = Session["UserEmail"]?.ToString();
            if (string.IsNullOrEmpty(userEmail))
                return RedirectToAction("Login", "Account");
            Rating = Rating ?? 0;
            if (!Rating.HasValue)  // Kiểm tra nếu Rating là null
            {
                ModelState.AddModelError("Rating", "Vui lòng nhập số sao.");
            }
            if (ModelState.IsValid)
            {



                if (string.IsNullOrWhiteSpace(ChiaSe))
                {
                    ModelState.AddModelError("ChiaSe", "Bạn cần chia sẻ cảm nhận về sản phẩm.");
                    return View();
                }

                if (string.IsNullOrWhiteSpace(HoTen))
                {
                    ModelState.AddModelError("HoTen", "Họ và tên không được để trống.");
                    return View();
                }

                if (string.IsNullOrWhiteSpace(SDT) || !System.Text.RegularExpressions.Regex.IsMatch(SDT, @"^\d{10,11}$"))
                {
                    ModelState.AddModelError("SDT", "Số điện thoại không hợp lệ (cần 10-11 chữ số).");
                    return View();
                }

                // Kiểm tra dữ liệu sản phẩm
                var product = db.Product.FirstOrDefault(p => p.ProductID == ProductId);
                if (product == null)
                    return HttpNotFound();

                // Kiểm tra file ảnh
                string directoryPath = Path.Combine(Server.MapPath("~/Content/Feedback/Feedback/"));
                if (!Directory.Exists(directoryPath))
                {
                    Directory.CreateDirectory(directoryPath);
                }

                string fileName = "";
                if (ImageFile != null && ImageFile.ContentLength > 0)
                {
                    fileName = Path.GetFileName(ImageFile.FileName);
                    string filePath = Path.Combine(directoryPath, fileName);

                    if (System.IO.File.Exists(filePath))
                    {
                        ModelState.AddModelError("ImageFile", "Ảnh bị trùng. Vui lòng đặt lại tên file ảnh.");
                        return View();
                    }

                    ImageFile.SaveAs(filePath);
                }

                // Thêm feedback
                var customer = db.Customer.FirstOrDefault(c => c.Email == userEmail);
                // Tính toán và cập nhật AverageRating
                if (product.AverageRating != 0)
                {
                    float newAverageRating = (float)((product.AverageRating ?? 0f) + Rating.Value) / 2f;
                    product.AverageRating = newAverageRating;
                }
                else { product.AverageRating = Rating; }
                // Gán lại giá trị cho AverageRating


                var feedback = new Feedback
                {
                    ProductID = ProductId,
                    CustomerID = customer.CustomerID,
                    FeedbackText = ChiaSe,
                    Rating = Rating.Value,
                    CreatedAt = DateTime.Now,
                    ImageFeedBack = fileName,
                    NameFeedback = HoTen
                };

                db.Feedback.Add(feedback);
                db.SaveChanges();

                return RedirectToAction("Xuhuong");
            }

            return View();
        }


        [HttpPost]
        public JsonResult checkVoucher(string code, decimal subtotal)
        {
            WatchStoreEntities9 db = new WatchStoreEntities9();
            var vouchers = db.Voucher.ToList();
            var selectedVoucher = vouchers.FirstOrDefault(v => v.Code.Equals(code, StringComparison.OrdinalIgnoreCase));

            var voucher = vouchers.FirstOrDefault(v =>
                v.Code.Equals(code, StringComparison.OrdinalIgnoreCase) &&
                v.RemainingUses > 0 &&
                v.status == 1 &&
                DateTime.Now < v.ExpDate &&
                subtotal >= v.MinOrderValue
            );

            if (voucher != null)
            {
                return Json(new
                {
                    success = true,
                    code = voucher.Code,
                    remaining = voucher.RemainingUses,
                    discount = voucher.Value,
                    vstatus = voucher.status,
                    date = DateTime.Now,
                    subtotal1 = subtotal,
                    typeVoucher = voucher.Type.ToString(),
                });
            }
            else
            {
                if (selectedVoucher.RemainingUses == 0)
                {
                    return Json(new
                    {
                        success = false,
                        message = "Voucher đạt giới hạn sử dụng."
                    });
                }

                else if (selectedVoucher.status == 0)
                {
                    return Json(new
                    {
                        success = false,
                        message = "Voucher không còn được áp dụng."
                    });
                }

                else if (selectedVoucher.ExpDate < DateTime.Now)
                {
                    return Json(new
                    {
                        success = false,
                        message = "Voucher quá hạn sử dụng."
                    });
                }

                else if (subtotal < selectedVoucher.MinOrderValue)
                {
                    return Json(new
                    {
                        success = false,
                        message = "Voucher áp dụng cho đơn hàng trên " + selectedVoucher.MinOrderValue.ToString() + "₫",
                    });
                }
                return Json(new
                {
                    success = false,
                    message = "Lỗi gì ai biết đâu",
                });
            }
        }
    }
}
