import { Provider } from "react-redux";
import { HashRouter as Router, Route, Routes } from "react-router-dom";
import store from "@/redux/store";
import DatasetsPage from "@/pages/datasets/DatasetsPage";
import LoginPage from "@/pages/login/LoginPage";
import Layout from "./pages/Layout";

function App() {
  return (
    <Provider store={store}>
      <Router>
        <div className="w-screen h-screen">
          <Routes>
            <Route path="/login" element={<LoginPage />} />
            
            {/* Layout Route */}
            <Route element={<Layout />}>
              <Route path="/dataset" element={<DatasetsPage />} />
            </Route>

            {/* Default Route */}
            <Route path="/" element={<LoginPage />} />
          </Routes>
        </div>
      </Router>
    </Provider>
  );
}

export default App;
