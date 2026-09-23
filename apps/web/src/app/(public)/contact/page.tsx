export const metadata = {
  title: 'Contact Us - Multikart',
  description: 'Contact us',
};

export default function ContactPage() {
  return (
    <>
      {/* breadcrumb start */}
      <div className="breadcrumb-section">
        <div className="container">
          <h2>Contact us</h2>
          <nav className="theme-breadcrumb">
            <ol className="breadcrumb">
              <li className="breadcrumb-item">
                <a href="index.html">Home</a>
              </li>
              <li className="breadcrumb-item active">Contact us</li>
            </ol>
          </nav>
        </div>
      </div>
      {/* breadcrumb End */}
      {/* contact section start */}
      <section className="contact-page">
        <div className="container">
          <div className="row g-sm-4 g-3">
            <div className="col-lg-5">
              <div className="contact-title">
                <h2>Get In Touch</h2>
                <p>We&apos;re here to help! Reach out to us with any questions, feedback, or inquiries, and we&apos;ll get
                  back to you as soon as possible.</p>
              </div>
            </div>
            <div className="col-lg-7">
              <form className="theme-form contact-form">
                <div className="row g-4">
                  <div className="col-12">
                    <div className="form-box">
                      <label className="form-label" htmlFor="name">Full Name</label>
                      <input className="form-control" id="name" placeholder="Full Name" type="text" />
                    </div>
                  </div>
                  <div className="col-md-6">
                    <div className="form-box">
                      <label htmlFor="email">Email</label>
                      <input className="form-control" id="email" placeholder="Email" type="email" />
                    </div>
                  </div>
                  <div className="col-md-6">
                    <div className="form-box">
                      <label htmlFor="review">Phone</label>
                      <input className="form-control" id="review" placeholder="Enter Your Phone Number" type="number" />
                    </div>
                  </div>
                  <div className="col-12">
                    <div className="form-box">
                      <label htmlFor="email">Subject</label>
                      <input className="form-control" id="last-name" placeholder="Subject" type="text" />
                    </div>
                  </div>
                  <div className="col-12">
                    <div className="form-box">
                      <label htmlFor="review">Write Your Message</label>
                      <textarea className="form-control" placeholder="Write Your Message" rows={6}></textarea>
                    </div>
                  </div>
                  <div className="col-12">
                    <div className="form-box">
                      <button className="btn btn-solid" type="button">Send Your Message</button>
                    </div>
                  </div>
                </div>
              </form>
            </div>
            <div className="col-12">
              <div className="contact-right">
                <ul>
                  <li>
                    <div className="contact-icon">
                      <i className="ri-phone-fill"></i>
                    </div>
                    <div className="media-body">
                      <h6>Contact Us</h6>
                      <p>+91 123 - 456 - 7890</p>
                    </div>
                  </li>
                  <li>
                    <div className="contact-icon">
                      <i className="ri-map-pin-fill"></i>
                    </div>
                    <div className="media-body">
                      <h6>Address</h6>
                      <p>ABC Complex,Near xyz, New York</p>
                    </div>
                  </li>
                  <li>
                    <div className="contact-icon">
                      <i className="ri-mail-fill"></i>
                    </div>
                    <div className="media-body">
                      <h6>Email</h6>
                      <p>support@multikart.com</p>
                    </div>
                  </li>
                  <li>
                    <div className="contact-icon">
                      <i className="ri-cellphone-fill"></i>
                    </div>
                    <div className="media-body">
                      <h6>Fax</h6>
                      <p>support@multikart.com</p>
                    </div>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </section>
      {/* contact section ends */}
      {/* map section start */}
      <section className="map-section">
        <iframe className="w-100 h-100" frameBorder="0" src="https://www.google.com/maps/embed?pb=!1m14!1m12!1m3!1d1605.811957341231!2d25.45976406005396!3d36.3940974010114!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!5e0!3m2!1sen!2sin!4v1550912388321"></iframe>
      </section>
      {/* map section End */}
    </>
  );
}
