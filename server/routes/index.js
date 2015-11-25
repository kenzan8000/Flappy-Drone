var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
    res.render('index', { title: 'Express' });
});

/* POST how to fly drone. */
router.post('/', function(req, res) {
    // commands
    var commands = null;
    if (req.body.commands) { commands = req.body.commands; }
    if (commands === null) { res.send({ 'application_code' : 400 }); return; }
    console.log(commands)

    res.send({ 'application_code' : 200 });
});

module.exports = router;



///// constants
//const ARD_DECIDING_AVERAGE_DIRECTION_FRAME_COUNT = 50;
//const ARD_ALTITUDE_MAX = 2000;
//const ARD_VELOCITY_Z_MAX = 1000;
//
//var arDrone = require('ar-drone');
//var arDroneConstants = require('ar-drone/lib/constants');
//
//function navdata_option_mask(c) {
//  return 1 << c;
//}
//
//// From the SDK.
//var navdata_options = (
//    navdata_option_mask(arDroneConstants.options.DEMO)
//  | navdata_option_mask(arDroneConstants.options.ALTITUDE)
//  | navdata_option_mask(arDroneConstants.options.VISION_DETECT)
//  | navdata_option_mask(arDroneConstants.options.MAGNETO)
//  | navdata_option_mask(arDroneConstants.options.WIFI)
//);
//
//var client = arDrone.createClient(navdata_options);
//
//// Connect and configure the drone
//client.config('general:navdata_demo', true);
//client.config('general:navdata_options', navdata_options);
////client.config('video:video_channel', 0);
//client.config('video:video_channel', 3);
//client.config('detect:detect_type', 12);
//client.config('control:altitude_max', ARD_ALTITUDE_MAX);
//client.config('control:control_vz_max', ARD_VELOCITY_Z_MAX);
//
//
//
///*
//// record video
//var PaVEParser = require('ar-drone/lib/video/PaVEParser');
//var output = require('fs').createWriteStream('./movie/' + (new Date()).toString() + '.h264');
//var video = client.getVideoStream();
//var parser = new PaVEParser();
//
//parser.on('data', function(data) { output.write(data.payload); })
//      .on('end', function() { output.end(); });
//video.pipe(parser);
//*/
//
//
//
///*
//// drone
//client.on('navdata', function(navigationData) {
//    console.log(navigationData)
//});
//*/
