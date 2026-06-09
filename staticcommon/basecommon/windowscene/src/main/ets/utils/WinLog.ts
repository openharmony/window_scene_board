/**
 * Copyright (c) Huawei Device Co., Ltd. 2025-2025. All rights reserved.
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
import hilog from '@ohos.hilog';

const UPPER_CALLER_DEPTH = 3;
type AnyType = string | boolean | number | bigint | null | object | undefined;

export enum WinLogDomain {
  WMS_DEFAULT = 0x04200,
  DMS = 0x04201,
  WMS_MAIN = 0x04202,
  WMS_SUB = 0x04203,
  WMS_SCB = 0x04204, // WINDOW SCB的零层控件
  WMS_DIALOG = 0x04205,
  WMS_SYSTEM = 0x04206,
  WMS_FOCUS = 0x04207,
  WMS_LAYOUT = 0x04208,
  WMS_IMMS = 0x04209,
  WMS_LIFE = 0x0420A,
  WMS_KEYBOARD = 0x0420B,
  WMS_EVENT = 0x0420C,
  WMS_UIEXT = 0x0420D,
  WMS_PIP = 0x0420E,
  WMS_RECOVER = 0x0420F,
  WMS_MULTI_USER = 0x04210,
  WMS_TOAST = 0x04211,
  WMS_MULTI_WINDOW = 0x04212,
  WMS_INPUT_KEY_FLOW = 0x04213,
  WMS_PIPELINE = 0x04214,
  WMS_HIERARCHY = 0x04215,
  WMS_PATTERN = 0x04216,
  WMS_ATTRIBUTE = 0x04217,
  WMS_PC = 0x04218,
  WMS_DECOR = 0x04219,
  WMS_LAYOUT_PC = 0x0421A,
  WMS_STARTUP_PAGE = 0x0421B,
  WMS_COMPAT = 0x0421C,
  WMS_ROTATION = 0x0421D,
  WMS_ANIMATION = 0x0421E,
  WMS_MULTI_SPLIT = 0x0421F,
  WMS_MULTI_FLOAT = 0x04220,
  WMS_MULTI_MID = 0x04221,
};

export enum WinDomainName {
  WMS_DEFAULT = 'WMS',
  DMS = 'DMS',
  WMS_MAIN = 'WMSMain',
  WMS_SUB = 'WMSSub',
  WMS_SCB = 'WMSScb',
  WMS_DIALOG = 'WMSDialog',
  WMS_SYSTEM = 'WMSSystem',
  WMS_FOCUS = 'WMSFocus',
  WMS_LAYOUT = 'WMSLayout',
  WMS_IMMS = 'WMSImms',
  WMS_LIFE = 'WMSLife',
  WMS_KEYBOARD = 'WMSKeyboard',
  WMS_EVENT = 'WMSEvent',
  WMS_UIEXT = 'WMSUiext',
  WMS_PIP = 'WMSPiP',
  WMS_RECOVER = 'WMSRecover',
  WMS_MULTI_USER = 'WMSMultiUser',
  WMS_TOAST = 'WMSToast',
  WMS_MULTI_WINDOW = 'WMSMultiWindow',
  WMS_INPUT_KEY_FLOW = 'InputKeyFlow',
  WMS_PIPELINE = 'WMSPipeLine',
  WMS_HIERARCHY = 'WMSHierarchy',
  WMS_PATTERN = 'WMSPattern',
  WMS_ATTRIBUTE = 'WMSAttribute',
  WMS_PC = 'WMSPc',
  WMS_DECOR = 'WMSDecor',
  WMS_LAYOUT_PC = 'WMSLayoutPc',
  WMS_STARTUP_PAGE = 'WMSStartupPage',
  WMS_COMPAT = 'WMSCompat',
  WMS_ROTATION = 'WMSRotation',
  WMS_ANIMATION = 'WMSAnimation',
  WMS_MULTI_SPLIT = 'WMSMultiSplit',
  WMS_MULTI_FLOAT = 'WMSMultiFloat',
  WMS_MULTI_MID = 'WMSMultiMidScene',
}

/**
 * Whether enables logs of each domain, used for debugging
 */
export const LOG_ENABLE_MAP: Map<WinLogDomain, boolean> = new Map([
  [WinLogDomain.WMS_DEFAULT, true],
  [WinLogDomain.DMS, true],
  [WinLogDomain.WMS_MAIN, true],
  [WinLogDomain.WMS_SCB, true],
  [WinLogDomain.WMS_SUB, true],
  [WinLogDomain.WMS_DIALOG, true],
  [WinLogDomain.WMS_SYSTEM, true],
  [WinLogDomain.WMS_FOCUS, true],
  [WinLogDomain.WMS_LAYOUT, true],
  [WinLogDomain.WMS_IMMS, true],
  [WinLogDomain.WMS_LIFE, true],
  [WinLogDomain.WMS_KEYBOARD, true],
  [WinLogDomain.WMS_EVENT, true],
  [WinLogDomain.WMS_UIEXT, true],
  [WinLogDomain.WMS_PIP, true],
  [WinLogDomain.WMS_RECOVER, true],
  [WinLogDomain.WMS_MULTI_USER, true],
  [WinLogDomain.WMS_TOAST, true],
  [WinLogDomain.WMS_MULTI_WINDOW, true],
  [WinLogDomain.WMS_INPUT_KEY_FLOW, true],
  [WinLogDomain.WMS_PIPELINE, true],
  [WinLogDomain.WMS_HIERARCHY, true],
  [WinLogDomain.WMS_PATTERN, true],
  [WinLogDomain.WMS_ATTRIBUTE, true],
  [WinLogDomain.WMS_PC, true],
  [WinLogDomain.WMS_DECOR, true],
  [WinLogDomain.WMS_LAYOUT_PC, true],
  [WinLogDomain.WMS_STARTUP_PAGE, true],
  [WinLogDomain.WMS_COMPAT, true],
  [WinLogDomain.WMS_ROTATION, true],
  [WinLogDomain.WMS_ANIMATION, true],
  [WinLogDomain.WMS_MULTI_SPLIT, true],
  [WinLogDomain.WMS_MULTI_FLOAT, true],
  [WinLogDomain.WMS_MULTI_MID, true],
]);

