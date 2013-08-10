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
					Console.WriteLine("\t" + isum.ToString("f2"));
				}
				else
				{
					double ival = Convert.ToDouble(line);
					if (ival > 0) isum += ival;
				}
			}

			Console.WriteLine("  ====\t" + isum.ToString("f2"));
		}
	}
}
