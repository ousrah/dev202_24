<?php

namespace App\Http\Controllers;

use App\Models\Post;
use Illuminate\Http\Request;

class PostController extends Controller
{
   
    public function index()
    /**
     * Show all the posts in the database
     * @return \Illuminate\View\View
     */
   {

        $posts =  Post::orderBy('created_at','desc')->get(); // expression eloquent select * from posts
        return view('posts.index',['posts' => $posts]); // , ['posts' => $posts]
   }


   /**
    * Show form to create a new post
    * @return \Illuminate\View\View
    */
   public function create() {
    return view('posts.create');
  }


  /**
   * Store a new post
   * @param \Illuminate\Http\Request $request
   * @return \Illuminate\Http\RedirectResponse
   */
  public function store(Request $request) {
    // validations
    $request->validate([
      'title' => 'required',
      'description' => 'required',
      'image' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
    ]);
  
    $post = new Post;
  
    $file_name = time() . '.' . request()->image->getClientOriginalExtension();
    request()->image->move(public_path('images'), $file_name);
  
    $post->title = $request->title;
    $post->description = $request->description;
    $post->image = $file_name;
  
    $post->save();
    return redirect()->route('posts.index')->with('success', 'Post created successfully.');
  }
}
