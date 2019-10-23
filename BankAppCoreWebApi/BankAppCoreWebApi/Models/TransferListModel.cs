using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace BankAppCoreWebApi.Models
{
	public class TransferListModel
	{
		public string receiverAccountNo { get; set; }
		public string senderAccountNo { get; set; }
		public string transferType { get; set; }
		public decimal balanceSent { get; set; }
		public DateTime? createdDate { get; set; }
	}
}
