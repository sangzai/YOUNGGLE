import { useEffect, useState } from "react";
import React from 'react';
import './Slider.css';

const Slider = ({ images }) => {
    const [currentIndex, setCurrentIndex] = useState(0);

    useEffect(() => {
        const interval = setInterval(() => {
            setCurrentIndex((prevIndex) => (prevIndex + 1) % images.length);
        }, 2000);

        return () => clearInterval(interval);
    }, [currentIndex, images.length]);

    return (
        <div className="slider">
            {images.map((image, index) => {
                const position = getPosition(index, currentIndex, images.length);
                return (
                    <div
                        key={index}
                        className={`slideTarget ${position} target${index}`}
                    >
                        <img className='target' src={image} alt={`Slide ${index + 1}`} />
                    </div>
                );
            })}
        </div>
    );
};

// 슬라이드의 위치를 결정하는 함수
const getPosition = (index, currentIndex, length) => {
    if (currentIndex === 0) {
        if (index === 0) {
            return 'center';
        } else if (index === 1) {
            return 'right1';
        } else if (index === 2) {
            return 'right2';
        } else if (index === 3) {
            return 'left2';
        } else if (index === 4) {
            return 'left1';
        }
    } else if (currentIndex === 1) {
        if (index === 0) {
            return 'left1';
        } else if (index === 1) {
            return 'center';
        } else if (index === 2) {
            return 'right1';
        } else if (index === 3) {
            return 'right2';
        } else if (index === 4) {
            return 'left2';
        }
    } else if (currentIndex === 2) {
        if (index === 0) {
            return 'left2';
        } else if (index === 1) {
            return 'left1';
        } else if (index === 2) {
            return 'center';
        } else if (index === 3) {
            return 'right1';
        } else if (index === 4) {
            return 'right2';
        }
    } else if (currentIndex === 3) {
        if (index === 0) {
            return 'right2';
        } else if (index === 1) {
            return 'left2';
        } else if (index === 2) {
            return 'left1';
        } else if (index === 3) {
            return 'center';
        } else if (index === 4) {
            return 'right1';
        }
    } else if (currentIndex === 4) {
        if (index === 0) {
            return 'right1';
        } else if (index === 1) {
            return 'right2';
        } else if (index === 2) {
            return 'left2';
        } else if (index === 3) {
            return 'left1';
        } else if (index === 4) {
            return 'center';
        }
    }

    // if (currentIndex ==== index) {
    //     return 'center';
    // } else if (index < currentIndex) {
    //     return 'left';
    // } else if (index ==== 0 && currentIndex ==== length - 1) {
    //     // 오른쪽으로 넘어가는 경우 (맨 마지막 슬라이드에서 첫 번째 슬라이드로)
    //     return 'right';
    // } else if (index > currentIndex) {
    //     // 오른쪽으로 넘어가는 경우
    //     return 'right';
    // } else if (index ==== length - 1 && currentIndex ==== 0) {
    //     // 왼쪽으로 넘어가는 경우 (맨 처음 슬라이드에서 마지막 슬라이드로)
    //     return 'left';
    // } else {
    //     // 왼쪽으로 넘어가는 경우
    //     return 'left';
    // }
};


export default Slider;
