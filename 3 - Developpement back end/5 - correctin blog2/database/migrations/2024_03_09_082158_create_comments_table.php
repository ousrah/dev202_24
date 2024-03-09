<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
 

        Schema::create('comments', function (Blueprint $table) {
            $table->id();
            $table->string('comment');

/*
$table->foreignId('user_id')->constrained();
$table->foreignId('post_id')->constrained();
$table->foreignId('article_id')->constrained();
*/
            $table->unsignedBigInteger('user_id');
            $table->unsignedBigInteger('post_id')->nullable();
            $table->unsignedBigInteger('article_id')->nullable();


            $table->foreign('user_id')->references('id')->on('users');
            $table->foreign('post_id')->references('id')->on('posts');
            $table->foreign('article_id')->references('id')->on('articles');

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('comments');
    }
};
