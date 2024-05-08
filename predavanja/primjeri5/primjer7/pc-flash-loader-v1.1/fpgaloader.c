#include <errno.h>
#include <fcntl.h> 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/time.h>
#include <termios.h>
#include <unistd.h>
#include <stdint.h>


// to aid the issue of Ubunutu sending AT-xxx by default (garbage to our device)
// copy 44-stlinkv2.rules as
// 		sudo cp 44-stlinkv2.reules /etc/udev/rules
// restart udev
// 		sudo udevadm control --reload-rules  
          
//wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
// test with one of these:
//----------------------------------------------------------------------
// fpgaloader blink1000ms.bin
// fpgaloader blinkfpgaall.bin
//----------------------------------------------------------------------
 
#define CODE_VERSION				"1.1.0"

//#define BAUDRATE 		B115200 
//#define BAUDRATE 		B460800 
//#define BAUDRATE 		B9600 
//#define BAUDRATE 		B921600 
#define BAUDRATE 		B4000000 
#define MODEMDEVICE 	"/dev/ttyACM0"
#define FALSE 			0
#define TRUE 			1

/// WORKS with version 1.1.3!!!
///wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
/// Data related constants
///wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

#define PKT_PREAMBULE									0x5A
#define COM_PACKET_SIZE									64
#define COM_CMD_CONNECT_REQ								0x15
#define COM_CMD_CONNECT_REP								0x16
#define COM_CMD_ERASE_FLASH_REQ							0x24
#define COM_CMD_ERASE_FLASH_REP							0x25
#define COM_CMD_ERASE_FLASH_COMPLETE					0x26
#define COM_CMD_TRANS_INFO								0x55
#define COM_CMD_ACK										0x56
#define COM_CMD_FPGA_DATA								0x57
#define COM_CMD_LOADING_FPGA_DATA						0x62
#define COM_CMD_ENABLE_UART_STREAMING					0x72
#define COM_CMD_DISABLE_UART_STREAMING					0x75

#define	CMD_NOT_RXED									0x00
#define CMD_RXED_CSUM_ERROR								0x01
#define CMD_RXED_WRONG_PREAMBULE						0x02
#define CMD_RXED_WRONG_CMD								0x03
#define CMD_RXED_OK										0x04




#define UART_INIT_ERROR									0x00
#define UART_INIT_OK									0x01

#define UART_RX_DATA_NOT_READY							0x00
#define UART_RX_DATA_READY								0x01
///wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
FILE *file;
int fileLen;
char *tmpbuffer;
void openport(void);
void readport(void);
void sendport(void);
int uart_fd = 0;
struct termios newtp;
//struct sigaction saio;

uint8_t initUART(void);
void sendCMD(uint8_t cmd);
uint8_t waitCMD(uint8_t rx_cmd);
void disposeERROR(uint8_t rxresp);
void drawProgBAR(uint32_t pbar);
volatile uint8_t uart_rx_buff[128];
volatile uint8_t uart_rx_idx = 0;

