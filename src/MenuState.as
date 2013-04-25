package {
	import org.flixel.*;
	
	public class MenuState extends FlxState {
		override public function create():void {
			FlxG.flash(0xFF000000);
			FlxG.bgColor = 0xffd5eeb0;
			
			var text:FlxText = new FlxText(0, 50, 800, "Tilemen");
			text.setFormat(null, 48, 0x43230a, "center", 0xff000000);
			add(text);
			
			text = new FlxText(0, 200, 800, "Press any button to start");
			text.setFormat(null, 18, 0x000000, "center");
			add(text);
		}
		
		override public function update():void {
			super.update();
			
			if (FlxG.keys.any()) FlxG.switchState(new PlayState());
		}
	}
}