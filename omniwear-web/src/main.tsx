import ReactDOM from "react-dom/client";
import { PrimeReactProvider } from "primereact/api";
import App from "./App";
// tailwind css
import "./index.css";
// primreact css
import "primeicons/primeicons.css";
import "./App.css";


ReactDOM.createRoot(document.getElementById("root") as HTMLElement).render(
  <PrimeReactProvider>
    <App />
  </PrimeReactProvider>
);
