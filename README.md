## 介紹
這是利用FPGA模擬口罩販賣機，功能包含投入錢幣，選擇口罩數量、購買口罩、取消購買、賣出口罩、退錢。(所有過程皆為模擬，並無實體金幣或口罩)
## 內容 
用verilog寫，其中有運用clk、debounce、onepulse等function，完成後利用vivado將程式燒進FPGA板中，便能按下電路板上的button及switch，使電路板的七段顯示器和LED產生燈號。

## 實作
共有五個過程，Initial state、Deposit state、Amount state、Release state、Change state，詳細如下。
1. Initial state : 初始化階段，七段顯示器顯示0000，LED全暗燈，並進入Deposit state。
2. Deposit state : 投幣階段，客人可投入5元或10元，投入金額將顯示於七段顯示器的右邊兩顆燈，最多不可超過45元。投幣結束後，若按下確認，進入Amount state；若按下取消(退款)，則進入Change state。
3. Amount state : 選擇口罩數量階段，客人可選擇購買口罩的數量，且數量不可超投入金額 / 5(一片口罩5元)，選擇的口罩數量將顯示於七段顯示器的左邊兩顆燈。若按下確認，進入Amount state；若按下取(退款)，則進入Change state。
4. Release state : 購買成功階段，七段顯示器會出現MASK字樣，LED會持續閃爍5秒，代表賣出口罩。結束後進入Change state。
5. Change state : 退錢階段，若購買數量*5<投入金額，或取消購買，販賣機皆會從10元先退款，<10元時才會退5元，如25->15->5->0。結束後返回Inital state。

## 附件
附上code、詳細report及demo影片https://www.youtube.com/watch?v=F1P1whgtG1w&feature=youtu.be
