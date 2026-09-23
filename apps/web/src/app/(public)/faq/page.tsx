import Breadcrumb from '@/components/ui/Breadcrumb';

export default function FAQPage() {
  return (
    <>
      <Breadcrumb
        title="Faq"
        items={[{ label: 'Home', url: '/' }, { label: 'Faq' }]}
      />
      {/* section start */}
<section className="faq-section section-b-space">
<div className="container">
<div className="accordion theme-accordion" id="accordionExample">
<div className="accordion-item">
<h2 className="accordion-header">
<button className="accordion-button" data-bs-target="#collapseOne" data-bs-toggle="collapse">How do
                            I protect my personal information when shopping online?</button>
</h2>
<div className="accordion-collapse collapse show" data-bs-parent="#accordionExample" id="collapseOne">
<div className="accordion-body">
<p>Use secure websites (look for &quot;https&quot; in the URL), avoid public Wi-Fi for sensitive
                                transactions, regularly update passwords, and be cautious about sharing unnecessary
                                personal information. Additionally, consider using a virtual private network (VPN) for
                                added security, and monitor your financial statements regularly for any unauthorized
                                transactions. Staying vigilant and adopting secure online practices is key to protecting
                                your personal information.</p>
</div>
</div>
</div>
<div className="accordion-item">
<h2 className="accordion-header">
<button className="accordion-button collapsed" data-bs-target="#collapseTwo" data-bs-toggle="collapse" type="button">What is the difference between refurbished and new
                            products?</button>
</h2>
<div className="accordion-collapse collapse" data-bs-parent="#accordionExample" id="collapseTwo">
<div className="accordion-body">
<p>Refurbished products have been repaired and tested to ensure functionality. They may show
                                slight wear but are generally more affordable than new items. New products are unused
                                and come in original packaging. When purchasing refurbished items, look for those
                                certified by the manufacturer or a reputable third party to ensure quality and
                                reliability.</p>
</div>
</div>
</div>
<div className="accordion-item">
<h2 className="accordion-header">
<button className="accordion-button collapsed" data-bs-target="#collapseThree" data-bs-toggle="collapse">How can I find out about product recalls?</button>
</h2>
<div className="accordion-collapse collapse" data-bs-parent="#accordionExample" id="collapseThree">
<div className="accordion-body">
<p>Check the product&apos;s official website, the manufacturer&apos;s website, or government websites
                                for recalls. You can also sign up for email alerts from consumer protection
                                organizations. Additionally, following the manufacturer and relevant product safety
                                organizations on social media can provide timely updates on recalls and safety concerns.
                            </p>
</div>
</div>
</div>
<div className="accordion-item">
<h2 className="accordion-header">
<button className="accordion-button collapsed" data-bs-target="#collapseFour" data-bs-toggle="collapse">Can I cancel an order after it has been placed?</button>
</h2>
<div className="accordion-collapse collapse" data-bs-parent="#accordionExample" id="collapseFour">
<div className="accordion-body">
<p>It depends on the retailer and the stage of processing. Quickly contact customer service
                                to inquire about cancellation possibilities. Some retailers have a short window for
                                order cancellations, especially if the order has already been processed or shipped.
                                Being proactive in reaching out can increase the chances of a successful cancellation
                            </p>
</div>
</div>
</div>
<div className="accordion-item">
<h2 className="accordion-header">
<button className="accordion-button collapsed" data-bs-target="#collapseSix" data-bs-toggle="collapse">What should I do if a product arrives damaged?</button>
</h2>
<div className="accordion-collapse collapse" data-bs-parent="#accordionExample" id="collapseSix">
<div className="accordion-body">
<p>Contact the retailer&apos;s customer service immediately. Most retailers have a process for
                                handling damaged or defective items and may offer a replacement or refund. Take clear
                                photos of the damage and provide detailed information to expedite the resolution
                                process. Many retailers prioritize customer satisfaction and will work to resolve the
                                issue promptly.</p>
</div>
</div>
</div>
<div className="accordion-item">
<h2 className="accordion-header">
<button className="accordion-button collapsed" data-bs-target="#collapseSeven" data-bs-toggle="collapse">How can I extend the lifespan of electronic
                            devices?</button>
</h2>
<div className="accordion-collapse collapse" data-bs-parent="#accordionExample" id="collapseSeven">
<div className="accordion-body">
<p>Keep devices in a cool and dry place, install software updates regularly, use protective
                                cases, and follow manufacturer recommendations for charging. Avoid exposing devices to
                                extreme temperatures, and consider investing in surge protectors to safeguard against
                                electrical issues.</p>
</div>
</div>
</div>
<div className="accordion-item">
<h2 className="accordion-header">
<button className="accordion-button collapsed" data-bs-target="#collapseEight" data-bs-toggle="collapse">Are online reviews reliable for making purchasing
                            decisions?</button>
</h2>
<div className="accordion-collapse collapse" data-bs-parent="#accordionExample" id="collapseEight">
<div className="accordion-body">
<p>Online reviews can be helpful, but it&apos;s essential to consider the overall sentiment and
                                read multiple reviews. Look for detailed reviews that discuss both positive and negative
                                aspects of the product. Consider the credibility of the source, and be aware that some
                                reviews may be influenced by factors like personal preferences or sponsored content.</p>
</div>
</div>
</div>
<div className="accordion-item">
<h2 className="accordion-header">
<button className="accordion-button collapsed" data-bs-target="#collapseNine" data-bs-toggle="collapse">How do I find the best deals and discounts when shopping
                            online?</button>
</h2>
<div className="accordion-collapse collapse" data-bs-parent="#accordionExample" id="collapseNine">
<div className="accordion-body">
<p>Subscribe to newsletters, follow retailers on social media, and use price comparison
                                tools. Many retailers also offer discounts for first-time shoppers or during seasonal
                                sales. Additionally, consider browser extensions that automatically apply coupon codes
                                at checkout, maximizing your savings.</p>
</div>
</div>
</div>
<div className="accordion-item">
<h2 className="accordion-header">
<button className="accordion-button collapsed" data-bs-target="#collapseTen" data-bs-toggle="collapse">What is the return policy for most products?</button>
</h2>
<div className="accordion-collapse collapse" data-bs-parent="#accordionExample" id="collapseTen">
<div className="accordion-body">
<p>Return policies vary by retailer. Typically, there is a specified window (e.g., 30 days)
                                for returns. Check the retailer&apos;s website or contact customer service for specific
                                details. Some retailers may offer free returns, while others may deduct return shipping
                                costs from your refund. It&apos;s crucial to review the policy before making a purchase to
                                ensure you&apos;re comfortable with the terms.</p>
</div>
</div>
</div>
<div className="accordion-item">
<h2 className="accordion-header">
<button className="accordion-button collapsed" data-bs-target="#collapseele" data-bs-toggle="collapse">How can I track my online order?</button>
</h2>
<div className="accordion-collapse collapse" data-bs-parent="#accordionExample" id="collapseele">
<div className="accordion-body">
<p>Most online retailers provide a tracking number in your order confirmation email. You can
                                use this number on the carrier&apos;s website to track the status and location of your
                                package. Additionally, some carriers offer detailed tracking information, including
                                estimated delivery times and real-time updates on the package&apos;s journey.</p>
</div>
</div>
</div>
</div>
</div>
</section>
{/* Section ends */}
    </>
  );
}
