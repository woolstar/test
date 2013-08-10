using System;

namespace AddingMachine
{
	class Program
	{
		static void Main(string[] args)
		{
			double isum = 0;
			string line ;

			while ( null != ( line = Console.ReadLine()) )
			{
				if (String.IsNullOrWhiteSpace(line))
				{
					Console.WriteLine("\t{0:f2}", isum);
				}
				else
				{
					try
					{
						double ival = Convert.ToDouble(line);
						if (ival > 0) isum += ival;
					}
					catch (Exception ex) { /* not a number */ }
				}
			}

			Console.WriteLine("  ====\t{0:f2}", isum);
		}
	}
}

