#include <iostream>

using namespace std;

  extern "C" 
  {
      void ir2_(int*,int *);
      int  if3_(int *);
      
      void    dr2_(double*,double *);
      double  df3_(double *);
  }

  int main()
  {
      cout << "INT" << endl;

      int n = 10;
      int n2 = 0;
      int n3 = 0;
	
      ir2_(&n,&n2);
      cout << n << "^2 = " << n2 << endl;

      n3 = if3_(&n);	
      cout << n << "^3 = " << n3 << endl;
      
      cout << "DOUBLE" << endl;

      double d  = 4.4;
      double d2 = 0;
      double d3 = 0;
	
      dr2_(&d,&d2);
      cout << d << "^2 = " << d2 << endl;

      d3 = df3_(&d);	
      cout << d << "^3 = " << d3 << endl;
      
      return 0;
  }

