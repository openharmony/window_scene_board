/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * 应用接续配置项（因为应用接续换了新接口，新接口中不提供之前相应的枚举，让自定义，这块可能会因为接口方改了枚举值而影响逻辑，具体可咨询
 * “分布式硬件子系统设备管理模块”）
 */
export const enum ContinueTypeEnum {
  DEVICE_TYPE_PHONE_STRING = 'PHONE', // 手机
  DEVICE_TYPE_PAD_STRING = 'PAD', // PAD
  DEVICE_TYPE_PC_STRING = 'PC', //PC
  DEVICE_TYPE_2IN1_STRING = '2IN1',
  DEVICE_TYPE_WATCH_STRING = 'WATCH',
  DEVICE_TYPE_SMARTSCREEN_STRING = 'SMARTSCREEN'
}

export const enum ContinueTypeNumEnum {
  DEVICE_TYPE_UNKNOWN = 0x00, // Indicates an unknown device type.
  DEVICE_TYPE_WIFI_CAMERA = 0x08, // Indicates a smart camera.
  DEVICE_TYPE_AUDIO = 0x0A, // Indicates a smart speaker.
  DEVICE_TYPE_PC = 0x0C, // Indicates a smart pc.
  DEVICE_TYPE_PHONE = 0x0E, // Indicates a smart phone.
  DEVICE_TYPE_PAD = 0x11, // Indicates a smart pad.
  DEVICE_TYPE_WATCH = 0x6D, // Indicates a smart watch.
  DEVICE_TYPE_CAR = 0x83, // Indicates a car.
  DEVICE_TYPE_SMART_DISPLAY = 0xA02, // Indicates smart display
  DEVICE_TYPE_2IN1 = 0xA2F // Indicates 2in1
}