package org.trueagile.amdi.containers.appmenus
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.controls.Menu;
	import mx.events.FlexEvent;
	import mx.events.MenuEvent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	import org.trueagile.amdi.containers.MDIApplication;
	
	/**
	 *  Reference to class  for BasicMenu, changes to this style
	 * are detected.
	 *  @default org.trueagile.amdi.containers.appmenus.BasicMenu
	 */
	[Style(name="appMenuStyleName", type="Class", inherit="no")]
	
	/**
	 * This class implements the Basic Menu of Flex for the AppMDI Framework.
	 * @author mmarmol
	 * For this class to function rigth it need to set the mdiApplication propertie.
	 */
	public class BasicMenu implements ApplicationMenu
	{
		public var _menuXML:XML;
		
		private var _menu:Menu;
		
		private var _mdiApplication:MDIApplication;
		
		private var _menuStyleName:Object;
		
		private static var classConstructed:Boolean = classConstruct();
		
		/**
		 *Basic constructor. 
		 * 
		 */
		public function BasicMenu()
		{
		}

		/**
		 * Define and prepare default styles.
		 */
		private static function classConstruct():Boolean
		{
			//------------------------
		    //  type selector
		    //------------------------
			var selector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("MDIBasicMenu");
			if(!selector)
			{
				selector = new CSSStyleDeclaration();
			}
			// these are default names for secondary styles. these can be set in CSS and will affect
			// all applications that don't have an override for these styles.
			selector.defaultFactory = function():void
			{
				this.appMenuStyleName="appMenu";
			}

			//------------------------
		    //  Application Menu
		    //------------------------
			var appMenuStyleName:String = selector.getStyle("appMenuStyleName");
			var appMenuSelector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("." + appMenuStyleName);
			if(!appMenuSelector)
			{
				appMenuSelector = new CSSStyleDeclaration();
			}
			appMenuSelector.defaultFactory = function():void
			{
				this.rollOverColor=0xA5A5A5;
				this.selectionColor=0xE0E0E0;
				this.backgroundColor=0x000000;
				this.borderColor=0x000000;
				this.cornerRadius=6;
				this.borderThickness=2;
				this.fontSize=11;
				this.paddingTop=6;
				this.paddingBottom=6;
				this.openDuration=0;
				this.borderStyle="solid";
				this.color=0xFFFFFF;
				this.backgroundAlpha=0.85;
				this.dropShadowEnabled=false;
			}					
			StyleManager.setStyleDeclaration("." + appMenuStyleName, appMenuSelector, false);
			
			StyleManager.setStyleDeclaration("MDIBasicMenu", selector, false);
			return true;
		}

		/**
		 * This function is in charge of showing the menu. 
		 * @param event
		 * 
		 */
		public function showMenu(event:Event):void {
			var point:Point;
			if (_menuXML != null){
				_menu.validateNow();
				if (_mdiApplication.barPossition == MDIApplication.TOP_POSITON){
					point= _mdiApplication.menuButton.localToGlobal(new Point(_mdiApplication.menuButton.x,_mdiApplication.menuButton.y));
					_menu.show(0, point.y + _mdiApplication.menuButton.height);
					_menu.y= point.y + _mdiApplication.menuButton.height;
				}
				else if (_mdiApplication.barPossition == MDIApplication.BOTTON_POSITON){
					_menu.show(0, _mdiApplication.height-_mdiApplication._appBarHeight - _menu.height);
					_menu.y=_mdiApplication.height-_mdiApplication._appBarHeight - _menu.height;
				}
				_menu.addEventListener(FlexEvent.HIDE,hideMenu);
				_menu.x=0;
			}
		}

        /**
         * This function is in charge of hide the menu. 
         * @param event
         * 
         */
        public function hideMenu(event:Event=null):void{
        	if (this._menu!=null){
				this._menu.hide();
				this._mdiApplication.menuButton.isShowing=false;
				this._mdiApplication.menuButton.appBar.handleZoom();				
			}
        }

        /**
         * This function sets the menu XML 
         * @param value
         * 
         */
        public function set menuXML(value:XML):void{
        	_menuXML=value;
        	if (_menu!=null){
        		_menu.removeEventListener(MenuEvent.MENU_SHOW,_mdiApplication.windowManager.appMenuShowListener);
        		_menu.removeEventListener(MenuEvent.ITEM_CLICK,_mdiApplication.windowManager.appMenuItemClickListener);
        	}
        	_menu = Menu.createMenu( null, _menuXML, false );
			_menu.labelField="@label";
			_menu.buttonMode=true;
			_menu.iconField="@icon"
			_menu.show(0,0);
			_menu.validateNow();
			_menu.hide();
			_menu.addEventListener(MenuEvent.MENU_SHOW,_mdiApplication.windowManager.appMenuShowListener);
			_menu.addEventListener(MenuEvent.ITEM_CLICK,_mdiApplication.windowManager.appMenuItemClickListener);			
        }

		/**
		 * This function returns the menu XML 
		 * @return 
		 * 
		 */
		public function get menuXML():XML{
			return this._menuXML;
		}

		/**
		 * Returns the style 
		 * @param style
		 * @return 
		 * 
		 */
		public function getStyle(style:String):Object{
			if (this._menu){
				return this._menu.getStyle(style);
			}
			return null;
		}

		/**
		 * Sets the mdiApplication propertie. 
		 * @param value
		 * 
		 */
		public function set mdiApplication(value:MDIApplication):void{
			this._mdiApplication=value;
		}
	
		/**
		 * Returns the mdiApplication propertie.
		 * @return 
		 * 
		 */
		public function get mdiApplication():MDIApplication{
			return this._mdiApplication;
		}
	
		/**
		 * This function updates the style. 
		 * 
		 */
		public function updateStyles():void{
			var selectorList:Array = getSelectorList();

			if(this._menu)
			{
				_menu.styleName = getStyleByPriority(selectorList, "appMenuStyleName");
			}
			
		}
	
		/**
		 * Returns the menu style name. 
		 * @return 
		 * 
		 */
		public function get menuStyleName():Object
		{
			return _menuStyleName;
		}
		
		/**
		 * Sets the menu style name. 
		 * @param value
		 * 
		 */
		public function set menuStyleName(value:Object):void
		{
			if(_menuStyleName == value)
				return;
			_menuStyleName = value;
			updateStyles();
		}
	
		/**
		 * Select the style to be used and returns it.
		 * @return 
		 * 
		 */
		protected function getSelectorList():Array
		{
			// initialize array with ref to ourself since inline styles take highest priority
			var selectorList:Array = new Array(this);
			
			// if windowStyleName was set by developer we associated styles to the list
			if(_menuStyleName)
			{
				// make sure a corresponding style actually exists
				var classSelector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("." + _menuStyleName);
				if(classSelector)
				{
					selectorList.push(classSelector);
				}
			}
			// add type selector (created in classConstruct so we know it exists)
			var typeSelector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("MDIBasicMenu");
			selectorList.push(typeSelector);
			
			return selectorList;
		}
	
		/**
		 * Function to return appropriate style based on our funky setup.
		 * Precedence of styles is inline, class selector (as specified by menuStyleName)
		 * and then type selector (MDIApplication).
		 * 
		 * @private
		 */
		protected function getStyleByPriority(selectorList:Array, style:String):Object
		{			
			var n:int = selectorList.length;			
			
			for(var i:int = 0; i < n; i++)
			{
				// we need to make sure this.getStyle() is not pointing to the style defined
				// in the type selector because styles defined in the class selector (windowStyleName)
				// should take precedence over type selector (MDIWindow) styles
				// this.getStyle() will return styles from the type selector if an inline
				// style was not specified
				if(selectorList[i] == this 
				&& selectorList[i].getStyle(style) 
				&& this._menu.getStyle(style) === selectorList[n - 1].getStyle(style))
				{
					continue;
				}
				if(selectorList[i].getStyle(style))
				{
					// if this is a style name make sure the style exists
					if(typeof(selectorList[i].getStyle(style)) == "string"
						&& !(StyleManager.getStyleDeclaration("." + selectorList[i].getStyle(style))))
					{
						continue;
					}
					else
					{
						return selectorList[i].getStyle(style);
					}
				}
			}
			
			return null;
		}
	
	}
}