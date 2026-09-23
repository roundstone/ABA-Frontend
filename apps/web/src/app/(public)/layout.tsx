import React from "react";
import Header from "@/components/layout/Header";
import Footer from "@/components/layout/Footer";
import SearchPopup from "@/components/layout/SearchPopup";
import CartOffcanvas from "@/components/layout/CartOffcanvas";
import QuickViewModal from "@/components/modals/QuickViewModal";

export default function PublicLayout({ children }: { children: React.ReactNode }) {
  return (
    <>
      <Header />
      <SearchPopup />
      <CartOffcanvas />
      <main className="flex-grow-1">{children}</main>
      <Footer />
      <QuickViewModal />
    </>
  );
}
