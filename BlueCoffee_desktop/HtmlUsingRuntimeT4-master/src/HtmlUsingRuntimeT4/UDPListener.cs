using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace BlueCoffeeManagement
{
    class UDPListener
    {
        private int m_portToListen = 2003;
        private volatile bool listening;
        Thread m_ListeningThread;
        public event EventHandler<MyMessageArgs> NewMessageReceived;

        //constructor
        public UDPListener()
        {
            this.listening = false;
        }

        public void StartListener()
        {
            if (!this.listening)
            {
                m_ListeningThread = new Thread(ListenForUDPPackages);
                this.listening = true;
                m_ListeningThread.IsBackground = true;
                m_ListeningThread.Start();
            }
        }

        public void StopListener()
        {
            this.listening = false;
        }

        public void ListenForUDPPackages()
        {
            UdpClient listener = null;
            try
            {
                listener = new UdpClient(m_portToListen);
            }
            catch (SocketException)
            {
                //do nothing
            }

            if (listener != null)
            {
                IPEndPoint groupEP = new IPEndPoint(IPAddress.Any, m_portToListen);

                try
                {
                    while (this.listening)
                    {
                        Console.WriteLine("Waiting for UDP broadcast to port " + m_portToListen);
                        byte[] bytes = listener.Receive(ref groupEP);
                        Console.WriteLine("receive UDP broadcast from IP: " + groupEP.Address.ToString());
                        IPEndPoint ip = new IPEndPoint(IPAddress.Parse(groupEP.Address.ToString()), 2003);
                        byte[] bytes_mes = Encoding.ASCII.GetBytes(groupEP.Address.ToString());
                        listener.Send(bytes_mes, bytes_mes.Length, ip);
                        //raise event                        
                        NewMessageReceived(this, new MyMessageArgs(bytes));
                    }
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.ToString());
                }
                finally
                {
                    listener.Close();
                    Console.WriteLine("Done listening for UDP broadcast");
                }
            }
        }
    }
}

public class MyMessageArgs : EventArgs
{
    public byte[] data { get; set; }

    public MyMessageArgs(byte[] newData)
    {
        data = newData;
    }
}