<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Comment extends Model
{
    use HasFactory;

      /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'comment',
        'user_id',
        'post_id',
        'article_id'
    ];

    public function user(){
        return $this->belongsTo(User::class);
    }

    public function commenttable(){
        return $this->morphTo();
    }
}
