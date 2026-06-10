/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG: string = 'OpenFolderHiddenIconLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
/**
 * 关闭文件夹隐藏节点
 */
export class OpenFolderHiddenIconLayout {
  private layouts?: Map<string, OpenFolderHiddenIconLayoutData>;
  private aniTask?: () => void;
  private isReady: boolean = false;

  public setLayoutData(keyName: string, data: OpenFolderHiddenIconLayoutData): void {
    if (!this.layouts) {
      this.layouts = new Map<string, OpenFolderHiddenIconLayoutData>();
    }
    this.layouts.set(keyName, data);
    log.showDebug(`setLayoutData ${keyName}`);
  }

  public getLayoutData(keyName: string, bundleName?: string): OpenFolderHiddenIconLayoutData | undefined {
    if (!this.layouts) {
      log.showInfo(`layouts empty, getLayoutData ${keyName}:${bundleName} fail`);
      return undefined;
    }
    const data = this.layouts.get(keyName);
    if (data) {
      return data;
    }
    // 对于安装中到安装完成短暂状态文件夹关闭需要用安装中的iconData做动效
    if (bundleName) {
      for (const layout of this.layouts) {
        if (layout[0].startsWith(bundleName)) {
          return layout[1];
        }
      }
    }
    log.showInfo(`not found, getLayoutData ${keyName}:${bundleName} fail`);
    return undefined;
  }

  public deleteLayoutData(keyName: string): void {
    this.layouts?.delete(keyName);
    if (this.layouts?.size === 0) {
      this.layouts = undefined;
    }
    log.showDebug(`deleteLayoutData ${keyName}`);
  }

  public setAniTask(aniTask?: () => void): void {
    log.showDebug(`setAniTask ${aniTask !== undefined}`);
    this.aniTask = aniTask;
  }

  public getAniTask(): (() => void) | undefined {
    return this.aniTask;
  }

  public setReady(isReady: boolean): void {
    log.showDebug(`setReady ${isReady}`);
    this.isReady = isReady;
  }

  public isReadyOrAniTask(): boolean {
    log.showDebug(`isReadyOrAniTask ${this.isReady} ${this.aniTask !== undefined}`);
    return this.isReady || (this.aniTask !== undefined);
  }
}

interface OpenFolderHiddenIconLayoutData {
  getPosition: () => [number, number];
  translateAnim?: (transX: number, transY: number) => void;
  iconOpacityAnim?: () => void;
  nameOpacityAnim?: () => void;
  maskOpacityAnim?: () => void;
  finish?: () => void;
}

// 单例
export const openFolderHiddenIconLayout: OpenFolderHiddenIconLayout = SingletonHelper
  .getInstance(OpenFolderHiddenIconLayout, TAG);
