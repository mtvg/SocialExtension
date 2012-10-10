package net.mtvg.air
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	[Event(name="complete",type="flash.events.Event")]
	[Event(name="cancel",type="flash.events.Event")]
	
	public class SocialExtension extends EventDispatcher
	{
		private const SOCIAL_EXTENSION_EVENT:String = 'socialExtensionEvent';
		private static const EXTENSION_ID:String = 'net.mtvg.air.SocialExtension';
		
		public static const SERVICE_FACEBOOK:int = 0;
		public static const SERVICE_TWITTER:int = 1;
		public static const SERVICE_SINAWEIBO:int = 2;
		
		private static var extContext:ExtensionContext;
		
		public function SocialExtension()
		{
			if (!extContext)
				initExtension();
			
			extContext.addEventListener(StatusEvent.STATUS, onStatus);
		}
		
		public function shareComposer(serviceType:int, shareText:String="", shareURL:String="", shareImage:BitmapData=null):Boolean
		{
			return extContext.call("composeViewController", serviceType, shareText, shareURL, shareImage);
		}
		
		private function onStatus(e:StatusEvent):void
		{
			if (e.code == SOCIAL_EXTENSION_EVENT)
				dispatchEvent(new Event(e.level=='cancelled'?Event.CANCEL:Event.COMPLETE));
		}
		
		private static function initExtension():void
		{
			extContext = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
		}
	}
}