<Query Kind="Statements">
  <Output>DataGrids</Output>
</Query>

var lines = new List<string>();


for (int i=30; i>= 0; i--) {
	lines.Add($"\t\telsif (cpt_compare_result({i}) = '1') then");
	lines.Add($"\t\t\tcpt_first_value <= cpt_reg_output_address({i});");
}

System.IO.File.WriteAllLines(@"C:\Users\jiawe\Desktop\WriteLine.txt", lines);