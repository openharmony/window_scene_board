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

import { CommonUtils, LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { ImmersiveConstants } from '@ohos/systemuicommon';
import { DrawableDescriptor } from '@ohos.arkui.drawableDescriptor';
import type image from '@ohos.multimedia.image';

const TAG = 'ImmersiveAppIconHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 普通通知沉浸锁屏胶囊图标更新工具类
 *
 */
class ImmersiveAppIconHelper {
  /**
   * 通知hashCode映射图标
   */
  public appIcons: Map<string, image.PixelMap | string | DrawableDescriptor> = new Map();

  /**
   * 通知hashCode映射通知图标数据改变回调
   */
  public listeners: Map<string, AppIconCallback> = new Map();

  /**
   * 每个hashCode映射一个数据监听回调
   *
   * @param hashCode 唯一标识
   * @param callback 回调
   */
  registerListener(hashCode?: string, callback?: AppIconCallback): void {
    if (hashCode === undefined || callback === undefined) {
      log.showError(`registerListener fail, hashCode: ${hashCode}`);
      return;
    }
    this.listeners.set(hashCode, callback);
    callback?.onAppIconChange();
  }

  /**
   * 注销数据监听
   *
   * @param hashCode 唯一标识
   */
  unRegisterListener(hashCode?: string): void {
    if (hashCode === undefined) {
      log.showError('unRegisterListener fail');
      return;
    }
    this.listeners.delete(hashCode);
    this.releaseAppIcon(hashCode);
  }

  /**
   * 根据hashCode查询通知图片资源
   *
   * @param hashCode
   * @returns
   */
  getAppIcon(hashCode?: string): image.PixelMap | string | DrawableDescriptor | undefined {
    if (hashCode === undefined) {
      log.showError('getAppIcon failed, hashcode is undefined');
      return undefined;
    }
    return this.appIcons.get(hashCode);
  }

  /**
   * 通知删除时释放图片资源
   */
  private releaseAppIcon(hashCode: string): void {
    let appIcon: image.PixelMap | string | DrawableDescriptor | null | undefined = this.appIcons.get(hashCode);
    if (!CommonUtils.isInvalid(appIcon)) {
      if (appIcon instanceof DrawableDescriptor) {
        appIcon.getPixelMap()?.release();
      } else if (appIcon instanceof String) {
        appIcon = null;
      } else {
        let pic = appIcon as image.PixelMap;
        if (pic.release) {
          pic.release();
        }
      }
    }
    this.appIcons.delete(hashCode);
  }
}

/**
 * 通知应用图标更新接口
 */
export interface AppIconCallback {
  /**
   * 通知应用图标变更
   *
   */
  onAppIconChange: () => void;
}

// 单例
export let appIconHelper = SingletonHelper.getInstance(ImmersiveAppIconHelper, TAG);