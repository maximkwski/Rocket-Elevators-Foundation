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
                    document.getElementById("batteries").style.display = "";
                    choose_battery.addEventListener("change", (e) => {
                        if(e.target.value) {
                            document.getElementById("columns").style.display = "";
                            choose_column.addEventListener("change", (e) => {
                                if(e.target.value) {
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
                for(building in result) {
                    $('#intervention_building_id').append(`<option value="${result[building].id}"> ${result[building].address} </option>`);
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