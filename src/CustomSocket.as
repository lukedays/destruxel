package {
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
	import flash.errors.*;
	import com.adobe.serialization.json.JSON;

	public class CustomSocket extends Socket {
		public var response:String;

		public function CustomSocket(host:String = null, port:uint = 0) {
			super();
			configureListeners();
			if (host && port)  {
				super.connect(host, port);
			}
		}

		private function configureListeners():void {
			addEventListener(Event.CLOSE, closeHandler);
			addEventListener(Event.CONNECT, connectHandler);
			addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}

		public function write(str:String):void {
			try {
				writeUTFBytes(str);
			}
			catch(e:IOError) {
				trace(e);
			}
		}
		
		private function readResponse():void {
			response = readUTFBytes(bytesAvailable);
			trace(response);
			
			var obj:Object = JSON.decode(response);
			if (obj.login) {
				if (!R.playerNumber) R.playerNumber = obj.player;
				
				if (obj.player >= 1) {
					R.textPlayerNumber1.text = "Player 1 Online";
					R.textPlayerNumber1.color = 0x00AA00;
				}
				
				if (obj.player >= 2) {
					R.textPlayerNumber2.text = "Player 2 Online";
					R.textPlayerNumber2.color = 0x00AA00;
				}
			}
			else {
				if (R.playerNumber == 1 && obj.player == 2) {
					R.player2.x = parseFloat(obj.x);
					R.player2.y = parseFloat(obj.y);
				}
				
				/*if (R.playerNumber == 2 && obj.player == 1) {
					R.player2.x = parseFloat(obj.x);
					R.player2.y = parseFloat(obj.y);
				}*/
			}
		}

		private function closeHandler(event:Event):void {
			trace("closeHandler: " + event);
			trace(response.toString());
		}

		private function connectHandler(event:Event):void {
			trace("connectHandler: " + event);
		}

		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
		}

		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
		}

		private function socketDataHandler(event:ProgressEvent):void {
			trace("socketDataHandler: " + event);
			readResponse();
		}
	}

	/*public function CustomSocket() {
		socket = new XMLSocket();
		configureListeners(socket);
		if (hostName && port) {
			socket.connect(hostName, port);
		}
	}

	public function send(data:Object):void {
		socket.send(data);
	}

	private function configureListeners(dispatcher:IEventDispatcher):void {
		dispatcher.addEventListener(Event.CLOSE, closeHandler);
		dispatcher.addEventListener(Event.CONNECT, connectHandler);
		dispatcher.addEventListener(DataEvent.DATA, dataHandler);
		dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
	}

	private function closeHandler(event:Event):void {
		trace("closeHandler: " + event);
	}

	private function connectHandler(event:Event):void {
		trace("connectHandler: " + event);
	}

	private function dataHandler(event:DataEvent):void {
		trace("dataHandler: " + event);
		trace(event.data);
	}

	private function ioErrorHandler(event:IOErrorEvent):void {
		trace("ioErrorHandler: " + event);
	}

	private function progressHandler(event:ProgressEvent):void {
		trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
	}

	private function securityErrorHandler(event:SecurityErrorEvent):void {
		trace("securityErrorHandler: " + event);
	}*/
}
