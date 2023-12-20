import React from 'react'
import "./Teaminfo.css"

const Teaminfo = () => {
  return (
    <div>
      <div className='teaminfo'>
        <div className='teaminfo-box'>
          <div className='team-who' style={{ lineHeight: '1.5' }}>
            <strong>TheTech</strong><br />
            광주광역시 동구 예술길 31-15 4층<br />
            스마트인재개발원<br />
            e-mail: rtop112@naver.com
          </div>
          <div className='team-what' style={{ lineHeight: '1.5' }}>
            당신의 즐거운 꿈을 위해<br />
            <strong className="highlight primaryHighlight ">A-pill</strong>
            을&nbsp;
            <strong className="highlight primaryHighlight ">A-peal</strong>
            하는 중<br />
          </div>
        </div>

      </div>
      <div className='blank'>

      </div>
    </div>
  )
}

export default Teaminfo