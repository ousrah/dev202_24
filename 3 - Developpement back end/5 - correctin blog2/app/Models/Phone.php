<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Phone extends Model
{
    use HasFactory;
    protected $table = 'phones';
   
    /**
    * The attributes that are mass assignable.
    *
    * @var array<int, string>
    */  
   protected $fillable = [
       'phoneNumber',
       'user_id',
     
   ];

   public function user()
   {
    return $this->belongsTo(User::class);
   }
}