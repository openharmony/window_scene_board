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
import { BusinessError } from '@kit.BasicServicesKit';
import { FileUtil } from '../utils/FileUtil';
import { RemoteCode } from './RemoteCode';

/**
 * 校验参数number合法性[min,max]
 *
 * @param min 最小值
 * @param max 最大值
 * @returns 参数合法，返回数字
 * @throws 参数不合法抛出异常
 */
export function checkNumber(min: number, max: number): (value: number) => number {
  return (value: number): number => {
    if (value === undefined || value === null) {
      throwParamError(`Invalid number parameter:${value}`);
    }
    if (value < min || value > max) {
      throwParamError(`Invalid number parameter:${value}`);
    }
    return value;
  }
}

/**
 * 校验参数路径的合法性
 * @param trustPath 可信路径白名单
 * @returns 参数合法，返回入参路径
 * @throws 参数不合法抛出异常
 */
export function checkPath(trustPath: string[]): (path: string) => string {
  return (path: string): string => {
    const normalizePath: string = FileUtil.normalizePath(path);
    let trustRet: boolean = false;
    for (let trust of trustPath) {
      if (normalizePath.startsWith(trust)) {
        trustRet = true;
        break;
      }
    }
    if (!trustRet) {
      throwParamError(`Invalid path:${FileUtil.getFileName(path)}`);
    }
    return path;
  }
}

/**
 * 校验参数是否不为null
 * @param argument 参数
 * @returns 参数值
 * @throws 参数为null抛出异常
 */
export function checkNonNull<T>(argument: T): T {
  if (argument === undefined || argument === null) {
    throwParamError(`Argument cannot be null`);
  }
  return argument;
}

function throwParamError(message: string): void {
  const error: BusinessError<string> = {
    name: 'ParamError',
    message: message,
    code: RemoteCode.ERR_PARAM
  }
  throw error as Error;
}