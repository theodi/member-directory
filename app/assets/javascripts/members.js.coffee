# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('[data-toggle="tooltip"]').tooltip(placement: 'right')

  $('select#member_origin').on 'change', (e) =>
    if e.target.value == ''
      $('.third-parties').hide()
    else
      $('.third-parties').show()

