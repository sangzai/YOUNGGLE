import React from 'react'
import './Text.css'
const Text = () => {
  return (
    <div className="text" style={{textAlign:'center', lineHeight:'2', fontSize:'32px'}}>
      <div className='animate' data-aos="fade-up" data-aos-duration="1000" style={{lineHeight: '1.3'}}>
        아직도&nbsp; 
        <strong className="highlight blackHighlight">베개</strong>
        에<br/>
        당신을 맞추고 계시나요?<br/>
      </div>
      <h3 style={{lineHeight: '1.5'}}>
        <strong className="highlight primaryHighlight">A-pill</strong>
        은<br/>
        당신에게 맞춥니다<br/>
      </h3>
    </div>
)}

export default Text