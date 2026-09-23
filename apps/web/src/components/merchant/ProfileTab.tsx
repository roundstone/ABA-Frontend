'use client';

export default function ProfileTab() {
  return (
    <div className="tab-pane fade show active" id="profile">
      <div className="dashboard-box">
        <div className="dashboard-title">
          <h4>profile</h4>
          <span data-bs-target="#edit-profile" data-bs-toggle="modal">edit</span>
        </div>
        <div className="dashboard-detail">
          <ul>
            <li className="details">
              <h5><span>company name</span> Fashion Store</h5>
            </li>
            <li className="details">
              <h5><span>email address</span> mark.enderess@mail.com</h5>
            </li>
            <li className="details">
              <h5><span>Country / Region</span> Downers Grove, IL</h5>
            </li>
            <li className="details">
              <h5><span>Year Established</span> 2018</h5>
            </li>
            <li className="details">
              <h5><span>Total Employees</span> Fashion Store</h5>
            </li>
            <li className="details">
              <h5><span>category</span> clothing</h5>
            </li>
            <li className="details">
              <h5><span>street address</span> 549 Sulphur Springs Road</h5>
            </li>
            <li className="details">
              <h5><span>city/state</span> Downers Grove, IL</h5>
            </li>
            <li className="details">
              <h5><span>zip</span> 96369</h5>
            </li>
          </ul>
        </div>
      </div>
    </div>
  );
}
