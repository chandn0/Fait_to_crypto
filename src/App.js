import './App.css';
import { Link } from "react-router-dom";
import { Routes, Route } from "react-router-dom";
import { useMoralis } from "react-moralis";
import { ConnectButton } from "web3uikit";
import BuyEth from './pages/BuyEth';
import SellEth from './pages/SellEth';

function App() {

  const { isAuthenticated, isAuthenticating } = useMoralis();
  const { logout } = useMoralis();

  const logOut = async () => {
    await logout();
  };



  return (
    <>
      <div className="App">
        <div className="d-flex justify-content-center">
          <div className="p-2">
            <Link to="/buyeth" className="link">
              <button type="button" class="btn btn-outline-info">Buy ETH</button>
            </Link>
          </div>
          <div className="p-2">
            <Link to="/selleth" className="link">
              <button type="button" class="btn btn-outline-info">sell ETH</button>
            </Link></div>

          <div className=" p-2">
            {!isAuthenticated ? (<ConnectButton />)
              : (<button type="button" class="btn btn-outline-info" disabled={isAuthenticating} onClick={logOut}>
                logOut
              </ button>)}
          </div>
        </div>
        <div >
          <Routes>
            {/* <Route path="/" element={<App />} /> */}
            <Route path="/buyeth" element={<BuyEth />} />
            <Route path="/selleth" element={<SellEth />} />

          </Routes>
        </div>
      </div>
    </>
  );
};

export default App;
