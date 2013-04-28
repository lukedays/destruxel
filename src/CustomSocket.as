package {
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;

    public class CustomSocket extends Sprite {
        private var hostName:String = "localhost";
        private var port:uint = 1123;
        private var socket:XMLSocket;

        public function CustomSocket() {
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
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
            trace("ioErrorHandler: " + event);
        }

        private function progressHandler(event:ProgressEvent):void {
            trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
        }
    }
}