volatile uint8_t * g_filebuff;
volatile uint8_t g_rx_usb_pkt[COM_PACKET_SIZE];
volatile uint32_t g_filesize;
volatile uint32_t g_ack_pkt;
int main(int argn, char * argc[])
{	
	FILE * fid; 
	long tstart, tend;
    struct timeval timecheck;
	
	uint8_t rxresp;
	printf("\nwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww\n");
	printf("w FPGA STM32F103 -> Xilinx LOADER [v%s]", CODE_VERSION);
	printf("\nwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww\n");
	
	if(initUART() == (UART_INIT_ERROR))
	{
		return 0;
	}
	
	
	fid = fopen(argc[1],"rb");
	if(fid == NULL)
	{
		printf("-> ERROR: bitstream file [%s] is missing\n",argc[1]);
		return 0;
	}
	else
	{
		printf("-> SYS: loading file >> %s <<\n",argc[1]);
	}
	
	g_filebuff = (uint8_t *)malloc(10*1024*1024);
	
	fseek(fid, 0, SEEK_END);
	g_filesize = ftell(fid);
	fseek(fid, 0, SEEK_SET);
	fread((uint8_t *)g_filebuff, sizeof(uint8_t), g_filesize, fid);
	fclose(fid);
	
	
	
	//wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
	// 1. initiate connection
	//------------------------------------------------------------------
	{
		printf("-> SYS: connecting...\n");
		sendCMD(COM_CMD_CONNECT_REQ);
		rxresp = waitCMD(COM_CMD_CONNECT_REP);
		if(rxresp != (CMD_RXED_OK))
		{
			disposeERROR(rxresp);
			return 0;
		}
		printf("-> SYS: connected!\n");
	}
	
	//wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
	// 2. erase flash and wait for completion
	//------------------------------------------------------------------
	{
		printf("-> SYS: requesting flash erase...\n");
		sendCMD(COM_CMD_ERASE_FLASH_REQ);
		rxresp = waitCMD(COM_CMD_ERASE_FLASH_REP);
		if(rxresp != (CMD_RXED_OK))
		{
			disposeERROR(rxresp);
			return 0;
		}
		
		printf("-> SYS: flash erase initated...\n");
		rxresp = waitCMD(COM_CMD_ERASE_FLASH_COMPLETE);
		if(rxresp != (CMD_RXED_OK))
		{
			disposeERROR(rxresp);
			return 0;
		}
		printf("-> SYS: flash erase completed...\n");
	}
	
	//wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
	// 3. send transaction info
	//------------------------------------------------------------------
	{
		printf("-> SYS: sending transaction info for [%ld]B...\n",(long)g_filesize);
		sendCMD(COM_CMD_TRANS_INFO);
		rxresp = waitCMD(COM_CMD_ACK); 
		if(rxresp != (CMD_RXED_OK))
		{
			disposeERROR(rxresp);
			return 0;
		}
	}
	
	g_ack_pkt = 0;
	uint32_t t_ack_pkt;
	uint32_t sent_pkts;
	//time_t tx_begin = time(NULL);
	uint32_t tx_pkts = 0;
	
	printf("-> SYS: sending bitstream...\n");
	gettimeofday(&timecheck, NULL);
	tstart = (long)timecheck.tv_sec * 1000 + (long)timecheck.tv_usec / 1000;
	
	//struct timespec tim1, tim2;
	//tim1.tv_sec = 0;
	//tim1.tv_nsec = 50;
	//tcflush(uart_fd, TCIFLUSH);
	//uint32_t k;
	//for(k=0;k<(g_filesize);k++)
	//{
		//write(uart_fd, &g_filebuff[k], 1);
		////usleep(1);
		//nanosleep(&tim1 , &tim2);
	//}
	
	uint8_t tbar = 0, pbar = 0;
	drawProgBAR(pbar);
	while(1)
	{
		uint32_t m;
		for(m=0;m<100;m++)
		{
			sendCMD(COM_CMD_FPGA_DATA);
			g_ack_pkt += 60;
			if(g_ack_pkt >= 340604)
				break;
		}	
		
		rxresp = waitCMD(COM_CMD_ACK);
		if(rxresp != (CMD_RXED_OK))
		{
			if(g_rx_usb_pkt[1] == (COM_CMD_LOADING_FPGA_DATA))
				break;
				
			disposeERROR(rxresp);
			return 0;
		}
		t_ack_pkt = g_ack_pkt;
	
		
		g_ack_pkt = ((uint32_t)g_rx_usb_pkt[3])<<24;
		g_ack_pkt |= ((uint32_t)g_rx_usb_pkt[4])<<16;
		g_ack_pkt |= ((uint32_t)g_rx_usb_pkt[5])<<8;
		g_ack_pkt |= ((uint32_t)g_rx_usb_pkt[6]);
		
		//g_ack_pkt += 60;
		sent_pkts = 0;
		if(g_ack_pkt > t_ack_pkt)
		{
			if((g_ack_pkt - t_ack_pkt) <= (64*100))
			{
				sent_pkts = g_ack_pkt - t_ack_pkt;
			}
			else
			{
				printf("\n-> ERROR: to many ACKed pkts [%02x]\n",g_ack_pkt - t_ack_pkt);
				free((uint8_t *)g_filebuff);
				close(uart_fd);
				return 0 ;
			}
		}
		tx_pkts += sent_pkts;
		
		pbar = (g_ack_pkt*100)/g_filesize;
		if(tbar != pbar)
		{
			drawProgBAR(pbar);
			tbar = pbar;
		}
		
		if(tx_pkts >= (g_filesize))
		//if(tx_pkts >= (6000))
			break;
	}
	drawProgBAR(100);
	
    gettimeofday(&timecheck, NULL);
    tend = (long)timecheck.tv_sec * 1000 + (long)timecheck.tv_usec / 1000;
    		
	printf("\n\n-> SYS: Firmware transmitted in [%ld] ms\n\n", (tend - tstart));
	
	close(uart_fd);
	free((uint8_t *)g_filebuff);
	return 0;
}

