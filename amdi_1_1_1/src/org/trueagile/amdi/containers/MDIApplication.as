/*
Copyright (c) 2010, TRUEAGILE
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of the TRUEAGILE nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package org.trueagile.amdi.containers
{
	
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Menu;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.MenuEvent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	import org.trueagile.amdi.containers.appmenus.ApplicationMenu;
	import org.trueagile.amdi.effects.IMDIEffectsDescriptor;
	import org.trueagile.amdi.events.DesktopRightClickEvent;
	import org.trueagile.amdi.events.MDIManagerEvent;
	import org.trueagile.amdi.managers.MDIManager;
	

	/**
	 *  Reference to class  for the application, changes to this style
	 * are detected.
	 *  @default org.trueagile.amdi.containers.MDIApplication
	 */
	[Style(name="appVBoxStyleName", type="Class", inherit="no")]

	/**
	 *  Reference to class  for the application bar, changes to this style
	 * are detected.
	 *  @default org.trueagile.amdi.containers.ApplicationControlBar
	 */
	[Style(name="appBarStyleName", type="Class", inherit="no")]

	/**
	 *  Reference to class  for the application button, changes to this style
	 * are detected.
	 *  @default org.trueagile.amdi.containers.MDIApplicationMenuButton
	 */
	[Style(name="appMenuBtnStyleName", type="Class", inherit="no")]

	
	/**
	 *  @auther 刘玉华
	 * 
	 *  Dispatched when the rightClick is not default label.
	 *
	 *  @eventType org.trueagile.amdi.events.DesktopRightClickEvent.DESKTOP_RIGHTCLICK_EVENT
	 */
	[Event(name="desktopRightClickEvent", type="org.trueagile.amdi.events.DesktopRightClickEvent")]
	
	
	/**
	 *This is the main class for using the framework. You hould start initiating this class to start working with it. 
	 * @author mmarmol
	 */
	public class MDIApplication extends VBox
	{
		[Embed(source="/org/trueagile/amdi/assets/img/applicationMenuButton.png")]
		private static var APPLICATION_ICON:Class;	
		
		/**
		 * @private
		 * Storage var to hold value originally assigned to styleName since it gets toggled per focus change.
		 */
		private var _appStyleName:Object;
		public var windowManager:MDIManager;
		public var _applicationBar:MDIApplicationBar;
		private var _minimizedWindowsContainer:MDIWindowsBar;
		private var _rigthControls:HBox;
		private var _container:Canvas;
		private var _myDesktop:Canvas;
		private var _initialWindows:Array;
		private var _dataProvider:Object;
		private var _vistaView:Boolean=true;
		public var menuButton:MDIApplicationMenuButton;
		public var windowShow:MDIWindowShow;
		
		private var _barPossition:String = MDIApplication.TOP_POSITON;		
		public var _appBarHeight:Number = 36;
		
		public var isBarCollapsing:Boolean=false;
		
		public var timeLastBarEffect:Number=0;
		
		private var _colapseBar:Boolean = false;

		public static var WINDOW_CTX_MENU:Boolean = true;
		public static var APP_CTX_MENU:Boolean = true;
		
		public static const TOP_POSITON:String = 'top';
		public static const BOTTON_POSITON:String = 'bottom';
		
		public static const CAROUSEL_CONTAINER:String = 'CarouselContainer';
		public static const COVER_FLOW_CONTAINER:String = 'CoverFlowContainer';
		public static const VCOVER_FLOW_CONTAINER:String = 'VCoverFlowContainer';
		public static const VISTA_FLOW_CONTAINER:String = 'VistaFlowContainer';
		
		[Bindable]
		public static var versionInfo:String = "版本说明";
		[Bindable]
		public static var orderDesktopItems:String = "排列图标";
		[Bindable]
		public static var desktopText:String = '桌面首选项';
		[Bindable]
		public static var titleText:String = '排列';
		[Bindable]
		public static var titleFillText:String = '排列填充';
		[Bindable]
		public static var cascadeText:String = '叠加' ;
		[Bindable]
		public static var showAllText:String = '显示所有';
		[Bindable]
		public static var minimizeText:String = '最小化';
		[Bindable]
		public static var minimizeAllText:String = '最小化所有';
		[Bindable]
		public static var restoreText:String = '恢复';
		[Bindable]
		public static var maximizeText:String = '最大化' ;
		[Bindable]
		public static var closeText:String = '关闭';
		[Bindable]
		public static var closeAllText:String = '关闭所有';
		[Bindable]
		public static var restoreAllText:String = '恢复所有';	

		private static var classConstructed:Boolean = classConstruct();

		public static var windowImageSize:Number = 150;


		/**
		 * Define and prepare default styles.
		 */
		private static function classConstruct():Boolean
		{
			//------------------------
		    //  type selector
		    //------------------------
			var selector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("MDIApplication");
			if(!selector)
			{
				selector = new CSSStyleDeclaration();
			}
			// these are default names for secondary styles. these can be set in CSS and will affect
			// all applications that don't have an override for these styles.
			selector.defaultFactory = function():void
			{
				this.appBarStyleName = "mdiAppBar";
				this.appMenuBtnStyleName = "mdiAppMenuBtn";
				this.appVBoxStyleName= "appVBoxStyleName";
			}

			//------------------------
		    //  Application VBOX
		    //------------------------
			var appVBoxStyleName:String = selector.getStyle("appVBoxStyleName");
			var appVBoxSelector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("." + appVBoxStyleName);
			if(!appVBoxSelector)
			{
				appVBoxSelector = new CSSStyleDeclaration();
			}
			appVBoxSelector.defaultFactory = function():void
			{
				this.verticalGap=1;
			}					
			StyleManager.setStyleDeclaration("." + appVBoxStyleName, appVBoxSelector, false);


			//------------------------
		    //  Application Bar
		    //------------------------
			var appBarStyleName:String = selector.getStyle("appBarStyleName");
			var appBarSelector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("." + appBarStyleName);
			if(!appBarSelector)
			{
				appBarSelector = new CSSStyleDeclaration();
			}
			appBarSelector.defaultFactory = function():void
			{   
				this.highlightAlphas=[0.6,0.30];
				this.fillAlphas=[0.8,0.9];
				this.fillColors=[0x000000,0x000000];
				this.cornerRadius=0;
				this.paddingLeft=15;
				this.shadowDirection="center";
			}					
			StyleManager.setStyleDeclaration("." + appBarStyleName, appBarSelector, false);
			
			//------------------------
		    //  menu button
		    //------------------------
			var appMenuBtnStyleName:String = selector.getStyle("appMenuBtnStyleName");
			var appMenuBtnSelector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("." + appMenuBtnStyleName);
			if(!appMenuBtnSelector)
			{
				appMenuBtnSelector = new CSSStyleDeclaration();
			}
			appMenuBtnSelector.defaultFactory = function():void
			{
				this.upSkin = APPLICATION_ICON;
				this.overSkin = APPLICATION_ICON;
				this.downSkin = APPLICATION_ICON;
				this.disabledSkin = APPLICATION_ICON;
			}					
			StyleManager.setStyleDeclaration("." + appMenuBtnStyleName, appMenuBtnSelector, false);
			
			
			StyleManager.setStyleDeclaration("MDIApplication", selector, false);
			return true;
		}

		/**
		 *Returns the stylename for this class. 
		 * @return 
		 * 
		 */
		public function get appStyleName():Object
		{
			return _appStyleName;
		}
		
		/**
		 *Sets the style name for this class. 
		 * @param value
		 * 
		 */
		public function set appStyleName(value:Object):void
		{
			if(_appStyleName === value)
				return;
			_appStyleName = value;
		}

		/**
		 * Mother of all styling functions. All styles fall back to the defaults if necessary.
		 */
		private function updateStyles():void{
			var selectorList:Array = getSelectorList();
			
			this.styleName=getStyleByPriority(selectorList, "appVBoxStyleName");
			if(menuButton)
			{
				menuButton.styleName = getStyleByPriority(selectorList, "appMenuBtnStyleName");
				if(menuButton.menu)
				{
					menuButton.menu.updateStyles();
				}	
			}
			if(_applicationBar)
			{
				_applicationBar.styleName = getStyleByPriority(selectorList, "appBarStyleName");
			}
			
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
			if(appStyleName)
			{
				// make sure a corresponding style actually exists
				var classSelector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("." + appStyleName);
				if(classSelector)
				{
					selectorList.push(classSelector);
				}
			}
			// add type selector (created in classConstruct so we know it exists)
			var typeSelector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("MDIApplication");
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
		 * Detects change to styleName that is executed by MDIManager indicating a change in focus.
		 * Iterates over window controls and adjusts their styles if they're focus-aware.
		 */
		override public function styleChanged(styleProp:String):void
		{
			super.styleChanged(styleProp);
			
			if(!styleProp || styleProp == "styleName")
				updateStyles(); 
		}

		/**
		 *No argument constructor. 
		 * 
		 */
		public function MDIApplication()
		{
			super();
			this.percentHeight=100;
			this.percentWidth=100;
			
			this._container = new Canvas();
			this._container.percentWidth=100;
			this._container.percentHeight=100;
			this._container.horizontalScrollPolicy="off";
			this._container.verticalScrollPolicy="off";
			
			this._myDesktop = new Canvas();
			this._myDesktop.percentWidth=100;
			this._myDesktop.percentHeight=100;
			this._myDesktop.horizontalScrollPolicy="off";
			this._myDesktop.verticalScrollPolicy="off";
			this._container.addChild(this._myDesktop);
						
			this._applicationBar = new MDIApplicationBar(this);
			this._applicationBar.dock=false;
			this._applicationBar.height=_appBarHeight;
			this._applicationBar.percentWidth=100;
			this._applicationBar.x=0;
			this._applicationBar.y=0;
			this._applicationBar.setStyle('verticalAlign','middle');
			this._applicationBar.setStyle('paddingTop',2);
			this._applicationBar.setStyle('paddingBottom',1);

			this._minimizedWindowsContainer=new MDIWindowsBar();
			
			this._applicationBar.addChild(this._minimizedWindowsContainer);

			this.addChild(this._applicationBar);
			this.addChild(this._container);		
			
			windowManager = new MDIManager(this);
			this._minimizedWindowsContainer.windowManager = this.windowManager;
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);//初始化默认加载的窗口
//			this.addEventListener(FlexEvent.CREATION_COMPLETE,function(ev:FlexEvent):void{
//				contextMenuInitData();
//			});//创建右键菜单数据提供者
			
			this._applicationBar.addEventListener(FlexEvent.CREATION_COMPLETE,setControllBarContextMenu);
			this.addEventListener(FlexEvent.CREATION_COMPLETE,setDesktopContextMenu);
			this.horizontalScrollPolicy="off";
			this.verticalScrollPolicy="off";
			this.windowManager.addApplicationBarListeners(_applicationBar);
			this.windowShow  = new MDIWindowShow(this);
			this.addEventListener(Event.ADDED_TO_STAGE,handleAddedToStage);
		}
		
		
		
		/**
		 * 任务栏右键
		 * @param event
		 * 
		 */
		private function setControllBarContextMenu(event:FlexEvent):void{			
			
			var defaultContextMenu:ContextMenu = new ContextMenu();
			defaultContextMenu.hideBuiltInItems();
			if (MDIApplication.APP_CTX_MENU){	
				var arrangeItem:ContextMenuItem = new ContextMenuItem(MDIApplication.titleText);
				arrangeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);	
				defaultContextMenu.customItems.push(arrangeItem);
				
				var arrangeFillItem:ContextMenuItem = new ContextMenuItem(MDIApplication.titleFillText);
				arrangeFillItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);  	
				defaultContextMenu.customItems.push(arrangeFillItem);
				
				var cascadeItem:ContextMenuItem = new ContextMenuItem(MDIApplication.cascadeText);
				cascadeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
				defaultContextMenu.customItems.push(cascadeItem);
				
				var restoreAllItem:ContextMenuItem = new ContextMenuItem(MDIApplication.restoreAllText);
				restoreAllItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
				defaultContextMenu.customItems.push(restoreAllItem);	
				
				var minimizeAllItem:ContextMenuItem = new ContextMenuItem(MDIApplication.minimizeAllText);
				minimizeAllItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
				defaultContextMenu.customItems.push(minimizeAllItem);	
				
				var closeAllItem:ContextMenuItem = new ContextMenuItem(MDIApplication.closeAllText);
				closeAllItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
				defaultContextMenu.customItems.push(closeAllItem);	
			}    	
			this._applicationBar.contextMenu = defaultContextMenu;				
			
		}
		
		/**
		 * 桌面右键
		 */
		
		private function setDesktopContextMenu(event:FlexEvent):void{			
			
			var defaultContextMenu:ContextMenu = new ContextMenu();
			defaultContextMenu.hideBuiltInItems();
			if (MDIApplication.APP_CTX_MENU){	
				var orderDesktopItems:ContextMenuItem = new ContextMenuItem(MDIApplication.orderDesktopItems);
				orderDesktopItems.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);  	
				defaultContextMenu.customItems.push(orderDesktopItems);
				
				var desktopText:ContextMenuItem = new ContextMenuItem(MDIApplication.desktopText);
				desktopText.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);	
				defaultContextMenu.customItems.push(desktopText);
				
				var versionInfo:ContextMenuItem = new ContextMenuItem(MDIApplication.versionInfo);
				versionInfo.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);	
				defaultContextMenu.customItems.push(versionInfo);
				
			}    	
			this.contextMenu = defaultContextMenu;				
			
		}
		
		
		/**
		 *Select the behavior to be used acording to the menu option. 
		 * @param event
		 * 
		 */		
		private function menuItemSelectHandler(event:ContextMenuEvent):void
		{
			this.windowManager.hideAllMenus();
			switch(event.target.caption)
			{	
				case(MDIApplication.titleText):
					this.windowManager.tile(false, this.windowManager.tilePadding);
					break;
				
				case(MDIApplication.titleFillText):
					this.windowManager.tile(true, this.windowManager.tilePadding);
					break;
				
				case(MDIApplication.cascadeText):
					this.windowManager.cascade();
					break;
				
				case(MDIApplication.showAllText):
					this.windowManager.showAllWindows();
					break;
				
				case(MDIApplication.minimizeAllText):
					this.windowManager.minimizeAll();
					break;			
				
				case(MDIApplication.closeAllText):
					this.windowManager.closeAll();
					break;
				
				case(MDIApplication.restoreAllText):
					this.windowManager.showAllWindows();
					break;		
				default:
					dispatchEvent(new DesktopRightClickEvent(DesktopRightClickEvent.DESKTOP_RIGHTCLICK_EVENT,event.target.caption));
					break;
			}
		}
		
		
		
		
		
		
		/**
		 * When added to stage this function handle some visual configurations. 
		 * @param event
		 * 
		 */
		private function handleAddedToStage(event:Event):void{
			this.vistaView=this._vistaView;
			if (this._colapseBar == true){
				this._applicationBar.handleZoom();
			}
		}
		
