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
		public int HavaleTranser([FromBody] HavaleModel havaleModel)
		{
			using (var db = new WebApiContext())
			{
				Account senderAccount = db.Accounts.Where(x => x.Id == havaleModel.senderAccountId).FirstOrDefault();
				if (senderAccount.balance >= havaleModel.amount)//Eğer gönderen hesapta yeterli para yoksa.
				{
					User receiverUser = db.Users.Where(x => x.TcIdentityKey == havaleModel.receiverTcIdentityKey).FirstOrDefault();
					if (receiverUser != null)//Alıcı kullanıcı bulunduysa.
					{
						Account receiverAccount = db.Accounts.Where(x => x.customerId == receiverUser.customerId && x.status == true).OrderBy(x => x.netBalance).FirstOrDefault();
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
							return 3;//Alıcıya ait aktif bir hesap bulunamadı!
						}
					}
					else
					{
						return 2;//Alıcı kullanıcı buluanamdı!
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
		public int VirmanTranser([FromBody] VirmanModel virmanModel)
		{
			using (var db = new WebApiContext())
			{
				//Account senderAccount=
				return 0;
			}				
		}

		#endregion Virman Transfer

	}
}