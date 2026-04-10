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

import util from '@ohos.util';
import securityManager from '@ohos.enterprise.securityManager';
import { BusinessError } from '@ohos.base';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { COMPLEXITY_STATUS, PcHiSysEventMgr } from '../../../common/manager/PcHiSysEventMgr';

/**
 * 密码最小长度
 */
export const LOCK_SCREEN_PSD_LENGTH_MIN: number = 6;

/**
 * 密码最大长度
 */
export const LOCK_SCREEN_PSD_LENGTH_MAX: number = 32;

const TAG = 'ScreenLock-PasswordUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 正则常量：不合法字符
 */
const PASSWORD_ILLEGAL: RegExp =
  new RegExp('^(?=.*[^0-9a-zA-Z\\\\/\:\;\(\)\$\&\@\'\\]\\[\}\{\#\%\^\*\+\_\\-\`\?\!\'\.\,])');

export interface PsdComplexityParams {
  maxLength: number;
  minLength: number;
  hasPsdComplexity: boolean;
  additionalDescription: string;
  complexityRegex: string;
}

/**
 * 工具类（密码相关）
 *
 * @since 2024-05-20
 */
export class PasswordComplexityUtil {
  /**
   * 将字符串转码为 Uint8Array
   *
   * @return Uint8Array
   */
  static stringToUint8Array(val: string): Uint8Array {
    if (!val) {
      return new Uint8Array([]);
    }
    let textEncoder = new util.TextEncoder();
    return textEncoder.encode(val);
  }

  /**
   * 判断密码是否包含非法字符，不在下面合法字符范围内的字符均是非法字符： 0-9、a-z、A-Z 、'\'、'/'、':'、';'、'('、')'、
   * '$'、'&'、'@'、'''、'['、']'、'{'、'}'、'#'、'%'、'^'、'*'、'+'、'_'、'-'、'`'、'?'、'!'、'''、'.'、','
   *
   * @param password 密码
   * @return true 当密码包含非法字符时
   */
  static isContainIllegalCharacter(password: string): boolean {
    if (!password) {
      return false;
    }
    return PASSWORD_ILLEGAL.test(password);
  }

  /**
   * 同步方式任意数量string类型替换
   *
   * @param resource Resource资源类
   * @param ...numbers 任意数量替换数字
   */
  static getAnyNumFormatStringSync(resource: Resource, ...numbers: Array<number>): string {
    let result = PasswordComplexityUtil.getStringSync(resource);
    if (!result) {
      return '';
    }
    for (let i: number = 0; i < numbers.length; i++) {
      result = result.replace(new RegExp('%' + (i + 1) + '\\$d', 'gm'), String(numbers[i]));
    }
    return result;
  }

  /**
   * 以同步方式获取string资源值
   *
   * @param resource Resource资源类
   */
  static getStringSync(resource: ResourceStr | undefined): string {
    let resourceString: string = '';
    if (!resource) {
      return resourceString;
    }
    if (typeof resource === 'string') {
      return resource;
    }
    let resourceManager = GlobalContext.getContext()?.resourceManager;
    if (!resourceManager) {
      return resourceString;
    }
    try {
      resourceString = resourceManager.getStringSync(resource.id);
    } catch (err) {
      log.error(` getStringSync error, BusinessError code is ${(err as BusinessError).code}`);
    }
    return resourceString;
  }

  static pinComplexityStatusEvent(complexityRegex: string, additionalDescription: string): void {
    if (complexityRegex !== '' || additionalDescription !== '') {
      PcHiSysEventMgr.userPinComplexityStatus(COMPLEXITY_STATUS.USER_PIN_HAVE_COMPLEXITY_PASSWORD);
    } else {
      PcHiSysEventMgr.userPinComplexityStatus(COMPLEXITY_STATUS.USER_PIN_PASSWORD_NO_LIMIT);
    }
  }

  /**
   * 获取密码复杂度
   */
  static getPasswordPolicy(): PsdComplexityParams {
    let complexityRegex: string = ''
    let additionalDescription: string = '';
    let hasPsdComplexity: boolean = false;
    let psdComplexity: PsdComplexityParams = {
      maxLength: 0,
      minLength: 0,
      hasPsdComplexity: hasPsdComplexity,
      additionalDescription: additionalDescription,
      complexityRegex: complexityRegex,
    }
    try {
      let passwordPolicy: securityManager.PasswordPolicy = securityManager.getPasswordPolicy();
      complexityRegex = passwordPolicy.complexityRegex as string;
      psdComplexity.additionalDescription = complexityRegex;
      additionalDescription = passwordPolicy.additionalDescription as string;
      psdComplexity.additionalDescription = additionalDescription;
      PasswordComplexityUtil.pinComplexityStatusEvent(complexityRegex, additionalDescription);
    } catch (err) {
      log.error(`SecurityManagerHelper err.code :${err.code} , err.message :${err.message} `);
    }
    let regexArray: string[] = [];
    if (complexityRegex && complexityRegex.includes('{') && complexityRegex.includes('}')) {
      complexityRegex.split('').reverse().join('');
      let end: number = 0;
      let start: number = 0;
      for (let i = complexityRegex.length - 1; i >= 0; i--) {
        if (complexityRegex.charAt(i) === '}') {
          end = i;
        }
        if (complexityRegex.charAt(i) === '{') {
          start = i + 1;
          break;
        }
      }
      let complexityRegexStr = complexityRegex.substring(start, end);
      log.showInfo(`getPasswordPolicy complexityRegexStr: ${complexityRegexStr}`);
      // 获取正则表达式最后一个{x,y}的两个参数做长度校验，x表示最小值，y表示最大值
      regexArray = complexityRegexStr.split(',');
      if (regexArray.length === 2 && (!Number.isNaN(Number(regexArray[1])) && !Number.isNaN(Number(regexArray[0]))) &&
        ((regexArray[1] && Number(regexArray[1]) >= 0) || (regexArray[0] && Number(regexArray[0]) >= 0))) {
        psdComplexity.hasPsdComplexity = true;
        psdComplexity.maxLength = Number(regexArray[1]);
        psdComplexity.minLength = Number(regexArray[0]);
      }
      if (!regexArray[1]) {
        psdComplexity.maxLength = Number.MAX_VALUE;
      }
    }
    return psdComplexity;
  }
}