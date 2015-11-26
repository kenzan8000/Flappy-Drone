var express = require('express');
var router = express.Router();


router.get('/', function(request, response, next) {
    response.render('index', { title: 'Express' });
});


/* ************************************************** *
 *                    Drone                           *
 * ************************************************** */

/// constants
const ARD_DECIDING_AVERAGE_DIRECTION_FRAME_COUNT = 50;
const ARD_ALTITUDE_MAX = 2000;
const ARD_VELOCITY_Z_MAX = 1000;

/// global variable
var g_arDrone = require('ar-drone');
var g_arDroneConstants = require('ar-drone/lib/constants');
function navigationDataOptionMask(c) { return 1 << c; }
var navigationDataOptions = (
    navigationDataOptionMask(g_arDroneConstants.options.DEMO)
  | navigationDataOptionMask(g_arDroneConstants.options.ALTITUDE)
  | navigationDataOptionMask(g_arDroneConstants.options.VISION_DETECT)
  | navigationDataOptionMask(g_arDroneConstants.options.MAGNETO)
  | navigationDataOptionMask(g_arDroneConstants.options.WIFI)
);
var g_client = g_arDrone.createClient(navigationDataOptions);
// Connect and configure the drone
g_client.config('general:navdata_demo', true);
g_client.config('general:navdata_options', navigationDataOptions);
//g_client.config('video:video_channel', 0);
g_client.config('video:video_channel', 3);
g_client.config('detect:detect_type', 12);
g_client.config('control:altitude_max', ARD_ALTITUDE_MAX);
g_client.config('control:control_vz_max', ARD_VELOCITY_Z_MAX);

/*
// record video
var PaVEParser = require('ar-drone/lib/video/PaVEParser');
var output = require('fs').createWriteStream('./movie/' + (new Date()).toString() + '.h264');
var video = g_client.getVideoStream();
var parser = new PaVEParser();

parser.on('data', function(data) { output.write(data.payload); })
      .on('end', function() { output.end(); });
video.pipe(parser);
*/

// drone
g_client.on('navdata', function(navigationData) {
    console.log(navigationData)
});


/* ************************************************* *
 *                     POST                          *
 * ************************************************* */

router.post('/takeoff', function(request, response) {
    g_client.takeoff();
    response.send({ 'application_code' : 200, 'takeoff' : 'succeeded' });
});

router.post('/land', function(request, response) {
    g_client.land();
    response.send({ 'application_code' : 200, 'land' : 'succeeded' });
});

router.post('/flap', function(request, response) {
    // flap count
    var count = parseInt(request.body.count);
    if (!count) { response.send({ 'application_code' : 400, 'flap' : 'failed' }); return; }

    response.send({ 'application_code' : 200, 'count' : count, 'flap' : 'succeeded' });
});



module.exports = router;
