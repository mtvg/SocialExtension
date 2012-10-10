package net.mtvg.air
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	[Event(name="complete",type="flash.events.Event")]
	[Event(name="cancel",type="flash.events.Event")]
	
	public class SocialExtension extends EventDispatcher
	{
		private const SOCIAL_EXTENSION_EVENT:String = 'socialExtensionEvent';
		private static const EXTENSION_ID:String = 'net.mtvg.air.SocialExtension';
		
		public static const SERVICE_FACEBOOK:int = 0;
		public static const SERVICE_TWITTER:int = 1;
		public static const SERVICE_SINAWEIBO:int = 2;
		
		public function SocialExtension()
		{
		}
		
		public function shareComposer(serviceType:int, shareText:String="", shareURL:String="", shareImage:BitmapData=null):Boolean
		{
			var req:URLRequest;
			var vars:URLVariables;
			
			switch (serviceType)
			{
				case SERVICE_FACEBOOK:
					req = new URLRequest("http://www.facebook.com/sharer/sharer.php");
					vars = new URLVariables;
					vars.u = shareURL;
					vars.t = shareText;
					req.data = vars;
					navigateToURL(req, "_blank");
					return true;
				case SERVICE_TWITTER:
					req = new URLRequest("https://twitter.com/intent/tweet");
					vars = new URLVariables;
					vars.url = shareURL;
					vars.text = shareText;
					req.data = vars;
					navigateToURL(req, "_blank");
					return true;
				case SERVICE_SINAWEIBO:
				default:
					return false;
			}
		}
	}
}