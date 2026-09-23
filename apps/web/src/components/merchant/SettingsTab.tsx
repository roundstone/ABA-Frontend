'use client';

export default function SettingsTab() {
  return (
    <div className="tab-pane fade show active" id="settings">
      <div className="dashboard-box">
        <div className="dashboard-title">
          <h4>settings</h4>
        </div>
        <div className="dashboard-detail">
          <div className="account-setting">
            <h5>Notifications</h5>
            <ul className="setting-list">
              <li className="form-check">
                <input defaultChecked className="radio_animated form-check-input" id="exampleRadios1" name="exampleRadios" type="radio" value="option1" />
                <label className="form-check-label" htmlFor="exampleRadios1">Allow Desktop Notifications</label>
              </li>
              <li className="form-check">
                <input className="radio_animated form-check-input" id="exampleRadios2" name="exampleRadios" type="radio" value="option2" />
                <label className="form-check-label" htmlFor="exampleRadios2">Enable Notifications</label>
              </li>
              <li className="form-check">
                <input className="radio_animated form-check-input" id="exampleRadios3" name="exampleRadios" type="radio" value="option3" />
                <label className="form-check-label" htmlFor="exampleRadios3">Get notification for my own activity</label>
              </li>
              <li className="form-check">
                <input className="radio_animated form-check-input" id="exampleRadios4" name="exampleRadios" type="radio" value="option4" />
                <label className="form-check-label" htmlFor="exampleRadios4">DND</label>
              </li>
            </ul>
          </div>
          <div className="account-setting">
            <h5>deactivate account</h5>
            <ul className="setting-list">
              <li className="form-check">
                <input defaultChecked className="radio_animated form-check-input" id="exampleRadios45" name="exampleRadios1" type="radio" value="option4" />
                <label className="form-check-label" htmlFor="exampleRadios45">
                  I have a privacy concern
                </label>
              </li>
              <li className="form-check">
                <input className="radio_animated form-check-input" id="exampleRadios5" name="exampleRadios1" type="radio" value="option5" />
                <label className="form-check-label" htmlFor="exampleRadios5">
                  This is temporary
                </label>
              </li>
              <li className="form-check">
                <input className="radio_animated form-check-input" id="exampleRadios6" name="exampleRadios1" type="radio" value="option6" />
                <label className="form-check-label" htmlFor="exampleRadios6">
                  other
                </label>
              </li>
            </ul>
            <button className="btn btn-solid btn-xs mt-4" type="button">Deactivate Account</button>
          </div>
          <div className="account-setting">
            <h5>Delete account</h5>
            <ul className="setting-list">
              <li className="form-check">
                <input defaultChecked className="radio_animated form-check-input" id="exampleRadios7" name="exampleRadios3" type="radio" value="option7" />
                <label className="form-check-label" htmlFor="exampleRadios7">
                  No longer usable
                </label>
              </li>
              <li className="form-check">
                <input className="radio_animated form-check-input" id="exampleRadios8" name="exampleRadios3" type="radio" value="option8" />
                <label className="form-check-label" htmlFor="exampleRadios8">
                  Want to switch on other account
                </label>
              </li>
              <li className="form-check">
                <input className="radio_animated form-check-input" id="exampleRadios9" name="exampleRadios3" type="radio" value="option9" />
                <label className="form-check-label" htmlFor="exampleRadios9">
                  other
                </label>
              </li>
            </ul>
            <button className="btn btn-solid btn-xs mt-3" type="button">Delete Account</button>
          </div>
        </div>
      </div>
    </div>
  );
}
