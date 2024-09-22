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
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Red

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
extern double kValue = 0.7;
double Upper[],Lower[];
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0, Upper);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexLabel(0, "Upper");

   SetIndexBuffer(1, Lower);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexLabel(1, "Lower");
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
      int prev_day_index = i+1;
      Upper[i] = iOpen(NULL,PERIOD_D1,i) + iATR(NULL,PERIOD_D1,14,prev_day_index)*kValue;
      Lower[i] = iOpen(NULL,PERIOD_D1,i) - iATR(NULL,PERIOD_D1,14,prev_day_index)*kValue;
     }


   return(rates_total);
  }
//+------------------------------------------------------------------+
