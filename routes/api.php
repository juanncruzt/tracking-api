<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
 */

//header('Access-Control-Allow-Origin: *');

Route::group(['middleware' => ['cors']], function () {
    Route::middleware('auth:api')->get('/user', function (Request $request) {
        return $request->user();
    });
    
    //General
    Route::get('/v1/tracking/{trackingId}', 'Api\ApiController@getTracking');
    
    //Redis
    Route::get('/v1/redis/test', 'Api\ApiController@testRedis');
});


URL::forceScheme('https');
