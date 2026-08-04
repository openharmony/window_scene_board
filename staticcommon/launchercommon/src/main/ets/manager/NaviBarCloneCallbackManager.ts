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

import { HashMap } from '@kit.ArkTS';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import CommonEventManager from '@ohos.commonEventManager';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { settings } from '@kit.BasicServicesKit';

const TAG = 'NaviBarCloneCallbackManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 *  settingData克隆完成事件回调
 */
export class NaviBarCloneCallbackManager {
  public readonly CLONE_TO_OPEN_THREE_KEY: string = 'CloneToOpenThreeKey';

  private _isCloneToOpenThreeKey: boolean = false;

  private settingsDataRestoreFinishCallbacks: HashMap<string, Function> = new HashMap();

  private static _instance: NaviBarCloneCallbackManager | null = null;

  public static getInstance(): NaviBarCloneCallbackManager {
    if (!NaviBarCloneCallbackManager._instance) {
      NaviBarCloneCallbackManager._instance = new NaviBarCloneCallbackManager();
    }
    return NaviBarCloneCallbackManager._instance;
  }

  /**
   * 设置是否是克隆时打开的三键
   *
   * @param value true 克隆时打开
   */
  public set isCloneToOpenThreeKey(value: boolean) {
    try {
      settings.setValue(GlobalContext.getContext(), this.CLONE_TO_OPEN_THREE_KEY, String(value));
      this._isCloneToOpenThreeKey = value;
    } catch (e) {
      log.showError(TAG, 'isCloneToOpenThreeKey error: %{public}s', e?.message);
    }
  }

  /**
   * 是否是克隆时打开的三键
   *
   * @returns true 克隆时打开
   */
  public get isCloneToOpenThreeKey(): boolean {
    return this._isCloneToOpenThreeKey;
  }

  /**
   * 注册监听
   * @param tag 标识
   * @param callback 回调
   */
  public registerSettingsDataRestoreFinishCallbacks(tag: string, callback: Function): void {
    if (!tag) {
      log.showError(`registerCallbacks tag is null`);
      return;
    }
    log.showInfo(`registerCallbacks --- ${tag}`);
    if (!this.settingsDataRestoreFinishCallbacks.hasKey(tag)) {
      this.settingsDataRestoreFinishCallbacks.set(tag, callback);
    }
  }

  /**
   * 反注册监听
   * @param tag 标识
   */
  public unRegisterSettingsDataRestoreFinishCallbacks(tag: string): void {
    if (!tag) {
      log.showError(`unRegisterSettingsDataRestoreFinishCallbacks tag is null`);
      return;
    }
    if (this.settingsDataRestoreFinishCallbacks.get(tag)) {
      log.showInfo(`unRegisterCallbacks --- ${tag}`);
      this.settingsDataRestoreFinishCallbacks.remove(tag);
    }
  }


  /**
   * 执行回调
   * @param data  settingData克隆完成事件后传递过来的数据
   */
  public executeCallback(data: CommonEventManager.CommonEventPublishData): void {
    // 使用对象解析
    for (let myEntry of this.settingsDataRestoreFinishCallbacks) {
      let key = myEntry[0];
      let value = myEntry[1];
      log.showInfo(`executeCallback :${key}`);
      value?.(data);
    }
  }
}