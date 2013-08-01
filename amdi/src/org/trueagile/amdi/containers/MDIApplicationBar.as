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
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.containers.ApplicationControlBar;
	import mx.effects.Zoom;
	import mx.effects.effectClasses.ZoomInstance;
	import mx.events.EffectEvent;
	
	/**
	 * This class represents de control Bar for the MDI Application
	 * @author mmarmol
	 * 
	 */
	public class MDIApplicationBar extends ApplicationControlBar
	{
        private var resizeInstArray:ArrayCollection = new ArrayCollection([]);
        private var resizeInst:ZoomInstance;
		private var r2:Zoom;
		private var app:MDIApplication;

		/**
		 * Basic constructor
		 * @param mdiApp
		 * 
		 */
		public function MDIApplicationBar(mdiApp:MDIApplication)
		{
			super();
			this.r2= new Zoom();
			this.r2.zoomHeightFrom=0.30;
			this.r2.zoomHeightTo=1;
			this.r2.duration=300;
			this.app=mdiApp;
			this.addEventListener(MouseEvent.ROLL_OVER,handleZoom);
			this.addEventListener(MouseEvent.ROLL_OUT,handleZoom);
			this.r2.addEventListener(EffectEvent.EFFECT_START,startEffect);
			this.r2.addEventListener(EffectEvent.EFFECT_END,endEffect);
		}
            
            /**
             * This is the handle method for the collapsing bar effect. 
             * @param event
             * 
             */
            public function handleZoom(event:MouseEvent=null):void {
				if (this.app.colapseBar==false){
					return;
				}
				var xy:Point = new Point(stage.mouseX,stage.mouseY);
				if (this.app.menuButton.isShowing){
					if (event!=null){
						event.preventDefault();
					}
					return;
				}
				if (this.app.barPossition==MDIApplication.TOP_POSITON){
					if (xy.y < this.y+this.height-4 && xy.y > this.y+4){
						if (event!=null){
							event.preventDefault();
						}
						return;
					}
				} 
				else if (this.app.barPossition==MDIApplication.BOTTON_POSITON){
					if (xy.y < this.y+this.height-4 && xy.y > this.y+4){
						if (event!=null){
							event.preventDefault();
						}
						return;
					}					
				}
				if (r2.isPlaying) {
                    r2.reverse();
                }
                else if (event==null){
                	  r2.play([this],true);
                }
                else {
                    // If this is a ROLL_OUT event, play the effect backwards. 
                    // If this is a ROLL_OVER event, play the effect forwards.
                    r2.play([event.target], event.type == MouseEvent.ROLL_OUT ? true : false);
                }
            }

        
        /**
         * Effect when starting collapsing
         * @param event
         * 
         */
        private function startEffect(event:EffectEvent): void
        {
	        this.app.isBarCollapsing=true;
	        this.validateNow();
	        for each (var child:Object in this.getChildren()){
				DisplayObject(child).visible=false;
        	}
        	
        }
        
        /**
         * Effect when ending collapsing
         * @param event
         * 
         */
        public function endEffect(event:EffectEvent): void
        {
        	this.validateNow();
        	if (Math.round(this.height)==this.app._appBarHeight){
	        	for each (var child:Object in this.getChildren()){
					DisplayObject(child).visible=true;
        		}
        	}
        	this.app.isBarCollapsing=false;
        }
	}
}