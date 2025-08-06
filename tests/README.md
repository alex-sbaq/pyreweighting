# PyReweighting Tests

## Grid Resolution Fix Test

This test verifies the fix for fine discretization grids producing flat PMFs.

### Files:
- `cv_input_pc1_pc2.dat`: Test CV data (PC1, PC2)
- `weight_input_pc1_pc2.dat`: Test weight data (dihedral-only boosting)  
- `test_grid_resolution_bug.sh`: Test script

### Usage:
```bash
cd tests/grid_resolution_fix
./test_grid_resolution_bug.sh
```

### Expected Result:
Both coarse (20x20) and fine (5x5) grids should produce PMFs with multiple unique values, confirming the fix works.
