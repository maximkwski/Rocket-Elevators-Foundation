document.addEventListener('DOMContentLoaded', function(e) {

    const choose_customer = document.getElementById("intervention_customer_id");
    const choose_building = document.getElementById("intervention_building_id");
    const choose_battery = document.getElementById("intervention_battery_id");
    const choose_column = document.getElementById("intervention_column_id");

    choose_customer.addEventListener("change", (e) => {
        if (e.target.value) {
        hideAll();
        // resetVal();
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
    
    function resetVal() {
        document.getElementById("buildings-input").value = "";
        document.getElementById("batteries-input").value = "";
        document.getElementById("columns-input").value = "";
        document.getElementById("elevators-input").value = "";
    }

    function hideAll() {
        document.getElementById("buildings").style.display = "none";
        document.getElementById("batteries").style.display = "none";
        document.getElementById("columns").style.display = "none";
        document.getElementById("elevators").style.display = "none";
    }    
})    