void disposeERROR(uint8_t rxresp)
{
	uint8_t k;
	printf("\n-> ERROR: [%02x]\n",rxresp);
	printf("-> USB: Rx pkt\n");
	for(k=0;k<(COM_PACKET_SIZE);k++)
	{
		printf("%02x", g_rx_usb_pkt[k]);
	}
	printf("\n");
	free((uint8_t *)g_filebuff);
	close(uart_fd);
}

void drawProgBAR(uint32_t pbar)
{
	uint8_t limit = 50;
	uint8_t k;
	char str[128];
	uint8_t kmax = pbar/2 + 1;
	
	for(k=0;k<128;k++)
		str[k] = ' ';
		
	str[0] = '[';
	str[limit + 1] = ']';
	
	
	for(k=1;k<kmax;k++)
	{
		str[k] = '#';
	}
	str[limit+2] = 0x00;
	printf("\r%s %d%%",str, pbar);
	//printf("\r%s ",str);
	
	//k = 0;
	//while(str[k] != 0x00)
	//{
		//putchar(str[k]);
		//k++;
	//}
	//putchar('\r');
	fflush(stdout); 
}

uint8_t waitCMD(uint8_t rx_cmd)
{
	uint32_t k;
	uint8_t csum = 0;
	uint8_t buff[COM_PACKET_SIZE];
	uint16_t n, m, nread;
	// 1. read one packet
	
	nread = 0;
	for(k=0;k<1000000;k++)
	{
		n = read(uart_fd, buff, COM_PACKET_SIZE);
		if(n > 0)
		{
			if((nread + n) > (COM_PACKET_SIZE))
			{
				uint16_t g = 0;
				for(m=nread;m<(COM_PACKET_SIZE);m++)
				{
					g_rx_usb_pkt[m] = buff[g];
					g++;
				}
				
				nread = (COM_PACKET_SIZE);
			}
			else
			{
				uint16_t g = 0;
				for(m=nread;m<(nread + n);m++)
				{
					g_rx_usb_pkt[m] = buff[g];
					g++;
				}
				nread += n;
			}
			
			
			if(nread == (COM_PACKET_SIZE))
			{
				break;
			}
			
		}
		usleep(1);
	}
	
	//printf("-> USB: Rxed\n");
	//for(k=0;k<nread;k++)
	//{
		//printf("%02x", g_rx_usb_pkt[k]);
	//}
	//printf("\n");
	
	if(nread != 64)
		return (CMD_NOT_RXED);
	
	for(k=0;k<((COM_PACKET_SIZE) - 1);k++)
		csum += g_rx_usb_pkt[k];
		
	// 2. check the packet integrity
	if(csum != g_rx_usb_pkt[(COM_PACKET_SIZE)-1])
		return (CMD_RXED_CSUM_ERROR);
	
	// 4. check for packet preambule
	if(g_rx_usb_pkt[0] != (PKT_PREAMBULE))
		return (CMD_RXED_WRONG_PREAMBULE);
	
	// 5. check if we have correct CMD
	if(g_rx_usb_pkt[1] != rx_cmd)
		return (CMD_RXED_WRONG_CMD);
		
	return (CMD_RXED_OK);
}

