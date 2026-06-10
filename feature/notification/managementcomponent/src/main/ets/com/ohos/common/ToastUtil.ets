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
import { promptAction } from '@kit.ArkUI';
import { systemDateTime } from '@kit.BasicServicesKit';
import { LogDomain, LogHelper } from './BasicCommon';

const TAG = 'ToastUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const TOAST_OPTIONS_DEFAULT_DURATION = 1500;

export class ToastUtil {
  private static timeMap: Map<ToastType, number> = new Map();

  public static showToast(options: promptAction.ShowToastOptions, type?: ToastType): void {
    let curTime = systemDateTime.getTime();
    let lastTime = ToastUtil.timeMap.get(type ?? ToastType.DEFAULT) ?? 0;
    log.showInfo(`toast time interval, ${curTime}, ${lastTime}`);
    if (curTime - lastTime > (options?.duration ?? TOAST_OPTIONS_DEFAULT_DURATION)) {
      log.showInfo(`show toast success`);
      promptAction.showToast(options);
      ToastUtil.timeMap.set(type ?? ToastType.DEFAULT, curTime);
    }
  }
}

export enum ToastType {
  DEFAULT = -1,
  BADGES_FORBIDDEN = 0,
  SCREEN_LOCK_NTF_STYLE_FORBIDDEN = 1,
  /** 显示锁屏通知内容 不允许设置为“仅机主注视时”的toast */
  APP_NTF_CONFIG_HIDE_BANNER_CONTENT_FORBIDDEN = 2,
}