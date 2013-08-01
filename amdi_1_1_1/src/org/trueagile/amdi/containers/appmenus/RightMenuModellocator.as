package org.trueagile.amdi.containers.appmenus
{
	import mx.controls.Menu;
	
	[Bindable]
	public class RightMenuModellocator
	{
		private static var instance:RightMenuModellocator;
		
		public var menu:Menu;
		
		
		public function RightMenuModellocator()
		{
			if(instance==null){
				instance = this;
			}
		}
		
		public static function getInstance():RightMenuModellocator{
			if(instance==null){
				instance = new RightMenuModellocator();
			}
			return instance;
		}
		
		/** 
		 * 如果显示过Menu，则先释放资源 
		 *  
		 */       
		public function removeMenu():void  
		{  
			if(menu!=null)  
			{  
				menu.hide();  
				//menu.removeEventListener(MenuEvent.ITEM_CLICK,menuItemClickHandler);  
				menu=null;  
			}  
		}  
	}
}