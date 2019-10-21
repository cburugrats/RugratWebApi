using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace BankAppCoreWebApi.Models
{
	public class VirmanModel
	{
		public string senderAccountNo { get; set; }
		public string receiverAccountNo { get; set; }
		public decimal amount { get; set; }
	}
}
