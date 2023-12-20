import React from 'react'
import appstore from '../../img/appstore.png'
import googleplay from '../../img/googleplay.png'
import mainlogo from '../../img/MainLogo.png'
import arrow from '../../img/arrow.png'
import './Banner.css'

const Banner = () => {
    return (
        <div className='banner'>
            <div className='wholeLR'>
                <a href='#'>
                    <div className='left-grp'>
                        <img className='bannerMainLogo' src={mainlogo} alt='logo' />
                        <div className='orderText'>
                            <span className='type1'>A-pill로 힐링하고 싶다면</span>
                            <h3 className='type2'>주문 문의 버튼 클릭!</h3>
                        </div>

                        <img className='arrow' src={arrow} alt='arrow' />

                    </div>
                </a>



                <div className='right-grp'>
                    <a href="https://www.apple.com/app-store/">
                        <img src={appstore} className='google img' alt='GooglePlay' />
                    </a>

                    <a href="https://play.google.com/store">
                        <img src={googleplay} className='appstore img' alt='App Store' />
                    </a>

                </div>



            </div>

        </div>
    )
}

export default Banner