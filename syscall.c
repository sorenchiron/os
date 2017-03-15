asm(".code16 \n\t");
/***  INCLUDE AND DEFINE ***/
#define TRUE 1
#define FALSE 0
#define POOL_SIZE 2
#define TTY_ROWS 25
#define TTY_COLS 80
#define NULL 0
#define UNDEFINED 0
#define READY 1
#define RUNNING 2
#define PAUSED 3

/*** TYPE DEFINITION ***/
typedef unsigned short int uint16;
typedef unsigned int uint32;
typedef unsigned char byte;
typedef struct task_desc
{
	byte tid;
	byte state; // 1 running; 0 not running
	uint16 flags;
	uint16 cs;
	uint16 ip;
	uint32 stack_base_ebp;
	uint32 ebp;
	uint32 esp;
	uint32 eax;
	uint32 ebx;
	uint32 ecx;
	uint32 edx;
	uint32 esi;
	uint32 edi;
	void (* procedure)();
	uint32 bar;
	byte stack[128];
} TD;

/*** FUNCTION DECLARATION  ***/
void int08(void);
void roottask(void);
void task1(void);
void clear(void);
void setcursor(byte row,byte col);
int len(char *strp);
void dispchar(char c);
void s_dispchar(char c);
void print(char *p);
void sleep(int ms);
uint32 getesp(void);
void start_procedure(byte tid ,byte sti);
void new_task(void (*procedure)(), byte tid);
void switch_proc(void);
void s_setcursor(byte row, byte col);

/*** GLOBAL DATA DECLARATION ***/
TD pool[POOL_SIZE];
TD taskbuffer;
byte current_task=0;
byte tty_current_row=0;
byte tty_current_col=0;

/*** FUNCTION ***/
void main(void)
{
	asm("pushl %eax \n\t"
	"movw %cs,%ax \n\t"
	"movw %ax,%ds \n\t"
	"movw %ax,%es \n\t"
	"movw %ax,%fs \n\t"
	"movw %ax,%gs \n\t"
	"movw %bp,%di \n\t"
	"popl %eax \n\t"
	);
	setcursor(1,0);
	new_task(roottask,0);
	new_task(task1,1);
	start_procedure(0,FALSE);

}

void int08(void)
{
	asm("pushl %eax \n"
        "pushal \n"
        "movl %ebp,%eax \n"
        "addl $10,%eax \n"
        "movl %eax,12(%esp) \n" //old esp
        "movl (%ebp),%eax   \n" //get old ebp
        "movl %eax,8(%esp)  \n" //save old ebp
        "movw 8(%ebp),%ax   \n" //old flags
        "pushw $0x0         \n"
        "pushw %ax          \n"
        "movw 6(%ebp),%ax   \n" //old cs
        "pushw $0x0         \n"
        "pushw %ax          \n" //save cs
        "movw 4(%ebp),%ax   \n" //old ip
        "pushw $0x0         \n"
        "pushw %ax          \n" //save old ip		
        "calll _savecontext \n"
        "addl $44,%esp \n"
		"popl %eax \n"
		);
	switch_proc();
}

void start_procedure(byte tid ,byte sti)
{
	pool[tid].stack_base_ebp = getesp();
		// this is the start of stack space of that task.
		// later used to save all it's stack data
	pool[tid].state=RUNNING;
	current_task = tid;
	if(sti==TRUE)
	{
		asm("sti\n");
	}
	pool[tid].procedure();
}

void savecontext(uint16 ip,
uint16 cs,
uint16 flags,
uint32 edi,
uint32 esi,
uint32 ebp, // ebp when interrupted
uint32 esp, // esp when interrupted
uint32 ebx,
uint32 edx,
uint32 ecx,
uint32 eax)
{
	uint32 stack_usage=0 ;
	TD * t = &(pool[current_task]) ;
	byte * ss = t->stack;
	t->ip = ip ;
	t->cs = cs ;
	t->flags = flags ;
	t->edi = edi ;
	t->esi = esi ;
	t->ebp = ebp ;
	t->esp = esp ;
	t->ebx = ebx ;
	t->edx = edx ;
	t->ecx = ecx ;
	t->eax = eax ;
	
	stack_usage = (t->stack_base_ebp) - (t->esp);
	stack_usage+=3; //to save 4B data ahead-of task-ebp
	if(stack_usage>=128)
	{
		stack_usage=128;
	}
	asm("cld \n"
		"rep movsb \n"
		:
		:"c"(stack_usage),"S"(esp),"D"(ss)
		);
	
}

