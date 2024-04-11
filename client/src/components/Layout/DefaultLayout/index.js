import Footer from "./Footer";
import Header from "./Header"

function DefaultLayout({ children }) {

  if (
    children.type.name === 'LoginPage'
  ) {
    return (
      <div>
        {/* <Header /> */}
        <div className="container">
          <div className="content">{children}</div>
        </div>
        <Footer />

      </div>

    );
  } else {
    return (
      <div>
        <Header />
        <div className="container">
          <div className="content">{children}</div>
        </div>
        <Footer />

      </div>

    );
  }
}

export default DefaultLayout;