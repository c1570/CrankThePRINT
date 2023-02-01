#!/bin/bash

set -o errexit

echo "Crank the PRINT defaults:"
echo "Main string table at E000, secondary tables A000 and C800"
echo "cranktheprint output file: output.prg"
echo "ASM helper start address: CE00"
echo "If you want to change that, edit the code. :)"
petcat -w2 -o tests.prg tests.txt
xa -o ctp_asm.prg ctp_asm.a65 || echo "xa not found, using default helper"
python3 cranktheprint tests.prg && mv output.prg tests_cranked.prg && petcat tests_cranked.prg
exomizer sfx basic -o tests_exomized.prg tests_cranked.prg table_a000.prg ctp_asm.prg table_c800.prg table_e000.prg
echo -e "\n\nRun the example using"
echo "# x64 tests_exomized.prg"
