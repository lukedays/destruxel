package {
	import org.flixel.*;
	import flash.display.*;
	
	public class PlayState extends FlxState {
		[Embed(source = "assets/tileset.png")] protected var Tileset:Class;
		[Embed(source = "assets/map.csv", mimeType = "application/octet-stream")] protected var Map:Class;
		
		public var socket:CustomSocket;
				
		override public function create():void {
			addEnvironment();
			spawnPlayer();
			
			FlxG.flash(0xff000000);
			FlxG.camera.setBounds(0, 0, FlxG.width, FlxG.height * 2, true);
			FlxG.camera.follow(R.player, FlxCamera.STYLE_PLATFORMER);
			FlxG.mouse.show();
			
			socket = new CustomSocket();
		}
		
		override public function update():void {
			if (FlxG.mouse.justPressed()) {
				socket.send(R.player.x + " " + R.player.y);
			}
			
			FlxG.collide(R.player, R.blocks);
			super.update();
		}
		
		protected function addEnvironment():void {
			// Background
			add(new Background(0, 0, 0));
			
			// Boundaries
			var left:FlxTileblock = new FlxTileblock(0, 0, 1, FlxG.height);
			var right:FlxTileblock = new FlxTileblock(FlxG.width - 1, 0, 1, FlxG.height);
			var top:FlxTileblock = new FlxTileblock(0, 0, FlxG.width, 1);
			var bottom:FlxTileblock = new FlxTileblock(0, FlxG.height - 1, FlxG.width, 1);
			
			// Map
			R.map = new FlxTilemap();
			R.map.loadMap(new Map, Tileset, R.size, R.size);
			
			// Lighting
			R.light = new Light(FlxG.width / 2, 0);
			R.darkness = new Darkness();
			R.shadows = new Shadows();
			R.shadows.updateVertices();
			
			// Particles
			R.bullets = new BulletManager();
			R.emitter = new FlxEmitter(0, 0, 20);
			R.emitter.bounce = 0.5;
			R.emitter.gravity = 800;
			
			for (var i:int = 0; i < 20; i++) {
				var particle:FlxParticle = new FlxParticle();
				particle.makeGraphic(4, 4, 0xff72651e);
				particle.exists = false;
				R.emitter.add(particle);
			}
			
			// Add to collision group
			R.blocks = new FlxGroup();
			R.blocks.add(left);
			R.blocks.add(right);
			R.blocks.add(top);
			//R.blocks.add(bottom);
			R.blocks.add(R.map);
			
			add(R.shadows);
			add(R.blocks);
			add(R.light);
			add(R.darkness);
			add(R.bullets);
			add(R.emitter);
		}
		
		protected function spawnPlayer():void {
			R.player = new Player(FlxG.width / 2, FlxG.height / 3);
			add(R.player);
		}
	}
}