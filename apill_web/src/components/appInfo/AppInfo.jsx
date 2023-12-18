import React, { useState, useEffect } from 'react';
import './AppInfo.css'
import app from './img/app.png'
import appmain from './img/app_main.png'
import appalarm from './img/app_alarm.png'
import appchart from './img/app_chart.png'
import apptutorial from './img/app_tutorial.png'
import appalarmdic from './img/app_alarm_dic.png'
import appchartdic from './img/app_chart_dic.png'
import apptutorialdic from './img/app_tutorial_dic.png'
import appcontroldoc from './img/app_chart_dic.png'

const AppInfo = () => {
  const [backgroundImageIndex, setBackgroundImageIndex] = useState(0);
  const images = [app, appmain, appalarm, appchart, apptutorial];

  const [opacity, setOpacity] = useState(1);

  useEffect(() => {
    const interval = setInterval(() => {
      setOpacity(0); 
      setTimeout(() => {
        setBackgroundImageIndex((prev) =>
          prev === images.length - 1 ? 0 : prev + 1
        );
        setOpacity(1); 
      }, 1000); 
    }, 5000); 

    return () => clearInterval(interval);
  }, [images.length]);

  return (
    <div id='appinfo' className="appinfo">
      <div
        className="app-main"
        style={{
          backgroundImage: `url('${images[backgroundImageIndex]}')`,
          opacity: opacity, 
          transition: "opacity 1s ease-in-out", 
        }}
      />
      <div className='app-tutorial-dic'></div>
      <div className='app-chart-dic'></div>
      <div className='app-alram-dic'></div>
      <div className='app-control-dic'></div>
    </div>
  );
};

export default AppInfo;
