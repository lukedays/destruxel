package {
	import org.flixel.*;
	
	public class MenuState extends FlxState {
		override public function create():void {
			FlxG.bgColor = 0xffd8d7a6;
			FlxG.shake(0.01, 0.2);
			
			var text:FlxText = new FlxText(0, 50, 800, "Tilemen");
			text.setFormat(null, 72, 0x43230a, "center", 0xff000000);
			add(text);
			
			text = new FlxText(0, 500, 800, "Press any button to start");
			text.setFormat(null, 24, 0x000000, "center");
			add(text);
			
			// Effects
			R.emitter = new FlxEmitter(FlxG.width / 2, 50, 30);
			R.emitter.maxParticleSpeed = new FlxPoint(500, 500);
			
			for (var i:int = 0; i < 30; i++) {
				var particle:FlxParticle = new FlxParticle();
				particle.makeGraphic(10, 10, 0xff43230a);
				particle.exists = false;
				R.emitter.add(particle);
			}
			
			add(R.emitter);
			R.emitter.start(true, 15, 0, 30);
		}
		
		override public function update():void {
			if (FlxG.keys.any()) FlxG.switchState(new PlayState());
			
			super.update();
		}
	}
}