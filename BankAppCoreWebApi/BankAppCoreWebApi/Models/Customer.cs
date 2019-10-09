using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace BankAppCoreWebApi
{
	public class Customer:BaseEntity
	{
		public int id { get; set; }
		public int userId { get; set; }
		public string name { get; set; }
		public string surname { get; set; }
		public DateTime dateOfBirth { get; set; }
		public int phoneNumber { get; set; }
	}
}
