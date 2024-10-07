<?php

declare(strict_types=1);

use Illuminate\Http\Response;
use Illuminate\Support\Facades\Route;

/**
 * Default Route - /
 */
Route::get('/', function () {
    return response()->json([
        'version' => '1.0.0',
        'message' => 'Welcome to v1 REST API',
    ], Response::HTTP_OK);
});

Route::get('/healthz', function () {
    return response()->json([
        'code' => Response::HTTP_OK,
        'message' => 'Site is up',
    ], Response::HTTP_OK);
});
