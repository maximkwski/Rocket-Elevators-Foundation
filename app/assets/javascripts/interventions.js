document.addEventListener('DOMContentLoaded', function(e) {
    $(document).ready(function() {
        
    const choose_customer = document.getElementById("intervention_customer_id");
    const choose_building = document.getElementById("intervention_building_id");
    const choose_battery = document.getElementById("intervention_battery_id");
    const choose_column = document.getElementById("intervention_column_id");

    choose_customer.addEventListener("change", (e) => {
        if (e.target.value) {
        resetVal();
        hideAll();
        search_building();
        document.getElementById("buildings").style.display = "";

        choose_building.addEventListener("change", (e) => {
                if(e.target.value) {
                    search_battery();
                    document.getElementById("batteries").style.display = "";

                    choose_battery.addEventListener("change", (e) => {
                        if(e.target.value) {
                            search_column();
                            document.getElementById("columns").style.display = "";

                            choose_column.addEventListener("change", (e) => {
                                if(e.target.value) {
                                    search_elevator()
                                    document.getElementById("elevators").style.display = "";
                                }
                            })
                        }
                    })
                }


            })
        }
    }); 

    function search_building() {
             // Send the request and update buildings dropdown
             var id_value_string = $('#intervention_customer_id').val();
             $.ajax({
              type: "GET",
              dataType: "json",
              url: '/get_buildings_by_customer/'+ id_value_string, 
              data: {'id_value_string': id_value_string},
              success: function(result) {
                
                  $("#intervention_building_id").empty(); 
                  $('#intervention_building_id').append('<option selected="selected" value="">None</option>')
                  for(building in result) {
                    $('#intervention_building_id').append(`<option value="${result[building].id}"> ${result[building].address} </option>`);
                }
                console.log(result);
              }
             });
    }

    function search_battery() {
        // Send the request and update batteries dropdown
        var id_value_string = $('#intervention_building_id').val();
        $.ajax({
         type: "GET",
         dataType: "json",
         url: '/get_batteries_by_building/'+ id_value_string, 
         data: {'id_value_string': id_value_string},
         success: function(result) {
             $("#intervention_battery_id").empty(); 
             $('#intervention_battery_id').append('<option selected="selected" value="">None</option>')
           for(battery in result) {
               $('#intervention_battery_id').append(`<option value="${result[battery].id}"> ${result[battery].id} </option>`);
           }
           console.log(result);
         }
        });
    }

    function search_column() {
        // Send the request and update columns dropdown
        var id_value_string = $('#intervention_battery_id').val();
        $.ajax({
         type: "GET",
         dataType: "json",
         url: '/get_columns_by_battery/'+ id_value_string, 
         data: {'id_value_string': id_value_string},
         success: function(result) {
             $("#intervention_column_id").empty(); 
             $('#intervention_column_id').append('<option selected="selected" value="">None</option>')
           for(column in result) {
               $('#intervention_column_id').append(`<option value="${result[column].id}"> ${result[column].id} </option>`);
           }
           console.log(result);
         }
        });
    }

    function search_elevator() {
        // Send the request and update elevators dropdown
        var id_value_string = $('#intervention_column_id').val();
        $.ajax({
         type: "GET",
         dataType: "json",
         url: '/get_elevators_by_column/'+ id_value_string, 
         data: {'id_value_string': id_value_string},
         success: function(result) {
           
             $("#intervention_elevator_id").empty(); 
             $('#intervention_elevator_id').append('<option selected="selected" value="">None</option>')
           for(elevator in result) {
               $('#intervention_elevator_id').append(`<option value="${result[elevator].id}"> ${result[elevator].id} </option>`);
           }
           console.log(result);
         }
        });
    }


    
    function resetVal() {
        document.getElementById("intervention_building_id").value = "";
        document.getElementById("intervention_battery_id").value = "";
        document.getElementById("intervention_column_id").value = "";
        document.getElementById("intervention_elevator_id").value = "";
    }

    function hideAll() {
        document.getElementById("buildings").style.display = "none";
        document.getElementById("batteries").style.display = "none";
        document.getElementById("columns").style.display = "none";
        document.getElementById("elevators").style.display = "none";
    }    

})

})    