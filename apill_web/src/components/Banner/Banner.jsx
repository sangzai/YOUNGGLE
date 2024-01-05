import React, { useEffect, useState, useRef } from 'react'
import appstore from '../../img/appstore.png'
import googleplay from '../../img/googleplay.png'
import mainlogo from '../../img/MainLogo.png'
import arrow from '../../img/arrow.png'
import './Banner.css'


const Banner = () => {
    const [isChatModalOpen, setIsChatModalOpen] = useState(false);
    const [isOrderModalOpen, setIsOrderModalOpen] = useState(false);

    const [userInput, setUserInput] = useState('');
    let [modalContent, setModalContent] = useState([]);
    let [clientContent, setClientContent] = useState([]);
    let newModalContent = [...modalContent];
    // const [isModalOpen, setIsModalOpen] = useState(true);

    // const YourChatComponent = ({ modalContent }) => {
    //     const chatContainerRef = useRef(null);
    //     if (modalContent){
    //     useEffect(() => {
    //         // chatContainerRef가 존재하고 scrollHeight가 정의되어 있는지 확인
    //         if (chatContainerRef.current && chatContainerRef.current.scrollHeight !== undefined) {
    //             // 스크롤을 최하단으로 이동
    //             chatContainerRef.current.scrollTop = chatContainerRef.current.scrollHeight;
    //         }
    //     }, [modalContent])}; // content가 업데이트될 때마다 useEffect 실행
    //     return (
    //         <div className='chatbotmodal-request' ref={chatContainerRef}>
    //             {/* content를 여기에 렌더링하는 로직이 있어야 함 */}
    //         </div>
    //     );
    // };
    const handleInputChange = (e) => {
        setUserInput(e.target.value);
    };

    const handleSubmit = () => {

        // 사용자 입력을 답변 목록에 추가합니다.
        newModalContent.push(['client', userInput])
        if (userInput.includes('제품')) {
            newModalContent.push(['bot','제품에 대한 정보입니다.']);
        } else if (userInput.includes('서비스')) {
            newModalContent.push(['bot','서비스 정보입니다.']);
        } else {
            newModalContent.push(['bot','죄송합니다. 이에 대한 답변을 찾을 수 없습니다.']);
        }

        setModalContent(newModalContent);
        // setIsModalOpen(true);
        setUserInput(''); // 입력창 비우기
    };


    const handleButtonClick = (event) => {
        console.log(event.target.innerText);

        let buttonText = event.target.innerText;
        if (buttonText === "제품 설명") {
            newModalContent.push(['client', buttonText])
            newModalContent.push(['bot', [
                <div >
                    &nbsp; A-pill은 스마트베개로 음성인터페이스를 통한 노래 재생, 날씨 알림, 알람 설정 등 다양한 기능을 장착해 편의를 제공합니다.  <br /> &nbsp; 주목할 것은 수면 모니터링을 통해 세심한 베개 높이 조정을 하여 사용자 맞춤형 최적높이를 제공한다는 점입니다. <br /> &nbsp; 이는 TheTech 유일무이한 기술로 여러분의 편안한 숙면을 책임지는 데 큰 역할을 할 것입니다.
                </div>]
            ]);
        } else if (buttonText === "제품 기능") {
            newModalContent.push(['client', buttonText])
            newModalContent.push(['bot', [
                <div >
                    제품 기능을 소개합니다. <br />원하는 세부 기능을 눌러주세요!
                    <button className='chatbot-btn btn1' onClick={handleButtonClick}>높이 설정</button><br />
                    <button className='chatbot-btn' onClick={handleButtonClick}>알람 설정</button><br />
                    <button className='chatbot-btn' onClick={handleButtonClick}>음성 서비스</button>
                </div>
            ]
            ]);
        } else if (buttonText === "찾아오는 길") {
            newModalContent.push(['client', buttonText])
            newModalContent.push(['bot', '주소: 광주광역시 동구 예술길 31-15 4층 스마트인재개발원 ']);
            // 사진도 넣어야 함
            // 기능 
        } else if (buttonText === "높이 설정") {
            console.log('here');
            newModalContent.push(['client', buttonText])
            newModalContent.push(['bot', '높이 설정 설명']);
        } else if (buttonText === "알람 설정") {
            newModalContent.push(['client', buttonText])
            newModalContent.push(['bot', '알람 설정 설명']);
        } else if (buttonText === "음성 서비스") {
            newModalContent.push(['client', buttonText])
            newModalContent.push(['bot', '음성 서비스 설명']);
        }

        // setClientContent(newClientContent);
        setModalContent(newModalContent);
        console.log(modalContent);
    }
    const handleKeyPress = (e) => {
        // 엔터 키가 눌렸을 때
        if (e.key === 'Enter') {
            handleSubmit(); // 또는 원하는 함수 호출
        }
    };

    const chatmodalOnOff = () => {
        if (isChatModalOpen) {
            setIsChatModalOpen(false);
        } else {
            defaultContent();
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

    const defaultContent = () => {
        // let newClientContent = [];
        // let newModalContent = [];
        newModalContent.push("default")
        setModalContent(newModalContent);

    }

    // useEffect(() => {
    //     if (!isChatModalOpen) {
    //         defaultContent();
    //     }
    // }
    //     , []);



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

            <div
                type='button' className='chatbot-button' onClick={chatmodalOnOff}
                style={{ paddingInline: isChatModalOpen ? '25px' : '10px' }}
            >
                <b>{isChatModalOpen ? 'X' : '구매 상담'}</b>
            </div>

            {isChatModalOpen && (
                <div className='chatbotmodal'>
                    <div className='chatbotmodal-content'>
                        <div className='chatbotmodal-bot'>
                            {/* {isModalOpen && ( */}
                            {/* <div className='chatbotmodal-client' > */}

                            {/* </div> */}
                            <div className='chatbotmodal-request'>
                                {/* {clientContent.map((content, index) => (
                                    <div className='chatbotmodal-request-bot' key={index}>
                                        <div className='chatbotmodal-request-bot-image' />
                                        <div className='client'>
                                            {content.buttonText}
                                        </div>
                                    </div>
                                ))} */}
                                {/* modalcontent = ["default", "제품설명", "설명"]
                                modalcontent = ["default", [client, "제품설명"], [bot, "설명"]]*/}
                                {modalContent.map((content, index) => {
                                    if (content == "default") {
                                        return (
                                            <div className='chatbotmodal-request-bot' key={index}>
                                                <div className='chatbotmodal-request-bot-image' />
                                                <div className='chatbotmodal-request-bot-answer'>
                                                    <div key={index}>
                                                        안녕하세요! <br />TheTech의 A-pill입니다.<br /> 원하는 정보를 눌러주세요!
                                                        <button className='chatbot-btn btn1' onClick={handleButtonClick}>제품 설명</button> <br />
                                                        <button className='chatbot-btn' onClick={handleButtonClick}>제품 기능</button> <br />
                                                        <button className='chatbot-btn' onClick={handleButtonClick}>찾아오는 길</button>
                                                    </div>
                                                </div>
                                            </div>

                                        )
                                    } else if (content[0] == 'client') {
                                        return (
                                            <div className='chatbotmodal-request-user' key={index}>
                                                {/* <div className='chatbotmodal-request-bot-image' /> */}
                                                <div className='client'>
                                                    {content[1]}
                                                </div>
                                            </div>
                                        );
                                    } else {
                                        return (
                                            <div className='chatbotmodal-request-bot' key={index}>
                                                <div className='chatbotmodal-request-bot-image' />
                                                <div className='chatbotmodal-request-bot-answer'>
                                                    {content[1]}
                                                </div>
                                            </div>
                                        );
                                    }
                                })}



                            </div>
                            {/* )} */}
                        </div>
                        <div className='chatbotmodal-user'>
                            <button className='chatbotmodal-home' onClick={defaultContent} />
                            <input className='chatbotmodal-chat' type="text" value={userInput}
                                onChange={handleInputChange} onKeyPress={handleKeyPress}
                                placeholder='원하는 버튼 클릭!' />
                            <button className='chatbotmodal-send' onClick={handleSubmit} />
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

export default Banner;