//		/**
//		 * 是否使用右键
//		 */
//		public var isShowRightMenu:Boolean = true;
//		
//		
//		//右键点击目标对象是否是任务栏.bar 默认是否
//		public function showRightMenu(isAplicationBar:Boolean=false):void{
//			RightMenuModellocator.getInstance().removeMenu();
//			if(!isShowRightMenu){//如果不是用右键
//				return;
//			}
//			var menuDataProvider:ArrayCollection = new ArrayCollection(
//				[
//					{"label":MDIApplication.titleText},
//					{"label":MDIApplication.titleFillText},
//					{"label":MDIApplication.cascadeText},
//					{"label":"separator","type":"separator"},
//					{"label":MDIApplication.restoreAllText},
//					{"label":MDIApplication.minimizeAllText},
//					{"label":"separator","type":"separator"},
//					{"label":MDIApplication.closeAllText}
//				]
//			);
//			
//			if(!isAplicationBar){//如果是点击的桌面,就加入桌面首选项等label
//				menuDataProvider.addItem({"label":"separator","type":"separator"});
//				menuDataProvider.addItem({"label":MDIApplication.orderDesktopItems});
//				menuDataProvider.addItem({"label":MDIApplication.desktopText});
//				
//			}
//			RightMenuModellocator.getInstance().menu = Menu.createMenu(this, menuDataProvider, false);  
//			
//			RightMenuModellocator.getInstance().menu.labelField="label";
//			//				index.menu.iconFunction = rightMenuIcon;
//			RightMenuModellocator.getInstance().menu.variableRowHeight = true;     
//			RightMenuModellocator.getInstance().menu.addEventListener(MenuEvent.ITEM_CLICK, function (ev:MenuEvent):void{
//				rightMenuItemSelectHandler(ev.label);
//			});       
//			
//			//				var point:Point = new Point(mouseX,mouseY);  
//			//				point = localToGlobal(point);   
//			RightMenuModellocator.getInstance().menu.show(); 
//			
//			var screenRight:int = screen.right;
//			var screenBottom:int = screen.bottom;
//			var screenLeft:int = screen.left;
//			var _showX:int = stage.mouseX;
//			var _showY:int = stage.mouseY;
//			if(screenRight-stage.mouseX<RightMenuModellocator.getInstance().menu.width){
//				_showX = stage.mouseX-(RightMenuModellocator.getInstance().menu.width-(screenRight-stage.mouseX));
//				//					trace("stage.mouseX :"+stage.mouseX+" \t screenRight"+screenRight+" 差 "+(screenRight-stage.mouseX)+" 到右边");
//			}
//			if(screenBottom-stage.mouseY<RightMenuModellocator.getInstance().menu.height){
//				_showY = stage.mouseY-(RightMenuModellocator.getInstance().menu.height-(screenBottom-stage.mouseY));
//				//					trace("stage.mouseY :"+stage.mouseY+" \t screenBottom"+screenBottom+" 差 "+(screenBottom-stage.mouseY)+" 到底边");
//			}
//			RightMenuModellocator.getInstance().menu.move(_showX,_showY);
//			//				trace(menu.width);
//			//				trace(menu.height);
//			
//		}
		
		
//		/**
//		 * 根据右键操作方式触发
//		 * @param label
//		 * 
//		 */		
//		public function rightMenuItemSelectHandler(operation:String):void
//		{
//			this.windowManager.hideAllMenus();
//			switch(operation)
//			{	
//				case(MDIApplication.titleText):
//					this.windowManager.tile(false, this.windowManager.tilePadding);
//					break;
//				
//				case(MDIApplication.titleFillText):
//					this.windowManager.tile(true, this.windowManager.tilePadding);
//					break;
//				
//				case(MDIApplication.cascadeText):
//					this.windowManager.cascade();
//					break;
//				
//				case(MDIApplication.showAllText):
//					this.windowManager.showAllWindows();
//					break;
//				
//				case(MDIApplication.minimizeAllText):
//					this.windowManager.minimizeAll();
//					break;			
//
//				case(MDIApplication.closeAllText):
//					this.windowManager.closeAll();
//					break;
//
//				case(MDIApplication.restoreAllText):
//					this.windowManager.showAllWindows();
//					break;		
//				default:
//					dispatchEvent(new DesktopRightClickEvent(DesktopRightClickEvent.DESKTOP_RIGHTCLICK_EVENT,operation));
//					break;
//			}
//		}
		
		/**
		 * Creat the child windows on creation complete event.
		 * @param event
		 * 
		 */
		private function onCreationComplete(event:FlexEvent):void
		{
			for each(var child:UIComponent in this._initialWindows)
			{
				if(child is MDIWindow)
				{
					this._container.getChildren().push(child);
					windowManager.add(child as MDIWindow);
				}
			}
		
			this._initialWindows = new Array();
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);//加载右键前先remove掉右键
			this.updateAllContextMenus();
			if (this._colapseBar){
				this.windowManager.dispatchEvent(new MDIManagerEvent(MDIManagerEvent.APP_BAR_ROLLOUT,null,this.windowManager,null,null,false,null,this._applicationBar));
			}
		}
		
		/**
		 *Returns the container where the windows are located. 
		 * @return 
		 * 
		 */
		public function get container():Canvas
		{
			return _container;
		}		
		/**
		 * 获取画布的桌面, 可以在其上放入快捷方式等元素
		 *Returns the container`s child named myDesktop 
		 * @return 
		 * 
		 */
		public function get myDesktop():Canvas{
			return _myDesktop;
		}
		/**
		 *Returns The array of the initial windows to be loaded into the framework. 
		 * @return 
		 * 
		 */
		public function get initialWindows():Array
		{
			return _initialWindows;
		}	

		/**
		 *Sets The array of the initial windows to be loaded into the framework. 
		 * @param value 
		 * 
		 */			
		public function set initialWindows(value:Array):void
		{
			this._initialWindows = value;
		}	

		/**
		 *Returns the height of the application bar in pixels. 
		 * @return 
		 * 
		 */
		public function get appBarHeight():Number
		{
			return this._appBarHeight;
		}							
		
		/**
		 *Sets the height of the application bar in pixels. 
		 * @param value
		 * 
		 */
		public function set appBarHeight(value:Number):void
		{
			this._appBarHeight=value;
			this._applicationBar.height = appBarHeight;
		}

		/**
		 * Returns the  MDIWindowsBar where the minimized windows are located.
		 * @return 
		 * 
		 */		
		public function get minimizedWindowsContainer():MDIWindowsBar 
		{
			return this._minimizedWindowsContainer;
		}		

		
		/**
		 * Returns the HBox where the controls on the rigth od the application bar after de minimized windows are located.
		 * @return 
		 * 
		 */
		public function get rigthControls():HBox 
		{
			return this._rigthControls;
		}		

		/**
		 * Sets the HBox where the controls on the rigth od the application bar after de minimized windows are located.
		 * @param value
		 * 
		 */
		public function set rigthControls(value:HBox):void 
		{
			if (this._rigthControls!=null){
				this._applicationBar.removeChild(this._rigthControls);
			}
			this._rigthControls = value;
			this._applicationBar.addChild(this._rigthControls);
		}
		
		/**
		 * Proxy to MDIManager effects property.
		 * 
		 * @deprecated use effects and class
		 * 
		 */ 
		public function set effectsLib(clazz:Class):void 
		{
			this.windowManager.effects = new clazz();
		}
		
		/**
		 * Proxy to MDIManager property of same name.
		 */
		public function set effects(effects:IMDIEffectsDescriptor):void 
		{
			this.windowManager.effects = effects;		
		}
		
		/**
		 * Sets the width of the windows when minimized. 
		 * @param value
		 * 
		 */
		public function set tileMinimizeWidth(value:int):void{
			this.windowManager.tileMinimizeWidth=value;
		}

		/**
		 * Returns the width of the windows when minimized. 
		 * @return 
		 * 
		 */
		public function get tileMinimizeWidth():int{
			return this.windowManager.tileMinimizeWidth;
		}

		/**
		 * Sets the title padding for the windows. 
		 * @param value
		 * 
		 */		
		public function set tilePadding(value:Number):void{
			this.windowManager.tilePadding=value;
		}
		
		/**
		 * Returns the title padding for the windows. 
		 * @return 
		 * 
		 */	
		public function get tilePadding():Number{
			return this.windowManager.tilePadding;
		}

		/**
		 * Sets the title padding for the windows when minimized. 
		 * @param value 
		 * 
		 */	
		public function set minTilePadding(value:Number):void{
			this.windowManager.minTilePadding=value;
		}
		
		/**
		 * Returns the title padding for the windows when minimized. 
		 * @return 
		 * 
		 */	
		public function get minTilePadding():Number{
			return this.windowManager.minTilePadding;
		}

		/**
		 * Sets the Name of the title option in the context menu, default is Title. 
		 * @param value
		 * 
		 */
		public function set titleLabel(value:String):void{
			MDIApplication.titleText = value;
			updateAllContextMenus();
		}
		
		/**
		 * Returns the Name of the title option in the context menu, default is Title. 
		 * @Return
		 * 
		 */
		public function get titleLabel():String{
			return MDIApplication.titleText;
		}

		/**
		 * Sets the Name of the titlefill option in the context menu, default is Title Fill. 
		 * @param value
		 * 
		 */
		public function set titleFillLabel(value:String):void{
			MDIApplication.titleFillText = value;
			updateAllContextMenus();
		}

		/**
		 * Returns the Name of the titlefill option in the context menu, default is Title Fill. 
		 * @Return
		 * 
		 */
		public function get titleFillLabel():String{
			return MDIApplication.titleFillText;
		}		

		/**
		 * Sets the Name of the cascade option in the context menu, default is Cascade. 
		 * @param value
		 * 
		 */
		public function set cascadeLabel(value:String):void{
			MDIApplication.cascadeText = value;
			updateAllContextMenus();
		}

		/**
		 * Returns the Name of the cascade option in the context menu, default is Cascade. 
		 * @Return
		 * 
		 */
		public function get cascadeLabel():String{
			return MDIApplication.cascadeText;
		}		

		/**
		 * Sets the Name of the showAll option in the context menu, default is Show All. 
		 * @param value
		 * 
		 */
		public function set showAllLabel(value:String):void{
			MDIApplication.showAllText = value;
			updateAllContextMenus();
		}

		/**
		 * Returns the Name of the showAll option in the context menu, default is Show All. 
		 * @Return
		 * 
		 */
		public function get showAllLabel():String{
			return MDIApplication.showAllText;
		}		

		/**
		 * Sets the Name of the minimize option in the context menu, default is Minimize. 
		 * @param value
		 * 
		 */
		public function set minimizeLabel(value:String):void{
			MDIApplication.minimizeText = value;
			updateAllContextMenus();
		}

		/**
		 * Returns the Name of the minimize option in the context menu, default is Minimize.  
		 * @Return
		 * 
		 */
		public function get minimizeLabel():String{
			return MDIApplication.minimizeText;
		}		

		/**
		 * Sets the Name of the minimizeAll option in the context menu, default is Minimize All. 
		 * @param value
		 * 
		 */
		public function set minimizeAllLabel(value:String):void{
			MDIApplication.minimizeAllText = value;
			updateAllContextMenus();
		}

		/**
		 * Returns the Name of the minimizeAll option in the context menu, default is Minimize All. 
		 * @Return
		 * 
		 */
		public function get minimizeAllLabel():String{
			return MDIApplication.minimizeAllText;
		}		

		/**
		 * Sets the Name of the restore option in the context menu, default is Restore. 
		 * @param value
		 * 
		 */
		public function set restoreLabel(value:String):void{
			MDIApplication.restoreText = value;
			updateAllContextMenus();
		}

		/**
		 * Returns the Name of the restore option in the context menu, default is Restore. 
		 * @Return
		 * 
		 */
		public function get restoreLabel():String{
			return MDIApplication.restoreText;
		}		

		/**
		 * Sets the Name of the maximize option in the context menu, default is Maximize. 
		 * @param value
		 * 
		 */
		public function set maximizeLabel(value:String):void{
			MDIApplication.maximizeText = value;
			updateAllContextMenus();
		}

		/**
		 * Returns the Name of the maximize option in the context menu, default is Maximize. 
		 * @Return
		 * 
		 */
		public function get maximizeLabel():String{
			return MDIApplication.maximizeText;
		}		

		/**
		 * Sets the Name of the close option in the context menu, default is close. 
		 * @param value
		 * 
		 */
		public function set closeLabel(value:String):void{
			MDIApplication.closeText = value;
			updateAllContextMenus();
		}
		
		/**
		 * Returns the Name of the close option in the context menu, default is close. 
		 * @Return
		 * 
		 */
		public function get closeLabel():String{
			return MDIApplication.closeText;
		}		
		
		/**
		 * Sets the Name of the closeAll option in the context menu, default is Close All. 
		 * @param value
		 * 
		 */
		public function set closeAllLabel(value:String):void{
			MDIApplication.closeAllText = value;
			updateAllContextMenus();
		}

		/**
		 * Returns the Name of the closeAll option in the context menu, default is Close All. 
		 * @Return
		 * 
		 */
		public function get closeAllLabel():String{
			return MDIApplication.closeAllText;
		}

		/**
		 * Sets the Name of the restoreAll option in the context menu, default is Restore All. 
		 * @param value
		 * 
		 */
		public function set restoreAllLabel(value:String):void{
			MDIApplication.restoreAllText = value;
			updateAllContextMenus();
		}

		/**
		 * Returns the Name of the restoreAll option in the context menu, default is Restore All.
		 * @Return
		 * 
		 */
		public function get restoreAllLabel():String{
			return MDIApplication.restoreAllText;
		}

		/**
		 * Sets the size in pixel for small windows preview while minimized in application bar.
		 * @param value
		 * 
		 */
		public function set smallWindowSize(value:Number):void{
			MDIApplication.windowImageSize = value;
		}

		/**
		 * Returns the size in pixel for small windows preview while minimized in application bar.
		 * @Return
		 * 
		 */
		public function get smallWindowSize():Number{
			return MDIApplication.windowImageSize;
		}

		/**
		 * Returns the boolean indicating if the context menu should be used.
		 * @Return
		 * 
		 */
		public function get applicationCTXM():Boolean{
			return MDIApplication.APP_CTX_MENU;
		}

		/**
		 * Sets the boolean indicating if the context menu should be used.
		 * @param value
		 * 
		 */
		public function set applicationCTXM(value:Boolean):void{
			MDIApplication.APP_CTX_MENU = value;
			updateAllContextMenus();
		}	

		/**
		 * Returns the boolean indicating if the context menu in windows should be used.
		 * @Return
		 * 
		 */
		public function get windowCTXM():Boolean{
			return MDIApplication.WINDOW_CTX_MENU;
		}

		/**
		 * Sets the boolean indicating if the context menu in windows should be used.
		 * @param value
		 * 
		 */
		public function set windowCTXM(value:Boolean):void{
			MDIApplication.WINDOW_CTX_MENU = value;
			updateAllContextMenus();
		}		
		
		private function updateAllContextMenus():void{
			this.setControllBarContextMenu(null);
//			this.setDesktopContextMenu(null);
			for each (var window : MDIWindow in this.windowManager.windowList){
				window.updateContextMenu();
			}
			
		}

		/**
		 * Returns the application bar possition
		 * @Return
		 * 
		 */	
		public function get barPossition():String{
			return this._barPossition;
		}

		/**
		 * Sets the application bar possition
		 * @param value
		 * 
		 */		
		public function set barPossition(value:String):void{
			if (value != this._barPossition){
				if (value == MDIApplication.TOP_POSITON){
					this.setChildIndex(this._applicationBar,0);
					this._barPossition=value;
				}
				else if(value == MDIApplication.BOTTON_POSITON){
					this.setChildIndex(this._applicationBar,1);
					this._barPossition=value;
				}
			}
		}

		/**
		 * Sets the application bar Menu using a XML
		 * @param value
		 * 
		 */			
		public function set dataProvider(value:Object):void{
			this._dataProvider = value;
			if (this.menuButton == null){
				menuButton = new MDIApplicationMenuButton(this);
				menuButton.mdiApplication = this;
				menuButton.appBar = this._applicationBar;
				_applicationBar.addChildAt(menuButton,0);
			}
			updateStyles();
			
			this.menuButton.dataProvider = value;
		}
		
		/**
		 * Returns the application bar Menu using a XML
		 * @Return
		 * 
		 */					
		public function get dataProvider():Object{
			if (this.menuButton!=null){
				return this.menuButton.dataProvider;
			}
			else{
				return this.dataProvider;
			}
		}

		public function set applicationMenu(value:ApplicationMenu):void{
			if (this.menuButton == null){
				menuButton = new MDIApplicationMenuButton(this);
				menuButton.mdiApplication = this;
				menuButton.appBar = this._applicationBar;
				_applicationBar.addChildAt(menuButton,0);
			}
			updateStyles();
			menuButton.menu=value;			
		}

		public function get applicationMenu():ApplicationMenu{
			return this.menuButton.menu;
		}
		
		/**
		 * Returns if the application bar should colapse or not
		 * @Return
		 * 
		 */					
		public function get colapseBar():Boolean{
			return this._colapseBar;
		}

		/**
		 * Sets if the application bar should colapse or not
		 * @param value
		 * 
		 */							
		public function set colapseBar(value:Boolean):void{			
			if (value==true && this._colapseBar == false){
				this._colapseBar=true;
				this._applicationBar.handleZoom();
			} else {
				this._colapseBar = value;	
			}
		}
		
		/**
		 * Returns if all the windows should have a preview with a carrousel effect.
		 * @Return
		 * 
		 */						
		public function get vistaView():Boolean{
			return this._vistaView;
		}

		/**
		 * Sets if all the windows should have a preview with a carrousel effect.
		 * @param value
		 * 
		 */							
		public function set vistaView(value:Boolean):void{			
			if (value==true){
				this.windowShow.addKeyboardListeners();
			} else {
				this.windowShow.removeKeyboardListeners();
			}
			this._vistaView = value;
		}	
		
		/**
		 * Returns if the windows should be enforced to stay in the screen size
		 * @Return
		 * 
		 */							
		public function get enforceBoundaries():Boolean{
			return this.windowManager.enforceBoundaries;
		}

		/**
		 * Sets if the windows should be enforced to stay in the screen size
		 * @param value
		 * 
		 */								
		public function set enforceBoundaries(value:Boolean):void{
			this.windowManager.enforceBoundaries=value;
		}

		/**
		 * Returns the size in pixel for the windows in the show view
		 * @Return
		 * 
		 */				
		public function get windowShowSize():Number{
			return this.windowShow.maxWidth;
		}

		/**
		 * Sets the size in pixel for the windows in the show view
		 * @param value
		 * 
		 */				
		public function set windowShowSize(value:Number):void{
			this.windowShow.maxWidth=value;
			this.windowShow.maxHeight=value;
		}		

		/**
		 * Returns the style for the windows in the show view
		 * @Return
		 * 
		 */			
		public function get windowShowStyle():String{
			return this.windowShow.actualStyle;
		}

		/**
		 * Sets the style for the windows in the show view
		 * @param value
		 * 
		 */						
		public function set windowShowStyle(value:String):void{
			this.windowShow.changeStyle(value);
		}		
	}	
}