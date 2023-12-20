import React, { useEffect, useState } from 'react';
import Menu from './FlyoutMenus';
import sleep1 from '../../img/sleep1.jpg';
import sleep2 from '../../img/sleep2.jpg';
import sleep3 from '../../img/sleep3.jpg';
import sleep4 from '../../img/sleep4.jpg';
import Logo from '../../img/MainLogo.png';
import Logo_Apill from '../../img/Logo_Apill.png';

import { Carousel } from 'react-responsive-carousel';
import 'react-responsive-carousel/lib/styles/carousel.min.css';
import './Mainslide.css';

const Mainslide = () => {
  const images = [sleep1, sleep2, sleep3, sleep4];
  const [currentSlide, setCurrentSlide] = useState(0);  //초기값 (인덱스 0)

  useEffect(() => { //변화가 생길때 감지
    const interval = setInterval(() => {
      setCurrentSlide((prevSlide) => (prevSlide + 1) % images.length);
    }, 4000);

    return () => {
      clearInterval(interval); 
    };
  }, [images.length]); //[]안에 있는 값이 변할때 렌더링, 비어있으면 처음에만 적용됨!

  // const toggleMenu=()=>{
  //   setIsMenuOpen(!isMenuOpen);
  // }
  return (
    <div id='main' className='MainDash'>
      <header class="header">
        <h2 classname="logo">
          <img className='logoimg' src={Logo_Apill} alt='Logo'/>
        </h2>
        <div class="Menu">
          <Menu/>
      </div>
      </header>
      <div className='imgslide'>
          {/* showThumbs={false} -> 밑에 같이 뜨는 사진 없애는 코드*/}
        <Carousel showThumbs={false} selectedItem={currentSlide} onChange={(nextSlide) => setCurrentSlide(nextSlide)}
        transitionTime={2000}
        // 슬라이드 상태 표시줄을 숨김
        showStatus={false} 
        // 무한루프 설정(넘어갈때 중간 슬라이드 안거치도록)
        infiniteLoop={true}
        // 화살표 보이지 않도록 설정
        showArrows={false}
        // 이미지 아래의 점을 보이지 않도록 설정
        showIndicators={false}
        >
          {images.map((image, index) => (
            <div key={index}>
              <img src={image} alt={`${index}`} />
            </div>
          ))}
        </Carousel>

        
          
      </div>
    </div>
  );
}

export default Mainslide;
