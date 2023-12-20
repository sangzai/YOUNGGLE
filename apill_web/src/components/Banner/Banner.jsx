import React from 'react'
import appstore from '../../img/appstore.png'
import googleplay from '../../img/googleplay.png'
import mainlogo from '../../img/MainLogo.png'
import arrow from '../../img/arrow.png'
import './Banner.css'

const Banner = () => {
  return (
    <div className='banner'>
        <div className='fixed-grp'>
            <div className='left-grp'>
                <a href='#'>
                    <div>
                        <div className='position1'>
                            <img className='bannerMainLogo' src={mainlogo} alt='logo'/>
                        </div>
                        <div className='position2'>
                            <p className='left-grp-bottom1'>A-pill로 힐링하고 싶다면</p>
                            <p className='left-grp-bottom2'>주문하기 버튼 클릭!</p>
                            <img src={arrow} alt=''/>
                        </div>
                    </div> 

                </a>
            </div>
            <div className='right-grp'>
                <a href="https://www.apple.com/app-store/">
                 <img src={appstore} className='google img' alt='GooglePlay'/>
                </a>
                <a href="https://play.google.com/store">
                 <img src={googleplay} className='appstore img' alt='App Store'/>
                </a>
            </div>

        {/* <div></div>
        <div></div>
        <button>A-pill 주문 사이트</button>
        <p>A-pill이 궁금하다면</p>
        <button>Goole Play</button>
        <button>App Store</button>
        안녕 */}
        </div>
    </div>
  )
}

export default Banner