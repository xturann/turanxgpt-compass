window.addEventListener('message', function(event) {
    const data = event.data;

    const compass = document.getElementById('compass');
    if (data.show) {
        compass.style.display = "flex";
        if (data.direction) {
            document.getElementById('direction').textContent = data.direction;
        }
        if (data.street) {
            document.getElementById('street').textContent = data.street;
        }
        if (data.zone) {
            document.getElementById('zone').textContent = data.zone;
        }
    } else {
        compass.style.display = "none";
    }
});
