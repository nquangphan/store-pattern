using System;
using System.Collections.Generic;

namespace BlueCoffeeManagement
{
    public class ReportModel
    {
        public string CustomerName { get; set; }
        public DateTime Date { get; set; }
        public List<OrderItem1> OrderItems { get; set; }
    }
    public class OrderItem1
    {
        public string Name { get; set; }
        public int Price { get; set; }
        public int Count { get; set; }
    }
}