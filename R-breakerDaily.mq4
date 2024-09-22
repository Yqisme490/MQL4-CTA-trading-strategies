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
#property indicator_buffers 7
#property indicator_color1 Red
#property indicator_color2 Blue
#property indicator_color3 Yellow
#property indicator_color4 Yellow
#property indicator_color5 Blue
#property indicator_color6 Red
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
double Btbuying[],Obselling[], Rvselling[], Rvbuying[], Obbuying[], Btselling[], Pivot[];
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0, Btbuying);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexLabel(0, "Btbuying");

   SetIndexBuffer(1, Obselling);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexLabel(1, "Obselling");

   SetIndexBuffer(2, Rvselling);
   SetIndexStyle(2, DRAW_LINE);
   SetIndexLabel(2, "Rvselling");

   SetIndexBuffer(3, Rvbuying);
   SetIndexStyle(3, DRAW_LINE);
   SetIndexLabel(3, "Rvbuying");

   SetIndexBuffer(4, Obbuying);
   SetIndexStyle(4, DRAW_LINE);
   SetIndexLabel(4, "Obbuying");

   SetIndexBuffer(5, Btselling);
   SetIndexStyle(5, DRAW_LINE);
   SetIndexLabel(5, "Btselling");

   SetIndexBuffer(6, Pivot);
   SetIndexLabel(6, "Pivot");
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
      double HighP = iHigh(NULL,PERIOD_D1,prev_day_index);
      double LowP = iLow(NULL,PERIOD_D1,prev_day_index);
      double CloseP = iClose(NULL,PERIOD_D1,prev_day_index);
      Pivot[i] = (HighP + CloseP + LowP)/3;
      Btbuying[i] = HighP + 2*(Pivot[i] - LowP);
      Obselling[i] = Pivot[i] + (HighP - LowP);
      Rvselling[i] = 2*Pivot[i] - LowP;
      Rvbuying[i] = 2*Pivot[i] - HighP;
      Obbuying[i] = Pivot[i] - (HighP - LowP);
      Btselling[i] = LowP - 2*(HighP - Pivot[i]);
     }


   return(rates_total);
  }
//+------------------------------------------------------------------+
