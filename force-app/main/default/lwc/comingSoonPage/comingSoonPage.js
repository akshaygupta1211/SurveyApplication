import { LightningElement, track } from 'lwc';

export default class ComingSoonPage extends LightningElement {
    @track timeLeft = "0d 0h 0m 0s";

    x = setInterval(() => {
        var countDownDate = new Date("Jan 5, 2023 15:37:25").getTime();
        // Get today's date and time
        var now = new Date().getTime();
        // Find the distance between now and the count down date
        var distance = countDownDate - now;
        // Time calculations for days, hours, minutes and seconds
        var days = Math.floor(distance / (1000 * 60 * 60 * 24));
        var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
        var seconds = Math.floor((distance % (1000 * 60)) / 1000);
          // Output the result in an element with id="demo"
        this.timeLeft = days + "d " + hours + "h "
        + minutes + "m " + seconds + "s ";
            
        // If the count down is over, write some text 
        if (distance < 0) {
            clearInterval(x);
            this.timeLeft  = "EXPIRED";
        }
    }, 1000);
}