using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Drawing.Printing;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace BlueCoffeeManagement
{
    public partial class Form1 : Form
    {

        public static string printerName;
        UDPListener uDPListener;

        private Thread _listenerThread;
        private string stringReceive;
        TableModel tableToPrint;
        float MAX_WIDTH = 189;
        TcpListener _listener;
        public Form1()
        {
            InitializeComponent();
        }
        private void Form1_Load(object sender, EventArgs e)
        {
            loadPrinter();
            startUDP();
           
          
        }


        private void startUDP() {
            uDPListener = new UDPListener();
            uDPListener.NewMessageReceived += OnNewMessageReceived;
            uDPListener.StartListener();
            StartListenerTCP();
        }

        private void stopUDP() {
            uDPListener.StopListener();
            this.uDPListener.NewMessageReceived -= OnNewMessageReceived;
        }
        private void StartListenerTCP()
        {
            _listenerThread = new Thread(RunListenerTCP);
            _listenerThread.IsBackground = true;
            _listenerThread.Start();
        }
        void OnNewMessageReceived(object sender, MyMessageArgs e)
        {
            Console.WriteLine("Done listening for UDP broadcast" + e.data);
           
        }

        private void loadPrinter() {
            if (PrinterSettings.InstalledPrinters.Count <= 0)
            {
                MessageBox.Show("Printer not found!");
                return;
            }

            //Get all available printers and add them to the combo box
            foreach (String printer in PrinterSettings.InstalledPrinters)
            {
                cbb_printer.Items.Add(printer.ToString());
            }
            cbb_printer.SelectedIndex = 0;
            printerName = cbb_printer.SelectedItem.ToString();
        }
        public static string GetLocalIPAddress()
        {
            var host = Dns.GetHostEntry(Dns.GetHostName());
            foreach (var ip in host.AddressList)
            {
                if (ip.AddressFamily == AddressFamily.InterNetwork)
                {
                    return ip.ToString();
                }
            }
            throw new Exception("No network adapters with an IPv4 address in the system!");
        }
        private void RunListenerTCP()
        {
            try
            {
                // Set the TcpListener on port 2004.
                Int32 port = 2004;
                IPAddress localAddr = IPAddress.Parse(GetLocalIPAddress());
                Console.WriteLine("My IP:   " + localAddr.ToString());
                // TcpListener server = new TcpListener(port);
                _listener = new TcpListener(localAddr, port);

                // Start listening for client requests.
                _listener.Start();

                // Buffer for reading data
                Byte[] bytes = new Byte[256];

                // Enter the listening loop.
                while (true)
                {
                    Console.WriteLine("Waiting for a connection... {0}", GetLocalIPAddress());

                    // Perform a blocking call to accept requests.
                    // You could also use server.AcceptSocket() here.
                    TcpClient client = _listener.AcceptTcpClient();
                    Console.WriteLine(" TCP Connected!");

                    // Get a stream object for reading and writing
                    NetworkStream stream = client.GetStream();

                    int i;

                    // Loop to receive all the data sent by the client.
                    while ((i = stream.Read(bytes, 0, bytes.Length)) != 0)
                    {
                        Console.WriteLine("Received unicodeeeeee: {0}", System.Text.Encoding.Unicode.GetString(bytes, 0, i));
                        stringReceive += System.Text.Encoding.Unicode.GetString(bytes, 0, i);
                        try
                        {
                            tableToPrint = TableModel.FromJson(stringReceive);
                            Console.WriteLine("order item 1 í: " + tableToPrint.OrderItems[0].Drink.Name);
                            PrintDocument pd = new PrintDocument();
                            pd.PrinterSettings.PrinterName = printerName;
                            pd.PrintPage += new PrintPageEventHandler(pd_PrintPage);
                            pd.Print();
                            stringReceive = "";
                        }
                        catch
                        {
                        };
                    }
                    Console.WriteLine("Done!");
                    // Shutdown and end connection
                    client.Close();
                }
            }
            catch (SocketException e)
            {
                Console.WriteLine("SocketException: {0}", e);
            }
            finally
            {
                // Stop listening for new clients.
                Console.WriteLine(" _listener.Stop()");
                _listener.Stop();
            }

            Console.WriteLine("\nHit enter to continue...");
            Console.Read();
        }

        public void pd_PrintPage(object sender, PrintPageEventArgs ev)
        {

            //Get the Graphics object
            Graphics g = ev.Graphics;
            float posY = 5.0F;
            float colSL = MAX_WIDTH * 6 / 10;
            float colTT = MAX_WIDTH * 7 / 10;
            //Create a font Arial with size 16
            Font fontNormal = new Font("Arial", 9);
            Font fontTitle = new Font("Arial", 15, FontStyle.Bold);
            Font fontNormalBold = new Font("Arial", 9, FontStyle.Bold);
            Font fontTotalMoney = new Font("Arial", 12, FontStyle.Bold);
            //Create a solid brush with black color
            SolidBrush brush = new SolidBrush(Color.Black);
            // Create point for upper-left corner of drawing.
            PointF drawPoint = new PointF(0.0F, 0.0F);
            g.DrawString("__", fontTitle, brush, new PointF(calCenterPos("__", fontTitle, 0, MAX_WIDTH), posY));
            posY += 80;
            g.DrawString("BLUE COFFEE", fontTitle, brush, new PointF(calCenterPos("BLUE COFFEE", fontTitle, 0, MAX_WIDTH), posY));
            posY += 80;
            List<String> textCal = calText("58 Nguyễn Huệ, TT Madaguoi, Đạ Huoai, Lâm Đồng", fontNormal , MAX_WIDTH);
            if (textCal.Count > 0)
            {
                for (int i = 0; i < textCal.Count; i++) {
                    g.DrawString(textCal[i], fontNormal, brush, new PointF(0, posY));
                    posY += (fontNormal.Size + 3);
                }
            }
            else
            {
                g.DrawString("58 Nguyễn Huệ, TT Madaguoi, Đạ Huoai, Lâm Đồng", fontNormal, brush, new PointF(0, posY));
            }
            posY += 12;
            g.DrawString("SĐT: 0965 487 380", fontNormalBold, brush, new PointF(0, posY));
            posY += 50;
            string tableNumberString = "Bàn số: " + tableToPrint.TableNumber.ToString();
            g.DrawString(tableNumberString
                , fontTotalMoney
                , brush
                , new PointF(0, posY));
            posY += 50;
            g.DrawString("========================", fontNormalBold, brush, new PointF(0, posY));
            posY += (fontNormalBold.Size + 5);
            g.DrawString("Tên món", fontNormalBold, brush, new PointF(0, posY));
            g.DrawString("SL"
                , fontNormalBold
                , brush
                 , new PointF(calCenterPos("SL", fontNormalBold, colSL, colTT), posY)
                );
            g.DrawString("TT", fontNormalBold, brush, new PointF(calCenterPos("TT", fontNormalBold,colTT, MAX_WIDTH), posY));
            posY += (fontNormalBold.Size + 5);
            g.DrawString("========================", fontNormalBold, brush, new PointF(0, posY));
            posY += 18;
            for (int i = 0; i < tableToPrint.OrderItems.Count; i++) {
                ////////////////////////////////////////////
                List<string> drinkNames = calText(tableToPrint.OrderItems[i].Drink.Name, fontNormal, colSL);
                foreach (string text in drinkNames) {
                    g.DrawString(text, fontNormal, brush, new PointF(0, posY));
                    if (drinkNames.IndexOf(text) != (drinkNames.Count - 1))
                    {
                        posY += (fontNormal.Size + 3);
                    }
                }
                /////////////////////////////////////////////////////
                g.DrawString(tableToPrint.OrderItems[i].Quantity.ToString()
                    , fontNormal
                    , brush
                    , new PointF(calCenterPos(tableToPrint.OrderItems[i].Quantity.ToString(), fontNormalBold, colSL, colTT), posY)
                    );
                //////////////////////////////////////////////////////

                long granTotal = tableToPrint.OrderItems[i].Quantity * tableToPrint.OrderItems[i].Drink.Price;
                string totalMoney = string.Format("{0:#.000 đ}", Convert.ToDecimal(granTotal.ToString()) / 1000);
                g.DrawString(totalMoney
                    , fontNormalBold
                    , brush
                    , new PointF(alignRight(totalMoney, fontNormalBold, colTT, MAX_WIDTH)
                    , posY));
                posY += (fontNormal.Size + 3);
                g.DrawString("----------------------------------------------", fontNormalBold, brush, new PointF(0, posY));
                posY += (fontNormal.Size + 3);
                //////////////////////////////////////////////////////
            }
            posY += 20;
            g.DrawString("========================", fontNormalBold, brush, new PointF(0, posY));
            posY += 20;
            g.DrawString("Tổng tiền: ", fontTotalMoney, brush, new PointF(0, posY));
            string totalTableMoney = string.Format("{0:#.000 đ}", Convert.ToDecimal(tableToPrint.getGrandTotal().ToString()) / 1000);
            g.DrawString(totalTableMoney
                , fontTotalMoney
                , brush
                , new PointF(alignRight(totalTableMoney, fontTotalMoney, colSL, MAX_WIDTH)
                , posY));

            posY += 60;
            g.DrawString("Xin cảm ơn và hẹn gặp lại!"
                , fontNormalBold
                , brush
                , new PointF(calCenterPos("Xin cảm ơn và hẹn gặp lại!", fontNormalBold, 0, MAX_WIDTH), posY));
            posY += 60;
            g.DrawString("__"
               , fontNormalBold
               , brush
               , new PointF(calCenterPos("__", fontNormalBold, 0, MAX_WIDTH), posY));
        }

        List<String> calText(string text, Font font, float width) {
            List<string> result = new List<string>();
            result.Add(text);
            float stringWidth = text.Length * font.Size;
            if (stringWidth > width) {
                string[] split = text.Split(' ');
                for (int i = split.Length-2; i >= 0; i--) {
                    string sub = text.Substring(0, text.IndexOf(split[i]) + split[i].Length);
                    if (sub.Length * font.Size < width) {
                        result.Clear();
                        result.Add(sub);
                        string text1 = text.Substring(text.IndexOf(split[i+1]));
                        result.Add(text1);
                        break;
                    }
                }
            }
            return result;
        }

        private float alignRight(String text, Font font, float start, float end)
        {
            float pos = 0;
            float stringWidth = text.Length * font.Size;
            if (stringWidth < (end - start))
                pos = ((end - start) - stringWidth) + start;
            else
                pos = start;

            return pos;
        }

        private float calCenterPos(String text, Font font, float start, float end) {
            float pos = 0;
            float stringWidth = text.Length * font.Size;
            if (stringWidth < (end- start))
                pos = ((end - start) - stringWidth) / 2 + start;
            else
                pos = start;

            return pos;
        }

        public static PageSettings GetPrinterPageInfo(String printerName)
        {
            PrinterSettings settings;

            // If printer name is not set, look for default printer
            if (String.IsNullOrEmpty(printerName))
            {
                foreach (var printer in PrinterSettings.InstalledPrinters)
                {
                    settings = new PrinterSettings();

                    settings.PrinterName = printer.ToString();

                    if (settings.IsDefaultPrinter)
                        return settings.DefaultPageSettings;
                }

                return null; // <- No default printer  
            }

            // printer by its name 
            settings = new PrinterSettings();

            settings.PrinterName = printerName;

            return settings.DefaultPageSettings;
        }

        private void cbb_printer_SelectedIndexChanged(object sender, EventArgs e)
        {
            printerName = cbb_printer.SelectedItem.ToString();
            Console.WriteLine("\nChoose printer: " + printerName);

        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            stopUDP();
        }
    }
}
