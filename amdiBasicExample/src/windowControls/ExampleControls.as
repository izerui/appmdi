package windowControls
{
	import org.trueagile.amdi.containers.MDIWindowControlsContainer;

	public class ExampleControls extends MDIWindowControlsContainer
	{
		public function ExampleControls()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			setStyle("horizontalGap", 2);
		}
	}
}