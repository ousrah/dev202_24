<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Post extends Model
{
    use HasFactory;
    protected $table = 'posts';
   
     /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */  
    protected $fillable = [
        'title',
        'description',
        'image'
    ];

    public function comments()
    {
        return $this->morphMany(Comment::class, 'commenttable');
    }
}