export class WinLogHelper {
  // domain	日志对应的领域标识，范围是0x0~0xFFFF，超出范围则日志无法打印
  private domainNumber: number = -1;
  // domain name 指定日志标识(tag)，可以为任意字符串，建议用于标识调用所在的类或者业务行为。tag最多为31字节，超出后会截断
  private domainName: string = '';
  
  private static instanceMap: Map<string, WinLogHelper> = new Map();

  private constructor(domain: WinLogDomain) {
    this.domainNumber = domain;
    const entries = Object.entries(WinDomainName);
    for (const entry of entries) {
      let key = entry[0];
      const value = entry[1];
      if (key === WinLogDomain[domain]) {
        this.domainName = value;
        return;
      }
    }
  }

  /**
   * 获取一个Logger实例
   *
   * @param domain 域参数
   */
  public static getWinLogHelper(domain: WinLogDomain): WinLogHelper {
    const key = `${domain}`;
    if (!WinLogHelper.instanceMap.has(key)) {
        WinLogHelper.instanceMap.set(key, new WinLogHelper(domain));
    }
    return WinLogHelper.instanceMap.get(key)!;
  }

  public info(format: string, ...args: AnyType[]): void {
    if (!LOG_ENABLE_MAP.has(this.domainNumber)) {
      return;
    }
    hilog.info(this.domainNumber, this.domainName, format, ...args);
  }

  public debug(format: string, ...args: AnyType[]): void {
    if (!LOG_ENABLE_MAP.has(this.domainNumber)) {
      return;
    }
    hilog.debug(this.domainNumber, this.domainName, format, ...args);
  }

  public warn(format: string, ...args: AnyType[]): void {
    if (!LOG_ENABLE_MAP.has(this.domainNumber)) {
      return;
    }
    hilog.warn(this.domainNumber, this.domainName, format, ...args);
  }

  public error(format: string, ...args: AnyType[]): void {
    if (!LOG_ENABLE_MAP.has(this.domainNumber)) {
      return;
    }
    hilog.error(this.domainNumber, this.domainName, format, ...args);
  }

  public fatal(format: string, ...args: AnyType[]): void {
    if (!LOG_ENABLE_MAP.has(this.domainNumber)) {
      return;
    }
    hilog.fatal(this.domainNumber, this.domainName, format, ...args);
  }
}

/**
 * Window domain log class
 */
export class WinLog {
  /**
   * Outputs info-level window logs.
   * 
   * @param logDomain Identifies the log domain.
   * @param format Indicates the log format string.
   * @param args Indicates the log parameters.
   */
  public static showInfo(logDomain: WinLogDomain, format: string, ...args: AnyType[]): void {
    const logger = WinLogHelper.getWinLogHelper(logDomain);
    logger.info(format, ...args);
  }

  /**
   * Outputs debug-level window logs.
   * 
   * @param logDomain Identifies the log domain.
   * @param format Indicates the log format string.
   * @param args Indicates the log parameters.
   */
  public static showDebug(logDomain: WinLogDomain, format: string, ...args: AnyType[]): void {
    const logger = WinLogHelper.getWinLogHelper(logDomain);
    logger.debug(format, ...args);
  }

  /**
   * Outputs warn-level window logs.
   * 
   * @param logDomain Identifies the log domain.
   * @param format Indicates the log format string.
   * @param args Indicates the log parameters.
   */
  public static showWarn(logDomain: WinLogDomain, format: string, ...args: AnyType[]): void {
    const logger = WinLogHelper.getWinLogHelper(logDomain);
    logger.warn(format, ...args);
  }

  /**
   * Outputs error-level window logs.
   * 
   * @param logDomain Identifies the log domain.
   * @param format Indicates the log format string.
   * @param args Indicates the log parameters.
   */
  public static showError(logDomain: WinLogDomain, format: string, ...args: AnyType[]): void {
    const logger = WinLogHelper.getWinLogHelper(logDomain);
    logger.error(format, ...args);
  }

  /**
   * Outputs fatal-level window logs.
   * 
   * @param logDomain Identifies the log domain.
   * @param format Indicates the log format string.
   * @param args Indicates the log parameters.
   */
  public static showFatal(logDomain: WinLogDomain, format: string, ...args: AnyType[]): void {
    const logger = WinLogHelper.getWinLogHelper(logDomain);
    logger.fatal(format, ...args);
  }
}