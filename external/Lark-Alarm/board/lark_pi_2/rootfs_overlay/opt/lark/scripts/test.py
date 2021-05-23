import RPi.GPIO as GPIO

try:
    import RPi.GPIO as GPIO
except RuntimeError:
    print("Error importing RPi.GPIO!  This is probably because you need superuser privileges.")


GPIO.setmode(GPIO.BOARD)


class Button:
        def __init__(self, name, gpio):
                self.name = name
                self.gpio = gpio

                # Set the GPIO as input
                GPIO.setup(self.gpio, GPIO.IN, GPIO.PUD_UP)

        def get_state(self):
                return GPIO.input(self.gpio)

# Create some buttons
button1 = Button('One', 31)
button2 = Button('Two', 33)

# Display current inputs
print('Button:{0} Input is:{1}'.format(button1.name, button1.get_state()))

GPIO.wait_for_edge(31, GPIO.BOTH)
print("Button 31 pressed.\n")



