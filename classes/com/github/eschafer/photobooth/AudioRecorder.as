package com.github.eschafer.photobooth {
	import flash.display.Sprite;
	import flash.media.Video;
	import flash.events.SampleDataEvent;
	import flash.media.Microphone;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	import com.zeropointnine.SimpleFlvWriter;
	import flash.filesystem.*;
	import com.adobe.audio.format.WAVWriter;
	import flash.utils.*;

	public class AudioRecorder extends Sprite {
		protected var microphone:Microphone;
		protected var isRecording:Boolean = false;
		protected var soundRecording:ByteArray;
		protected var soundOutput:Sound;

		public function AudioRecorder() {
		}

		public function recordAudioClip():void {
		}

		protected function setupMicrophone():void
		{
			microphone = Microphone.getMicrophone();
			microphone.rate = 44;
		}

		protected function startMicRecording():void
		{
			isRecording = true;
			soundRecording = new ByteArray();
			microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, gotMicData);
		}

		protected function stopMicRecording():void
		{
			isRecording = false;
			microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, gotMicData);
		}

		private function gotMicData(micData:SampleDataEvent):void
		{
			soundRecording.writeBytes(micData.data);
		}

		protected function playbackData():void
		{
			soundRecording.position = 0;

			soundOutput = new Sound();
			soundOutput.addEventListener(SampleDataEvent.SAMPLE_DATA, playSound);

			soundOutput.play();
		}

		private function playSound(soundOutput:SampleDataEvent):void
		{
			if (!soundRecording.bytesAvailable > 0)
				return;
			for (var i:int = 0; i < 8192; i++)
			{
				var sample:Number = 0;
				if (soundRecording.bytesAvailable > 0)
					sample = soundRecording.readFloat();
				soundOutput.data.writeFloat(sample);
				soundOutput.data.writeFloat(sample);
			}
		}

		protected function saveFile():void
		{
			var outputFile:File = File.desktopDirectory.resolvePath("recording.wav");
			var outputStream:FileStream = new FileStream();
			var wavWriter:WAVWriter = new WAVWriter();

			soundRecording.position = 0;  // rewind to the beginning of the sample

			wavWriter.numOfChannels = 1; // set the inital properties of the Wave Writer
			wavWriter.sampleBitRate = 16;
			wavWriter.samplingRate = 44100;

			outputStream.open(outputFile, FileMode.WRITE);  //write out our file to disk.
			wavWriter.processSamples(outputStream, soundRecording, 44100, 1); // convert our ByteArray to a WAV file.
			outputStream.close();
		}
	}
}
