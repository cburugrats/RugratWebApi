using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace BankAppCoreWebApi.Models
{
	public class HavaleModel
	{
		public long receiverTcIdentityKey { get; set; }
		public int senderAccountId { get; set; }
		public decimal amount { get; set; }
		public DateTime? realizationTime { get; set; }
	}
}
