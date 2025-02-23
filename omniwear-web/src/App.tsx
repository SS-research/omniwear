import { Provider } from 'react-redux';
import { HashRouter as Router, Route, Routes } from 'react-router-dom';
import store from '@/redux/store';
import DatasetsPage from '@/pages/datasets/DatasetsPage';
import LoginPage from '@/pages/login/LoginPage';
import Layout from '@/pages/Layout';
import TSHealthsPage from '@/pages/ts-healths/TSHealthsPage';
import TSInertialsPage from '@/pages/ts-inertials/TSInertialsPage';
import { ToastProvider } from '@/components/ToastContext';

function App() {
    return (
        <Provider store={store}>
            <ToastProvider>
                <Router>
                    <div className="w-screen h-screen">
                        <Routes>
                            <Route path="/login" element={<LoginPage />} />

                            {/* Layout Route */}
                            <Route element={<Layout />}>
                                <Route path="/dataset" element={<DatasetsPage />} />
                                <Route
                                    path="/ts-inertial/dataset/:datasetId"
                                    element={<TSInertialsPage />}
                                />
                                <Route
                                    path="/ts-health/dataset/:datasetId"
                                    element={<TSHealthsPage />}
                                />
                            </Route>

                            {/* Default Route */}
                            <Route path="/" element={<LoginPage />} />
                        </Routes>
                    </div>
                </Router>
            </ToastProvider>
        </Provider>
    );
}

export default App;
