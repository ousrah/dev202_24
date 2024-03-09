<?php

namespace Database\Seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use App\Models\Post;
use App\Models\Role;
use App\Models\User;
use App\Models\Phone;
use App\Models\Article;
use App\Models\Comment;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $role=new Role();
        $role->name = 'Admin';
        $role->save();
        $role=new Role();
        $role->name = 'Publisher';
        $role->save();
        $role=new Role();
        $role->name = 'Author';
        $role->save();
        $role=new Role();
        $role->name = 'Guest';
        $role->save();
        $roles = Role::all();
    User::factory(10)->create()->each(function ($user) use ($roles) {
        $user->phone()->save(Phone::factory()->make());
        $user->roles()->attach($roles->random()->id);
        $user->roles()->attach($roles->random()->id);
    });

     // Create 10 posts
    Post::factory(10)->create()->each(function ($post) {
         Comment::factory(10)->create(['post_id' => $post->id]);
         
      });
      Article::factory(10)->create()->each(function ($article) {
          Comment::factory(10)->create(['article_id' => $article->id]);
          
       });
    }
}
