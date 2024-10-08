//+------------------------------------------------------------------+
//|                                                    R-breaker.mq4 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Blue
#property indicator_color2 Blue
#property indicator_color3 Red
#property indicator_color4 Red

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
input int period = 20;
input int periodTPSL = 10;
input ENUM_TIMEFRAMES periodTF = PERIOD_D1;
double Upper[],Lower[],UpperSTOP[],LowerSTOP[];
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0, Upper);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexLabel(0, "Upper");

   SetIndexBuffer(1, Lower);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexLabel(1, "Lower");

   SetIndexBuffer(2, UpperSTOP);
   SetIndexStyle(2, DRAW_LINE);
   SetIndexLabel(2, "UpperSTOP");

   SetIndexBuffer(3, LowerSTOP);
   SetIndexStyle(3, DRAW_LINE);
   SetIndexLabel(3, "LowerSTOP");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   int limit = rates_total - prev_calculated;

   if(prev_calculated > 0)
      limit++;


   for(int i = 0; i < limit; i++)
     {
      int prev_day_index = iBarShift(NULL, periodTF, Time[i], false)+1; 
      Upper[i] = iHigh(NULL,periodTF,iHighest(NULL,periodTF,MODE_HIGH,period,prev_day_index));
      Lower[i] = iLow(NULL,periodTF,iLowest(NULL,periodTF,MODE_LOW,period,prev_day_index));
      UpperSTOP[i] = iHigh(NULL,periodTF,iHighest(NULL,periodTF,MODE_HIGH,periodTPSL,prev_day_index));
      LowerSTOP[i] = iLow(NULL,periodTF,iLowest(NULL,periodTF,MODE_LOW,periodTPSL,prev_day_index));
     }


   return(rates_total);
  }
//+------------------------------------------------------------------+
