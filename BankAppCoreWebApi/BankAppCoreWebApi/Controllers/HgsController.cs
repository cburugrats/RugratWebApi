using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using BankAppCoreWebApi.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;

namespace BankAppCoreWebApi.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	public class HgsController : ControllerBase
	{
		#region Register Hgs
		// POST api/hgs
		[HttpPost]
		public async Task<int> PostRegisterAsync([FromBody] HgsUserModel userModel)
		{
			string url = "https://bankapphgswebapi.azurewebsites.net/api/user";
			return await HttpRequestAsync(userModel, "post", url);
		}
		#endregion Register Hgs

		#region Get Hgs User By accountNo With CustomerId
		// GET api/hgs/5
		[HttpGet("{customerId}")]
		public async Task<HgsUserModel> GetByIdAsync(int customerId)
		{
			string url = "https://bankapphgswebapi.azurewebsites.net/api/user/7";
			HgsUserModel result = new HgsUserModel();
			using (var client = new HttpClient())
			{
				var task = client.GetAsync(url)
				  .ContinueWith((taskwithresponse) =>
				  {
					  var response = taskwithresponse.Result;
					  var jsonString = response.Content.ReadAsStringAsync();
					  jsonString.Wait();
					  result = JsonConvert.DeserializeObject<HgsUserModel>(jsonString.Result);

				  });
				task.Wait();
			}
			return result;
		}

		#endregion Get Hgs User By accountNo With CustomerId

		#region To Deposit Money Hgs
		// PUT api/user/toDepositMoney
		[HttpPut("toDepositMoney")]
		public async Task<int> PutToDepositMoneyAsync([FromBody] HgsUserModel userModel)
		{
			string url = "https://bankapphgswebapi.azurewebsites.net/api/user/toDepositMoney";
			return await HttpRequestAsync(userModel, "put", url);
		}
		#endregion To Deposit Money Hgs

		#region With Draw Money Hgs
		// PUT api/user/withDrawMoney
		[HttpPut("withDrawMoney")]
		public async Task<int> PutWithDrawMoneyAsync(int id, [FromBody] HgsUserModel userModel)
		{
			string url = "https://bankapphgswebapi.azurewebsites.net/api/user/withDrawMoney";
			return await HttpRequestAsync(userModel, "put", url);
		}
		#endregion With Draw Money Hgs

		#region Http Request 
		public async Task<int> HttpRequestAsync([FromBody] HgsUserModel userModel, string requestType, string url)
		{
			string response = "";
			using (var client = new HttpClient())
			{
				var result = new HttpResponseMessage();
				client.BaseAddress = new Uri(url);
				var content = new StringContent(JsonConvert.SerializeObject(userModel), Encoding.UTF8, "application/json");
				if (requestType.Equals("put"))
				{
					result = await client.PutAsync(url, content);
				}
				else if (requestType.Equals("post"))
				{
					result = await client.PostAsync(url, content);
				}
				else
				{
					result = await client.PostAsync(url, content);
				}
				if (result.IsSuccessStatusCode)
				{
					result.EnsureSuccessStatusCode();
					response = await result.Content.ReadAsStringAsync();
				}
			}
			return Convert.ToInt32(response);
		}
		#endregion Http Request 
	}
}