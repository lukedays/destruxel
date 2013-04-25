package {
	import org.flixel.*;
	
	public class Light extends FlxSprite {
		[Embed(source = "assets/light2.png")] protected var Img:Class;
				
		public function Light(x:int, y:int):void {
			super(x, y);
			loadGraphic(Img, true, true, 200, 200);
			
			blend = "screen";
			scale = new FlxPoint(5, 5);
			addAnimation("light", [0, 0, 1, 2, 1, 2, 1], 3);
		}

		override public function draw():void {
			var screenXY:FlxPoint = getScreenXY();

			R.darkness.stamp(this,
							screenXY.x - this.width / 2,
							screenXY.y - this.height / 2);
			
			play("light");
		}
	}
}