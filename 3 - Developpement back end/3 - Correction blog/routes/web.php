<?php

use Illuminate\Support\Facades\Route;
use  App\Http\Controllers\PostController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});
Route::resource('posts', PostController::class);
/*
Route::get("posts.index",[PostController::class,"index"])->name("Posts.index");

Route::get("posts.create",[PostController::class,"create"])->name("Posts.create");

Route::get("posts.store",[PostController::class,"store"])->name("Posts.store");

*/