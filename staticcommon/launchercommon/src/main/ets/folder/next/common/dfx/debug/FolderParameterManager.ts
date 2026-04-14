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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG = 'FolderDebug';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/* 文件夹DEBUG配置参数的索引 */
export enum FolderDebugParameter {
  FOLDER_PARAM_START = 1, /* 永远在开始 */
  BIG_FOLDER_PARAM_START,
  /* 折叠态大文件夹参数添加在此处 */
  BIG_FOLDER_PARAM_END,

  SMALL_FOLDER_PARAM_START,
  /* 折叠态小文件夹参数添加在此处 */
  SMALL_FOLDER_PARAM_END,

  OPEN_FOLDER_PARAM_START,
  /* 展开态文件夹参数添加在此处 */
  OPEN_FOLDER_PARAM_END,
  FOLDER_PARAM_END, /* 永远在最后 */
}

/* 文件夹DEBUG配置参数的原型 */
enum FolderParameterType {
  NULL_TYPE,
  NUMBER_TYPE,
  STRING_TYPE,
}

/* 文件夹DEBUG配置参数 */
class FolderParameter {
  public name: string | undefined;
  public value: string | number | undefined;
  public type: FolderParameterType | undefined;

  constructor(name: string, type: FolderParameterType, value: string | number) {
    this.update(name, type, value);
  }

  public update(name: string, type: FolderParameterType, value: string | number): void {
    this.name = name;
    this.type = type;
    this.value = value;
  }

  public setValueByString(newValue: string): boolean {
    if (this.type === FolderParameterType.NUMBER_TYPE) {
      this.value = Number(newValue);
      return true;
    } else if (this.type === FolderParameterType.STRING_TYPE) {
      this.value = newValue;
      return true;
    }
    return false;
  }
}

/* 文件夹DEBUG配置参数模块 */
export class FolderParameterManager {
  private static instance: FolderParameterManager;

  private readonly NULL_CMD: string = '';

  private parameters: FolderParameter[] = Array(FolderDebugParameter.FOLDER_PARAM_END).fill(-1).map(
    () => new FolderParameter(this.NULL_CMD, FolderParameterType.NULL_TYPE, ''));

  public static getInstance(): FolderParameterManager {
    if (!FolderParameterManager.instance) {
      FolderParameterManager.instance = new FolderParameterManager();
    }

    return FolderParameterManager.instance;
  }

  private constructor() {
    this.initialOpenFolderCommands();
    this.initialSmallFolderCommands();
    this.initialBigFolderCommands();
  }

  /**
   * 获取所有管理的参数列表
   * @returns 参数列表字符串
   */
  public getAllParameterDesc(): string {
    let ret = 'support parameters below:\n';

    this.parameters.forEach((param: FolderParameter) => {
      if (param.name?.length as number > 0) {
        ret += '\t' + param.name + '\n';
      }
    });

    return ret;
  }

  /**
   * DEBUG 设置参数接口
   * @param key 参数名称
   * @param value 参数值
   * @returns  设置结果
   */
  public setParameterByDebug(key?: string, value?: string): string {
    if (!key || !value) {
      return 'please input your parameter name ...\n';
    }

    const param = this.getParameterByName(key);
    if (!param) {
      return 'not support parameter name ...\n';
    }

    const ret = param.setValueByString(value);
    return 'update ' + param.name + ' as ' + param.value?.toString() ?? '' + ret ? ' success' : ' failed' + '\n';
  }

  /**
   * DEBUG 获取参数接口
   * @param key 参数名称
   * @returns  获取结果
   */
  public getParameterByDebug(key?: string): string {
    if (!key) {
      return 'please input your parameter name ...\n';
    }

    const param = this.getParameterByName(key);
    if (!param) {
      return 'not support parameter name ...\n';
    }

    return param.name + ' = ' + param.value?.toString() + '\n';
  }

  private initialOpenFolderCommands(): void {
    /* 在这里使用updateParameterById更新展开态文件夹的配置参数 */
  }

  private initialSmallFolderCommands(): void {
    /* 在这里使用updateParameterById更新小文件夹的配置参数 */
  }

  private initialBigFolderCommands(): void {
    /* 在这里使用updateParameterById更新大文件夹的配置参数 */
  }

  private updateParameterById(id: FolderDebugParameter, name: string, type: FolderParameterType,
    value: string | number): void {
    this.getParameterById(id).update(name, type, value);
  }

  private getParameterById(id: FolderDebugParameter): FolderParameter {
    try {
      return this.parameters[id];
    } catch (error) {
      log.showError(`cannot find %{public}d paramter by ID`, id);
      return new FolderParameter('', FolderParameterType.NULL_TYPE, '');
    }
  }

  private getParameterByName(name: string): FolderParameter | null {
    const param = this.parameters.find((item: FolderParameter) => {
      if (item.name === name) {
        return true;
      }
      return false;
    });

    if (param) {
      return param;
    }

    log.showError(`cannot find %{public}s paramter by name`, name);
    return null;
  }

  /**
   * 获取指定文件夹DEBUG配置参数
   *
   * @param id 参数索引
   * @returns 数字参数结果
   */
  public getNumberById(id: FolderDebugParameter): number {
    return this.getParameterById(id).value as number;
  }

  /**
   * 获取指定文件夹DEBUG配置参数
   *
   * @param id 参数索引
   * @returns 字符串参数结果
   */
  public getStringById(id: FolderDebugParameter): string {
    return this.getParameterById(id).value as string;
  }
}