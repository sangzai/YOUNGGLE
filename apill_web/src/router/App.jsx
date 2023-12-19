import React from 'react'
import "./App.css"
import AppInfoPage from '../pages/AppInfoPage'
import ProductInfoPage from '../pages/ProductInfoPage'
import Mainpage from '../pages/Mainpage'
import TextPage from '../pages/TextPage'
import Menu from '../components/N01mainpage/FlyoutMenus'
import TeamInfoPage from '../pages/TeamInfoPage'
const App = () => {
  return (
    <div className='appcontainer'>
      <Mainpage />
      <TextPage/>
      <ProductInfoPage />
      <AppInfoPage />
      <TeamInfoPage />
    </div>
  )
}

export default App