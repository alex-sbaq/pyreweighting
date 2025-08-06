#!/bin/bash
# Minimal reproducer for PyReweighting grid resolution bug
# 
# BUG: Dihedral-only boosting produces flat PMF with fine grids
# EXPECTED: PMF should have energy variation regardless of grid resolution

echo "PyReweighting Grid Resolution Bug Test"
echo "====================================="
echo ""

echo "Test 1: Coarse grid (should work)"
python ../../PyReweighting-2D.py -input cv_input_pc1_pc2.dat -job amdweight_CE -T 298.15 -Xdim -300 150 -Ydim -250 200 -discX 20.0 -discY 20.0 -weight weight_input_pc1_pc2.dat

if [ -f "pmf-c1-cv_input_pc1_pc2.dat.xvg" ]; then
    UNIQUE_COARSE=$(awk 'NR>5 && !/^#/ && !/^@/ {print $3}' pmf-c1-cv_input_pc1_pc2.dat.xvg | sort | uniq | wc -l)
    echo "Coarse grid unique PMF values: $UNIQUE_COARSE"
    mv pmf-c1-cv_input_pc1_pc2.dat.xvg pmf_coarse.xvg
fi

echo ""
echo "Test 2: Fine grid (BUG - produces flat PMF)"
python ../../PyReweighting-2D.py -input cv_input_pc1_pc2.dat -job amdweight_CE -T 298.15 -Xdim -300 150 -Ydim -250 200 -discX 5.0 -discY 5.0 -weight weight_input_pc1_pc2.dat

if [ -f "pmf-c1-cv_input_pc1_pc2.dat.xvg" ]; then
    UNIQUE_FINE=$(awk 'NR>5 && !/^#/ && !/^@/ {print $3}' pmf-c1-cv_input_pc1_pc2.dat.xvg | sort | uniq | wc -l)
    echo "Fine grid unique PMF values: $UNIQUE_FINE"
    mv pmf-c1-cv_input_pc1_pc2.dat.xvg pmf_fine.xvg
fi

echo ""
echo "SUMMARY:"
echo "  Coarse grid (discX=20): $UNIQUE_COARSE unique PMF values"
echo "  Fine grid (discX=5): $UNIQUE_FINE unique PMF values"
echo ""
if [ "$UNIQUE_FINE" -le "2" ] && [ "$UNIQUE_COARSE" -gt "2" ]; then
    echo "BUG CONFIRMED: Fine grid produces flat PMF"
    echo "Expected: Both should have multiple unique PMF values"
else
    echo "Bug not reproduced - check PyReweighting version"
fi