void sendCMD(uint8_t cmd)
{
	//struct timespec tim1, tim2;
	//tim1.tv_sec = 0;
	//tim1.tv_nsec = 5;

  
	
	uint8_t k;
	uint8_t usb_pkt[COM_PACKET_SIZE];
	
	for(k=0;k<(COM_PACKET_SIZE);k++)
		usb_pkt[k] = 0x00;
	
	usb_pkt[0] = (PKT_PREAMBULE);
	usb_pkt[1] = cmd;
	
	switch(cmd)
	{
		case(COM_CMD_CONNECT_REQ):
		{
			usb_pkt[2] = 0;
			break;
		}
		case(COM_CMD_ERASE_FLASH_REQ):
		{
			usb_pkt[2] = 0;
			break;
		}
		case(COM_CMD_TRANS_INFO):
		{
			usb_pkt[2] = 4;
			usb_pkt[3] = (uint8_t)((g_filesize>>24)&0x000000FF);
			usb_pkt[4] = (uint8_t)((g_filesize>>16)&0x000000FF);
			usb_pkt[5] = (uint8_t)((g_filesize>>8)&0x000000FF);
			usb_pkt[6] = (uint8_t)((g_filesize)&0x000000FF);
			
			break;
		}
		case(COM_CMD_FPGA_DATA):
		{
			
			uint32_t n = g_ack_pkt;
			uint8_t len;
			
			if((n + 60) > g_filesize)
			{
				len = g_filesize - n + 4;
			}
			else
			{
				len = 64;
			}
			
			usb_pkt[2] = len - 4;
			for(k=3;k<len;k++)
			{
				usb_pkt[k] = g_filebuff[n];
				n++;
			}
			break;
		}
	}
	
	
	// add checksum
	usb_pkt[(COM_PACKET_SIZE) - 1] = 0;
	for(k=0;k<((COM_PACKET_SIZE) - 1);k++)
	{
		usb_pkt[(COM_PACKET_SIZE) - 1] += usb_pkt[k];
	}
	
	
	tcflush(uart_fd, TCIFLUSH);
	write(uart_fd, usb_pkt, COM_PACKET_SIZE);
	//for(k=0;k<(COM_PACKET_SIZE);k++)
	//{
		//write(uart_fd, &usb_pkt[k], 1);
		////usleep(1);
		//nanosleep(&tim1 , &tim2);
	//}
	
	//tcdrain(uart_fd);
	//// tx packet via COM interface
	//txDataUSB((uint8_t *)g_com_usb_pkt, COM_PACKET_SIZE);
}


uint8_t initUART(void)
{
	//uart_fd = open(MODEMDEVICE, O_RDWR | O_NOCTTY | O_NDELAY);
	uart_fd = open(MODEMDEVICE, O_RDWR | O_NOCTTY | O_SYNC);
	if (uart_fd <0)
	{
		printf("-> ERROR: initUART() -[ device %s not present\n",MODEMDEVICE);
		return (UART_INIT_ERROR);
	}
	

     //saio.sa_handler = signal_handler_IO;
     //saio.sa_flags = 0;
     //saio.sa_restorer = NULL; 
     //sigaction(SIGIO,&saio,NULL);
	
	////fcntl(uart_fd, F_SETFL, 0);
	//fcntl(uart_fd, F_SETFL, FNDELAY);
    //fcntl(uart_fd, F_SETOWN, getpid());
    //fcntl(uart_fd, F_SETFL,  O_ASYNC ); 
	
	
	
	
																			
	tcgetattr(uart_fd,&newtp);
	//baudRate = B115200;          /* Not needed */
	cfsetispeed(&newtp,BAUDRATE);
	cfsetospeed(&newtp,BAUDRATE);
	newtp.c_cflag &= ~PARENB;
	newtp.c_cflag &= ~CSTOPB;
	newtp.c_cflag &= ~CSIZE;
	newtp.c_cflag |= CS8;
	newtp.c_cflag |= (CLOCAL | CREAD);
	//newtp.c_lflag &= ~(ICANON | ECHO | ECHOE | ISIG);
	//newtp.c_iflag &= ~(IXON | IXOFF | IXANY);
	//newtp.c_iflag &= ~IGNBRK;  
	
	newtp.c_iflag &= ~(IGNBRK | BRKINT | PARMRK | ISTRIP | INLCR | IGNCR | ICRNL | IXON);
    newtp.c_lflag &= ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN);
    newtp.c_oflag &= ~OPOST;

	//newtp.c_oflag &= ~OPOST;
	
	//newtp.c_lflag = 0;                // no signaling chars, no echo,
                                        // no canonical processing
	//newtp.c_oflag = 0;                // no remapping, no delays
	newtp.c_cc[VMIN]  = 1;            // read doesn't block
	newtp.c_cc[VTIME] = 1;            // 0.1 seconds read timeout
	
	tcflush(uart_fd, TCIFLUSH);
	tcsetattr(uart_fd,TCSANOW, &newtp);
	
	return (UART_INIT_OK);
}

