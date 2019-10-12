using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace BankAppCoreWebApi.Models
{
	public class Account:BaseEntity
	{
		public  int Id { get; set; }
		public int  customerId{ get; set; }
		public int balance { get; set; }
		public int blockageAmount { get; set; }
		public int netBalance { get; set; }
		public DateTime openingDate { get; set; }
		public DateTime lastTransactionDate { get; set; }
		public bool status{ get; set; }
	}

}
