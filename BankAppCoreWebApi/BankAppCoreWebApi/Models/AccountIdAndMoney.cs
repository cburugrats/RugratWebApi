﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace BankAppCoreWebApi.Models
{
	public class AccountIdAndMoney
	{
		public int Id { get; set; }
		public decimal Balance { get; set; }
	}
}
