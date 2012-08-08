package de.benz.exec.screenrecording {
    
    import flash.events.EventDispatcher;
    import flash.events.SampleDataEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.media.Microphone;
    import flash.utils.ByteArray;

    public class AudioRecorder extends EventDispatcher {
      
		private var microphone:Microphone;
		private var targetFile:File;
		private var outputStream:FileStream;
		private var sample:Number;
		
		public function AudioRecorder() {
			
        }
		
        public function startRecording(micIndex:int,targetFile:File):void {
			microphone = Microphone.getMicrophone(micIndex);
			microphone.setSilenceLevel(0);
			microphone.rate = 44;
			microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, onMicData);

			if(targetFile.exists){
				targetFile.deleteFile();
			}
			outputStream = new FileStream();
			outputStream.open(targetFile, FileMode.APPEND);			
        }

        public function stopRecording():void {
			microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, onMicData);
			outputStream.close();
        }

        protected function onMicData(sampleData:SampleDataEvent):void {
			while(sampleData.data.bytesAvailable){
				sample = sampleData.data.readFloat();
				outputStream.writeShort(sample*32767); // normalize for bitrate 16
			}
        }

       
    }
}