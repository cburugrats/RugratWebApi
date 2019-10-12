﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace BankAppCoreWebApi
{
	public class Customer:BaseEntity
	{
		public int id { get; set; }
		public string firstname { get; set; }
		public string surname { get; set; }
		public DateTime dateOfBirth { get; set; }
		public int phoneNumber { get; set; }
		public string eMail { get; set; }
	}
}
