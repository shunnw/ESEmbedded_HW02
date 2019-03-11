HW02
===
This is the hw02 sample. Please follow the steps below.

# Build the Sample Program

1. Fork this repo to your own github account.

2. Clone the repo that you just forked.

3. Under the hw02 dir, use:

	* `make` to build.

	* `make clean` to clean the ouput files.

4. Extract `gnu-mcu-eclipse-qemu.zip` into hw02 dir. Under the path of hw02, start emulation with `make qemu`.

	See [Lecture 02 ─ Emulation with QEMU] for more details.

5. The sample is designed to help you to distinguish the main difference between the `b` and the `bl` instructions.  

	See [ESEmbedded_HW02_Example] for knowing how to do the observation and how to use markdown for taking notes.

# Build Your Own Program

1. Edit main.s.

2. Make and run like the steps above.

# HW02 Requirements

1. Please modify main.s to observe the `push` and the `pop` instructions:  

	Does the order of the registers in the `push` and the `pop` instructions affect the excution results?  

	For example, will `push {r0, r1, r2}` and `push {r2, r0, r1}` act in the same way?  
v
	Which register will be pushed into the stack first?

2. You have to state how you designed the observation (code), and how you performed it.  

	Just like how [ESEmbedded_HW02_Example] did.

3. If there are any official data that define the rules, you can also use them as references.

4. Push your repo to your github. (Use .gitignore to exclude the output files like object files or executable files and the qemu bin folder)

[Lecture 02 ─ Emulation with QEMU]: http://www.nc.es.ncku.edu.tw/course/embedded/02/#Emulation-with-QEMU
[ESEmbedded_HW02_Example]: https://github.com/vwxyzjimmy/ESEmbedded_HW02_Example

--------------------

- [ ] **If you volunteer to give the presentation next week, check this.**

--------------------

# 1. 實驗題目

觀察`{r0,r1,r2,r3}`和`push{r2,r0,r3,r1}`兩者之差異


# 2. 實驗步驟

1.先將資料夾 gnu-mcu-eclipse-qemu 完整複製到 ESEmbedded_HW02 資料夾中

2.根據[ARM Architecture Reference Manual Thumb-2 Supplement](http://www.nc.es.ncku.edu.tw/course/embedded/pdf/Thumb2.pdf)敘述知道順序並無差異
  + 4.6.98 `POP`
  	+ The registers are loaded in sequence, the lowest-numbered register from the lowest memory address, through to the highest-numbered register from the highest memory address.
  
  + 4.6.99 `PUSH`
  	+ The registers are stored in sequence, the lowest-numbered register to the lowest memory address, through to the highest-numbered register to the highest memory address.
	
3.設計測試程式 main.s ，從 _start 開始後先在r0,r1,r2,r3中分別填入100,101,102,103的值，執行`push {r0, r1, r2, r3}`與`pop {r2}`，再執行`push{r2,r0,r3,r1}`和`pop {r1, r2}`


# main.s

```
_start:
	//
	//mov # to reg
	//
	movs	r0,	#100
	movs	r1,	#101
	mov	r2,	#102
	movw	r3,	#103

	//
	//push
	//
	push	{r0,r1,r2,r3}

	//
	//pop
	//
	pop	{r2}

	//
        //push
        //
        push    {r2,r0,r3,r1}

	//
        //pop
        //
        pop     {r1,r2}

label01:
	nop

	//
	//branch w/ link
	//
	bl	sleep

sleep:
	nop
	b	.
```

4. 將 main.s 編譯並以 qemu 模擬， `$ make clean`, `$ make`, `$ make qemu` 開啟另一 Terminal 連線 `$ arm-none-eabi-gdb` ，再輸入 `target remote localhost:1234` 連接，輸入兩次的 ctrl + x 再輸入 2, 開啟 Register 以及指令，並且輸入 `si` 單步執行觀察。

5. 將#100,#101,#102,#103 分別存入r0,r1,r2,r3，接著執行`push {r0, r1, r2, r3}`，sp由`0x20000100`變為`0x200000f0`。
![](https://raw.githubusercontent.com/shunnw/ESEmbedded_HW02/master/img/2019-03-11%2019-26-39%20%E7%9A%84%E8%9E%A2%E5%B9%95%E6%93%B7%E5%9C%96.png)

6.執行`pop {r2}`，sp由`0x200000f0`變為`0x200000f4`，此時r0被放入r2。
![](https://raw.githubusercontent.com/shunnw/ESEmbedded_HW02/master/img/2019-03-11%2019-26-57%20%E7%9A%84%E8%9E%A2%E5%B9%95%E6%93%B7%E5%9C%96.png)

7.發現程式碼內原本的`push{r2, r0, r3, r1}`，變成了`push {r0, r1, r2, r3}`，而執行後sp由`0x200000f4`變為`0x200000ef`。
![](https://raw.githubusercontent.com/shunnw/ESEmbedded_HW02/master/img/2019-03-11%2019-27-08%20%E7%9A%84%E8%9E%A2%E5%B9%95%E6%93%B7%E5%9C%96.png)

8.執行`pop {r1, r2}`，sp由`0x200000ef`變為`0x200000ec`，此時r1和r2分別被放入r2和r1。
![](https://raw.githubusercontent.com/shunnw/ESEmbedded_HW02/master/img/2019-03-11%2019-27-14%20%E7%9A%84%E8%9E%A2%E5%B9%95%E6%93%B7%E5%9C%96.png)

# 3. 結果與討論
1.暫存器的順序對`pop`和`push`的順序並無影響。

2.`push`會將值由上往下堆疊入暫存器，而`pop`則是由下往上讀取，因此後存入暫存器的值會先被取出。
