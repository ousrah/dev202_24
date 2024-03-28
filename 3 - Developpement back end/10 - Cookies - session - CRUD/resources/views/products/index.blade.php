@extends('products.layout')

@section('content')


<div class="row">
    <div class='max-w-md mx-auto'>
        <form method="post" action="{{ route('products.search') }}"  id="searchForm" onsubmit="return submitForm(event)">
            @csrf
        <div class="relative flex items-center w-full h-12 rounded-lg focus-within:shadow-lg bg-white overflow-hidden">
            <div class="grid place-items-center h-full w-12 text-gray-300">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
            </div>

            <input
            class="peer h-full w-full outline-none text-sm text-gray-700 pr-2"
            type="text"
            id="search"
            name="search"
            placeholder="Search something.." />
        </form>
        </div>
    </div>
</div>
    <div class="row">
        <div class="col-lg-12 margin-tb">
            <div class="pull-left">
                <h2>Laravel 10 CRUD Example from scratch - ItSolutionStuff.com</h2>
            </div>
            <div class="pull-right">
                <a class="btn btn-success" href="{{ route('products.create') }}"> Create New Product</a>
            </div>
        </div>
    </div>

    <div id="searchResults">
        @if ($message = Session::get('success'))
            <div class="alert alert-success">
                <p>{{ $message }}</p>
            </div>
        @endif

    <table class="table table-bordered">
        <tr>
            <th>No</th>
            <th>Name</th>
            <th>Details</th>
            <th width="280px">Action</th>
        </tr>
        @foreach ($products as $product)
        <tr id="row{{ $product->id }}">
            <td>{{ ++$i }}</td>
            <td>{{ $product->name }}</td>
            <td>{{ $product->detail }}</td>
            <td>
                    <a class="btn btn-info" href="{{ route('products.show',$product->id) }}">Show</a>

                    <a class="btn btn-primary" href="{{ route('products.edit',$product->id) }}">Edit</a>



                    <button onclick="confirmDelete({{ $product->id }})" class="btn btn-danger bg-red-500 hover:bg-red-700 text-white">Delete</button>

            </td>
        </tr>
        @endforeach
    </table>

    {!! $products->links() !!}

    </div>


    <button id="myBtn">Open Modal</button>
@include("modals.deleteProduct")

@endsection
@section('scripts')
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>


function confirmDelete(id) {
    event.preventDefault(); // Prevent the default form submission

    $('#deleteId').val(id);
    $('#myModal').show();

}

// When the user clicks the button, open the modal
$('#close').click( function() {
    $('#myModal').hide();
});


// When the user clicks anywhere outside of the modal, close it
$(window).on('click',function(event) {
 if(event.target.id === 'myModal')   $('#myModal').hide();
});
  function submitForm(event) {
        event.preventDefault(); // Prevent the default form submission

        var formData = $('#searchForm').serialize(); // Serialize form data

 /*       $.ajax({
            type: 'POST',
            url: $('#searchForm').attr('action'),
            data: formData,
            success: function (response) {
                $('#searchResults').html(response); // Display the search results in the specified div
            },
            error: function (xhr, status, error) {
                console.error(xhr.responseText);
            }
        });*/

        axios.post('{{ route("products.search") }}', formData)
            .then(function (response) {
                $('#searchResults').html(response.data); // Display the search results in the specified div
            })
            .catch(function (error) {
                console.error(error);
            });

        return false; // Prevent the form from submitting again
    }
</script>
@endsection
