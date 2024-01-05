import React, { useEffect, useState, useRef } from 'react'
import appstore from '../../img/appstore.png'
import googleplay from '../../img/googleplay.png'
import mainlogo from '../../img/MainLogo.png'
import arrow from '../../img/arrow.png'
import './Banner.css'
import xmark from '../../img/xmark.png'
import chatIcon from '../../img/chatbotIcon.png'

const Banner = () => {
    const [isChatModalOpen, setIsChatModalOpen] = useState(false);
    const [isOrderModalOpen, setIsOrderModalOpen] = useState(false);

    const [userInput, setUserInput] = useState('');
    let [modalContent, setModalContent] = useState([]);
    let newModalContent = [...modalContent];

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
            newModalContent.push(['bot', '다음은 A-pill 설명입니다.']);
            newModalContent.push(['bot', [
                <div >
                    &nbsp;<b> A-pill</b>은 스마트베개로 음성인터페이스를 통한 노래 재생, 날씨 알림, 알람 설정 등 다양한 기능을 장착해 편의를 제공합니다.  <br /> &nbsp; 주목할 것은 수면 모니터링을 통해 세심한 베개 높이 조정을 하여 사용자 맞춤형 최적높이를 제공한다는 점입니다. <br /> &nbsp; 이는 TheTech 유일무이한 기술로 여러분의 편안한 숙면을 책임지는 데 큰 역할을 할 것입니다.
                </div>]
            ]);
        } else if (userInput.includes('서비스') || userInput.includes('기능')) {
            newModalContent.push(['bot', 'A-pill이 제공하는 서비스 정보입니다.']);
            newModalContent.push('function');
        } else if (userInput.includes('질문')) {
            newModalContent.push(['bot', '아래에 있는 질문인가요?']);
            newModalContent.push('question');
        }
        else {
            newModalContent.push(['bot', '죄송합니다. 이에 대한 답변을 찾을 수 없습니다.']);
        }

        setModalContent(newModalContent);
        // setIsModalOpen(true);
        setUserInput(''); // 입력창 비우기
    };


    const handleButtonClick = (e) => {


        let buttonText = e.target.innerText;
        console.log('내가 누른 버튼', buttonText)

        if (buttonText === "제품 설명") {
            newModalContent.push(['client', buttonText])
            newModalContent.push(['bot', [
                <div >
                    &nbsp; <b>A-pill</b>은 스마트베개로 음성인터페이스를 통한 노래 재생, 날씨 알림, 알람 설정 등 다양한 기능을 장착해 편의를 제공합니다.  <br /> &nbsp; 주목할 것은 수면 모니터링을 통해 세심한 베개 높이 조정을 하여 사용자 맞춤형 최적높이를 제공한다는 점입니다. <br /> &nbsp; 이는 TheTech 유일무이한 기술로 여러분의 편안한 숙면을 책임지는 데 큰 역할을 할 것입니다.
                </div>]
            ]);
        } else if (buttonText === "제품 기능") {
            newModalContent.push(['client', buttonText])
            newModalContent.push("function");
        } else if (buttonText === "자주하는 질문") {
            newModalContent.push(['client', buttonText])
            newModalContent.push("question");
        } else if (buttonText === "높이 설정") {
            newModalContent.push(['client', buttonText])
            newModalContent.push(['bot', [
                <div >
                    <b>높이 설정</b>은 음성과 어플을 통해 가능합니다. 자동으로 사용자 체형을 분석해 알맞은 베개 높이를 제공하며 추가로 수동 조정도 가능합니다.
                </div>]
            ]);
        } else if (buttonText === "알람 설정") {
            newModalContent.push(['client', buttonText])
            newModalContent.push(['bot', [
                <div >
                    <b>알람 설정</b>은 기본적으로 어플을 통해 설정 및 수정이 가능합니다. 또 음성을 통한 알람 설정 및 타이머 설정이 가능해 편리성을 높였습니다.
                </div>]
            ]);
        } else if (buttonText === "음성 서비스") {
            newModalContent.push(['client', buttonText])
            newModalContent.push(['bot', [
                <div >
                    <b>음성 서비스</b>를 통해 노래 재생, 알람 설정이 가능하며 기상 후에 자동으로 날씨를 브리핑해주는 편리함을 제공합니다. 높이 설정 또한 음성 명령으로 가능하니 어플없이도 사용가능합니다.
                </div>]
            ]);
        } else if (buttonText === "추천 대상") {
            newModalContent.push(['client', buttonText])
            newModalContent.push(['bot', [
                <div >
                    이런 분들에게 추천합니다.<br /><br />
                    ● 평소 베개가 <b>본인 체형에 맞지 않아 불편함</b>을 느꼈왔던 사람<br />
                    ●  <b>자세에 따른 베개 높이 조절</b>이 되지 않는 기존 제품에 불만이 있는 사람 <br />
                    ● <b>잠자리가 불편해</b> 피로가 누적되고 있는 사람<br />
                </div>]
            ]);
        } else if (buttonText === "앱 설치 가능 기종") {
            newModalContent.push(['client', buttonText])
            newModalContent.push(['bot', [
                <div >
                    현재 ios는 개발 중으로 안드로이드 운영체재의 경우 설치 가능합니다.
                </div>
            ]
            ]);
        } else if (buttonText === "세탁 가능 여부") {
            newModalContent.push(['client', buttonText])
            newModalContent.push(['bot', [
                <div >
                    베개 자체를 세탁하기에는 어려움이 있으나 베개 커버는 세탁 가능합니다.
                </div>]
            ]);
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
            setModalContent([]);
            setIsChatModalOpen(false);
        } else {
            newModalContent.push(['bot', [
                <div >
                    안녕하세요, 고객님!<br />
                    TheTech에 오신걸 환영합니다!
                </div>
            ]
            ]);
            defaultContent();
            setIsChatModalOpen(true);
        }
    }

    const defaultContent = () => {
        newModalContent.push("default")
        setModalContent(newModalContent);

    }

    useEffect(() => {
        const chatContainer = document.querySelector('.chatbotmodal-bot');

        // chatContainer가 존재하고 scrollHeight가 정의되어 있는지 확인
        if (chatContainer && chatContainer.scrollHeight !== undefined) {
            // 스크롤을 최하단으로 이동
            chatContainer.scrollTop = chatContainer.scrollHeight;
        }
    }, [modalContent]);


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

    const ordermodalOnOff = () => {
        if (isOrderModalOpen) {
            setIsOrderModalOpen(false);
        } else {
            setIsOrderModalOpen(true);

        }
    }

    const [name, setName] = useState('');
    const [nameCheck, setNameCheck] = useState(false);
    const [address, setAddress] = useState('');
    const [addressCheck, setAddressCheck] = useState(false);
    const [phoneNumber, setPhoneNumber] = useState('');
    const [phoneNumberCheck, setPhoneNumberCheck] = useState(false);
    const [mount, setMount] = useState('');
    const [mountCheck, setMountCheck] = useState(false);
    const [messageForm, setMessageForm] = useState('');
    const [isValidForm, setIsValidForm] = useState(true);

    useEffect(() => {
        if (name == '') {
            setMessageForm('이름을 입력해주세요.')
            setIsValidForm(true);
        } else if (address === '') {
            setMessageForm('주소를 입력해주세요.')
            setIsValidForm(true);
        } else if (phoneNumber === '') {
            setMessageForm('핸드폰 번호를 입력해주세요.')
            setIsValidForm(true);
        } else if (mount === '' || mount === '선택') {
            setMessageForm('수량을 선택해주세요.')
            setIsValidForm(true);
        } else {
            setMessageForm('항목을 다 채웠습니다. 회원가입이 가능합니다.')
            setIsValidForm(false);
        }
    })

    const orderCompletedAlert = () => {
        if (isValidForm) {
            alert('항목을 다 채워주세요!');
            setIsOrderModalOpen(false);
        } else {
            alert('주문이 완료되었습니다!');
            // setIsOrderModalOpen(false);
        }

    }


    return (
        <div className='banner'>
            <div className={isChatModalOpen ? 'chatbot-btn-not' : 'chatbot-btnn'}>
                <img
                    onClick={chatmodalOnOff}
                    className={isChatModalOpen ? 'chatbot-button x' : 'chatbot-button chat'}
                    src={isChatModalOpen ? xmark : chatIcon}
                >
                </img>
                <p className='chatbot-button-name'>상품 문의&nbsp;</p>
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
                                    if (content === "default") {
                                        return (
                                            <div className='chatbotmodal-request-bot' key={index}>
                                                <div className='chatbotmodal-request-bot-image' />
                                                <div className='chatbotmodal-request-bot-answer'>
                                                    <div key={index}>
                                                        어떤 정보를 원하시나요?
                                                        <button className='chatbot-btn btn1' onClick={handleButtonClick}>제품 설명</button> <br />
                                                        <button className='chatbot-btn' onClick={handleButtonClick}>제품 기능</button> <br />
                                                        <button className='chatbot-btn' onClick={handleButtonClick}>자주하는 질문</button>
                                                    </div>
                                                </div>
                                            </div>

                                        )
                                    } else if (content === "function") {
                                        return (
                                            <div className='chatbotmodal-request-bot' key={index}>
                                                <div className='chatbotmodal-request-bot-image' />
                                                <div className='chatbotmodal-request-bot-answer'>
                                                    <div >
                                                        제품 기능을 소개합니다. <br />원하는 세부 기능을 눌러주세요!
                                                        <button className='chatbot-btn btn1' onClick={handleButtonClick}>높이 설정</button><br />
                                                        <button className='chatbot-btn' onClick={handleButtonClick}>알람 설정</button><br />
                                                        <button className='chatbot-btn' onClick={handleButtonClick}>음성 서비스</button>
                                                    </div>
                                                </div>
                                            </div>

                                        )
                                    } else if (content === "question") {
                                        return (
                                            <div className='chatbotmodal-request-bot' key={index}>
                                                <div className='chatbotmodal-request-bot-image' />
                                                <div className='chatbotmodal-request-bot-answer'>
                                                    <div >
                                                        다음은 자주 문의하시는 <br />질문입니다.
                                                        <button className='chatbot-btn btn1' onClick={handleButtonClick}>추천 대상</button><br />
                                                        <button className='chatbot-btn' onClick={handleButtonClick}>앱 설치 가능 기종</button><br />
                                                        <button className='chatbot-btn' onClick={handleButtonClick}>세탁 가능 여부</button>
                                                    </div>
                                                </div>
                                            </div>

                                        )
                                    } else if (content[0] === 'client') {
                                        console.log('client')
                                        return (
                                            <div className='chatbotmodal-request-user' key={index}>
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
                                onChange={(e) => setName(e.target.value)}
                            />
                        </div>
                        <div className='StyledDiv'>
                            <label className='StyledLabel'>주소</label>
                            <input
                                className='StyledInput'
                                // type=''
                                // value={}
                                placeholder='주소를 입력하세요'
                                onChange={(e) => setAddress(e.target.value)}
                            />
                        </div>
                        <div className='StyledDiv'>
                            <label className='StyledLabel'>핸드폰 번호</label>
                            <input
                                className='StyledInput'
                                // type=''
                                // value={}
                                placeholder='번호를 입력하세요'
                                onChange={(e) => setPhoneNumber(e.target.value)}
                            />
                        </div>
                        <div className='StyledDiv'>
                            <label className='StyledLabel'>상품 갯수</label>
                            <select
                                className='StyledSelect'
                                // type=''
                                // value={}
                                onChange={(e) => setMount(e.target.value)}
                            >
                                <option value="선택">선택</option>
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
                        <div className='StyledP' style={{ color: isValidForm ? 'red' : 'green' }}>
                            {messageForm}
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