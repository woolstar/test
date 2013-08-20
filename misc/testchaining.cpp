#include <stdio.h>
#include <string.h>
#include <memory>

		// OLD way - C++98

  class SampleBuffer
  {
    public:
      SampleBuffer(int alen) ;
      SampleBuffer(char const * astring) ;

    protected:
      std::unique_ptr<char []>    m_buffer ;
      int m_len ;
  } ;

  SampleBuffer::SampleBuffer(int alen) : m_buffer( new char[alen +1]), m_len(alen)
  { }
  SampleBuffer::SampleBuffer(char const * astring)
  {
    int tmplen= strlen( astring) ;
    m_buffer = new char[tmplen +1] ;
    m_len= tmplen ;
    strncpy( m_buffer.get(), astring, tmplen) ;
  }

		// NEW way - C++11
		// constructor chaining

  class DRYBuffer
  {
    public:
      DRYBuffer(int alen) ;
      DRYBuffer(char const * astring) ;

    protected:
      std::unique_ptr<char []>    m_buffer ;
      int m_len ;
  } ;

  DRYBuffer::DRYBuffer(int alen) : m_buffer( new char[alen +1]), m_len(alen)
  {
  }
  DRYBuffer::DRYBuffer(char const * astring) : DRYBuffer(strlen(astring))
  {
    strncpy( m_buffer.get(), astring, m_len) ;
  }
	

	//

int main(int N, char ** S)
{
	SampleBuffer	test1(100), test2("hello world") ;
	DRYBuffer		dry1(100), dry2("hello pragmatic world") ;

	return 0 ;
}

