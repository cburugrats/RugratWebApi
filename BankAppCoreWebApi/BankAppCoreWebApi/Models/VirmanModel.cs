using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace BankAppCoreWebApi.Models
{
	public class VirmanModel
	{
		public int senderAccountId { get; set; }
		public int receiverAccountId { get; set; }
		public decimal amount { get; set; }
	}
}
