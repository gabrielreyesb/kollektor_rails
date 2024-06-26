// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "bootstrap";

$(document).ready(function() {
    $('#genreModal').on('show.bs.modal', function (event) {
      var button = $(event.relatedTarget); // Button that triggered the modal
      var action = button.data('action'); // Extract action from data attribute
      
      $.get('/genres/' + action, function(data) {
        $('.modal-content').html(data); // Replace modal content
      });
    });
  });