source ~/.bashrc
python2 autosva.py -f imuldiv/imuldiv-IntMulDivIterative.v -v -i imuldiv -x XPROP -tool jasper
python2 autosva.py -f imuldiv/imuldiv-IntMulIterative.v -v -i imuldiv -x XPROP -tool jasper
python2 autosva.py -f imuldiv/imuldiv-IntDivIterative.v -v -i imuldiv -x XPROP -tool jasper