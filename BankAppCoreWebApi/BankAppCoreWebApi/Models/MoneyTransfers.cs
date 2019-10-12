using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace BankAppCoreWebApi.Models
{
	public class MoneyTransfers:BaseEntity
	{
		public int Id { get; set; }
		public int senderAccountId { get; set; }
		public int balanceSent { get; set; }
		public int receiverAccountId { get; set; }
		public DateTime realizationTime { get; set; }
		public bool status { get; set; }
		public bool transferType { get; set; }
	}
}