<?php

use Illuminate\Support\Facades\Route;

use App\Http\Controllers\ProductController;

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

Route::resource('products', ProductController::class);
Route::post('/products/search', [ProductController::class, 'search'])->name('products.search');
Route::post("/products/delete", [ProductController::class, 'delete'])->name('products.delete');



Route::post("/saveCookie", [ProductController::class, 'saveCookie'])->name("saveCookie");

Route::post("/saveSession", [ProductController::class, 'saveSession'])->name("saveSession");
