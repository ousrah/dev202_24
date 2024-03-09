<?php

namespace Database\Seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use App\Models\Post;
use App\Models\Role;
use App\Models\User;
use App\Models\Phone;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
      $role=new Role();
      $role->name='admin';
      $role->description='admin';
      $role->save();
      $role=new Role();
      $role->name='author';
      $role->description='author';
      $role->save();
      $role=new Role();
      $role->name='publisher';
      $role->description='publisher';
      $role->save();
      $role=new Role();
      $role->name='guest';
      $role->description='guest';
      $role->save();
      $roles = Role::all();



     User::factory(10)->create()->each(function($user) use ($roles) {
       Phone::factory()->create(['user_id'=>$user->id]);
       $user->roles()->attach($roles->random()->id);
       $user->roles()->attach($roles->random()->id);
     });

    /*   User::factory()->create([
            'name' => 'Test User',
             'email' => 'test@example.com',
        ]);*/
        //Post::factory(10)->create();
    }
}
