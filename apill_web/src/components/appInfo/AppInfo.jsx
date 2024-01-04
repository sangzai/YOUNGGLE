import React, { useState, useEffect } from 'react';
import './Appinfo.css'
import app from './img/app.png'
import appmain from './img/app_main.png'
import appalarm from './img/app_alarm.png'
import appchart from './img/app_chart.png'
import apptutorial from './img/app_tutorial.png'
// import appalarmdic from './img/app_alarm_dic.png'
// import appchartdic from './img/app_chart_dic.png'
// import apptutorialdic from './img/app_tutorial_dic.png'
// import appcontroldoc from './img/app_chart_dic.png'

const AppInfo = () => {
  const [backgroundImageIndex, setBackgroundImageIndex] = useState(0);
  const images = [app, apptutorial, appchart, appalarm, appmain];
  const [dicImageIndex, setDicImageIndex] = useState(0);

  const [opacity, setOpacity] = useState(1);

  useEffect(() => {
    const interval = setInterval(() => {
      setOpacity(0); 
      setTimeout(() => {
        setBackgroundImageIndex((prev) =>
          prev === images.length - 1 ? 0 : prev + 1
        );
        setOpacity(1); 
      }, 600); 
    }, 5000); 

    return () => clearInterval(interval);
  }, [images.length]);

  useEffect(() => {
    const interval = setInterval(() => {
      setDicImageIndex((prev) =>
        prev === images.length - 1 ? 0 : prev + 1
      );
    }, 5000);
  
    return () => clearInterval(interval);
  }, [images.length]);
  
  useEffect(() => {
    const currentImageIndex = dicImageIndex % images.length;
    const prevImageIndex = currentImageIndex === 0 ? images.length - 1 : currentImageIndex - 1;
    
    const elements = document.querySelectorAll('.app-dic > div');
  
    // 요소가 존재하는지 확인 후 작업 수행
    if (elements[prevImageIndex] && elements[currentImageIndex]) {
      elements[prevImageIndex].classList.remove('active');
      elements[currentImageIndex].classList.add('active');
    }
  }, [dicImageIndex]);
  
  

  return (
    <div id='appinfo' className="appinfo">
      <div
        className="app-main"
        style={{
          backgroundImage: `url(${images[backgroundImageIndex]})`,
          opacity: opacity, 
          transition: "opacity 1s ease-in-out", 
        }}/>
      <div className='app-dic'>
        <div />
        <div className='app-tutorial-dic'></div>
        <div className='app-chart-dic'></div>
        <div className='app-alarm-dic'></div>
        <div className='app-control-dic'></div>
      </div>
    
      {/* <div className="app-tutorial-dic-dotted-line"></div>
      <div className="app-chart-dic-dotted-line"></div>
      <div className="app-alarm-dic-dotted-line"></div>
      <div className="app-control-dic-dotted-line"></div> */}
    </div>
  );
};

export default AppInfo;