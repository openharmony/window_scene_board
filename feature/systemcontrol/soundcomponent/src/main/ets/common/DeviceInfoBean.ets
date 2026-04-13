/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
 * 耳机信息
 */
export class DeviceInfoBean {
  /**
   * 设备名，如：OpenHarmony FreeBuds Pro 3
   */
  public deviceName: string = '';
  /**
   * 加密后设备sn号
   */
  public sn: string = '';
  /**
   * 设备型号ID,可以用此值来查询对应的设备
   */
  public modelId: string = '';
  /**
   * 产品子型号ID，查询对应设备颜色
   */
  public subModelId: string = '';
  /**
   * 设备软件版本号
   */
  public deviceSoftVersion: string = '';
  /**
   * 设备修改名
   */
  public modifyName: string = '';
  /**
   * 设备mac
   */
  public deviceMac: string = '';
  /**
   * 设备蓝牙地址
   */
  public deviceBtMac: string = '';

  /**
   * 设备星闪右耳地址
   */
  public deviceRightSleMac: string = '';

  /**
   * 设备星闪左耳地址
   */
  public deviceLeftSleMac: string = '';
}