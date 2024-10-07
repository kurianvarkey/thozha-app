<?php

use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

/**
 * Default Route - /
 */
Route::get('/', function () {
    return response()->json([
        'code' => Response::HTTP_OK,
        'message' => 'Welcome to '.config('app.name').' '.env('APP_VERSION', '1.0'),
    ], Response::HTTP_OK);
});

/**
 * Route Fallback - for any endpoints not supported by the system
 */
Route::fallback(function () {
    return response()->json([
        'code' => Response::HTTP_NOT_FOUND,
        'message' => 'Endpoint not found. Please check the URL.',
    ], Response::HTTP_NOT_FOUND);
});
