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
double BtbuyingD[],ObsellingD[], RvsellingD[], RvbuyingD[], ObbuyingD[], BtsellingD[], PivotD[];
datetime TimeD[];
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
      
      int prev_day_index = iBarShift(NULL, PERIOD_D1, Time[i], false);

      Pivot[i] = iCustom(NULL,PERIOD_D1,"R-breakerDaily",6,prev_day_index);
      Btbuying[i] = iCustom(NULL,PERIOD_D1,"R-breakerDaily",0,prev_day_index);
      Obselling[i] = iCustom(NULL,PERIOD_D1,"R-breakerDaily",1,prev_day_index);
      Rvselling[i] = iCustom(NULL,PERIOD_D1,"R-breakerDaily",2,prev_day_index);
      Rvbuying[i] = iCustom(NULL,PERIOD_D1,"R-breakerDaily",3,prev_day_index);
      Obbuying[i] = iCustom(NULL,PERIOD_D1,"R-breakerDaily",4,prev_day_index);
      Btselling[i] = iCustom(NULL,PERIOD_D1,"R-breakerDaily",5,prev_day_index);
     }


   return(rates_total);
  }
//+------------------------------------------------------------------+
