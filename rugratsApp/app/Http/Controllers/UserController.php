<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class UserController extends Controller
{
    public function userLoginControllerGet(){

        return view('login');

    }
    public function userLoginControllerPost(Request $request){

        //API Url
        $url = 'asd';
 
        //Initiate cURL.
        $ch = curl_init($url);
 
        //The JSON data.
        $jsonData = array(
            'username' => $request->input('TC'),
            'password' => $request->input('password')
        );
        //Encode the array into JSON.
        $jsonDataEncoded = json_encode($jsonData);
 
        //Tell cURL that we want to send a POST request.
        curl_setopt($ch, CURLOPT_POST, 1);
 
        //Attach our encoded JSON string to the POST fields.
        curl_setopt($ch, CURLOPT_POSTFIELDS, $jsonDataEncoded);
 
        //Set the content type to application/json
        curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json')); 
 
        //Execute the request
        $result = curl_exec($ch);
        echo $result;
    }
    public function userRegisterControllerGet(){

        return view('register');

    }
    public function userRegisterControllerPost(Request $request){

        //API Url
        $url = 'https://localhost:44329/api/user/register';
 
        //Initiate cURL.
        $ch = curl_init($url);
 
        //The JSON data.
        $jsonData = array(
            'TcIdentityKey' => $request->input('TC'),
            'userPassword' => $request->input('password'),
            'userName' => $request->input('Name'),
            'Surname' => $request->input('Surname'),
            'email' => $request->input('email'),
            'dateofbirth' => $request->input('dateofbirth'),
            'phone' => $request->input('phone')
        );
        //Encode the array into JSON.
        $jsonDataEncoded = json_encode($jsonData);
 
        //Tell cURL that we want to send a POST request.
        curl_setopt($ch, CURLOPT_POST, 1);
 
        //Attach our encoded JSON string to the POST fields.
        curl_setopt($ch, CURLOPT_POSTFIELDS, $jsonDataEncoded);
 
        //Set the content type to application/json
        curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json')); 
 
        //Execute the request
        $result = curl_exec($ch);
        echo $result;
        //return redirect('/');
    }
    
}
