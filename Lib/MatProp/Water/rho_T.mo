within Lib.MatProp.Water;

block rho_T = Modelica.Blocks.Tables.CombiTable1D(table = [0, 999.84; 10, 999.7; 20, 998.21; 30, 995.65; 40, 992.22; 50, 988.05; 60, 983.21; 70, 977.78; 80, 971.8; 90, 965.32; 99.61, 958.64], smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative);