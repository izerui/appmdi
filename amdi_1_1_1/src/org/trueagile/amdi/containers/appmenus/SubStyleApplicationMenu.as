package org.trueagile.amdi.containers.appmenus
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.containers.HBox;
	import mx.containers.Panel;
	import mx.containers.VBox;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.events.FlexEvent;
	import mx.events.MenuEvent;
	import mx.managers.PopUpManager;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	import org.trueagile.amdi.containers.MDIApplication;
	
	/**
	 *  Reference to class  for SubStyleApplicationMenu, changes to this style
	 * are detected.
	 *  @default org.trueagile.amdi.containers.appmenus.SubStyleApplicationMenu
	 */
	[Style(name="appMenuStyleName", type="Class", inherit="no")]
	
	/**
	 *  Reference to class  for SubStyleApplicationMenu, changes to this style
	 * are detected.
	 *  @default org.trueagile.amdi.containers.appmenus.SubStyleApplicationMenu
	 */
	[Style(name="appSubMenuStyleName", type="Class", inherit="no")]
	
	/**
	 *  Reference to class  for SubStyleApplicationMenu, changes to this style
	 * are detected.
	 *  @default org.trueagile.amdi.containers.appmenus.SubStyleApplicationMenu
	 */
	[Style(name="appVBoxMenuStyleName", type="Class", inherit="no")]

	/**
	 *  Reference to class  for SubStyleApplicationMenu, changes to this style
	 * are detected.
	 *  @default org.trueagile.amdi.containers.appmenus.SubStyleApplicationMenu
	 */
	[Style(name="appImagePanelStyleName", type="Class", inherit="no")]

	/**
	 *  Reference to class  for SubStyleApplicationMenu, changes to this style
	 * are detected.
	 *  @default org.trueagile.amdi.containers.appmenus.SubStyleApplicationMenu
	 */
	[Style(name="appLabelStyleName", type="Class", inherit="no")]
	
	/**
	 * This clase implements de ApplicationMenu interface and has the feature of 
	 * showing user image and name. It also has a Menu that can use diferente style from main menu and submenues.
	 * @author mmarmol
	 * 
	 */
	public class SubStyleApplicationMenu extends VBox implements ApplicationMenu
	{

		public var _dataProvider:Object;
		
		private var _menu:SubStyleMenu;
		
		private var _mdiApplication:MDIApplication;
		
		private var _menuStyleName:Object;
		
		private var _userBox:HBox;
		
		private var _imagePanel:Panel;
		
		private var _userImage:Image;
		
		private var _userLabel:Label;
		
		private var _isUserShow:Boolean = true;
		
		private static var classConstructed:Boolean = classConstruct();
		
		// assets for default buttons
		[Embed(source="/org/trueagile/amdi/assets/img/user.png")]
		private static var USER_IMAGE:Class;

		/**
		 * The Basic constructor. 
		 * 
		 */
		public function SubStyleApplicationMenu() 
		{
			this._userBox=new HBox();
			this._userBox.setStyle("paddingBottom",6);
			this._userBox.setStyle("paddingLeft",6);
			this._userBox.setStyle("paddingRight",6);
			this._userBox.setStyle("paddingTop",6);
			this._userBox.setStyle("verticalAlign","middle");
			this._userBox.setStyle("horizontalAlign","center");
			this._imagePanel=new Panel();
			this._userImage=new Image();
			this._userImage.source=USER_IMAGE;
			this._userLabel=new Label();
			this._userLabel.text="User Name";
			this._imagePanel.addChild(this._userImage);
			this._userBox.addChild(this._imagePanel);
			this._userBox.addChild(this._userLabel);
			this._userBox.percentWidth=100;
			this.addChildAt(_userBox,0);
		}

		/**
		 * Define and prepare default styles.
		 */
		private static function classConstruct():Boolean
		{
			//------------------------
		    //  type selector
		    //------------------------
			var selector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("MDISubStyleMenu");
			if(!selector)
			{
				selector = new CSSStyleDeclaration();
			}
			// these are default names for secondary styles. these can be set in CSS and will affect
			// all applications that don't have an override for these styles.
			selector.defaultFactory = function():void
			{
				this.appMenuStyleName="appMenu";
				this.appSubMenuStyleName="appSubMenu";
				this.appVBoxMenuStyleName="appVBoxMenu";
				this.appImagePanelStyleName="appImagePanel";
				this.appLabelStyleName="appLabel";
			}

			//------------------------
		    //  Application VBox
		    //------------------------
			var appVBoxMenuStyleName:String = selector.getStyle("appVBoxMenuStyleName");
			var appVBoxMenuSelector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("." + appVBoxMenuStyleName);
			if(!appVBoxMenuSelector)
			{
				appVBoxMenuSelector = new CSSStyleDeclaration();
			}
			appVBoxMenuSelector.defaultFactory = function():void
			{
				this.borderStyle="solid";
				this.borderThickness=1;
				this.cornerRadius=10;
				this.backgroundColor=0x000000;
				this.backgroundAlpha=0.85;
				this.borderColor=0x000000;
			}					
			StyleManager.setStyleDeclaration("." + appVBoxMenuStyleName, appVBoxMenuSelector, false);

			//------------------------
		    //  Application Label
		    //------------------------
			var appLabelStyleName:String = selector.getStyle("appLabelStyleName");
			var appLabelSelector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("." + appLabelStyleName);
			if(!appLabelSelector)
			{
				appLabelSelector = new CSSStyleDeclaration();
			}
			appLabelSelector.defaultFactory = function():void
			{
				this.color=0xFFFFFF;
				this.fontWeight="bold";
			}					
			StyleManager.setStyleDeclaration("." + appLabelStyleName, appLabelSelector, false);

			//------------------------
		    //  Application ImagePanel
		    //------------------------
			var appImagePanelStyleName:String = selector.getStyle("appImagePanelStyleName");
			var appImagePanelSelector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("." + appImagePanelStyleName);
			if(!appImagePanelSelector)
			{
				appImagePanelSelector = new CSSStyleDeclaration();
			}
			appImagePanelSelector.defaultFactory = function():void
			{
				this.borderAlpha=0.1;
				this.roundedBottomCorners=true;
				this.cornerRadius=10;
				this.borderThicknessTop=5;
				this.borderThicknessBottom=5;
				this.backgroundAlpha=0.3;
				this.backgroundColor=0xFFFFFF;
				this.borderThicknessLeft=5;
				this.borderThicknessRight=5;
				this.headerHeight=0;
				this.dropShadowEnabled=false;
			}					
			StyleManager.setStyleDeclaration("." + appImagePanelStyleName, appImagePanelSelector, false);

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
				this.borderThickness=2;
				this.fontSize=11;
				this.paddingTop=6;
				this.paddingBottom=6;
				this.openDuration=0;
				this.borderStyle="none";
				this.color=0xFFFFFF;
				this.backgroundAlpha=0.0;
				this.dropShadowEnabled=false;
			}					
			StyleManager.setStyleDeclaration("." + appMenuStyleName, appMenuSelector, false);
			
			//------------------------
		    //  Application SubMenu
		    //------------------------
			var appSubMenuStyleName:String = selector.getStyle("appSubMenuStyleName");
			var appSubMenuSelector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("." + appSubMenuStyleName);
			if(!appSubMenuSelector)
			{
				appSubMenuSelector = new CSSStyleDeclaration();
			}
			appSubMenuSelector.defaultFactory = function():void
			{
				this.rollOverColor=0xA5A5A5;
				this.selectionColor=0xE0E0E0;
				this.fontSize=11;
				this.paddingTop=6;
				this.paddingBottom=6;
				this.openDuration=0;
				this.borderStyle="solid";
				this.borderThickness=1;
				this.cornerRadius=10;
				this.borderColor=0x000000;
				this.backgroundColor=0x000000;
				this.backgroundAlpha=0.85;
				this.color=0xFFFFFF;
				this.dropShadowEnabled=false;
			}					
			StyleManager.setStyleDeclaration("." + appSubMenuStyleName, appSubMenuSelector, false);
						
			
			StyleManager.setStyleDeclaration("MDISubStyleMenu", selector, false);
			return true;
		}
		
		/**
		 * This function is in charge of showing the menu. 
		 * @param event
		 * 
		 */
		public function showMenu(event:Event):void {
			var point:Point;
			if (_dataProvider != null){
				_menu.validateNow();
				this.validateNow();
				this.validateSize(true);
				this.validateDisplayList();
				if (_mdiApplication.barPossition == MDIApplication.TOP_POSITON){
					point= _mdiApplication.menuButton.localToGlobal(new Point(_mdiApplication.menuButton.x,_mdiApplication.menuButton.y));
					this.x=0;
					this.y=point.y + _mdiApplication.menuButton.height;
				}
				else if (_mdiApplication.barPossition == MDIApplication.BOTTON_POSITON){
					this.x=0;
					this.y=_mdiApplication.height-_mdiApplication._appBarHeight - this.measuredHeight;
				}
				_menu.addEventListener(FlexEvent.HIDE,hideMenu);
				this.visible=true;
				PopUpManager.addPopUp(this,this._mdiApplication,false);
				_menu.visible=true;
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
				this.visible=false;
				PopUpManager.removePopUp(this);
				this._mdiApplication.menuButton.isShowing=false;
				this._mdiApplication.menuButton.appBar.handleZoom();
			}
        }

        /**
         * This function sets the menu XML 
         * @param value
         * 
         */
        public function set dataProvider(value:Object):void{
        	_dataProvider=value;
        	if (_menu!=null){
        		_menu.removeEventListener(MenuEvent.MENU_SHOW,_mdiApplication.windowManager.appMenuShowListener);
        		_menu.removeEventListener(MenuEvent.ITEM_CLICK,_mdiApplication.windowManager.appMenuItemClickListener);
        		this.removeChild(_menu);
        	}
        	_menu = SubStyleMenu.createMenu( null, _dataProvider, false );
			_menu.labelField="label";
			_menu.buttonMode=true;
			_menu.iconField="icon";
//			_menu.variableRowHeight = true;
			_menu.percentWidth=100;
			_menu.percentHeight=100;
			_menu.show(0,0);
			_menu.validateNow();
			this.addChildAt(_menu,this.numChildren);
			this.validateNow();
			PopUpManager.addPopUp(this,_mdiApplication,false);
			PopUpManager.removePopUp(this);
			_menu.addEventListener(MenuEvent.MENU_SHOW,_mdiApplication.windowManager.appMenuShowListener);
			_menu.addEventListener(MenuEvent.ITEM_CLICK,_mdiApplication.windowManager.appMenuItemClickListener);
			
			updateStyles();
        }
		
		/**
		 * This function returns the menu XML 
		 * @return 
		 * 
		 */
		public function get dataProvider():Object{
			return this._dataProvider;
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
			
			this.styleName = getStyleByPriority(selectorList, "appVBoxMenuStyleName");
			
			if(this._menu)
			{
				_menu.styleName = getStyleByPriority(selectorList, "appMenuStyleName");
				_menu.subMenuStyleName = getStyleByPriority(selectorList, "appSubMenuStyleName").toString();
			}
			if (this._imagePanel){
				_imagePanel.styleName = getStyleByPriority(selectorList, "appImagePanelStyleName");
			}
			if (this._userLabel){
				_userBox.styleName = getStyleByPriority(selectorList, "appLabelStyleName");
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
			var typeSelector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("MDISubStyleMenu");
			selectorList.push(typeSelector);
			
			return selectorList;
		}
	
		/**
		 * Function to return appropriate style based on our funky setup.
		 * Precedence of styles is inline, class selector (as specified by windowStyleName)
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
				&& this.getStyle(style) === selectorList[n - 1].getStyle(style))
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

		/**
		 * Returns the text for the label. 
		 * @return 
		 * 
		 */
		public function get userName():String{
			return this._userLabel.text;
		}

		/**
		 * Sets the text for the label. 
		 * @param value
		 * 
		 */
		public function set userName(value:String):void{
			this._userLabel.text=value;
		}

		/**
		 * Returns if the Menu should show the image and label. 
		 * @return 
		 * 
		 */
		public function get isUserShow():Boolean{
			return this._isUserShow;
		}

		/**
		 * Sets if the Menu should show the image and label. 
		 * @param value
		 * 
		 */
		public function set isUserShow(value:Boolean):void{
			if (value==true && this._isUserShow==false){
				this.addChildAt(this._userBox,0);
				this.validateNow();
				this._isUserShow=true;
			} 
			else if (value==false && this._isUserShow==true){
				this.removeChild(this._userBox);
				this.validateNow();
				this._isUserShow=false;
			}
			
		}

		/**
		 * Sets the image source. 
		 * @param value
		 * 
		 */
		public function set userImageSrc(value:Object):void{
			this._userImage.source = value;
		}

		/**
		 * Returns the image source. 
		 * @return 
		 * 
		 */
		public function get userImageSrc():Object{
			return this._userImage.source;
		}

        /**
         * 
         * @return 
         * 
         */
        public function get imagePanel():Panel{
        	return this._imagePanel;
        }

		/**
		 * 
		 * @return 
		 * 
		 */
		public function get userImage():Image{
			return this._userImage;	
		}

	}
}