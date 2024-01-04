import React, { useEffect, useState } from 'react'
import appstore from '../../img/appstore.png'
import googleplay from '../../img/googleplay.png'
import mainlogo from '../../img/MainLogo.png'
import arrow from '../../img/arrow.png'
import './Banner.css'


const Banner = () => {

    const [isChatModalOpen, setIsChatModalOpen] = useState(false);
    const [isOrderModalOpen, setIsOrderModalOpen] = useState(false);

    const [userInput, setUserInput] = useState('');
    const [modalContent, setModalContent] = useState('');
    const [isModalOpen, setIsModalOpen] = useState(false);

    const handleInputChange = (e) => {
        setUserInput(e.target.value);
    };

    const handleSubmit = () => {
        let newModalContent = [...modalContent];

        // 사용자 입력을 답변 목록에 추가합니다.
        if (userInput.toLowerCase().includes('제품')) {
            newModalContent.push('제품에 대한 정보입니다.');
        } else if (userInput.toLowerCase().includes('서비스')) {
            newModalContent.push('서비스 정보입니다.');
        } else {
            newModalContent.push('죄송합니다. 이에 대한 답변을 찾을 수 없습니다.');
        }

        setModalContent(newModalContent);
        setIsModalOpen(true);
        setUserInput(''); // 입력창 비우기
    };

    const chatmodalOnOff = () => {
        if (isChatModalOpen) {
            setIsChatModalOpen(false);
        } else {
            setIsChatModalOpen(true);
        }
    }

    const ordermodalOnOff = () => {
        if (isOrderModalOpen) {
            setIsOrderModalOpen(false);
        } else {
            setIsOrderModalOpen(true);
        }
    }

    const orderCompletedAlert = () => {
        // 주문 완료 알림창을 띄웁니다.
        alert('주문이 완료되었습니다!');
        setIsOrderModalOpen(false);
    }


    useEffect(() => {
        const handleScroll = () => {
            // const advElements = document.querySelectorAll('.banner')[0];
            const advElements = document.querySelector('.banner')
            const scrollPosition = window.scrollY;
            const triggerPosition = 150;

            if (scrollPosition > triggerPosition) {
                advElements.style.transitionDelay = '0.2s';
                advElements.classList.add('visible');
            } else {
                advElements.style.transitionDelay = '0.2s';
                advElements.classList.remove('visible');
            }

        };
        window.addEventListener('scroll', handleScroll);

        return () => {
            window.removeEventListener('scroll', handleScroll)
        };
    }, []);
    return (
        <div className='banner'>

            <div type='button' className='chatbot-button' onClick={chatmodalOnOff}>
                <p>구매 상담</p>
            </div>

            {isChatModalOpen && (
                <div className='chatbotmodal'>
                    <div className='chatbotmodal-content'>
                        <div className='chatbotmodal-bot'>
                            {/* 모달 내용 */}
                            <p>모달 내용</p>
                            {isModalOpen && (
                                <div className='chatbotmodal-request'>
                                    <div className='chatbotmodal-request-content'>
                                        {modalContent.map((content, index) => (
                                            <p key={index}>{content}</p>
                                        ))}
                                    </div>
                                </div>
                            )}
                        </div>
                        <div className='chatbotmodal-user'>
                            <input type="text" value={userInput} onChange={handleInputChange} />
                            <button onClick={handleSubmit}>질문하기</button>
                        </div>
                    </div>
                </div>
            )}

            {isOrderModalOpen && (
                <div className='ordermodal StyledDiv'>
                    <span type='button' className='ordermodal-close' onClick={ordermodalOnOff}>&times;</span>
                    <h2 className='StyledH2'>Apill 주문 페이지</h2>
                    <form className='ordermodal-content StyledForm'>
                        {/* 모달 내용 */}
                        {/* <span className='close' onClick={closeModal}>&times;</span> */}
                        <div className='StyledDiv'>
                            <label className='StyledLabel'>주문자 성명</label>
                            <input
                                className='StyledInput'
                                // type=''
                                // value={}
                                placeholder='이름을 입력하세요'
                            />
                        </div>
                        <div className='StyledDiv'>
                            <label className='StyledLabel'>주소</label>
                            <input
                                className='StyledInput'
                                // type=''
                                // value={}
                                placeholder='주소를 입력하세요'
                            />
                        </div>
                        <div className='StyledDiv'>
                            <label className='StyledLabel'>핸드폰 번호</label>
                            <input
                                className='StyledInput'
                                // type=''
                                // value={}
                                placeholder='번호를 입력하세요'
                            />
                        </div>
                        <div className='StyledDiv'>
                            <label className='StyledLabel'>상품 갯수</label>
                            <select
                                className='StyledSelect'
                            // type=''
                            // value={}
                            >
                                <option value="선택" disabled>선택</option>
                                <option value="1">1개</option>
                                <option value="2">2개</option>
                                <option value="3">3개</option>
                                <option value="4">4개</option>
                                <option value="5">5개</option>
                                <option value="6">6개</option>
                                <option value="7">7개</option>
                                <option value="8">8개</option>
                                <option value="9">9개</option>
                                <option value="10">10개</option>
                            </select>
                        </div>
                        <button type='submit' className='StyledButton' onClick={orderCompletedAlert}>상품주문!!</button>
                    </form>
                </div>

            )}

            <div className='wholeLR'>
                <div type='button' className='left-grp' onClick={ordermodalOnOff}>
                    <img className='bannerMainLogo' src={mainlogo} alt='logo' />
                    <div className='orderText'>
                        <span className='type1'>A-pill로 힐링하고 싶다면</span>
                        <h3 className='type2'>주문 문의 버튼 클릭!</h3>
                    </div>

                    <img className='arrow' src={arrow} alt='arrow' />

                </div>



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