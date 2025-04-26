Super Simple Calculator or ycalc ... y for yad frontend.

ycalc.sh has two modes, basic and scientific.

supply arguments as follows on startup
  'exec ycalc.sh simp' or 'exec ycalc.sh vance'

SSC has four memory insert buttons. Press M+ button to open a yad gui to select per button values, either from history or pasted or typed.

The gui has a Clr button which removes the history file.
Del is a backspace. After completing a calculation with '=' the formula is intact. If you want to continue editing it just use an operator '+'
or whatever, or Del to remove the last entry. Enter a new number and press '=' button.

For sin cos atan log and sqrt, press the relevant button first then the number to operate on, including floating point.

Modulo with bc takes scale=0, meaning no floating point. So better not string operations together with modulo, unless whole numbers only.
Just calculate modulo and M+ results for use in further operations.

I hope someone enjoys using it.
![Image](https://github.com/user-attachments/assets/baf53444-3665-4b42-8d23-96995aaf9f1b)
