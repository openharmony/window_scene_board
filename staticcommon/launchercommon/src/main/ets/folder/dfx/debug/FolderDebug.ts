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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DebugCommand, DebugCommandManager } from '@ohos/frameworkwrapper';
import { FolderData } from '../../model/FolderData';
import { FolderStateManager } from '../../model/FolderStateManager';

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
  public name: string = '';
  public value: string | number = '';
  public type: FolderParameterType = FolderParameterType.NULL_TYPE;

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
export class FolderDebug {
  private static instance: FolderDebug;

  private readonly NULL_CMD: string = '';

  private parameters: FolderParameter[] = Array(FolderDebugParameter.FOLDER_PARAM_END).fill(-1).map(
    () => new FolderParameter(this.NULL_CMD, FolderParameterType.NULL_TYPE, ''));

  public static getInstance(): FolderDebug {
    if (!FolderDebug.instance) {
      FolderDebug.instance = new FolderDebug();
    }

    return FolderDebug.instance;
  }

  private constructor() {
    this.initialOpenFolderCommands();
    this.initialSmallFolderCommands();
    this.initialBigFolderCommands();
    DebugCommandManager.getInstance().register('Folder', this.getCommands());
  }

  private getCommands(): DebugCommand[] {
    let cmds: DebugCommand[] = [];


    cmds.push({cmdName: 'set',
      callback: (args: Array<string>) => this.setParameterWithCmd(args)});
    cmds.push({cmdName: 'get',
      callback: (args: Array<string>) => this.getParameterWithCmd(args)});
    cmds.push({cmdName: 'list',
      callback: (args: Array<string>) => this.listParameterWithCmd(args)});
    cmds.push({cmdName: 'getFolderDataDesc',
      callback: (args: Array<string>) => this.getFolderDataDesc(args)});
    cmds.push({cmdName: 'getFolderDataCallbackDesc',
      callback: (args: Array<string>) => this.getFolderDataCallbackDesc(args)});
    cmds.push({cmdName: 'getFolderItemsDesc',
      callback: (args: Array<string>) => this.getFolderItemsDesc(args)});
    cmds.push({cmdName: 'getFoldersDesc',
      callback: (args: Array<string>) => this.getFoldersDesc(args)});
    cmds.push({cmdName: 'getStatusDesc',
      callback: (args: Array<string>) => this.getStatusDesc(args)});

    return cmds;
  }

  private getStatusDesc(args: Array<string>): string {
    return FolderStateManager.getInstance().getStatusDesc();
  }

  private getFolderDataDesc(args: Array<string>): string {
    return FolderData.getInstance().getFolderDataDesc();
  }

  private getFolderDataCallbackDesc(args: Array<string>): string {
    return FolderData.getInstance().getCallbackDesc();
  }

  private getFolderItemsDesc(args: Array<string>): string {
    if (args.length < 1) {
      return 'please input your folder id, you can get it from command \'getFoldersDesc\'';
    }
    return FolderData.getInstance().getFolderItemsDesc(args[0]);
  }

  private getFoldersDesc(args: Array<string>): string {
    return FolderData.getInstance().getFoldersDesc();
  }

  private listParameterWithCmd(args: Array<string>): string {
    let ret = 'support parameters below:\n';

    this.parameters.forEach((param: FolderParameter) => {
      if (param.name.length > 0) {
        ret += '\t' + param.name + '\n';
      }
    });

    return ret;
  }

  private setParameterWithCmd(args: Array<string>): string {
    if (args.length <= 1) {
      return 'please input your parameter name ...\n';
    }

    const param = this.getParameterByName(args[0]);
    if (!param) {
      return 'not support parameter name ...\n';
    }

    const ret = param.setValueByString(args[1]);

    return 'update ' + param.name + ' as ' + param.value.toString() + ret ? ' success' : ' failed' + '\n';
  }

  private getParameterWithCmd(args: Array<string>): string {
    if (args.length === 0) {
      return 'please input your parameter name ...\n';
    }

    const param = this.getParameterByName(args[0]);
    if (!param) {
      return 'not support parameter name ...\n';
    }

    return param.name + ' = ' + param.value.toString() + '\n';
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