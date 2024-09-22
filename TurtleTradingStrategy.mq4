//+------------------------------------------------------------------+
//|                                                         Yq_8.mq4 |
//|                                                          Yung Qi |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "yqyqyq01@gmail.com"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
enum LotTypes
  {
   Fixed,         //Fixed
   LotB,          //Risk based Balance
   LotE           //Risk based Equity
  };

enum EfessType
  {
   Grey,
   Color,
  };
enum TradeMode
  {
   A,
   B
  };
int BuyticketID;
int SellticketID;
input int MagicNum = 1119;
int totalorder;
bool  Buying;
bool  Selling;
input int Stoploss = 0;
input int TakeProfit = 0;
input LotTypes LotType      = Fixed;     // Lot type:
input double  FixedLot      = 0.1;       // Fixed Lot
input double  RiskB         = 5.0;       // Risk based Balance
input double  RiskE         = 5.0;       // Risk based Equity
input bool    LossMartin    = false;     // Use Martingale on Loss trades
input double  MultLot       = 2.0;       // Lot Multiplier
input bool reverse = false;
input int lotCounter = 4;
extern string I_6  = "----------------------- 'Turtle Trading' indicator settings --------------------------"; //.
input int period = 20;
input int periodTPSL = 10;
input ENUM_TIMEFRAMES periodTF = PERIOD_D1;
input int emaperiod = 55;
double pivot;
int LotDigits;
double MyPoint;
int count = 0;
datetime open = iTime(NULL,0,1);
datetime openP;
datetime openC;
int OnInit()
  {
//---
   if(MarketInfo(Symbol(), MODE_LOTSTEP)==0.001)
      LotDigits=3;
   if(MarketInfo(Symbol(), MODE_LOTSTEP)==0.01)
      LotDigits=2;
   if(MarketInfo(Symbol(), MODE_LOTSTEP)==0.1)
      LotDigits=1;
   if(MarketInfo(Symbol(), MODE_LOTSTEP)==1)
      LotDigits=0;
//3-5 digits broker
   if(Digits==3 ||  Digits==5)
      MyPoint=Point*10;
   else
      MyPoint=Point;
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   totalorder = Caltotal();

   if(open != iTime(NULL,0,1))
     {
      open = iTime(NULL,0,1);
     }

   if(totalorder < 1 && (open != openP || (BuyticketID == -1 || SellticketID == -1)))
     {
      SellticketID = 0;
      BuyticketID = 0;
      bool BuyO;
      bool SellO;
      if(!reverse)
        {
         BuyO = (BuyTrend());
         SellO = (SellTrend());
        }
      else
        {
         BuyO = (SellTrend());
         SellO = (BuyTrend());
        }

      if(BuyO)
        {
         double Price=NormalizeDouble(Ask,Digits);
         double SL=0;
         double TP=0;
         if(Stoploss > 0)
            SL=NormalizeDouble(Price-Stoploss*MyPoint,Digits);
         if(TakeProfit > 0)
            TP=NormalizeDouble(Price+TakeProfit*MyPoint,Digits);
         double MyLot;
         if(Stoploss==0)
            MyLot=CalcLot(OP_BUY,0);
         else
            MyLot=CalcLot(OP_BUY,(Price-SL)/Point);
         RefreshRates();
         BuyticketID = OrderSend(NULL,0,MyLot,Ask,20,SL,TP,"YqRobot",MagicNum);
         if(BuyticketID == -1)
            Alert("Order Open Error:" + IntegerToString(GetLastError()));
        }
      else
         if(SellO)
           {
            double Price=NormalizeDouble(Bid,Digits);
            double SL=0;
            double TP=0;
            if(Stoploss > 0)
               SL=NormalizeDouble(Price+Stoploss*MyPoint,Digits);
            if(TakeProfit > 0)
               TP=NormalizeDouble(Price-TakeProfit*MyPoint,Digits);
            double MyLot;
            if(Stoploss==0)
               MyLot=CalcLot(OP_SELL,0);
            else
               MyLot=CalcLot(OP_SELL, (SL-Price)/Point);
            RefreshRates();
            SellticketID = OrderSend(NULL,1,MyLot,Bid,20,SL,TP,"YqRobot",MagicNum);
            if(SellticketID == -1)
               Alert("Order Open Error:" + IntegerToString(GetLastError()));
           }
      openP = open;
     }
   if(totalorder >= 1)
     {
      if(BuyticketID > 0)
        {
         bool closeTrade;
         if(!reverse)
            closeTrade = closeBuy();
         else
            closeTrade = closeSell();
         if(closeTrade)
           {
            double Lotsize = CalL();
            RefreshRates();
            bool closed = OrderClose(BuyticketID,Lotsize,Bid,2);
            if(!closed)
               Alert("Order Close Error:" + IntegerToString(GetLastError()));
            BuyticketID = 0;
           }
        }
      if(SellticketID > 0)
        {
         bool closeTrade;
         if(!reverse)
            closeTrade = closeSell();
         else
            closeTrade = closeBuy();
         if(closeTrade)
           {
            double Lotsize = CalL();
            RefreshRates();
            bool closed = OrderClose(SellticketID,Lotsize,Ask,20);
            if(!closed)
               Alert("Order Close Error:" + IntegerToString(GetLastError()));
            SellticketID = 0;
           }
        }
      openC = open;
     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
bool closeBuy()
  {
   bool retVal = false;
   if(Close[1] < Turtle(3,1))
      retVal = true;
   return retVal;
  }
//+------------------------------------------------------------------+
bool closeSell()
  {
   bool retVal = false;
   if(Close[1] > Turtle(2,1))
      retVal = true;
   return retVal;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Caltotal()
  {
   int caltotalorder = 0;
   for(int i = 0; i < OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS) == true)
        {
         if(OrderMagicNumber() == MagicNum)
           {
            caltotalorder ++;
           }
        }
     }
   return caltotalorder;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
bool BuyTrend()
  {
   bool retVal = false;
   if(Close[1] > Turtle(0,1) && Close[1] > iMA(NULL,periodTF,emaperiod,0,MODE_EMA,PRICE_CLOSE,1))
      retVal = true;
   return retVal;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SellTrend()
  {
   bool retVal = false;
   if(Close[1] < Turtle(1,1) && Close[1] < iMA(NULL,periodTF,emaperiod,0,MODE_EMA,PRICE_CLOSE,1))
      retVal = true;
   return retVal;
  }
//+------------------------------------------------------------------+
double CalcLot(int TypeOrder, double Stop)
  {
   double MyLot=FixedLot;
   double PrevLot = 0;
   double REQUIRED = MarketInfo(Symbol(),MODE_MARGINREQUIRED);
   if(LotType == LotB)
     {
      if(RiskB>0.0 && Stop>0.0)
         MyLot =  AccountBalance() * RiskB/100/ Stop;
      if(RiskB>0.0 && Stop==0.0)
         MyLot =  AccountBalance()/REQUIRED*RiskB/100;
     }
   else
      if(LotType == LotE)
        {
         if(RiskE>0.0 && Stop>0.0)
            MyLot =  AccountEquity() * RiskE/100/ Stop;
         if(RiskE>0.0 && Stop==0.0)
            MyLot =  AccountEquity()/REQUIRED*RiskE/100;
        }
   if(LossMartin)
     {
      for(int i = OrdersHistoryTotal()-1; i >= 0; i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
           {
            if(OrderMagicNumber() == MagicNum)
              {
               if(OrderProfit() <= 0)
                 {
                  PrevLot = OrderLots();
                  count += 1;
                 }
               else
                 {
                  count = 0;
                 }
               break;
              }
           }
        }
      if(MultLot>0.0)
        {
         if(PrevLot>0.0)
           {
            if((count <= lotCounter) || (lotCounter == 0))
              {
               MyLot =  PrevLot * MultLot;
              }
            else
              {
               count = 0;
               MyLot = FixedLot;
              }
           }
        }
     }

   double MinLot = MarketInfo(Symbol(),MODE_MINLOT);
   double MaxLot = MarketInfo(Symbol(),MODE_MAXLOT);

   if(MyLot<MinLot)
      MyLot=MinLot;
   if(MyLot>MaxLot)
      MyLot=MaxLot;

   return(NormalizeDouble(MyLot, LotDigits));

  }
//+------------------------------------------------------------------+
double CalL()
  {
   double Lotsize = 0;
   for(int i = 0; i < OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS) == true)
        {
         if(OrderMagicNumber() == MagicNum)
           {
            Lotsize = OrderLots();
            break;
           }
        }
     }
   return Lotsize;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Turtle(int Buffer,int Shift)
  {
   double retVal = iCustom(NULL,0,"TurtleTrading",period,periodTPSL,periodTF,Buffer,Shift);
   return retVal;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
