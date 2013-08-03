#include <iostream>
#include <atomic>
#include <condition_variable>
#include <thread>
#include <chrono>

#ifdef	WIN32
#	include <windows.h>
#endif

	// stolen straight from http://en.cppreference.com/w/cpp/thread/condition_variable/wait_for
	// just to make sure the parts were there
	// compiled: g++ -std=gnu++0x -pthread threadcondwait.cpp

	// hacked up to get around platform wait_for issues.

	static void	wait(int ams)
	{
#ifdef	CYGWIN
	#include <time.h>

		struct timespec delay= { 0, 0} ;

		delay.tv_nsec= 1000000 * ams ;
		nanosleep( &delay, NULL) ;

#else
#ifdef	WIN32
		Sleep( ams) ;
#else
		std::this_thread::sleep_for(std::chrono::milliseconds(ams));
#endif
#endif
	}


std::condition_variable cv;
std::mutex cv_m;
std::atomic<int> i = 0 ;
 
void waits(int idx)
{
    std::unique_lock<std::mutex> lk(cv_m);
    if(cv.wait_for(lk, std::chrono::milliseconds(idx*100), [](){return i == 1;})) 
        std::cerr << "Thread " << idx << " finished waiting. i == " << i << '\n';
    else
        std::cerr << "Thread " << idx << " timed out. i == " << i << '\n';
}
void signals()
{
    wait( 120) ;
    std::cerr << "Notifying...\n";
    cv.notify_all();
    wait( 120) ;
    i = 1;
    std::cerr << "Notifying again...\n";
    cv.notify_all();
}

int main()
{
    std::thread t1(waits, 1), t2(waits, 2), t3(waits, 3), t4(signals);
    t1.join(); t2.join(), t3.join(), t4.join();
}

