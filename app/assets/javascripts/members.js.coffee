# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('[data-toggle="tooltip"]').tooltip(placement: 'right')

  $('.datepicker').datepicker
    format: 'dd/mm/yyyy',

  $('select#member_university_name').on 'change', (e) =>
    parentElement = $('#member_university_name_other').parents('.control-group')
    parentElement.hide()
    if e.target.value == 'Other (please specify)'
      parentElement.show()
      parentElement.find('input').focus()

  $('select#member_university_qualification').on 'change', (e) =>
    parentElement = $('#member_university_qualification_other').parents('.control-group')
    parentElement.hide()
    if e.target.value == 'Other (please specify)'
      parentElement.show()
      parentElement.find('input').focus()

