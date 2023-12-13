import React, { useEffect } from 'react';
import './Text.css';
import line from '../../img/line.png'
import target1 from '../../img/target1.png'
import target2 from '../../img/target2.png'
import target3 from '../../img/target3.png'
import target4 from '../../img/target4.png'
import target5 from '../../img/target5.png'

const Text = () => {
  useEffect(() => {
    const handleScroll = () => {
      const advElements = document.querySelectorAll('.scroll1, .scroll2');

      advElements.forEach((element, index) => {
        const top = element.getBoundingClientRect().top;
        const windowHeight = window.innerHeight;

        if (top < windowHeight * 0.85) {
          element.style.transitionDelay = `${index * 0.2}s`;
          element.classList.add('visible');
        }
      });
    };

    window.addEventListener('scroll', handleScroll);

    return () => {
      window.removeEventListener('scroll', handleScroll);
    };
  }, []);

  return (
    <div style={{padding:'10%'}}>
    <div className="text" style={{ textAlign: 'center', lineHeight: '2'}}>
      <div className='animate scroll1' style={{ lineHeight: '1.3'}}>
        아직도&nbsp; 
        <strong className="highlight blackHighlight">베개</strong>
        에<br/>
        당신을 맞추고 계시나요?<br/>
      </div>
      <img className="line" src={line}/>
      <div className="scroll2" style={{ lineHeight: '1.5'}}>
        <strong className="highlight primaryHighlight ">A-pill</strong>
        은<br/>
        당신에게 맞춥니다<br/>
      </div>
    </div>
    <div className='targetslide-wrap'>
    {/* 원 */}
    <div className='circle-wrap'>

      <div className="circle-lg">
      </div>
      <div className="circle-md">
      </div>

    </div>
    {/* 타겟 */}
    <div className='target-wrap'>
      <img  className='target' src={target1} ></img>
      <img  className='target' src={target2} ></img>
      <img  className='target' src={target3} ></img>
      <img  className='target' src={target4} ></img>
      <img  className='target' src={target5} ></img>

    </div>

    </div>

    </div>
  );
};

export default Text;
