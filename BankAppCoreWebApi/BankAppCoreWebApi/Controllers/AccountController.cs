using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using BankAppCoreWebApi.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;



namespace BankAppCoreWebApi.Controllers
{
	/// <author>Muhammet</author>


	[Route("api/[controller]")]
	[ApiController]
	public class AccountController : ControllerBase
	{
		#region getAccounts

		// GET api/user
		[HttpGet]
		[Route("{TcIdentityKey}")]
		public IEnumerable<Account> Get(long TcIdentityKey)
		{
			using (var db = new WebApiContext())
			{			
				User tempUser = db.Users.Where(x => x.TcIdentityKey == TcIdentityKey).FirstOrDefault();
				if (tempUser != null)
				{
					var temp = db.Accounts.Where(x => x.customerId == tempUser.customerId && x.status == true).ToList();//Sadece aktif olan hesapların listesini alıyor.				}
					return temp;
				}
				else
					return null;
			}
		}
		#endregion

		#region Get Account By accountId With CustomerId
		// GET api/user/5
		[HttpGet("{customerId}/{accountId}")]
		public Account GetAccount(long TcIdentityKey, int accountId)
		{
			using (var db = new WebApiContext())
			{
				User tempUser = db.Users.Where(x => x.TcIdentityKey == TcIdentityKey).FirstOrDefault();
				if (tempUser != null)
				{
					Account tempAccount = null;
					tempAccount = db.Accounts.FirstOrDefault(x => x.Id == accountId && x.customerId == tempUser.customerId);
					if (tempAccount == null)//Eğer müşteri daha önce hiç hesap açmadıysa
					{
						return null;
					}
					else
						return tempAccount;
				}
				else
					return null;
			}
		}
		#endregion 

		#region Open An Account
		// POST api/user
		[HttpPost]
		[Route("openAnAccount")]
		public int PostRegister([FromBody] int TcIdentityKey)
		{
			using (var db = new WebApiContext())
			{
				User tempUser = db.Users.Where(x => x.TcIdentityKey == TcIdentityKey).FirstOrDefault();
				if (tempUser != null)
				{
					Account account = new Account();
					account.balance = 0;
					account.blockageAmount = 0;
					account.netBalance = 0;
					Account tempAccount = db.Accounts.OrderByDescending(p => p.createdDate).FirstOrDefault(x => x.customerId == tempUser.customerId);//Müşterinin son açtığı hesabı al.
					if (tempAccount != null)//Eğer müşterinin var olan en az bir hesabı varsa.
					{
						account.accountNo = (Convert.ToInt64(tempAccount.accountNo) + 1).ToString();//Son açtığı hesap numarasının üzerine +1 ekle.
					}
					else
					{
						account.accountNo = tempUser.TcIdentityKey.ToString() + 1001;//Tc no'sunun yanına 1001 ekle.
					}
					try
					{
						db.Accounts.Add(account);
						db.SaveChanges();
					}
					catch (Exception)
					{
						return 2;//Veritabanına kaydedilemedi!
					}
					
					return 1;//Hesap başarıyla açıldı.
				}
				else
					return 0;//Bu tcno ile kayıtlı kullanıcı bulunamadı!
			}
		}
		#endregion

		#region With Draw Money
		[HttpPost]
		[Route("withDrawMoney")]
		public int WithDrawMoney([FromBody] AccountIdAndMoney drawMoney)
		{
			using (var db = new WebApiContext())
			{
				Account tempAccount = db.Accounts.FirstOrDefault(x => x.Id == drawMoney.Id);//Hesabı bul.
				if (tempAccount == null)//Eğer müşteri daha önce hiç hesap açmadıysa
				{
					return 0;
				}
				else
				{
					tempAccount.balance -= drawMoney.Balance;//Hesaptan {balance} kadar para çek.
				}
				try
				{
					db.SaveChanges();
				}
				catch (Exception)
				{

					return 0;
				}
			}
			return 1;
		} 
		#endregion

		#region To Deposit Money
		[HttpPost]
		[Route("toDepositMoney")]
		public int toDepositMoney([FromBody] AccountIdAndMoney toDepositMoney)
		{
			using (var db = new WebApiContext())
			{
				Account tempAccount = db.Accounts.FirstOrDefault(x => x.Id == toDepositMoney.Id);//Hesabı bul.
				if (tempAccount == null)//Eğer müşteri daha önce hiç hesap açmadıysa
				{
					return 0;
				}
				else
				{
					tempAccount.balance += toDepositMoney.Balance;//Hesaba {balance} kadar para yatır.
				}
				try
				{
					db.SaveChanges();
				}
				catch (Exception)
				{

					return 0;
				}
			}
			return 1;
		} 
		#endregion

		#region HttpPut
		// PUT api/user/5
		[HttpPut("{id}")]
		public void Put(int id, [FromBody] string value)
		{

		}
		#endregion

		#region Close Account By AccountId
		// DELETE api/values/5
		[HttpDelete("{id}")]
		public int CloseAccount(int id)
		{
			using (var db = new WebApiContext())
			{
				try
				{
					var tempAccount = db.Accounts.FirstOrDefault(x => x.Id == id);//İstenen id'ye sahip hesabı bul.
					tempAccount.status = false;//Hesabı pasif hale getir.
					db.SaveChanges();
				}
				catch (Exception)
				{
					return 0;
				}
				return 1;
			}
		} 
		#endregion
	}
}