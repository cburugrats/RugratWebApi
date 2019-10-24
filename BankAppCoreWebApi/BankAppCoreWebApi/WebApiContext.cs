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
		public DbSet<TransferTypesModel> TransferTypes { get; set; }

		protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
		{
			optionsBuilder.UseSqlServer(@"Server=desktop-fnnj9k8\sqlexpress; Database=RugratsDb; Trusted_Connection=true;");
		}

		protected override void OnModelCreating(ModelBuilder modelBuilder)
		{
			base.OnModelCreating(modelBuilder);

			modelBuilder.Query<TransferListModel>();
		}
	}
}
