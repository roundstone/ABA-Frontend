import type { Metadata } from "next";
import { Montserrat } from "next/font/google";
import "slick-carousel/slick/slick.css";
import "slick-carousel/slick/slick-theme.css";
import "./globals.scss";
import BootstrapProvider from "@/components/BootstrapProvider";
import RoleSwitcher from "@/components/RoleSwitcher";

const montserrat = Montserrat({
  variable: "--font-montserrat",
  subsets: ["latin"],
  weight: ["300", "400", "500", "600", "700", "800"],
});

export const metadata: Metadata = {
  title: "Aba E-commerce",
  description: "Aba E-commerce template",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html
      lang="en"
      className={`${montserrat.variable} h-full antialiased`}
      suppressHydrationWarning
    >
      <head>
        <link href="/assets/css/vendors/font-awesome.css" rel="stylesheet" type="text/css" />
        <link href="/assets/css/vendors/remixicon.css" rel="stylesheet" type="text/css" />
        <link href="/assets/css/vendors/themify-icons.css" rel="stylesheet" type="text/css" />
        <link href="/assets/css/vendors/price-range.css" rel="stylesheet" type="text/css" />
      </head>
      <body className="min-h-full flex flex-col" suppressHydrationWarning>
        {children}
        {/* <RoleSwitcher /> */}
        <BootstrapProvider />
      </body>
    </html>
  );
}
