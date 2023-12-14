import { useEffect } from "react"
import React from 'react'
import "./ProductInfo.css"
import product from './img/apill.png'

const ProductInfo = () => {
    useEffect(() => {
        const handleScroll = () => {
            const advElements = document.querySelectorAll('.product-adv1, .product-adv2, .product-adv3, .product-adv4, .product-adv5, .product-adv6');
    
            const firstElement = advElements[0];
            const top = firstElement.getBoundingClientRect().top;
            const windowHeight = window.innerHeight;
    
            if (top < windowHeight * 0.75) {
                advElements.forEach((element, index) => {
                    element.style.transitionDelay = `${index * 0.2}s`;
                    element.classList.add('visible');
                });
            }
        };    

        window.addEventListener('scroll', handleScroll);

        return () => {
            window.removeEventListener('scroll', handleScroll);
        };
    }, []);
    
    return (
        <div className='productinfo'>
            <div className='productinfo-left-section'>
                <div className='productinfo-left-top-circle' />
            </div>
            <div className='productinfo-right-section'>
                <div className='productinfo-right-bottom-circle' />
            </div>
            <div className='product'>
                <div className='product-left-diagonal'/>
                <div className='product-right-diagonal'/>
                <div className='product-main-hole1'></div>  
                <div className='product-main-hole2'></div>  
                <div className='product-main'>
                    <div className='product-main-deco1'></div>
                    <div className='product-main-deco2'></div>
                    <div className='product-main-deco3'></div>
                    <div className='product-main-deco4'></div>
                    <p className='product-name' style={{lineHeight: '1.5'}}>
                        <strong className="producthighlight productprimaryHighlight">A-pill</strong>
                    </p>
                    <img className='product-img' src={product} alt="" />
                </div>
            </div>
            <div className='product-text-box'>
                <p className='product-text' style={{lineHeight: '1.5'}}>
                    <strong className="producthighlight productprimaryHighlight1">Good Choice</strong>
                    &nbsp;
                    for&nbsp; 
                    <strong className="producthighlight productprimaryHighlight2">Honey Sleep</strong>
                    <br/>
                    <span>당신에게 편안한 잠을 선사해드립니다.</span>
                </p>
                <p className='product-text-name' style={{lineHeight: '1.5'}}>
                    <strong className="producthighlight productprimaryHighlight">A-pill</strong>
                </p>
            </div>
            <div className='product-adv1'></div>
            <div className='product-adv2'></div>
            <div className='product-adv3'></div>
            <div className='product-adv4'></div>
            <div className='product-adv5'></div>
            <div className='product-adv6'></div>
        </div>
    )
}

export default ProductInfo