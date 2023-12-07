import React from 'react'
import "./App.css"
import AppInfoPage from '../pages/AppInfoPage'
import ProductInfoPage from '../pages/ProductInfoPage'
import Mainpage from '../pages/Mainpage'
import TextPage from '../pages/TextPage'

const App = () => {
  return (
    <div>
      <Mainpage />
      <TextPage/>
      <AppInfoPage />
      <ProductInfoPage />
    </div>
  )
}

export default App