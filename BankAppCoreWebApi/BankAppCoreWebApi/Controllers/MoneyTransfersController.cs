using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using BankAppCoreWebApi.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace BankAppCoreWebApi.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	public class MoneyTransfersController : ControllerBase
	{

		#region Havale Transfer
		[HttpPost]
		[Route("havale")]
		public int HavaleTranser([FromBody] MoneyTransferModel havaleModel)
		{
			using (var db = new WebApiContext())
			{
				Account senderAccount = db.Accounts.Where(x => x.accountNo == havaleModel.senderAccountNo).FirstOrDefault();//Gönderenin hesabı bulunuyor.
				if (senderAccount.balance >= havaleModel.amount)//Eğer gönderen hesapta yeterli para yoksa.
				{
						Account receiverAccount = db.Accounts.Where(x => x.accountNo == havaleModel.receiverAccountNo && x.status == true).FirstOrDefault();//Alıcı hesap bulunuyor.
						if (receiverAccount != null)//Alıcı hesap bulunduysa.
						{
							senderAccount.balance -= havaleModel.amount;
							receiverAccount.balance += havaleModel.amount;
							//MoneyTransfers moneyTransfer = new MoneyTransfers() { balanceSent = havaleModel.amount, realizationTime = DateTime.Now, receiverAccountNo = receiverAccount.accountNo, senderAccountNo = senderAccount.accountNo, status = true, transferType = true, createdDate = DateTime.Now, updatedDate = DateTime.Now };
							try
							{
								//db.MoneyTransfers.Add(moneyTransfer);
								db.SaveChanges();
								return 1;//Para başarıyla diğer müşteriye aktarıldı.
							}
							catch (Exception)
							{

								return 4;//Veritabanına kaydedilirken hata oluştu!
							}
						}
						else
						{
							return 3;//Alıcıya ait aktif hesap bulunamadı!
						}

				}
				else
				{
					return 0;//Hesapta yeterli bakiye yok!
				}
			}
		}

		#endregion Havale Transfer

		#region Virman Transfer

		[HttpPost]
		[Route("virman")]
		public int VirmanTranser([FromBody] MoneyTransferModel virmanModel)
		{
			using (var db = new WebApiContext())
			{
				Account senderAccount = db.Accounts.Where(x => x.accountNo == virmanModel.senderAccountNo).FirstOrDefault();
				Account receiverAccoount = db.Accounts.Where(x => x.accountNo == virmanModel.receiverAccountNo).FirstOrDefault();
				if (senderAccount.customerId!=receiverAccoount.customerId)
				{
					return 2;//Para göndermeye çalıştğınız hesap size ait değil!
				}
				else
				{
					if (senderAccount.balance >= virmanModel.amount)
					{
						senderAccount.balance -= virmanModel.amount;
						receiverAccoount.balance += virmanModel.amount;
						try
						{
							db.SaveChanges();
							return 1;//Para gönderme işlemi başarılı.
						}
						catch (Exception)
						{
							return 3;//Veritabanına kaydedilirken hata oluştu!
						}
					}
					else
						return 4;//Hesapta yeterli para yok.
				}
			}				
		}

		#endregion Virman Transfer

	}
}