<Query Kind="Statements">
  <Output>DataGrids</Output>
</Query>

for (int i=29; i>= 0; i--) {
	Console.WriteLine($"\t\treg52_{i}_inst: reg52 port map(");
	Console.WriteLine($"\t\t\t\treg52_in => current_reg_output({i+1}),");
	Console.WriteLine("\t\t\t\treg52_clock => rc_clock,");
	Console.WriteLine("\t\t\t\treg52_reset => rc_reset,");
	Console.WriteLine($"\t\t\t\treg52_write_enable => rc_write_enable({i}),");
	Console.WriteLine($"\t\t\t\treg52_out => current_reg_output({i})");
	Console.WriteLine("\t\t);");
	Console.WriteLine();
};