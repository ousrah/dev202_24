<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Str;

class UserController extends Controller
{
    public function index()
    {
        $user = User::find(1); 
        $pic=$user->avatar;
        return view('welcome',compact('pic'));
    }
    public function saveAvatar(Request $request)
    {
        request()->validate([
            'avatarFile'=>'required|image',
                ]);

            $ext = request()->avatarFile->getClientOriginalExtension();;
            $name = Str::random(30).time().".".$ext;
            request()->avatarFile->move(public_path('storage/avatars'),$name);
            $user = User::find(1); //Auth()->user() extract the current authenticated user;
            $user->update(['avatar'=>$name]);
            return redirect()->back();
    }
}
