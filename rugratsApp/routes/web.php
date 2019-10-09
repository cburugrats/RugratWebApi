<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/
Route::get('/', 'userController@userLoginControllerGet');
Route::post('/', 'userController@userLoginControllerPost');
Route::get('/register', 'userController@userRegisterControllerGet');
Route::post('/register', 'userController@userRegisterControllerPost');
