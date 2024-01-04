import { Fragment } from 'react'
import './FlyoutMenus.css'
import Mainslide from './Mainslide'
// 팀소개 페이지도 import해야함
import { Popover, Transition } from '@headlessui/react'
import { ChevronDownIcon, PhoneIcon, PlayCircleIcon } from '@heroicons/react/20/solid'
import React from 'react'


import {
  HomeIcon,
  DocumentTextIcon,
  DevicePhoneMobileIcon,
  CursorArrowRaysIcon,
  UsersIcon,
  SquaresPlusIcon,
} from '@heroicons/react/24/outline'

const MenuBar = [
  { name: '홈 화면', description: '메인화면 이동', to: 'main', icon: HomeIcon },
  { name: '제품 소개',  description: 'A-pill을 소개합니다',to: 'productinfo', icon: DocumentTextIcon },
  { name: "앱 소개", description: 'A-pill 어플을 소개합니다', to: 'appinfo', icon: DevicePhoneMobileIcon },
  { name: '찾아오시는 길', description: 'TheTech', to: '#', icon: UsersIcon },
]
export default function Menu() {
    
  return (
    <Popover className="relative">
      <Popover.Button className=" MenuIcon">
        <span>Menu</span>
      </Popover.Button>

      <Transition
        as={Fragment}
        enter="transition ease-out duration-200"
        enterFrom="opacity-0 translate-y-1"
        enterTo="opacity-100 translate-y-0"
        leave="transition ease-in duration-150"
        leaveFrom="opacity-100 translate-y-0"
        leaveTo="opacity-0 translate-y-1"
      >
        <Popover.Panel className="absolute right-[-40px] z-10 mt-5 flex w-screen max-w-max px-4">
          <div className="w-screen flex-auto overflow-hidden rounded-3xl bg-white text-sm leading-6 shadow-lg ring-1 ring-gray-900/5"
          style={{maxWidth:'23rem'}}>
            <div className="p-4">
              {MenuBar.map((item) => (
                <div key={item.name} className="group relative flex gap-x-6 rounded-lg p-4 hover:bg-gray-50">
                  <div className="icon mt-1 flex h-11 w-0.5 flex-none items-center justify-center rounded-lg bg-gray-50 group-hover:bg-white">
                    <item.icon className="h-6 w-6 text-gray-600 group-hover:text-indigo-600" aria-hidden="true" />
                  </div>
                  <div>
                    <a href={`#${item.to}`} className="font-semibold text-gray-900">
                      {item.name}
                      <span className="absolute inset-0" />
                    </a>
                    <p className="mt-1 text-gray-600">{item.description}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </Popover.Panel>
      </Transition>
    </Popover>
  )
}
