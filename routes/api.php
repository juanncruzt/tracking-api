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
header('Access-Control-Allow-Origin', "*");


Route::middleware('auth:api')->get('/user', function (Request $request) {
    return $request->user();
});

//General
Route::get('/v1/carriers/get', 'Api\ApiController@getCarriers');
Route::get('/v1/carriers-messages/all', 'Api\ApiController@getCarrierMessages');
Route::get('/v1/tracking/{trackingId}', 'Api\ApiController@getTracking');


//Andreani
Route::get('/v1/carriers-messages/andreani', 'Api\ApiController@getMessagesAndreani');
Route::post('/v1/tracking/andreani/{trackingId}', 'Api\ApiController@getTrackingAndreani');


//Chazki
Route::get('/v1/carriers-messages/chazki', 'Api\ApiController@getMessagesChazki');
Route::post('/v1/tracking/chazki/{trackingId}', 'Api\ApiController@getTrackingChazki');

//Redis
Route::get('/v1/redis/test', 'Api\ApiController@testRedis');
