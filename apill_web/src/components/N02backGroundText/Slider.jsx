import { useEffect, useState } from "react"
import React from 'react'
import './Slider.css'

const Slider = ({images}) => {
    const [currentIndex, setCurrentIndex]=useState(0);
    useEffect(()=>{
        const interval = setInterval(()=>{
        // 이미지 이동시키는 로직
        setCurrentIndex((preIndex)=>(preIndex+1)%images.length);
        },2000);

        return ()=> clearInterval(interval);
    },[currentIndex, images.length]);

    return (
    <div className="slider">
        {images.map((image, index) => (
            <div
                key={index}
                className={`slide ${
                    index === currentIndex ? 'center' : index < currentIndex ? 'left' : 'right'
                }`}
            >
                <img className="target" src={image} alt={`Slide ${index + 1}`} />
            </div>
        ))}
    </div>
);

}

export default Slider
// 이미지 좌우로 이동하면서 크기 형식을 슬라이드