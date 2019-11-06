﻿using System;
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

		#region Get Account By accountNo With CustomerId
		// GET api/getaccountbyid/5
		[HttpGet("getaccountbyNo/{accountNo}")]
		public Account GetAccount(string accountNo)
		{
			using (var db = new WebApiContext())
			{
				Account tempAccount = null;
				tempAccount = db.Accounts.FirstOrDefault(x => x.accountNo == accountNo);
				if (tempAccount == null)
				{
					return null;//Hesap bulunamadı.
				}
				else
					return tempAccount;
			}
		}
		#endregion

		#region Open An Account
		// POST api/user
		[HttpPost]
		[Route("openAnAccount")]
		public int PostOpenAnAccount([FromBody] TcIdentityKeyModel tcIdentityKeyModel)
		{
			using (var db = new WebApiContext())
			{
				User tempUser = db.Users.Where(x => x.TcIdentityKey == tcIdentityKeyModel.TcIdentityKey).FirstOrDefault();
				if (tempUser != null)
				{
					Account account = new Account();
					account.balance = 0;
					account.blockageAmount = 0;
					account.netBalance = 0;
					account.createdDate = DateTime.Now;
					account.lastTransactionDate = DateTime.Now;
					account.openingDate = DateTime.Now;
					account.updatedDate = DateTime.Now;
					account.customerId = tempUser.customerId;
					account.status = true;
					Account tempAccount = db.Accounts.OrderByDescending(p => p.createdDate).FirstOrDefault(x => x.customerId == tempUser.customerId);//Müşterinin son açtığı hesabı al.
					if (tempAccount != null)//Eğer müşterinin var olan en az bir hesabı varsa.
					{
						account.accountNo = (Convert.ToInt64(tempAccount.accountNo) + 1).ToString();//Son açtığı hesap numarasının üzerine +1 ekle.
					}
					else
					{
						account.accountNo = tcIdentityKeyModel.TcIdentityKey.ToString() + 1001;//Tc no'sunun yanına 1001 ekle.
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
		public int WithDrawMoney([FromBody] AccountNoAndMoney drawMoney)
		{
			using (var db = new WebApiContext())
			{
				Account tempAccount = db.Accounts.FirstOrDefault(x => x.accountNo == drawMoney.accountNo);//Hesabı bul.
				if (tempAccount == null)
				{
					return 0;//Hesap bulunamadı.
				}
				else
				{
					if (tempAccount.balance < drawMoney.Balance)
					{
						return 2;//Hesapta yeterli para yok.
					}
					else
					{
						tempAccount.balance -= drawMoney.Balance;//Hesaptan {balance} kadar para çek.
                        tempAccount.netBalance -= drawMoney.Balance;//Hesaptan {balance} kadar para çek.
                    }
				}
				try
				{
					db.SaveChanges();
				}
				catch (Exception)
				{

					return 0;//Veritabanına kaydedilirken hata oluştu!
				}
			}
			return 1;//Para başarıyla çekildi.
		}
		#endregion

		#region To Deposit Money
		[HttpPost]
		[Route("toDepositMoney")]
		public int toDepositMoney([FromBody] AccountNoAndMoney toDepositMoney)
		{
			using (var db = new WebApiContext())
			{
				Account tempAccount = db.Accounts.FirstOrDefault(x => x.accountNo == toDepositMoney.accountNo);//Hesabı bul.
				if (tempAccount == null)
				{
					return 0;//Böyle bir hesap bulunamadı.
				}
				else
				{
					tempAccount.balance += toDepositMoney.Balance;//Hesaba {balance} kadar para yatır.
					tempAccount.netBalance += toDepositMoney.Balance;
				}
				try
				{
					db.SaveChanges();
				}
				catch (Exception)
				{

					return 0;//Veritabanına kaydedilirken hata oluştu!
				}
			}
			return 1;//Para başarıyla yatırıldı.
		}
		#endregion

		#region Close Account By AccountNo
		// DELETE api/values/5
		[HttpPost]
		[Route("closeAccount")]
		public int CloseAccount([FromBody] Account AccountNo)
		{
			using (var db = new WebApiContext())
			{
				Account tempAccount = db.Accounts.FirstOrDefault(x => x.accountNo == AccountNo.accountNo);//İstenen id'ye sahip hesabı bul.
				if (tempAccount != null)
				{
					if (tempAccount.balance != 0)
					{
						return 2;//Hesapta para olduğu için kapatılamadı.
					}
					else
					{
						try
						{
							tempAccount.status = false;//Hesabı pasif hale getir.
							db.SaveChanges();
							return 1;//Başarıyla kapatıldı.
						}
						catch (Exception)
						{
							return 3;//Veritabanına kaydedilirken hata oluştu!
						}						
					}
				}
				else
					return 0;//Hesap bulunamadı.
			}			
		}
	}
	#endregion
}