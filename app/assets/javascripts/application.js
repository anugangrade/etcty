// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-datepicker
//= require jquery.tokeninput
//= require underscore
//= require gmaps/google
//= require social-share-button
//= require bootstrap-colorpicker
//= require_tree .


$(document).ready(function(){
	$('.colorpicker').colorpicker()

	$('.datepicker_main').datepicker({
	  startDate: new Date(),
	  format: "yyyy-mm-dd"
	});

	$(".country_select_header").change(function(){
		$.ajax({
			type: "get",
			url: "/session/change_country",
			data: {country_code: this.value},
			success: function(data){
				window.location = data.url
			}
		})
	})
	$(document).on('click','.print_me',function(){
		var id = this.id.replace("print_", "")
		var divToPrint = $("#image_"+id)[0];
   	var popupWin = window.open('', '_blank', 'width=600,height=600');
    popupWin.document.open();
    popupWin.document.write('<html><body onload="window.print()"><img src='+ $(divToPrint).attr("src") +' style="height: 97%; width: 100%"></html>');
    popupWin.document.close();	
	})

   $(".social-share-button").addClass("pull-right")

   $(document).on('change',"input[name='template[no_of_images]']",function(){
      id = this.id.split("_")[4]
      if(id == "1"){
        $("#template_image_"+id).show()
        $("#template_image_"+(parseInt(id)+1)).hide()
        $("#template_image_"+(parseInt(id)+2)).hide()
      }
      else if(id == "2"){
        $("#template_image_"+(parseInt(id)-1)).show()
        $("#template_image_"+id).show()
        $("#template_image_"+(parseInt(id)+1)).hide()
      }
      else if(id == "3"){
        $(".template_images").show()
      }
      else{
        $(".template_images").hide()
      }
    })

})