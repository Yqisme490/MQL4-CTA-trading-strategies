# CTA Trading Strategies in MQL4

**Objective**

This repository contains several Commodity Trading Advisor (CTA) strategies implemented in MQL4 for MetaTrader 4. These strategies are focused on capturing market trends, breakouts, and reversals using well-known technical indicators.

**Included Strategies:**

* **ATR Breakout Strategy:** This strategy sets dynamic upper and lower breakout levels based on the Average True Range (ATR) and the previous day’s opening price. A kValue is a multiplier that adjusts the sensitivity to market volatility, allowing traders to customize breakout points. When the price breaks above the Upper level, it signals a long position; breaking below the Lower level signals a short position.

* **R-Breaker Strategy:** A trend-following and reversal strategy that defines specific breakout and reversal levels based on the previous day’s price data. It captures both breakouts and counter-trend opportunities.

* **Dual Thrust Strategy:** A simple yet effective breakout system using the previous day’s high-low range to set buy and sell thresholds. This allows traders to capitalize on significant market moves.

* **Turtle Trading Strategy:** A classic trend-following strategy that enters long positions on price breakouts above a certain threshold and short positions on breakouts below, aiming to capture extended trends in the market.

**Features:**
* MQL4 code designed for MetaTrader 4 platform.
* Customizable breakout thresholds and parameters for each strategy.
* ATR-based dynamic breakout levels.
* Tested across multiple market conditions for trend-following and breakout strategies.

**Author:** Chin Yung Qi






