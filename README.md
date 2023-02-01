# Crank the PRINT!
https://github.com/c1570/CrankThePRINT

The C64's [PRINT](https://www.c64-wiki.com/wiki/PRINT) command is awfully slow.
For example, PRINTing a string constant of 39 characters to screen takes the PRINT routine ($AAA0-$AAE7) about 15,000 CPU cycles, which amounts to about 15ms,
so when filling the text screen (25 lines), the CPU spends almost 400ms just in the PRINT code.
BASIC compilers do not help much here since those still call the original PRINT code for compatibility reasons.

**Crank the PRINT** to the rescue!

CtP processes a C64 BASIC V2 PRG file, extracts PRINT constants, converts them to an own format,
and replaces PRINTs in the code by SYS commands that do the same thing the PRINTs did, but faster:
Printing those 39 characters mentioned above will take CtP about 1500 cycles².

The result is very compiler friendly, so do put CtP's result code through some BASIC compiler such as [Reblitz64](https://github.com/c1570/Reblitz64) for additional speed.

Impatient? Have a look at [run_tests.sh](run_tests.sh).

* CtP supports a simple PRINT AT variant (a very short SYS helper), too. See [tests.txt](tests.txt) to get an idea how it works.
* CtP tries to combine consecutive PRINT commands.
* CtP only supports constants as PRINT operands.
  * PRINT"HOW DO YOU DO" gets processed. PRINT"MY NAME IS "A$ gets ignored.
* CtP only supports relative positioning in PRINT constants: Cursor Up is fine but HOME or CLR/HOME makes CtP ignore that PRINT.
* CtP will happily put your constants below ROM. More space for your BASIC program.
  * You can configure several memory locations that CtP may use. See "buckets" in the source.
* Your program will have to take care about loading the SYS helper and data.
  * It's easiest just to use [Exomizer](https://bitbucket.org/magli143/exomizer/wiki/Home) to combine all parts into one packed PRG.
* Caveats
  * CtP handles reverse control characters but ignores the reverse flag.
    * PRINT"{RVON}";:A=0:PRINT"THIS SHOULD BE REVERSED" will break (the "A=0" is just there to prevent CtP from combining strings).
    * PRINT"{RVON}THIS IS REVERSED{RVOF}" will work just fine.
  * Long logical lines (>40 chars) are not supported.
  * Screen scrolling is not supported.
  * There's no range checking when writing to the screen. Printing outside screen space will corrupt memory.

As a bonus, CtP also generates an HTML document of the BASIC program with some automated formatting (blank lines before subroutines), highlighting of selected variables, backreferences per line, and clickable GOTO/GOSUB destinations.

² Going even faster would certainly be possible if sacrificing some compatibility, e.g., hardcoding screen mem or not caring about $D1/$D2.
