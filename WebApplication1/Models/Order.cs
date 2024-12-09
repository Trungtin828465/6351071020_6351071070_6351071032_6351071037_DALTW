//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace WebApplication1.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class Order
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Order()
        {
            this.OrderItem = new HashSet<OrderItem>();
        }
    
        public int OrderID { get; set; }
        public Nullable<System.DateTime> OrderDate { get; set; }
        public int CustomerID { get; set; }
        public Nullable<int> OrderStatus { get; set; }
        public Nullable<int> Discount_Code { get; set; }
        public string Status { get; set; }
        public Nullable<decimal> TotalPrice { get; set; }
        public string ReceiverName { get; set; }
        public string ReceiverGender { get; set; }
        public string ReceiverPhone { get; set; }
        public string ReceiverAddress { get; set; }
        public string HouseNumber { get; set; }
        public string Note { get; set; }
    
        public virtual Customer Customer { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<OrderItem> OrderItem { get; set; }
    }
}
