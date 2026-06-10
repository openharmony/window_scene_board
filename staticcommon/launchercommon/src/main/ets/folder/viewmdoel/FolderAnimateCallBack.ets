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
import { CheckEmptyUtils, LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG: string = 'FolderAnimateCallBack';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const FOLDER_DISSOLVE = 'waitFolderDissolveAnimate';

/**
 * 文件夹动效生命周期回调类
 * 用于文件夹动效和数据刷新逻辑的时序管理
 * 后续需要将BigFolderViewModel中的动效回调都统一迁移到这个类中
 *
 */
class FolderAnimateCallBack {
  // 文件夹解散动效完成后的回调
  private mWaitFolderDissolveAnimate: Callback<void>[] = [];

  /**
   * 添加回调到待执行列表中
   *
   * @param callback 待添加回调
   * @param callbackList 待执行回调列表
   * @param msg 动效类型信息
   *
   */
  private waitFolderAnimation(callback: Callback<void>, callbackList: Callback<void>[], msg: string) {
    try {
      if (callback) {
        log.showInfo(`${msg} push ${callback.name}, ${msg} length = ${callbackList.length}`);
        callbackList.push(callback);
      }
    } catch (error) {
      log.showError(`${msg} failed, error: ${error.code} ${error.message}`);
    }
  }

  /**
   * 执行callbackList中的动效回调
   * @param callbackList 待执行回调列表
   * @param msg 动效类型信息
   *
   */
  private async excuteAfterFolderAnimation(callbackList: Callback<void>[], msg: string): Promise<void> {
    if (CheckEmptyUtils.isEmpty(callbackList) || callbackList.length === 0) {
      log.showWarn(`${msg} callbackList is empty`);
      return;
    }
    log.showInfo(`excuteAfterFolderAnimation ${msg} finish callback length: ${callbackList.length}`);
    callbackList.forEach((callback) => {
      if (callback) {
        try {
          callback();
        } catch (error) {
          log.showError(`${msg} excuteAfterFolderAnimation, error: ${error.code} ${error.message}`);
        }
      }
    });
    callbackList.splice(0);
  }

  /**
   * 添加文件夹解散动效执行完成后的回调函数
   *
   * @param callback 文件夹解散动效执行完成后的回调
   */
  waitFolderDissolveAnimation(callback: Callback<void>): void {
    this.waitFolderAnimation(callback, this.mWaitFolderDissolveAnimate, FOLDER_DISSOLVE);
  }

  /**
   * 执行文件夹解散动效完成后的回调函数
   *
   */
  async excuteAfterFolderDissolveAnimation(): Promise<void> {
    this.excuteAfterFolderAnimation(this.mWaitFolderDissolveAnimate, FOLDER_DISSOLVE);
  }
}


export let folderAnimateCallBack: FolderAnimateCallBack = SingletonHelper
  .getInstance(FolderAnimateCallBack, TAG);