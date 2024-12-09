using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace WebApplication1.Models
{
    public class register
    {


        [Required(ErrorMessage = "FullName không được để trống.")]
        public string FullName { get; set; }

        [Required(ErrorMessage = "Email không được để trống.")]
        [RegularExpression(@"^\S+@gmail\.com$", ErrorMessage = "Email không hợp lệ hoặc chứa khoảng trắng.")]
        public string Email { get; set; }

        [Required(ErrorMessage = "Password không được để trống.")]
        [RegularExpression(@"^\S+$", ErrorMessage = "Password không hợp lệ hoặc chứa khoảng trắng.")]
        public string Password { get; set; }

        [Required(ErrorMessage = "Vui lòng chọn ảnh.")]
        
        public string Images { get; set; }

        [Required(ErrorMessage = "Phone không được để trống.")]
        [RegularExpression(@"^\d{10}$", ErrorMessage = "Số điện thoại phải gồm 10 chữ số và không có khoảng trắng.")]
        public string Phone { get; set; }

        [Required(ErrorMessage = "Gender không được để trống.")]
        [RegularExpression(@"^(Nam|Nữ)$", ErrorMessage = "Giới tính chỉ có thể là 'Nam' hoặc 'Nữ'.")]
        public string Gender { get; set; }

        [Required(ErrorMessage = "Address không được để trống.")]
        public string Address { get; set; }
        public Nullable<System.DateTime> CreatedAt { get; set; }
    }
}