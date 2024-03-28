
<!-- The Modal -->
<div id="myModal" class="modal">
    <!-- Modal content -->
    <div class="modal-content">
      <div class="modal-header">
        <span id="close">&times;</span>
        <h2>Modal Header</h2>
      </div>
      <div class="modal-body">
        <form method="post" id="deleteForm">
            @csrf
            <input type="hidden" id="deleteId" name="deleteId">
            <h1>Etes vous certain de supprimer ce produit?</h1>

        </form>

      </div>
      <div class="modal-footer">

        <button class="btn btn-danger bg-red-500 hover:bg-red-700 text-white" id="btnDelete">Delete</button>
        <button class="btn btn-secondary bg-gray-500 hover:bg-gray-700 text-white" id="btnCancel">Cancel</button>
      </div>
    </div>
  </div>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script>
    $("#btnCancel").on('click',function(){
        $("#myModal").hide();
    });

    $("#btnDelete").on('click',function(){
        var formData = $('#deleteForm').serialize(); // Serialize form data
        axios.post('{{ route("products.delete") }}', formData)
            .then(function (response) {
               if(response.data=="ok")
               {
              //  alert( $("#row"+response.data.deleteId).html());
                $("#row"+$("#deleteId").val()).remove();
               }
            })
            .catch(function (error) {
                console.error(error);
            });

        $("#myModal").hide();
    });
  </script>
