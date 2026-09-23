import Breadcrumb from '@/components/ui/Breadcrumb';

export const metadata = {
  title: 'Forgot Password - Multikart',
  description: 'Recover your password',
};

export default function ForgotPasswordPage() {
  return (
    <>
      <Breadcrumb
        title="Forget Password"
        items={[{ label: 'Home', url: '/' }, { label: 'Forget Password' }]}
      />
      <section className="pwd-page section-b-space">
        <div className="container">
          <div className="row">
            <div className="col-lg-6 offset-lg-3">
              <h2>Forget Your Password</h2>
              <form className="theme-form">
                <div className="row">
                  <div className="col-md-12">
                    <input type="email" className="form-control" id="email" placeholder="Enter Your Email" required />
                  </div>
                  <div className="col-md-12 mt-3">
                    <button type="submit" className="btn btn-solid">Submit</button>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </div>
      </section>
    </>
  );
}
