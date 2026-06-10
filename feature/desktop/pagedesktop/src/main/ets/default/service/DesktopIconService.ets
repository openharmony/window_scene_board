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

import { LogHelper, LogDomain } from '@ohos/basicutils';
import type { IService } from '@ohos/componenthelper';
import { IExecutor } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { CheckShortcut } from './impl/CheckShortcut';
import { CheckAppIconLost } from './impl/CheckAppIconLost';
import { AddShortcutToDesktop } from './impl/AddShortcutToDesktop';
import { FixAppIconLost } from './impl/FixAppIconLost';
import { SetPinShortcutLimitInfo } from './impl/SetPinShortcutLimitInfo';
import { Response } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/ShortcutViewModel';

const TAG: string = 'DesktopIconService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 请求方法
 */
export const enum RequestMethod {
  /**
   * 检查快捷图标的合法性
   */
  CHECK_SHORTCUT = 'checkShortcut',

  /**
   * 快捷图标添加到桌面
   */
  ADD_SHORTCUT_TO_DESKTOP = 'addShortcutToDesktop',

  /**
   * 设置应用快捷方式加桌数量上限
   */
  SET_SHORTCUT_LIMIT = 'setPinShortcutLimitInfo',

  /**
   * 检测图标丢失状态
   */
  CHECK_APP_ICON_LOST = 'checkAppIconLost',

  /**
   * 修复图标丢失状态
   */
  FIX_APP_ICON_LOST = 'fixAppIconLost',
}

/**
 * 桌面图标业务服务
 */
export class DesktopIconService implements IService {
  private static readonly executorMap: Map<string, () => IExecutor> = new Map<string, () => IExecutor>([
    [RequestMethod.CHECK_SHORTCUT, (): IExecutor => new CheckShortcut()],
    [RequestMethod.ADD_SHORTCUT_TO_DESKTOP, (): IExecutor => new AddShortcutToDesktop()],
    [RequestMethod.SET_SHORTCUT_LIMIT, (): IExecutor => new SetPinShortcutLimitInfo()],
    [RequestMethod.CHECK_APP_ICON_LOST, (): IExecutor => new CheckAppIconLost()],
    [RequestMethod.FIX_APP_ICON_LOST, (): IExecutor => new FixAppIconLost()],
  ]);

  async onCall(json: string): Promise<string> {
    let msg: CallMessage | undefined;
    try {
      msg = JSON.parse(json) as CallMessage;
    } catch (err) {
      log.error('onCall parse message failed, ', err);
    }
    if (!msg || !msg.method) {
      log.showWarn('onCall invalid method');
      return Response.INVALID_METHOD_ERROR;
    }

    const method: string = msg.method;
    log.showInfo(`onCall method = ${method}`);
    const executor = DesktopIconService.executorMap.get(method);
    if (!executor) {
      log.showWarn(`onCall unknown method = ${method}`);
      return Response.UNKNOWN_METHOD_ERROR;
    }
    return executor().execute(msg.extra);
  }

  isSupportSegments(): boolean {
    return true;
  }
}

/**
 * 请求消息
 */
export interface CallMessage {
  /**
   * 方法名
   */
  method: string;

  /**
   * 附加参数
   */
  extra: object;
}