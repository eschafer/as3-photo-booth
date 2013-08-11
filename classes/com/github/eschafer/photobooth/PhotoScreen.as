package com.github.eschafer.photobooth {
	import flash.utils.clearInterval;
	import flash.events.MouseEvent;

	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.utils.setInterval;
	import com.adobe.images.PNGEncoder;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.filesystem.*;
	import flash.geom.Matrix;
	import flash.media.Video;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	public class PhotoScreen extends Sprite {
		protected var imageRecorder:ImageRecorder;
		protected var video:Video;
		protected var startButton:StartButton;
		protected var savingAnimation:SavingAnimation;
		protected var countdownAnimation:CountdownAnimation;
		protected var photoFlash:PhotoFlash;
		protected var bitmapData1:BitmapData;
		protected var bitmapData2:BitmapData;
		protected var bitmapData3:BitmapData;
		protected var bitmapData4:BitmapData;
		protected var results:Sprite;
		protected var intervalId:int;
		protected var saveStartTime:Number;

		public function PhotoScreen(vid:Video) {
			video = vid;

			imageRecorder = new ImageRecorder(video);
			imageRecorder.addEventListener("TAKE_PHOTO", takePhotoHandler);
			imageRecorder.addEventListener("IMAGES_CAPTURED", imagesCapturedHandler);
		}

		public function init():void {
			startButton = new StartButton();
			startButton.buttonMode = true;
			startButton.addEventListener(MouseEvent.CLICK, startButtonClickHandler);
			startButton.x = (960 - startButton.width) / 2;
			startButton.y = 670;
			addChild(startButton);

			countdownAnimation = new CountdownAnimation();
			countdownAnimation.addEventListener("COMPLETE", countdownCompleteHandler);
			countdownAnimation.x = video.x - video.width;
			countdownAnimation.y = video.y + video.height - countdownAnimation.height;
			countdownAnimation.alpha = 0;
			addChild(countdownAnimation);

			photoFlash = new PhotoFlash();
			photoFlash.x = video.x - video.width;
			photoFlash.y = video.y;
			addChild(photoFlash);

			savingAnimation = new SavingAnimation();
			savingAnimation.x = (960 - savingAnimation.width) / 2;
			savingAnimation.y = 670;
			savingAnimation.addEventListener("OPEN", savingAnimationOpenHandler);
			savingAnimation.addEventListener("CLOSE", savingAnimationCloseHandler);
			addChild(savingAnimation);
		}

		public function capture():void {
			countdownAnimation.alpha = 1;
			countdownAnimation.play();
		}

		protected function startButtonClickHandler(e:MouseEvent):void {
			startButton.visible = false;
			startButton.alpha = 0;
			capture();
		}

		protected function countdownCompleteHandler(e:Event):void {
			imageRecorder.recordImages();
		}

		protected function takePhotoHandler(e:Event):void {
			photoFlash.flash();

		}

		protected function imagesCapturedHandler(e:EventWithParameters):void {
			saveStartTime = getTimer();

			bitmapData1 = e.parameters.bitmapData1;
			bitmapData2 = e.parameters.bitmapData2;
			bitmapData3 = e.parameters.bitmapData3;
			bitmapData4 = e.parameters.bitmapData4;

			savingAnimation.gotoAndPlay(2);
		}

		protected function savingAnimationOpenHandler(e:Event):void {
			new Tween(video, "alpha", Strong.easeOut, video.alpha, 0, 1, true);
			new Tween(countdownAnimation, "alpha", Strong.easeOut, countdownAnimation.alpha, 0, 1, true);
			results = new Sprite();
			var resultsMask:Sprite = new Sprite();
			resultsMask.graphics.beginFill(0x000000, 1);
			resultsMask.graphics.drawRect(0, 0, 800, 600);
			resultsMask.x = 80;
			resultsMask.y = 60;
			results.mask = resultsMask;

			var background:Sprite = new Sprite();
			background.graphics.beginFill(0xeeeeee, 1);
			background.graphics.drawRect(0, 0, 800, 600);
			results.addChild(background);

			var bitmap1:Bitmap = new Bitmap(bitmapData1);
			bitmap1.width = 385;
			bitmap1.height = 285;
			bitmap1.x = 10;
			bitmap1.y = 10;
			results.addChild(bitmap1);

			var bitmap2:Bitmap = new Bitmap(bitmapData2);
			bitmap2.width = 385;
			bitmap2.height = 285;
			bitmap2.x = 405;
			bitmap2.y = 10;
			results.addChild(bitmap2);

			var bitmap3:Bitmap = new Bitmap(bitmapData3);
			bitmap3.width = 385;
			bitmap3.height = 285;
			bitmap3.x = 10;
			bitmap3.y = 305;
			results.addChild(bitmap3);

			var bitmap4:Bitmap = new Bitmap(bitmapData4);
			bitmap4.width = 385;
			bitmap4.height = 285;
			bitmap4.x = 405;
			bitmap4.y = 305;
			results.addChild(bitmap4);

			results.x = 80;
			results.y = -590;
			addChild(results);
			addChild(resultsMask);

			new Tween(results, "y", Strong.easeOut, results.y, 60, 1, true);

			intervalId = setInterval(encodeImages, 1000);
		}

		protected function savingAnimationCloseHandler(e:Event):void {
			new Tween(video, "alpha", Strong.easeOut, video.alpha, 1, 1, true);
			startButton.visible = true;
			new Tween(startButton, "alpha", Strong.easeOut, startButton.alpha, 1, 1, true);
		}

		protected function encodeImages():void {
			clearInterval(intervalId);

			var byteArray1:ByteArray = PNGEncoder.encode(bitmapData1);
			var byteArray2:ByteArray = PNGEncoder.encode(bitmapData2);
			var byteArray3:ByteArray = PNGEncoder.encode(bitmapData3);
			var byteArray4:ByteArray = PNGEncoder.encode(bitmapData4);

			var date:String = getDate();
			saveImage(byteArray1, 1, date);
			saveImage(byteArray2, 2, date);
			saveImage(byteArray3, 3, date);
			saveImage(byteArray4, 4, date);

			this.addEventListener(Event.ENTER_FRAME, checkSaveTime);
		}

		protected function checkSaveTime(e:Event):void {
			if (getTimer() - saveStartTime > 10000) {
				this.removeEventListener(Event.ENTER_FRAME, checkSaveTime);
				onSaveComplete();
			}
		}

		protected function onSaveComplete():void {
			removeChild(results);
			savingAnimation.gotoAndPlay(11);
		}

		protected function saveImage(byteArray:ByteArray, index:Number, date:String):void {
			var directory:File = File.documentsDirectory.resolvePath("Party Photo Booth");
			if (!directory.exists) {
				directory.createDirectory();
			}
			var file:File = directory.resolvePath(date + "_" + index +".png");
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeBytes(byteArray);
			fileStream.addEventListener(Event.CLOSE, fileClosed);
			fileStream.close();

			function fileClosed(event:Event):void {
			  trace("closed event fired");
			}
		}

		protected function getDate():String {
			var date:Date = new Date();
			var year:String = addLeadingZeros(date.getFullYear().toString().substring(2));
			var month:String = addLeadingZeros((date.getMonth()+1).toString());
			var day:String = addLeadingZeros(date.getDate().toString());
			var hours:String = addLeadingZeros(date.getHours().toString());
			var minutes:String = addLeadingZeros(date.getMinutes().toString());
			var seconds:String = addLeadingZeros(date.getSeconds().toString());

			return year + month + day + hours + minutes + seconds;
		}

		protected function addLeadingZeros(string:String):String {
			if (string.length == 1) {
				string = "0" + string;
			}
			return string;
		}
	}
}
