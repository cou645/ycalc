Super Simple Calculator or ycalc ... y for yad frontend.

SSC has four memory insert buttons. These are assigned the last four results in reverse order when M+ is pressed. There is a history file ~/.ycalc.history
in which sums and results are stored line by line. The last 4 lines are used for the memory buttons. The last result goes into M1 etc.

The gui has a Clr button which removes the history file.
Del is a backspace. After completing a calculation with '=' the formula is intact. If you want to continue editing it just use an operator '+'
or whatever, or Del to remove the last entry. Enter a new number and press '=' button.

For sin cos atan log and sqrt, press the relevant button first then the number to operate on, including floating point.

Modulo with bc takes scale=0, meaning no floating point. So better not string operations together wwith modulo, unless whole numbers only.
Just calculate modulo and M+ results for use in further operations.

I hope someone enjoys using it.
![Image](https://github.com/user-attachments/assets/c5ee84f5-ecaf-4d1e-8c25-ab2a0eba0b9c)
