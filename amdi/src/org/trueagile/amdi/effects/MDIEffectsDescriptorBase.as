/*
Copyright (c) 2010, TRUEAGILE
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of the TRUEAGILE nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package org.trueagile.amdi.effects
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.containers.ApplicationControlBar;
	import mx.effects.Blur;
	import mx.effects.Effect;
	import mx.effects.EffectInstance;
	import mx.effects.IEffect;
	import mx.effects.Move;
	import mx.effects.Parallel;
	import mx.effects.Resize;
	import mx.effects.Sequence;
	import mx.effects.easing.Back;
	import mx.events.EffectEvent;
	
	import org.trueagile.amdi.containers.MDIApplication;
	import org.trueagile.amdi.containers.MDIWindow;
	import org.trueagile.amdi.effects.effectClasses.MDIGroupEffectItem;
	import org.trueagile.amdi.managers.MDIManager;
		
	/**
	 * Base effects implementation with no animation. Extending this class means the developer
	 * can choose to implement only certain effects, rather than all required by IMDIEffectsDescriptor.
	 */
	public class MDIEffectsDescriptorBase implements IMDIEffectsDescriptor
	{
		public var duration:Number = 10;
		
		public function getWindowAddEffect(window:MDIWindow, manager:MDIManager):Effect
		{
			return new Effect();
		}
		
		public function getWindowMinimizeEffect(window:MDIWindow, manager:MDIManager, moveTo:Point = null):Effect
		{
			var parallel:Parallel = new Parallel();
			parallel.duration = this.duration;
			
			var resize:Resize = new Resize(window);
			resize.widthTo = window.minWidth;
			resize.duration = this.duration;
			resize.heightTo = window.minimizeHeight;
			parallel.addChild(resize);
			
			if(moveTo != null)
			{
				var move:Move = new Move(window);
				move.xTo = moveTo.x;
				move.yTo = moveTo.y;
				move.duration = this.duration;
				parallel.addChild(move);
			}
			
			return parallel;
		}
		
		public function getWindowRestoreEffect(window:MDIWindow, manager:MDIManager, restoreTo:Rectangle):Effect
		{
			var parallel:Parallel = new Parallel();
			parallel.duration = this.duration;
			
			var resize:Resize = new Resize(window);
			resize.widthTo = restoreTo.width;
			resize.heightTo = restoreTo.height;
			resize.duration = this.duration;
			parallel.addChild(resize);
			
			var move:Move = new Move(window);
			move.xTo = restoreTo.x;
			move.yTo = restoreTo.y;
			move.duration = this.duration;
			parallel.addChild(move);
			
			return parallel;
		}

		public function getWindowRestoreMinimizedEffect(window:MDIWindow, manager:MDIManager, restoreTo:Rectangle):Effect
		{
			var parallel:Parallel = new Parallel();
			parallel.duration = this.duration;
			
			var resize:Resize = new Resize(window);
			resize.widthTo = restoreTo.width;
			resize.heightTo = restoreTo.height;
			resize.duration = this.duration;
			parallel.addChild(resize);
			
			var move:Move = new Move(window);
			move.xTo = restoreTo.x;
			move.yTo = restoreTo.y;
			if (manager.mdiApplication.barPossition == MDIApplication.TOP_POSITON){
				move.xFrom=0;
				move.yFrom=0;
			}
			else if (manager.mdiApplication.barPossition == MDIApplication.BOTTON_POSITON){
				move.xFrom=0;
				move.yFrom=manager.mdiApplication._appBarHeight+manager.mdiApplication.container.height;
			}			
			move.duration = this.duration;
			parallel.addChild(move);
			
			return parallel;
		}
		
		
		public function getWindowMaximizeEffect(window:MDIWindow, manager:MDIManager, bottomOffset:Number = 0):Effect
		{
			var parallel:Parallel = new Parallel();
			parallel.duration = this.duration;
			
			var resize:Resize = new Resize(window);
			resize.widthTo = manager.container.width;
			resize.heightTo = manager.container.height - bottomOffset;
			resize.duration = this.duration;
			parallel.addChild(resize);
			
			var move:Move = new Move(window);
			move.xTo = 0;
			move.yTo = 0;
			move.duration = this.duration;
			parallel.addChild(move);
			
			return parallel;
		}
		
		public function getWindowCloseEffect(window:MDIWindow, manager:MDIManager):Effect
		{
			// have to return something so that EFFECT_END listener will fire
			var resize:Resize = new Resize(window);
			resize.duration = this.duration;
			resize.widthTo = window.width;
			resize.heightTo = window.height;
			
			return resize;
		}
		
		public function getWindowFocusStartEffect(window:MDIWindow, manager:MDIManager):Effect
		{
			return new Effect();
		}
		
		public function getWindowFocusEndEffect(window:MDIWindow, manager:MDIManager):Effect
		{
			return new Effect();
		}
		
		public function getWindowDragStartEffect(window:MDIWindow, manager:MDIManager):Effect
		{
			return new Effect();
		}
		
		public function getWindowDragEffect(window:MDIWindow, manager:MDIManager):Effect
		{
			return new Effect();
		}
		
		public function getWindowDragEndEffect(window:MDIWindow, manager:MDIManager):Effect
		{
			return new Effect();
		}
		
		public function getWindowResizeStartEffect(window:MDIWindow, manager:MDIManager):Effect
		{
			return new Effect();
		}
		
		public function getWindowResizeEffect(window:MDIWindow, manager:MDIManager):Effect
		{
			return new Effect();
		}
		
		public function getWindowResizeEndEffect(window:MDIWindow, manager:MDIManager):Effect
		{
			return new Effect();
		}		
		
		public function getTileEffect(items:Array, manager:MDIManager):Effect
		{
			var parallel:Parallel = new Parallel();
			parallel.duration = this.duration;
			
			for each(var item:MDIGroupEffectItem  in items)
			{	
				manager.bringToFront(item.window);
				var move:Move = new Move(item.window);
					move.xTo = item.moveTo.x;
					move.yTo = item.moveTo.y;
					move.duration = this.duration;
					parallel.addChild(move);
					
				item.setWindowSize();
			}
			
			return parallel;
		}
		
		public function getCascadeEffect(items:Array, manager:MDIManager):Effect
		{
			var parallel:Parallel = new Parallel();
			parallel.duration = this.duration;
			
			for each(var item:MDIGroupEffectItem in items)
			{
				
				if( ! item.isCorrectPosition )
				{
					var move:Move = new Move(item.window);
						move.xTo = item.moveTo.x;
						move.yTo = item.moveTo.y;
						move.duration = this.duration;
					parallel.addChild(move);
				
				}
				
				if( ! item.isCorrectSize )
				{
					
					var resize:Resize = new Resize(item.window);
						resize.widthTo = item.widthTo;
						resize.heightTo = item.heightTo;
						resize.duration = this.duration;
					parallel.addChild(resize);
						
				}
			}
			
			return parallel;
		}		
		
		public function reTileMinWindowsEffect(window:MDIWindow, manager:MDIManager, moveTo:Point):Effect
		{
			var move:Move = new Move(window);
			move.duration = this.duration;
			move.xTo = moveTo.x;
			move.yTo = moveTo.y;
			return move
		}
		
		
		public function getTitledContainerDownEffect(object:DisplayObject):Effect{
			var effectDown:Move = new Move();
			effectDown.easingFunction=mx.effects.easing.Back.easeInOut;
			effectDown.yFrom = object.y - object.height;
			effectDown.yTo = object.y;
			effectDown.duration=500;
			return effectDown;
		}
				
		public function getTitledContainerUpEffect(object:DisplayObject):Effect{
			var effectUp:Move = new Move();
			effectUp.easingFunction = mx.effects.easing.Back.easeInOut;
			effectUp.yFrom = object.y + object.height;
			effectUp.yTo = object.y;			
			effectUp.duration=500;
			return effectUp;
		}
		
		
		public function getMinWindowShowEffect(minWin:DisplayObject):Effect
		{			
			var parallel:Parallel = new Parallel(minWin);

			var blurSequence:Sequence = new Sequence();

			var blurOut:Blur = new Blur();
				blurOut.blurXFrom = 0;
				blurOut.blurYFrom = 0;
				blurOut.blurXTo = 10;
				blurOut.blurYTo = 10;
			
			
			blurSequence.addChild(blurOut);
			
			var blurIn:Blur = new Blur();
				blurIn.blurXFrom = 10;
				blurIn.blurYFrom = 10;
				blurIn.blurXTo  = 0;
				blurIn.blurYTo = 0;
				
			
			blurSequence.addChild(blurIn);

			parallel.addChild(blurSequence);
	
			
			parallel.duration = 100;
			return parallel;
		}
		
		public function getMinWindowHideEffect(minWin:DisplayObject):Effect
		{
			var blur:Blur = new Blur(minWin);
				blur.blurXFrom = 0;
				blur.blurYFrom = 0;
				blur.blurXTo = 10;
				blur.blurYTo = 10;
				blur.duration =100;
				return blur;
		}	

	}
}