void switch_proc(void)
{
	if(pool[1].state==READY)
	{
		
		asm("pushl %eax \n"
			"movw $0,%ax \n"
			"pushw %ax \n"
			"popfw \n"
			"movb $0x20,%al \n"
			"outb %al,$0x20 \n"
			"popl %eax \n"
			);
		start_procedure(1,TRUE); // no return;
		
	}
	
	pool[current_task].state=PAUSED;
	if(current_task==0)
		current_task=1;
	else
		current_task=0;
	pool[current_task].state=RUNNING;
	
	
	TD * t = &(pool[current_task]);
	uint32 stack_usage = (t->stack_base_ebp) - (t->esp) + 3;
	byte * ss = t->stack;
	if(stack_usage>=128)
		stack_usage=128;

	asm("movw $0x00,-2(%%esi) \n" // ip
	    "movw %%ax,-4(%%esi) \n"  // ip
		"movw %%bx,-6(%%esi) \n" //flags
		"movl %%ecx,-10(%%esi) \n" //edi
		"movl %%edx,-14(%%esi) \n" //esi
		:
		:"S"(t->esp),"a"(t->ip),"b"(t->flags),"c"(t->edi),"d"(t->esi)
		);

	asm("movl %%eax,-18(%%esi) \n" //eax
		"movl %%ebx,-22(%%esi) \n" //ebx
		"movl %%ecx,-26(%%esi) \n" //ecx
		"movl %%edx,-30(%%esi) \n" //edx
		"movl %%esi,%%edx \n"      // save esp in edx
		:
		:"a"(t->eax),"b"(t->ebx),"c"(t->ecx),"d"(t->edx)
		);

	asm("\n"
		:
		:"b"(t->ebp)             // save ebp in ebx
		);
	// recover lower stack
	
	asm("cld \n"
		"rep movsb \n"
		:
		:"c"(stack_usage),"S"(ss),"D"(t->esp)
		);
	
	asm("movl %ebx,%ebp \n"
		"movl %edx,%esp \n"
		"movb $0x20,%al \n"
		"outb %al,$0x20 \n"
		"subl $30,%esp \n"
		"popl %edx \n"
		"popl %ecx \n"
		"popl %ebx \n"
		"popl %eax \n"
		"popl %esi \n"
		"popl %edi \n"
		"popfw \n"
		"sti \n"
		"retl \n"
		);
}

void new_task(void (*procedure)(), byte tid)
{
	pool[tid].procedure=procedure;
	pool[tid].tid=tid;
	pool[tid].state=READY;
}

void roottask(void)
{
	//print("idle running\n");
	asm("sti \n\t");
	while(1)
	{
		sleep(10);
		dispchar('I');
	}
}

void task1(void)
{
	while(1)
	{
		sleep(10);
		dispchar('O');
	}
}

void scroll(byte up_num)
{
	byte ROWS=25;
	byte scroll_row=up_num;
	asm("movw $0,%%cx \n\t"  //Page 0
	"movb $25,%%dh \n\t"     //25 rows height
	"movb $80,%%dl \n\t"     //80 cols width
	"movb $6,%%ah \n\t"      //INT No.
	"movb %0,%%al \n\t"      //Scroll 1 line
	"int $0x10 \n\t"
	:
	:"b" (scroll_row)
	:"%cx","%dx","%ax"
			);
}


uint32 getesp(void)
{
	uint32 esp=0;
	asm("movl %%ebp,%%edx \n\t"
		"addl $8,%%edx \n\t"   //old-ebp:4B, EIP:4B
		"movl %%edx,%0 \n\t"
		:"=r"(esp)
		:
		:"%edx"
		);
	return esp;
}

void clear(void)
{
	scroll(0x0);
}

void setcursor(byte row, byte col)
{
	asm("movb $2,%%ah \n\t"
	"movb $0,%%bh \n\t"     //Page No.
	"movb %0,%%dh \n\t"   //set row
	"movb %1,%%dl \n\t"
	"int $0x10"
	:
	:"r" (row), "r" (col)
	:"%ax","%bx","%dx"
			);
	tty_current_row=row;
	tty_current_col=col;
}

void resetcursor(void)
{
	setcursor(0,0);
}

void newlinecursor(void)
{
	if(tty_current_row>=(TTY_ROWS-1))
	{ //need scroll
		scroll(1);
		tty_current_row=TTY_ROWS-1;
		tty_current_col=0;
	}
	else
	{ //screen is not yet filled
		tty_current_row++;
		tty_current_col=0;
	}
	setcursor(tty_current_row,tty_current_col);
}

void setnextcursor(void)
{
	if(tty_current_col>=TTY_COLS-1)
	{
		tty_current_row++;
		tty_current_col=0;
	}
	else
		tty_current_col++;

	if(tty_current_row>=TTY_ROWS)
	{
		tty_current_row=TTY_ROWS-1;
		scroll(1);
	}
	s_setcursor(tty_current_row,tty_current_col);
}

void dispchar(char c)
{
	if(c=='\n')
	{
		newlinecursor();
		return;
	}

	asm("movb $0x9,%%ah \n\t"
	"movb $0,%%bh \n\t"
	"movb $0x0f,%%bl \n\t"
	"movw $1,%%cx \n\t"
	"movb %0,%%al \n\t"  //put char into al
	"int $0x10 \n\t"
	:
	:"r"(c)
	:"%ax","%bx","%cx"
			);
	setnextcursor();
	return;
}

void s_dispchar(char c)
{
	asm("cli \n");
	dispchar(c);
	asm("sti \n");
}

int len(char * strp)
{
	int i=0;
	while( strp[i] != '\0')
	{
		i++;			
	}
	return i;
}

void print(char *p)
{	
	int l=len(p);
	for(int i=0;i<l;i++)
		dispchar(p[i]);	
}

void sleep(int ms)
{
	for(int i=0;i<ms;i++)
		for(unsigned int i=0;i<1000;i++)
			;
}

void s_setcursor(byte row, byte col)
{
	asm("movb $2,%%ah \n\t"
	"movb $0,%%bh \n\t"     //Page No.
	"movb %0,%%dh \n\t"   //set row
	"movb %1,%%dl \n\t"
	"int $0x10"
	:
	:"r" (row), "r" (col)
	:"%ax","%bx","%dx"
			);
	tty_current_row=row;
	tty_current_col=col;
}

