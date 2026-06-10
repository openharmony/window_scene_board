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

import { LogDomain, Logger } from '@ohos/basicutils/src/main/ets/TsIndex';
import { launcherStatusUtil } from '@ohos/windowscene';
import { AppIconMouseEventIface } from '../interface/AppIconMouseEventIface';
import { AppItemInfo } from '../../bean/AppItemInfo';
import { AppIconConfig } from '../config/AppIconConfig';
import { AppIconData } from './AppIconData';
import { AppIconMenuEvent } from './AppIconMenuEvent';

const TAG = 'AppIconMouseEvent';
const log: Logger = Logger.getLogHelper(LogDomain.ICON);

export interface AppIconMouseEventParam {
  itemInfo: AppItemInfo;
  iconData: AppIconData;
  iconMenuEvent: AppIconMenuEvent;
  appIconConfig: AppIconConfig;
}

/**
 * Mouse 事件处理
 */
export class AppIconMouseEvent implements AppIconMouseEventIface {
  private itemInfo?: AppItemInfo;
  private iconData?: AppIconData;
  private iconMenuEvent?: AppIconMenuEvent;
  private appIconConfig?: AppIconConfig;

  public initEventParam(param: AppIconMouseEventParam): AppIconMouseEventIface {
    if (!param) {
      log.showError(TAG, 'init event param failed!');
      return this;
    }

    this.itemInfo = param.itemInfo;
    this.iconData = param.iconData;
    this.iconMenuEvent = param.iconMenuEvent;
    this.appIconConfig = param.appIconConfig;
    return this;
  }

  /**
   * onMouse事件
   *
   * @param event
   */
  public onMouse(event: MouseEvent): void {
    if (!event) {
      log.showError(TAG, 'onMouse failed, event is invalid!');
      return;
    }

    if (event.button === MouseButton.Right && event?.action === MouseAction.Press) {
      this.onMouseButtonRight(event);
    }
  }

  private onMouseButtonRight(event: MouseEvent): void {
    log.showInfo(TAG, 'onMouseButtonRight: ' + event?.action);
    if (!this.itemInfo || !this.iconData || !this.iconMenuEvent) {
      log.showError(TAG, 'onMouseButtonRight failed, itemInfo or iconData or iconMenuEvent is invalid!');
      return;
    }

    this.iconMenuEvent.setMenuInfo(this.appIconConfig?.externCb?.getMenuInfo,
      this.appIconConfig?.externCb?.getNotInstalledMenuMap);
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      this.iconMenuEvent.setOuterAppMenuPosition(this.itemInfo);
    } else {
      this.iconMenuEvent.setAppMenuPosition(event?.displayX, this.iconData.iconId);
    }
  };
}