<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <title>Laravel</title>

        <!-- Fonts -->
        <link rel="preconnect" href="https://fonts.bunny.net">
        <link href="https://fonts.bunny.net/css?family=figtree:400,600&display=swap" rel="stylesheet" />
        @vite(['resources/css/app.css', 'resources/js/app.js'])
        <!-- Styles -->
        
    </head>
    <body class="antialiased">
        
        
    <button class="btn btn-primary bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
            {{__('Save Cookie') }}
        </button>

    <div class="p-10 m-10">
    <button id="testJquery" class="btn btn-warning bg-orange-500 hover:bg-orange-700 text-white font-bold py-2 px-4 rounded">
           test jquery
        </button>
        <button id="testAjax" class="btn btn-success bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded">
           test ajax
        </button>
        <button id="testAxios" class="btn btn-danger bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded">
           test axios
        </button>
        <p id="testResult">Before click</p>
    </div>

    <p class="zoomable">
        Click me to zoom
    </p>



    <form method="POST" action="saveAvatar"  enctype="multipart/form-data" >
        @csrf
        <label for="txtCookie">{{__('Choose your picture')}}</label>
        <input type="file" id = "avatarFile"  name = "avatarFile" />
        <button class="btn btn-primary bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
            {{__('Save picture') }}
        </button>
        <img style = "width:200px; border-radius:50%" src="{{"storage/avatars/".$pic}}" alt="">
    </form>

    <script type="module">
        $(document).ready(function(){
            
            $(".zoomable").click(function(){
                $(this).animate({
                    fontSize: "40px"
                }, 1000);
            });
$("#testJquery").click(function(){
    $("#testResult").html("ok");
})


$("#testAjax").click(function(){
    $.ajax({
        url: '/test',
        success: function(data) {
            $("#testResult").html(data);
        }
    });
})

$("#testAxios").click(function(){
    axios.get('/test')
        .then(response => {
                console.log(response)
                $("#testResult").html(response.data);
        })
        .catch(error => {
            console.log(error);
        });
    
})

        });
    </script>

    </body>
</html>
