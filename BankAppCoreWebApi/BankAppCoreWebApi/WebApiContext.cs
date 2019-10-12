using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using BankAppCoreWebApi.Models;
using Microsoft.EntityFrameworkCore;

namespace BankAppCoreWebApi
{
	public class WebApiContext:DbContext
	{
		public DbSet<User> Users { get; set; }
		public DbSet<Customer> Customers{ get; set; }
		public DbSet<Account> Accounts { get; set; }
		public DbSet<MoneyTransfers> MoneyTransfers { get; set; }

		protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
		{
			optionsBuilder.UseSqlServer(@"Server=LAPTOP-0D83SARE\SQL2012KURDUM; Database=RugratsDb; Trusted_Connection=true;");
		}
	}
}
