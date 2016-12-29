function floors_interaction(floor_id)
{
    var floors = document.getElementsByClassName('floor');
    console.log(floors);
    [].forEach.call(floors, function(floor) {
       if(floor.id == floor_id) {
           floor.style.display = 'inherit';
       }
        else {
           floor.style.display = 'none';
       }
    });
}
