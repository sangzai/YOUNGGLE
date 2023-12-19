import React from 'react'
import "./App.css"
import AppInfoPage from '../pages/AppInfoPage'
import ProductInfoPage from '../pages/ProductInfoPage'
import Mainpage from '../pages/Mainpage'
import TextPage from '../pages/TextPage'
import Menu from '../components/N01mainpage/FlyoutMenus'
<<<<<<< HEAD
import BannerPage from '../pages/BannerPage'
=======
import TeamInfoPage from '../pages/TeamInfoPage'
>>>>>>> dc0d34a7878cfd1e116323259ca27676906ebd21
const App = () => {
  return (
    <div className='appcontainer'>
      <Mainpage />
      <TextPage/>
      <ProductInfoPage />
      <AppInfoPage />
<<<<<<< HEAD
      <BannerPage/>
=======
      <TeamInfoPage />
>>>>>>> dc0d34a7878cfd1e116323259ca27676906ebd21
    </div>
  )
}

export default App